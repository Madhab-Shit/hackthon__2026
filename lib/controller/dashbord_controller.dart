import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class GoalProvider extends ChangeNotifier {
  final TextEditingController incomeController = TextEditingController();
  final TextEditingController budgetController = TextEditingController();
  final TextEditingController targetController = TextEditingController();
  final TextEditingController customGoalController = TextEditingController();

  final List<String> predefinedGoals = [
    "New Phone",
    "Laptop",
    "Course",
    "Bike",
    "Other",
  ];

  String _selectedGoal = "New Phone";
  String get selectedGoal => _selectedGoal;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  void setSelectedGoal(String goal) {
    _selectedGoal = goal;
    notifyListeners();
  }

  // Firebase এ ডেটা সেভ করার ফাংশন
  Future<bool> saveGoalToFirebase() async {
    // Validation
    if (incomeController.text.isEmpty ||
        budgetController.text.isEmpty ||
        targetController.text.isEmpty ||
        (_selectedGoal == "Other" && customGoalController.text.isEmpty)) {
      return false; // Validation failed
    }

    _isLoading = true;
    notifyListeners();

    try {
      String finalGoal = _selectedGoal == "Other"
          ? customGoalController.text
          : _selectedGoal;

      // Current Logged-in User ID বের করা
      User? currentUser = FirebaseAuth.instance.currentUser;

      if (currentUser != null) {
        // ইউজারের নির্দিষ্ট Document ID তে ডেটা সেভ করা
        await FirebaseFirestore.instance
            .collection('users')
            .doc(currentUser.uid) // Logged in user's doc id
            .collection('goals')
            .doc() // অথবা তুমি চাইলে random ID ও জেনারেট করতে পারো .doc() দিয়ে
            .set(
              {
                'income': double.tryParse(incomeController.text) ?? 0.0,
                'budget': double.tryParse(budgetController.text) ?? 0.0,
                'target_amount': double.tryParse(targetController.text) ?? 0.0,
                'goal_name': finalGoal,
                'created_at': FieldValue.serverTimestamp(),
              },
              SetOptions(merge: true),
            ); // merge: true দিলে আগের ডেটা রিপ্লেস না হয়ে আপডেট হবে
      }

      _isLoading = false;
      notifyListeners();
      return true; // Success
    } catch (e) {
      print("Error saving goal: $e");
      _isLoading = false;
      notifyListeners();
      return false; // Failed
    }
  }

  // Provider dispose হওয়ার সময় কন্ট্রোলারগুলো ক্লিয়ার করে দেওয়া ভালো
  void clearControllers() {
    incomeController.clear();
    budgetController.clear();
    targetController.clear();
    customGoalController.clear();
    _selectedGoal = "New Phone";
  }
}
