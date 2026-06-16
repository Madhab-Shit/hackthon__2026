import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ExpensesListProvider extends ChangeNotifier {
  bool isLoading = false;
  bool isDeleting = false;

  double totalExpense = 0.0;

  List<Map<String, dynamic>> allExpenses = [];
  List<Map<String, dynamic>> expenseGroups = [];

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

    if (value is Timestamp) {
      return value.toDate();
    }

    if (value is DateTime) {
      return value;
    }

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

    // Latest date first
    keys.sort((a, b) {
      final dateA = DateTime.parse(a);
      final dateB = DateTime.parse(b);
      return dateB.compareTo(dateA);
    });

    return keys.map((key) {
      final date = DateTime.parse(key);
      final items = groupedMap[key]!;

      double dayTotal = 0.0;

      for (final item in items) {
        dayTotal += _toDouble(item['amount']);
      }

      // Same date-er moddhe latest first
      items.sort((a, b) {
        final DateTime dateA = a['dateTime'];
        final DateTime dateB = b['dateTime'];
        return dateB.compareTo(dateA);
      });

      return {
        'date': date,
        'title': _formatDateTitle(date),
        'dayTotal': dayTotal,
        'items': items,
      };
    }).toList();
  }

  Future<void> fetchExpenses() async {
    isLoading = true;
    notifyListeners();

    try {
      final user = FirebaseAuth.instance.currentUser;

      if (user == null) {
        isLoading = false;
        notifyListeners();
        return;
      }

      final expenseSnap = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('expenses')
          .get();

      double tempTotal = 0.0;
      List<Map<String, dynamic>> tempExpenses = [];

      for (final doc in expenseSnap.docs) {
        final data = doc.data();

        final double amount = _toDouble(data['amount']);

        final DateTime expenseDate = _getDateTime(
          data['createdAt'] ??
              data['created_at'] ??
              data['date'] ??
              data['expenseDate'],
        );

        tempTotal += amount;

        tempExpenses.add({
          'id': doc.id,
          'title': data['title'] ?? data['name'] ?? 'Expense',
          'category': data['category'] ?? 'Other',
          'amount': amount,
          'createdAt': data['createdAt'] ?? data['created_at'],
          'dateTime': expenseDate,
          'timeText': _formatTime(expenseDate),
        });
      }

      tempExpenses.sort((a, b) {
        final DateTime dateA = a['dateTime'];
        final DateTime dateB = b['dateTime'];
        return dateB.compareTo(dateA);
      });

      totalExpense = tempTotal;
      allExpenses = tempExpenses;
      expenseGroups = _buildDateWiseGroups(tempExpenses);
    } catch (e) {
      debugPrint("Fetch expenses error: $e");
    }

    isLoading = false;
    notifyListeners();
  }

  Future<bool> deleteExpense(String expenseId) async {
    try {
      final user = FirebaseAuth.instance.currentUser;

      if (user == null) {
        return false;
      }

      isDeleting = true;
      notifyListeners();

      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('expenses')
          .doc(expenseId)
          .delete();

      await fetchExpenses();

      isDeleting = false;
      notifyListeners();

      return true;
    } catch (e) {
      debugPrint("Delete expense error: $e");

      isDeleting = false;
      notifyListeners();

      return false;
    }
  }
}