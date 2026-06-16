import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:hacathon_2026/screen/bottomNavigationBar/bottom_navigation.dart';
import 'package:hacathon_2026/screen/dashboard/dashboard.dart';
import 'package:hacathon_2026/screen/onbording_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider extends ChangeNotifier {
  bool isLogin = true;
  bool isLoading = false;
  bool isPasswordVisible = false;

  bool islogin = false;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void toggleView() {
    isLogin = !isLogin;
    notifyListeners();
  }

  void togglePasswordVisibility() {
    isPasswordVisible = !isPasswordVisible;
    notifyListeners();
  }

  // Basic email validation regex
  bool _isValidEmail(String email) {
    return RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
    ).hasMatch(email);
  }

  // Authentication Logic
  Future<void> submitAuth(BuildContext context) async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();
    final name = nameController.text.trim();

    // 1. Basic Empty Field Validation
    if (email.isEmpty || password.isEmpty || (!isLogin && name.isEmpty)) {
      _showCustomPremiumSnackBar(
        title: "Oops!",
        message: "Please fill in all fields!",
        icon: Icons.warning_amber_rounded,
        backgroundColor: const Color(0xFFFF9500), // Orange Warning
      );
      return;
    }

    // 2. Email Format Validation
    if (!_isValidEmail(email)) {
      _showCustomPremiumSnackBar(
        title: "Invalid Email",
        message: "Please enter a valid email address!",
        icon: Icons.alternate_email_rounded,
        backgroundColor: const Color(0xFFFF3B30), // Red Error
      );
      return;
    }

    // 3. Password Length Validation (Firebase requires at least 6 chars)
    if (password.length < 6) {
      _showCustomPremiumSnackBar(
        title: "Weak Password",
        message: "Password must be at least 6 characters long!",
        icon: Icons.lock_outline_rounded,
        backgroundColor: const Color(0xFFFF3B30), // Red Error
      );
      return;
    }

    isLoading = true;
    notifyListeners();

    try {
      if (isLogin) {
        // --- SIGN IN ---
        await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('isLoggedIn', true);

        Get.offAll(() => MainNavigationScreen());
        _showCustomPremiumSnackBar(
          title: "Welcome Back!",
          message: "Login Successful!",
          icon: Icons.check_circle_outline_rounded,
          backgroundColor: const Color(0xFF34C759), // Green Success
        );
        // TODO: Navigate to Home Screen
      } else {
        // --- SIGN UP ---
        UserCredential userCredential = await _auth
            .createUserWithEmailAndPassword(email: email, password: password);

        // Save Name to Firestore
        await _firestore.collection('users').doc(userCredential.user!.uid).set({
          'uid': userCredential.user!.uid,
          'name': name,
          'email': email,
          'createdAt': FieldValue.serverTimestamp(),
        });
        Get.offAll(() => MainNavigationScreen());

        _showCustomPremiumSnackBar(
          title: "Welcome!",
          message: "Account Created Successfully!",
          icon: Icons.check_circle_outline_rounded,
          backgroundColor: const Color(0xFF34C759), // Green Success
        );
      }
    } on FirebaseAuthException catch (e) {
      // --- FIREBASE ERROR HANDLING ---
      String errorMessage = "An unexpected error occurred. Please try again.";

      switch (e.code) {
        case 'invalid-email':
          errorMessage = "The email address is badly formatted.";
          break;
        case 'user-disabled':
          errorMessage = "This account has been disabled by an administrator.";
          break;
        case 'user-not-found':
        case 'wrong-password':
        case 'invalid-credential':
          errorMessage = "Invalid email or password. Please try again.";
          break;
        case 'email-already-in-use':
          errorMessage = "An account already exists for that email address.";
          break;
        case 'weak-password':
          errorMessage = "The password provided is too weak.";
          break;
        case 'network-request-failed':
          errorMessage =
              "Network error. Please check your internet connection.";
          break;
        case 'too-many-requests':
          errorMessage = "Too many attempts. Please try again later.";
          break;
        default:
          errorMessage = e.message ?? errorMessage;
      }

      _showCustomPremiumSnackBar(
        title: "Error",
        message: errorMessage,
        icon: Icons.error_outline_rounded,
        backgroundColor: const Color(0xFFFF3B30), // Red Error
      );
    } catch (e) {
      // Catch any other non-Firebase errors
      _showCustomPremiumSnackBar(
        title: "Error",
        message: "Something went wrong. Please try again.",
        icon: Icons.error_outline_rounded,
        backgroundColor: const Color(0xFFFF3B30), // Red Error
      );
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // --- GETX PREMIUM SNACKBAR ---
  void _showCustomPremiumSnackBar({
    required String title,
    required String message,
    required IconData icon,
    required Color backgroundColor,
  }) {
    if (Get.isSnackbarOpen) {
      Get.closeAllSnackbars();
    }

    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.TOP,
      backgroundColor: backgroundColor,
      colorText: Colors.white,
      icon: Padding(
        padding: const EdgeInsets.only(left: 8.0),
        child: Icon(icon, color: Colors.white, size: 28),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      borderRadius: 16,
      duration: const Duration(seconds: 4),
      isDismissible: true,
      dismissDirection: DismissDirection.horizontal,
      forwardAnimationCurve: Curves.easeOutBack,
      boxShadows: [
        BoxShadow(
          color: Colors.black.withOpacity(0.15),
          blurRadius: 15,
          offset: const Offset(0, 8),
        ),
      ],
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
