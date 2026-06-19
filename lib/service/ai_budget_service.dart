import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hacathon_2026/model/ai_insight_model.dart';
import 'package:http/http.dart' as http;

class AiBudgetService {
  AiBudgetService({FirebaseFirestore? firestore, FirebaseAuth? auth})
    : _firestore = firestore ?? FirebaseFirestore.instance,
      _auth = auth ?? FirebaseAuth.instance;

  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  static const String _openRouterUrl =
      'https://openrouter.ai/api/v1/chat/completions';

  static const String _model = 'openai/gpt-chat-latest';

  String get _apiKey {
    return (dotenv.env['OPENROUTER_API_KEY'] ?? dotenv.env['api_Key'] ?? '')
        .trim();
  }

  static const List<String> essentialCategories = [
    'Food',
    'Travel',
    'Study',
    'Medicine',
  ];

  BudgetPrediction buildPrediction({
    required double monthlyBudget,
    required double totalSpent,
    required int daysLeftInMonth,
  }) {
    final now = DateTime.now();
    final daysInMonth = DateTime(now.year, now.month + 1, 0).day;
    final daysPassed = (now.day).clamp(1, daysInMonth).toDouble();

    final remainingBudget = monthlyBudget - totalSpent;

    final safePerDay = daysLeftInMonth <= 0 || remainingBudget <= 0
        ? 0.0
        : remainingBudget / daysLeftInMonth;

    final predicted = daysPassed <= 0
        ? totalSpent
        : totalSpent / daysPassed * daysInMonth;

    final risk = monthlyBudget <= 0
        ? 0.0
        : (predicted / monthlyBudget * 100).clamp(0.0, 200.0).toDouble();

    return BudgetPrediction(
      totalSpent: totalSpent,
      remainingBudget: remainingBudget,
      daysLeftInMonth: daysLeftInMonth,
      safeToSpendPerDay: safePerDay,
      predictedMonthEndSpend: predicted,
      riskPercentage: risk,
    );
  }

  SmartExpenseInfo classifyExpense(String text, {String? selectedCategory}) {
    final normalized = text.toLowerCase();

    String category =
        selectedCategory == null || selectedCategory.trim().isEmpty
        ? 'Other'
        : _normalizeCategory(selectedCategory);

    final rules = <String, List<String>>{
      'Food': [
        'food',
        'meal',
        'lunch',
        'dinner',
        'breakfast',
        'snack',
        'tea',
        'coffee',
        'canteen',
        'restaurant',
        'khawa',
        'খাবার',
      ],
      'Travel': [
        'bus',
        'train',
        'metro',
        'auto',
        'uber',
        'ola',
        'taxi',
        'fuel',
        'travel',
        'fare',
      ],
      'Study': [
        'book',
        'course',
        'class',
        'tuition',
        'xerox',
        'print',
        'stationery',
        'exam',
        'study',
        'college',
      ],
      'Medicine': [
        'medicine',
        'doctor',
        'hospital',
        'pharmacy',
        'health',
        'tablet',
      ],
      'Shopping': ['shopping', 'shirt', 'shoe', 'dress', 'clothes', 'mall'],
      'Entertainment': [
        'movie',
        'game',
        'party',
        'netflix',
        'music',
        'concert',
        'entertainment',
      ],
    };

    for (final entry in rules.entries) {
      if (entry.value.any(normalized.contains)) {
        category = entry.key;
        break;
      }
    }

    final isEssential = essentialCategories.contains(category);

    return SmartExpenseInfo(
      category: category,
      isEssential: isEssential,
      aiNote: isEssential
          ? '$category looks essential for student survival.'
          : '$category looks non-essential. Spend carefully if your budget is tight.',
    );
  }

  Future<AiInsight> generateInsight({
    required double monthlyBudget,
    required double totalSpent,
    required int daysLeftInMonth,
    required double targetAmount,
    required String goalName,
  }) async {
    final prediction = buildPrediction(
      monthlyBudget: monthlyBudget,
      totalSpent: totalSpent,
      daysLeftInMonth: daysLeftInMonth,
    );

    final fallback = _fallbackInsight(
      prediction,
      targetAmount: targetAmount,
      goalName: goalName,
    );

    if (_apiKey.isEmpty) {
      await saveInsight(fallback);
      return fallback;
    }

    try {
      final reply = await _callOpenRouter(
        messages: [
          {
            'role': 'system',
            'content': '''
You are an AI financial assistant for Indian students.
Return only valid JSON.
No markdown.
No extra text.
''',
          },
          {
            'role': 'user',
            'content':
                '''
Create a budget insight from this data:

Monthly Budget: ₹$monthlyBudget
Total Spent: ₹$totalSpent
Remaining Budget: ₹${prediction.remainingBudget}
Days Left In Month: $daysLeftInMonth
Safe To Spend Per Day: ₹${prediction.safeToSpendPerDay}
Predicted Month End Spend: ₹${prediction.predictedMonthEndSpend}
Risk Percentage: ${prediction.riskPercentage}
Goal Name: $goalName
Target Amount: ₹$targetAmount

Return JSON with these keys:
{
  "health": "Good or Warning or Danger",
  "suggestion": "short useful suggestion",
  "riskLevel": "Low or Medium or High",
  "budgetWarning": "short warning",
  "safeToSpendPerDay": number,
  "riskPercentage": number,
  "predictedMonthEndSpend": number
}
''',
          },
        ],
        maxTokens: 300,
      );

      final jsonData = _extractJsonFromText(reply);

      final insight = AiInsight(
        health: _stringValue(jsonData['health'], fallback.health),
        suggestion: _stringValue(jsonData['suggestion'], fallback.suggestion),
        riskLevel: _stringValue(jsonData['riskLevel'], fallback.riskLevel),
        safeToSpendPerDay: _toDouble(
          jsonData['safeToSpendPerDay'],
          fallback.safeToSpendPerDay,
        ),
        budgetWarning: _stringValue(
          jsonData['budgetWarning'],
          fallback.budgetWarning,
        ),
        riskPercentage: _toDouble(
          jsonData['riskPercentage'],
          fallback.riskPercentage,
        ),
        predictedMonthEndSpend: _toDouble(
          jsonData['predictedMonthEndSpend'],
          fallback.predictedMonthEndSpend,
        ),
        createdAt: DateTime.now(),
      );

      await saveInsight(insight);
      return insight;
    } catch (e) {
      debugPrint('AI INSIGHT ERROR: $e');
      await saveInsight(fallback);
      return fallback;
    }
  }

  Future<String> askAssistant({
    required String message,
    required Map<String, dynamic> summary,
  }) async {
    if (_apiKey.isEmpty) {
      return _localBudgetReply(message: message, summary: summary);
    }

    try {
      final reply = await _callOpenRouter(
        messages: [
          {
            'role': 'system',
            'content': '''
You are a smart student budgeting assistant.

Rules:
- Answer only about budget, student spending, savings, expenses, emergency mode, and financial planning.
- Use the student's real budget data.
- Keep replies short and practical.
- If user writes Bengali or Banglish, reply in Bengali/Banglish.
- If user writes English, reply in simple English.
- Do not give random fixed answers.
- Answer the exact question.
''',
          },
          {
            'role': 'user',
            'content':
                '''
Student budget data:
Monthly budget: ₹${summary['monthlyBudget']}
Total spent: ₹${summary['totalSpent']}
Remaining budget: ₹${summary['remainingBudget']}
Days left in month: ${summary['daysLeftInMonth']}
Safe to spend per day: ₹${summary['safeToSpendPerDay']}
Goal name: ${summary['goalName']}
Target amount: ₹${summary['targetAmount']}

User question:
$message
''',
          },
        ],
        maxTokens: 300,
      );

      if (reply.trim().isEmpty) {
        return _localBudgetReply(message: message, summary: summary);
      }

      return reply.trim();
    } catch (e) {
      debugPrint('AI CHAT ERROR: $e');
      return _localBudgetReply(message: message, summary: summary);
    }
  }

  Future<String> _callOpenRouter({
    required List<Map<String, dynamic>> messages,
    int maxTokens = 300,
  }) async {
    final response = await http.post(
      Uri.parse(_openRouterUrl),
      headers: {
        'Authorization': 'Bearer $_apiKey',
        'Content-Type': 'application/json; charset=utf-8',
        'HTTP-Referer': 'https://student-budget-assistant.app',
        'X-Title': 'Student Budget Assistant',
      },
      body: jsonEncode({
        'model': _model,
        'messages': messages,
        'max_tokens': maxTokens,
        'temperature': 0.4,
      }),
    );

    final body = utf8.decode(response.bodyBytes);

    debugPrint('OPENROUTER STATUS: ${response.statusCode}');
    debugPrint('OPENROUTER BODY: $body');

    if (response.statusCode != 200) {
      throw Exception('OpenRouter Error ${response.statusCode}: $body');
    }

    final data = jsonDecode(body) as Map<String, dynamic>;

    final choices = data['choices'];

    if (choices is List && choices.isNotEmpty) {
      final first = choices.first;

      if (first is Map<String, dynamic>) {
        final message = first['message'];

        if (message is Map<String, dynamic>) {
          final content = message['content'];

          if (content is String) {
            return content;
          }
        }
      }
    }

    return '';
  }

  Future<void> saveInsight(AiInsight insight) async {
    final user = _auth.currentUser;
    if (user == null) return;

    await _firestore
        .collection('users')
        .doc(user.uid)
        .collection('ai_insights')
        .add(insight.toJson());
  }

  AiInsight _fallbackInsight(
    BudgetPrediction prediction, {
    required double targetAmount,
    required String goalName,
  }) {
    final risk = prediction.riskPercentage;

    final health = risk >= 100
        ? 'Danger'
        : risk >= 80
        ? 'Warning'
        : 'Good';

    final riskLevel = risk >= 100
        ? 'High'
        : risk >= 80
        ? 'Medium'
        : 'Low';

    final warning = prediction.remainingBudget < 0
        ? 'Budget crossed. Emergency spending control is recommended.'
        : risk >= 80
        ? 'You are close to crossing your monthly budget.'
        : 'Budget is under control right now.';

    final goalText = targetAmount > 0
        ? ' Keep saving for ${goalName.isEmpty ? 'your goal' : goalName}.'
        : '';

    return AiInsight(
      health: health,
      suggestion:
          'Spend up to ₹${prediction.safeToSpendPerDay.toStringAsFixed(0)} per day and prioritize food, travel, study, and medicine.$goalText',
      riskLevel: riskLevel,
      safeToSpendPerDay: prediction.safeToSpendPerDay,
      budgetWarning: warning,
      riskPercentage: risk,
      predictedMonthEndSpend: prediction.predictedMonthEndSpend,
      createdAt: DateTime.now(),
    );
  }

  String _localBudgetReply({
    required String message,
    required Map<String, dynamic> summary,
  }) {
    final lower = message.toLowerCase();

    final monthlyBudget = _toDouble(summary['monthlyBudget']);
    final totalSpent = _toDouble(summary['totalSpent']);
    final remaining = _toDouble(summary['remainingBudget']);
    final safePerDay = _toDouble(summary['safeToSpendPerDay']);
    final targetAmount = _toDouble(summary['targetAmount']);
    final goalName = (summary['goalName'] ?? '').toString();
    final daysLeft = summary['daysLeftInMonth'] ?? 0;

    if (lower.contains('food') ||
        lower.contains('khawa') ||
        lower.contains('খাবার') ||
        lower.contains('lunch') ||
        lower.contains('dinner')) {
      return 'Food is an essential expense. Try to keep your daily food spending within ₹${safePerDay.toStringAsFixed(0)}.';
    }

    if (lower.contains('travel') ||
        lower.contains('bus') ||
        lower.contains('train') ||
        lower.contains('auto')) {
      return 'Travel is essential. Your remaining budget is ₹${remaining.toStringAsFixed(0)}, so keep a fixed daily travel limit.';
    }

    if (lower.contains('shopping') ||
        lower.contains('movie') ||
        lower.contains('game') ||
        lower.contains('party')) {
      if (remaining <= 0) {
        return 'Avoid non-essential spending now. Your budget is already crossed, so pause shopping, movies, games, and parties.';
      }

      return 'This is a non-essential expense. Your remaining budget is ₹${remaining.toStringAsFixed(0)}, so avoid it unless it is really necessary.';
    }

    if (lower.contains('save') ||
        lower.contains('saving') ||
        lower.contains('goal') ||
        lower.contains('target')) {
      return 'Your goal is ${goalName.isEmpty ? 'your selected goal' : goalName}, and your target is ₹${targetAmount.toStringAsFixed(0)}. Keep daily spending within ₹${safePerDay.toStringAsFixed(0)} to improve your savings.';
    }

    if (remaining <= 0) {
      return 'You have crossed your budget. Spend only on food, travel, study, and medicine for now.';
    }

    return 'Your monthly budget is ₹${monthlyBudget.toStringAsFixed(0)}, spent amount is ₹${totalSpent.toStringAsFixed(0)}, remaining budget is ₹${remaining.toStringAsFixed(0)}, and days left are $daysLeft. Your safe daily spending is about ₹${safePerDay.toStringAsFixed(0)}.';
  }

  Map<String, dynamic> _extractJsonFromText(String text) {
    try {
      return Map<String, dynamic>.from(jsonDecode(text) as Map);
    } catch (_) {
      final start = text.indexOf('{');
      final end = text.lastIndexOf('}');

      if (start != -1 && end != -1 && end > start) {
        final jsonPart = text.substring(start, end + 1);
        return Map<String, dynamic>.from(jsonDecode(jsonPart) as Map);
      }

      return {};
    }
  }

  String _normalizeCategory(String value) {
    switch (value.toLowerCase()) {
      case 'transport':
        return 'Travel';
      case 'academics':
      case 'education':
        return 'Study';
      case 'health':
        return 'Medicine';
      case 'others':
        return 'Other';
      default:
        return value;
    }
  }

  double _toDouble(dynamic value, [double fallback = 0]) {
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? fallback;
    return fallback;
  }

  String _stringValue(dynamic value, String fallback) {
    if (value == null) return fallback;
    final text = value.toString().trim();
    return text.isEmpty ? fallback : text;
  }
}
