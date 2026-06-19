import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class GoalProvider extends ChangeNotifier {
  final TextEditingController incomeController = TextEditingController();

  // Eta r UI theke use hochhe na, but old code compatibility er jonno rakhlam
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

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  void setSelectedGoal(String goal) {
    _selectedGoal = goal;
    notifyListeners();
  }

  double _toDouble(String value) {
    return double.tryParse(value.trim()) ?? 0.0;
  }

  Future<bool> saveGoalToFirebase() async {
    _errorMessage = null;

    final double income = _toDouble(incomeController.text);
    final double targetAmount = _toDouble(targetController.text);

    if (incomeController.text.trim().isEmpty ||
        targetController.text.trim().isEmpty ||
        (_selectedGoal == "Other" &&
            customGoalController.text.trim().isEmpty)) {
      _errorMessage = "Please fill all required fields!";
      notifyListeners();
      return false;
    }

    if (income <= 0) {
      _errorMessage = "Monthly income must be greater than 0.";
      notifyListeners();
      return false;
    }

    if (targetAmount <= 0) {
      _errorMessage = "Goal money must be greater than 0.";
      notifyListeners();
      return false;
    }

    final double maxGoalMoney = income / 2;

    if (targetAmount > maxGoalMoney) {
      _errorMessage =
          "Max allowed ₹${maxGoalMoney.toStringAsFixed(0)}";
      notifyListeners();
      return false;
    }

    final double monthlyBudget = income - targetAmount;

    _isLoading = true;
    notifyListeners();

    try {
      final String finalGoal = _selectedGoal == "Other"
          ? customGoalController.text.trim()
          : _selectedGoal;

      final User? currentUser = FirebaseAuth.instance.currentUser;

      if (currentUser == null) {
        _errorMessage = "User not logged in!";
        _isLoading = false;
        notifyListeners();
        return false;
      }

      await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser.uid)
          .collection('goals')
          .doc('premium_goal')
          .set(
        {
          'income': income,
          'budget': monthlyBudget,
          'target_amount': targetAmount,
          'goal_name': finalGoal,
          'updated_at': FieldValue.serverTimestamp(),
        },
        SetOptions(merge: true),
      );

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      debugPrint("Error saving goal: $e");
      _errorMessage = "Something went wrong. Please try again.";
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  void clearControllers() {
    incomeController.clear();
    budgetController.clear();
    targetController.clear();
    customGoalController.clear();
    _selectedGoal = "New Phone";
    _errorMessage = null;
  }

  @override
  void dispose() {
    incomeController.dispose();
    budgetController.dispose();
    targetController.dispose();
    customGoalController.dispose();
    super.dispose();
  }
}