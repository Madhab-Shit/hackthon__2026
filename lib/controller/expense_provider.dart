import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class GolesProvider extends ChangeNotifier {
  bool _isLoading = true;
  bool get isLoading => _isLoading;

  double _totalExpense = 0.0;
  double get totalExpense => _totalExpense;

  double _maxExpense = 0.0;
  double get maxExpense => _maxExpense;

  String _maxCategory = "";
  String get maxCategory => _maxCategory;

  List<Map<String, dynamic>> _categoryExpenses = [];
  List<Map<String, dynamic>> get categoryExpenses => _categoryExpenses;

  // ক্যাটাগরি অনুযায়ী কালার সেট করে রাখা হলো
  final Map<String, Color> _categoryColors = {
    'Food': const Color(0xFFFF7B00),
    'Transport': Colors.blue,
    'Entertainment': Colors.purple,
    'Bills': Colors.redAccent,
    'Shopping': Colors.pink,
    'Health': Colors.green,
    'Education': Colors.orange,
    'Other': Colors.teal,
  };

  Future<void> fetchExpenses() async {
    _isLoading = true;
    notifyListeners();

    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        _isLoading = false;
        notifyListeners();
        return;
      }

      // ফায়ারবেস থেকে বর্তমান ইউজারের expenses কালেকশন ফেচ করা
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('expenses')
          .get();

      Map<String, double> tempCategoryMap = {};
      double tempTotal = 0.0;

      // ডেটা লুপ করে ক্যাটাগরি অনুযায়ী যোগ করা
      for (var doc in snapshot.docs) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        String category = data['category'] ?? 'Other';
        // ফায়ারবেসে amount int বা double হিসেবে থাকতে পারে, তাই toDouble() ব্যবহার করা হলো
        double amount = (data['amount'] ?? 0).toDouble();

        tempTotal += amount;
        if (tempCategoryMap.containsKey(category)) {
          tempCategoryMap[category] = tempCategoryMap[category]! + amount;
        } else {
          tempCategoryMap[category] = amount;
        }
      }

      // Map থেকে List এ রূপান্তর এবং সর্বোচ্চ খরচ বের করা
      List<Map<String, dynamic>> tempList = [];
      double currentMax = 0.0;
      String currentMaxCat = "";

      tempCategoryMap.forEach((key, value) {
        if (value > currentMax) {
          currentMax = value;
          currentMaxCat = key;
        }

        tempList.add({
          'category': key,
          'amount': value,
          'color': _categoryColors[key] ?? Colors.grey.shade600, // লিস্টে না থাকলে ডিফল্ট কালার
        });
      });

      // অ্যামাউন্ট অনুযায়ী লিস্টটি বড় থেকে ছোট হিসেবে সাজানো (Sort)
      tempList.sort((a, b) => b['amount'].compareTo(a['amount']));

      _totalExpense = tempTotal;
      _categoryExpenses = tempList;
      _maxExpense = currentMax;
      _maxCategory = currentMaxCat;

    } catch (e) {
      debugPrint("Error fetching expenses: $e");
    }

    _isLoading = false;
    notifyListeners();
  }
}