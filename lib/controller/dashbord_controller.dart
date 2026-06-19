import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class DashboardProvider extends ChangeNotifier {
  bool isLoading = false;

  double monthlyIncome = 0.0;
  double monthlyBudget = 0.0;
  double totalSpent = 0.0;
  double targetAmount = 0.0;

  String goalName = "";

  List<Map<String, dynamic>> recentExpenses = [];
  List<Map<String, dynamic>> recentExpenseGroups = [];

  StreamSubscription<DocumentSnapshot<Map<String, dynamic>>>? _goalSub;
  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>? _expenseSub;

  bool _goalLoaded = false;
  bool _expenseLoaded = false;

  double get remainingBudget => monthlyBudget - totalSpent;

  double get savings => monthlyIncome - monthlyBudget;

  double get progress {
    if (monthlyBudget <= 0) return 0.0;
    return (totalSpent / monthlyBudget).clamp(0.0, 1.0);
  }

  int get daysLeftInMonth {
    final now = DateTime.now();
    final lastDay = DateTime(now.year, now.month + 1, 0).day;
    return lastDay - now.day + 1;
  }

  double get safeToSpendPerDay {
    if (daysLeftInMonth <= 0) return 0.0;
    if (remainingBudget <= 0) return 0.0;
    return remainingBudget / daysLeftInMonth;
  }

  double _toDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is int) return value.toDouble();
    if (value is double) return value;
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }

  DateTime _getDateTime(dynamic value) {
    if (value == null) return DateTime.now();

    if (value is Timestamp) return value.toDate();

    if (value is DateTime) return value;

    if (value is String) {
      return DateTime.tryParse(value) ?? DateTime.now();
    }

    return DateTime.now();
  }

  String _dateKey(DateTime date) {
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');
    return "${date.year}-$month-$day";
  }

  String _formatDateTitle(DateTime date) {
    const months = [
      "January",
      "February",
      "March",
      "April",
      "May",
      "June",
      "July",
      "August",
      "September",
      "October",
      "November",
      "December",
    ];

    final now = DateTime.now();

    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final expenseDate = DateTime(date.year, date.month, date.day);

    if (expenseDate == today) return "Today";
    if (expenseDate == yesterday) return "Yesterday";

    return "${date.day} ${months[date.month - 1]} ${date.year}";
  }

  String _formatTime(DateTime date) {
    int hour = date.hour;
    final minute = date.minute.toString().padLeft(2, '0');
    final period = hour >= 12 ? "PM" : "AM";

    if (hour == 0) {
      hour = 12;
    } else if (hour > 12) {
      hour = hour - 12;
    }

    return "$hour:$minute $period";
  }

  List<Map<String, dynamic>> _buildDateWiseGroups(
    List<Map<String, dynamic>> expenses,
  ) {
    final Map<String, List<Map<String, dynamic>>> groupedMap = {};

    for (final expense in expenses) {
      final DateTime dateTime = expense['dateTime'];
      final String key = _dateKey(dateTime);

      groupedMap.putIfAbsent(key, () => []);
      groupedMap[key]!.add(expense);
    }

    final keys = groupedMap.keys.toList();

    // Latest date first: Today, Yesterday, then old dates
    keys.sort((a, b) {
      final dateA = DateTime.parse(a);
      final dateB = DateTime.parse(b);
      return dateB.compareTo(dateA);
    });

    return keys.map((key) {
      final date = DateTime.parse(key);
      final items = groupedMap[key]!;

      items.sort((a, b) {
        final DateTime dateA = a['dateTime'];
        final DateTime dateB = b['dateTime'];
        return dateB.compareTo(dateA);
      });

      return {'date': date, 'title': _formatDateTitle(date), 'items': items};
    }).toList();
  }

  void startDashboardListener() {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      isLoading = false;
      notifyListeners();
      return;
    }

    _goalSub?.cancel();
    _expenseSub?.cancel();

    isLoading = true;
    _goalLoaded = false;
    _expenseLoaded = false;
    notifyListeners();

    final userRef = FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid);

    _goalSub = userRef
        .collection('goals')
        .doc('premium_goal')
        .snapshots()
        .listen(
          (doc) async {
            if (doc.exists) {
              _applyGoalData(doc.data());
            } else {
              final goalsSnap = await userRef
                  .collection('goals')
                  .limit(1)
                  .get();

              if (goalsSnap.docs.isNotEmpty) {
                _applyGoalData(goalsSnap.docs.first.data());
              } else {
                _applyGoalData(null);
              }
            }

            _goalLoaded = true;
            _updateLoadingState();
          },
          onError: (e) {
            debugPrint("Goal listener error: $e");
            _goalLoaded = true;
            _updateLoadingState();
          },
        );

    _expenseSub = userRef
        .collection('expenses')
        .snapshots()
        .listen(
          (snap) {
            _applyExpensesData(snap.docs);
            _expenseLoaded = true;
            _updateLoadingState();
          },
          onError: (e) {
            debugPrint("Expense listener error: $e");
            _expenseLoaded = true;
            _updateLoadingState();
          },
        );
  }

  Future<void> fetchDashboardData() async {
    isLoading = true;
    notifyListeners();

    try {
      final user = FirebaseAuth.instance.currentUser;

      if (user == null) {
        isLoading = false;
        notifyListeners();
        return;
      }

      final userRef = FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid);

      final premiumGoalDoc = await userRef
          .collection('goals')
          .doc('premium_goal')
          .get();

      if (premiumGoalDoc.exists) {
        _applyGoalData(premiumGoalDoc.data());
      } else {
        final goalsSnap = await userRef.collection('goals').limit(1).get();

        if (goalsSnap.docs.isNotEmpty) {
          _applyGoalData(goalsSnap.docs.first.data());
        } else {
          _applyGoalData(null);
        }
      }

      final expenseSnap = await userRef.collection('expenses').get();
      _applyExpensesData(expenseSnap.docs);
    } catch (e) {
      debugPrint("Dashboard fetch error: $e");
    }

    isLoading = false;
    notifyListeners();
  }

  void _applyGoalData(Map<String, dynamic>? goalData) {
    if (goalData == null) {
      monthlyIncome = 0.0;
      monthlyBudget = 0.0;
      targetAmount = 0.0;
      goalName = "";
      return;
    }

    monthlyIncome = _toDouble(
      goalData['income'] ??
          goalData['monthlyIncome'] ??
          goalData['monthly_income'] ??
          goalData['totalIncome'],
    );

    targetAmount = _toDouble(
      goalData['target_amount'] ??
          goalData['targetAmount'] ??
          goalData['target'] ??
          goalData['goalAmount'],
    );

    monthlyBudget = monthlyIncome - targetAmount;
    if (monthlyBudget < 0) {
      monthlyBudget = 0.0;
    }

    goalName =
        (goalData['goal_name'] ??
                goalData['goalName'] ??
                goalData['selectedGoal'] ??
                goalData['goal'] ??
                "")
            .toString();
  }

  void _applyExpensesData(
    List<QueryDocumentSnapshot<Map<String, dynamic>>> docs,
  ) {
    double tempTotalSpent = 0.0;
    List<Map<String, dynamic>> allExpenses = [];

    for (final doc in docs) {
      final data = doc.data();

      final double amount = _toDouble(data['amount']);

      final DateTime expenseDate = _getDateTime(
        data['createdAt'] ??
            data['created_at'] ??
            data['date'] ??
            data['expenseDate'],
      );

      tempTotalSpent += amount;

      allExpenses.add({
        'id': doc.id,
        'title': data['title'] ?? data['name'] ?? 'Expense',
        'category': data['category'] ?? 'Other',
        'amount': amount,
        'createdAt': data['createdAt'] ?? data['created_at'],
        'dateTime': expenseDate,
        'timeText': _formatTime(expenseDate),
      });
    }

    totalSpent = tempTotalSpent;

    allExpenses.sort((a, b) {
      final DateTime dateA = a['dateTime'];
      final DateTime dateB = b['dateTime'];
      return dateB.compareTo(dateA);
    });

    final latest5 = allExpenses.take(5).toList();

    recentExpenses = latest5;
    recentExpenseGroups = _buildDateWiseGroups(latest5);
  }

  void _updateLoadingState() {
    if (_goalLoaded && _expenseLoaded) {
      isLoading = false;
    }

    notifyListeners();
  }

  @override
  void dispose() {
    _goalSub?.cancel();
    _expenseSub?.cancel();
    super.dispose();
  }
}
