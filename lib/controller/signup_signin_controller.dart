import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:hacathon_2026/screen/onbording_screen.dart';

class AuthProvider extends ChangeNotifier {
  bool isLogin = true;
  bool isLoading = false;
  bool isPasswordVisible = false;

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

  // Authentication Logic
  Future<void> submitAuth(BuildContext context) async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();
    final name = nameController.text.trim();

    if (email.isEmpty || password.isEmpty || (!isLogin && name.isEmpty)) {
      _showSnackBar(context, "Please fill in all fields!");
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
        //login
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
        Get.offAll(() => OnboardingFlow());

        // _showSnackBar(context, "Account Created Successfully!");
        // TODO: Navigate to Home Screen
      }
    } on FirebaseAuthException catch (e) {
      _showSnackBar(context, e.message ?? "An error occurred");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
