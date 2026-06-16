import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ExpenseProvider extends ChangeNotifier {
  bool isLoading = false;

  Future<void> saveExpense({
    required String amount,
    required String title,
    required String category,
    required String paymentMethod,
    required DateTime date,
  }) async {
    try {
      isLoading = true;
      notifyListeners();

      final user = FirebaseAuth.instance.currentUser;

      if (user == null) {
        return;
      }

      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('expenses')
          .add({
            'amount': double.parse(amount),
            'title': title.trim(),
            'category': category,
            'paymentMethod': paymentMethod,
            'date': Timestamp.fromDate(date),
            'createdAt': FieldValue.serverTimestamp(),
          });
      Get.back();

      Get.snackbar(
        "Success",
        "Expense saved successfully",
        backgroundColor: const Color(0xFFFF7B00),
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );

      await Future.delayed(const Duration(seconds: 2));
    } catch (e) {
      debugPrint(e.toString());
      return;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
