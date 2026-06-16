import 'package:flutter/material.dart';
import 'package:hacathon_2026/controller/signup_signin_controller.dart';
import 'package:provider/provider.dart';
// Provider file ta import kore niben: import 'auth_provider.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 247, 238),
      // Consumer wrap kora holo
      body: Consumer<AuthProvider>(
        builder: (context, authProvider, child) {
          return SingleChildScrollView(
            child: SizedBox(
              height: size.height,
              child: Stack(
                children: [
                  SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 28.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 30),

                          // Logo
                          Center(
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(
                                      0xFFFF5E3A,
                                    ).withOpacity(0.15),
                                    blurRadius: 20,
                                    offset: const Offset(0, 8),
                                  ),
                                ],
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: Image.asset(
                                  'assets/images/logo.png',
                                  fit: BoxFit.cover,
                                  scale: 2,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 32),

                          // Animated Welcome Text
                          AnimatedSwitcher(
                            duration: const Duration(milliseconds: 300),
                            switchInCurve: Curves.easeIn,
                            switchOutCurve: Curves.easeOut,
                            child: Text(
                              authProvider.isLogin
                                  ? "Welcome Back,"
                                  : "Create Account,",
                              key: ValueKey<bool>(authProvider.isLogin),
                              style: const TextStyle(
                                fontSize: 34,
                                fontWeight: FontWeight.w900,
                                letterSpacing: -1.0,
                                color: Color(0xFF1C1C1E),
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),

                          // Animated Subtitle Text
                          AnimatedSwitcher(
                            duration: const Duration(milliseconds: 300),
                            child: Text(
                              authProvider.isLogin
                                  ? "Sign in to continue your financial journey\nwith GreenTrack."
                                  : "Join GreenTrack to start achieving your\nfinancial goals today.",
                              key: ValueKey<bool>(authProvider.isLogin),
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                                color: Color(0xFF8E8E93),
                                height: 1.5,
                                letterSpacing: 0.2,
                              ),
                            ),
                          ),
                          const SizedBox(height: 40),

                          // Name Field (Appears only on Sign Up)
                          AnimatedSize(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                            child: authProvider.isLogin
                                ? const SizedBox.shrink()
                                : Padding(
                                    padding: const EdgeInsets.only(
                                      bottom: 20.0,
                                    ),
                                    child: _buildPremiumTextField(
                                      controller: authProvider.nameController,
                                      hint: "Full Name",
                                      icon: Icons.person_outline_rounded,
                                      authProvider: authProvider,
                                    ),
                                  ),
                          ),

                          // Email Field
                          _buildPremiumTextField(
                            controller: authProvider.emailController,
                            hint: "Email address",
                            icon: Icons.email_outlined,
                            keyboardType: TextInputType.emailAddress,
                            authProvider: authProvider,
                          ),
                          const SizedBox(height: 20),

                          // Password Field
                          _buildPremiumTextField(
                            controller: authProvider.passwordController,
                            hint: "Password",
                            icon: Icons.lock_outline_rounded,
                            isPassword: true,
                            authProvider: authProvider,
                          ),

                          // Forgot Password
                          AnimatedSize(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                            child: authProvider.isLogin
                                ? Align(
                                    alignment: Alignment.centerRight,
                                    child: Padding(
                                      padding: const EdgeInsets.only(top: 12.0),
                                      child: TextButton(
                                        onPressed: () {
                                          authProvider.resetPassword(context);
                                        },
                                        style: TextButton.styleFrom(
                                          foregroundColor: const Color(
                                            0xffFF7B00,
                                          ),
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 8,
                                          ),
                                        ),
                                        child: const Text(
                                          "Forgot Password?",
                                          style: TextStyle(
                                            fontWeight: FontWeight.w700,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                : const SizedBox(height: 30),
                          ),

                          SizedBox(height: authProvider.isLogin ? 20 : 10),

                          // Action Button (Login / Sign Up)
                          GestureDetector(
                            onTap: authProvider.isLoading
                                ? null
                                : () => authProvider.submitAuth(context),
                            child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(vertical: 20),
                              decoration: BoxDecoration(
                                color: const Color(0xffFF7B00),
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(
                                      0xffFF7B00,
                                    ).withOpacity(0.3),
                                    blurRadius: 20,
                                    offset: const Offset(0, 8),
                                  ),
                                ],
                              ),
                              child: Center(
                                child: authProvider.isLoading
                                    ? const SizedBox(
                                        height: 24,
                                        width: 24,
                                        child: CircularProgressIndicator(
                                          color: Colors.white,
                                          strokeWidth: 3,
                                        ),
                                      )
                                    : Text(
                                        authProvider.isLogin
                                            ? "Sign In"
                                            : "Sign Up",
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                          fontWeight: FontWeight.w800,
                                          letterSpacing: 0.5,
                                        ),
                                      ),
                              ),
                            ),
                          ),

                          const Spacer(),

                          // Bottom Toggle Section
                          Padding(
                            padding: const EdgeInsets.only(bottom: 40.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  authProvider.isLogin
                                      ? "Don't have an account? "
                                      : "Already have an account? ",
                                  style: const TextStyle(
                                    color: Color(0xFF8E8E93),
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                GestureDetector(
                                  onTap: authProvider.toggleView,
                                  child: Text(
                                    authProvider.isLogin
                                        ? "Sign Up"
                                        : "Sign In",
                                    style: const TextStyle(
                                      color: Color(0xffFF7B00),
                                      fontSize: 15,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildPremiumTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    bool isPassword = false,
    TextInputType keyboardType = TextInputType.text,
    required AuthProvider authProvider, // Provider pass kora holo
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFEFE8E1), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        obscureText: isPassword && !authProvider.isPasswordVisible,
        keyboardType: keyboardType,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Color(0xFF1C1C1E),
        ),
        decoration: InputDecoration(
          prefixIcon: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Icon(icon, color: Colors.orange, size: 24),
          ),
          prefixIconConstraints: const BoxConstraints(minWidth: 60),
          suffixIcon: isPassword
              ? IconButton(
                  icon: Icon(
                    authProvider.isPasswordVisible
                        ? Icons.visibility_rounded
                        : Icons.visibility_off_rounded,
                    color: const Color(0xFFC7C7CC),
                    size: 22,
                  ),
                  onPressed: authProvider.togglePasswordVisibility,
                )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 20),
          hintText: hint,
          hintStyle: const TextStyle(
            color: Color(0xFFD1D1D6),
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
