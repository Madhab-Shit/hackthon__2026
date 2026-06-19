import 'package:cloud_firestore/cloud_firestore.dart';

class AiInsight {
  const AiInsight({
    required this.health,
    required this.suggestion,
    required this.riskLevel,
    required this.safeToSpendPerDay,
    required this.budgetWarning,
    required this.riskPercentage,
    required this.predictedMonthEndSpend,
    this.createdAt,
  });

  final String health;
  final String suggestion;
  final String riskLevel;
  final double safeToSpendPerDay;
  final String budgetWarning;
  final double riskPercentage;
  final double predictedMonthEndSpend;
  final DateTime? createdAt;

  factory AiInsight.fromJson(Map<String, dynamic> json) {
    return AiInsight(
      health: (json['health'] ?? 'Good').toString(),
      suggestion: (json['suggestion'] ?? '').toString(),
      riskLevel: (json['riskLevel'] ?? 'Low').toString(),
      safeToSpendPerDay: _toDouble(json['safeToSpendPerDay']),
      budgetWarning: (json['budgetWarning'] ?? '').toString(),
      riskPercentage: _toDouble(json['riskPercentage']),
      predictedMonthEndSpend: _toDouble(json['predictedMonthEndSpend']),
      createdAt: _toDate(json['createdAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'health': health,
      'suggestion': suggestion,
      'riskLevel': riskLevel,
      'safeToSpendPerDay': safeToSpendPerDay,
      'budgetWarning': budgetWarning,
      'riskPercentage': riskPercentage,
      'predictedMonthEndSpend': predictedMonthEndSpend,
      'createdAt': createdAt == null
          ? FieldValue.serverTimestamp()
          : Timestamp.fromDate(createdAt!),
    };
  }

  static double _toDouble(dynamic value) {
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0;
    return 0;
  }

  static DateTime? _toDate(dynamic value) {
    if (value is Timestamp) return value.toDate();
    if (value is DateTime) return value;
    if (value is String) return DateTime.tryParse(value);
    return null;
  }
}

class BudgetPrediction {
  const BudgetPrediction({
    required this.totalSpent,
    required this.remainingBudget,
    required this.daysLeftInMonth,
    required this.safeToSpendPerDay,
    required this.predictedMonthEndSpend,
    required this.riskPercentage,
  });

  final double totalSpent;
  final double remainingBudget;
  final int daysLeftInMonth;
  final double safeToSpendPerDay;
  final double predictedMonthEndSpend;
  final double riskPercentage;
}

class SmartExpenseInfo {
  const SmartExpenseInfo({
    required this.category,
    required this.isEssential,
    required this.aiNote,
  });

  final String category;
  final bool isEssential;
  final String aiNote;
}
