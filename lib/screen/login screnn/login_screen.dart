import 'dart:ui';
import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Gradient Orbs (for subtle top glow)
          Positioned(
            top: -50,
            left: MediaQuery.of(context).size.width * 0.1,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFFFF8E53).withOpacity(0.15),
              ),
            ),
          ),
          Positioned(
            top: 50,
            right: -50,
            child: Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFFFA7059).withOpacity(0.1),
              ),
            ),
          ),
          // Blur effect over the orbs
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 40, sigmaY: 40),
              child: const SizedBox(),
            ),
          ),

          // Bottom Layered Wavy Background
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: CustomPaint(
              size: Size(MediaQuery.of(context).size.width, 220),
              painter: PremiumWavePainter(),
            ),
          ),

          // Main Content
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                horizontal: 20.0,
                vertical: 20.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 10),

                  // Top Logo and Glassmorphism Floating Icons
                  SizedBox(
                    height: 180,
                    width: double.infinity,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // Center Logo with Glow
                        Container(
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: const Color(
                                  0xFFFA7059,
                                ).withOpacity(0.15),
                                blurRadius: 30,
                                spreadRadius: 10,
                              ),
                            ],
                          ),
                          child: ShaderMask(
                            shaderCallback: (Rect bounds) {
                              return const LinearGradient(
                                colors: [Color(0xFFFF8E53), Color(0xFFFA7059)],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ).createShader(bounds);
                            },
                            child: const Icon(
                              Icons.eco_rounded,
                              size: 48,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        // Floating Glass Icons
                        Positioned(
                          top: 10,
                          left: 40,
                          child: _buildGlassIcon(
                            Icons.account_balance_wallet_rounded,
                          ),
                        ),
                        Positioned(
                          top: 20,
                          right: 40,
                          child: _buildGlassIcon(Icons.bar_chart_rounded),
                        ),
                        Positioned(
                          bottom: 20,
                          left: 50,
                          child: _buildGlassIcon(Icons.pie_chart_rounded),
                        ),
                        Positioned(
                          bottom: 30,
                          right: 30,
                          child: _buildGlassIcon(Icons.savings_rounded),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 10),

                  // ================= MAIN LOGIN CARD =================
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(28),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.04),
                          blurRadius: 40,
                          offset: const Offset(0, 15),
                        ),
                        BoxShadow(
                          color: const Color(0xFFFA7059).withOpacity(0.05),
                          blurRadius: 20,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        // Welcome Text
                        const Text(
                          "Welcome Back",
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF2D3142),
                            letterSpacing: -0.5,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          "Login to manage your finances",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xFF9098B1),
                            height: 1.5,
                            fontWeight: FontWeight.w500,
                          ),
                        ),

                        const SizedBox(height: 30),

                        // Premium Filled Email Field
                        _buildTextField(
                          hintText: "Email Address",
                          icon: Icons.email_outlined,
                        ),

                        const SizedBox(height: 16),

                        // Premium Filled Password Field
                        _buildTextField(
                          hintText: "Password",
                          icon: Icons.lock_outline,
                          isPassword: true,
                        ),

                        const SizedBox(height: 8),

                        // Forgot Password
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () {},
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.zero,
                              foregroundColor: const Color(0xFFFA7059),
                            ),
                            child: const Text(
                              "Forgot Password?",
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 16),

                        // Glowing Gradient Login Button
                        Container(
                          width: double.infinity,
                          height: 55,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(18),
                            gradient: const LinearGradient(
                              colors: [Color(0xFFFF8E53), Color(0xFFFA7059)],
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(
                                  0xFFFA7059,
                                ).withOpacity(0.35),
                                blurRadius: 20,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(18),
                              onTap: () {},
                              child: const Center(
                                child: Text(
                                  "Login",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // ================= END MAIN LOGIN CARD =================
                  const SizedBox(height: 30),

                  // Divider
                  Row(
                    children: [
                      Expanded(
                        child: Divider(
                          color: Colors.grey.shade300,
                          thickness: 1,
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          "or continue with",
                          style: TextStyle(
                            color: Color(0xFF9098B1),
                            fontSize: 13,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Divider(
                          color: Colors.grey.shade300,
                          thickness: 1,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Google Login Button
                  // SizedBox(
                  //   width: double.infinity,
                  //   height: 55,
                  //   child: OutlinedButton.icon(
                  //     onPressed: () {},
                  //     icon: Image.network(
                  //       'https://upload.wikimedia.org/wikipedia/commons/c/c1/Google_%22G%22_logo.svg',
                  //       height: 22,
                  //     ),
                  //     label: const Text(
                  //       "Google",
                  //       style: TextStyle(
                  //         color: Color(0xFF2D3142),
                  //         fontSize: 15,
                  //         fontWeight: FontWeight.bold,
                  //       ),
                  //     ),
                  //     style: OutlinedButton.styleFrom(
                  //       side: BorderSide(color: Colors.grey.shade300, width: 1.5),
                  //       shape: RoundedRectangleBorder(
                  //         borderRadius: BorderRadius.circular(18),
                  //       ),
                  //       backgroundColor: Colors.white,
                  //       elevation: 1,
                  //       shadowColor: Colors.black.withOpacity(0.05),
                  //     ),
                  //   ),
                  // ),
                  const SizedBox(height: 24),

                  // Register Link
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Don't have an account? ",
                        style: TextStyle(
                          color: Color(0xFF9098B1),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {},
                        child: const Text(
                          "Register",
                          style: TextStyle(
                            color: Color(0xFFFA7059),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Helper widget for Glassmorphic Floating Icons
  Widget _buildGlassIcon(IconData icon) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(14),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.4),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: Colors.white.withOpacity(0.6),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10),
            ],
          ),
          child: Icon(icon, color: const Color(0xFFFA7059), size: 18),
        ),
      ),
    );
  }

  // Helper widget for Text Fields (styled for inside the card)
  Widget _buildTextField({
    required String hintText,
    required IconData icon,
    bool isPassword = false,
  }) {
    return TextFormField(
      obscureText: isPassword,
      style: const TextStyle(
        fontWeight: FontWeight.w500,
        color: Color(0xFF2D3142),
      ),
      decoration: InputDecoration(
        filled: true,
        fillColor: const Color(0xFFFAFAFC), // Slight grey inside the white card
        hintText: hintText,
        hintStyle: const TextStyle(
          color: Color(0xFF9098B1),
          fontWeight: FontWeight.w400,
          fontSize: 14,
        ),
        prefixIcon: Icon(icon, color: const Color(0xFFFA7059), size: 22),
        suffixIcon: isPassword
            ? const Icon(
                Icons.visibility_outlined,
                color: Color(0xFF9098B1),
                size: 22,
              )
            : null,
        contentPadding: const EdgeInsets.symmetric(vertical: 18),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Colors.grey.shade200, width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Color(0xFFFA7059), width: 2),
        ),
      ),
    );
  }
}

// Custom Painter for Layered Premium Waves
class PremiumWavePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Background layer wave (lighter)
    var paint1 = Paint()
      ..color = const Color(0xFFFF8E53).withOpacity(0.25)
      ..style = PaintingStyle.fill;

    var path1 = Path();
    path1.lineTo(0, size.height * 0.4);
    path1.quadraticBezierTo(
      size.width * 0.25,
      size.height * 0.1,
      size.width * 0.5,
      size.height * 0.5,
    );
    path1.quadraticBezierTo(
      size.width * 0.75,
      size.height * 0.9,
      size.width,
      size.height * 0.2,
    );
    path1.lineTo(size.width, size.height);
    path1.lineTo(0, size.height);
    path1.close();
    canvas.drawPath(path1, paint1);

    // Foreground layer wave (gradient)
    var paint2 = Paint()
      ..shader = const LinearGradient(
        colors: [Color(0xFFFF8E53), Color(0xFFFA7059)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    var path2 = Path();
    path2.lineTo(0, size.height * 0.5);
    path2.quadraticBezierTo(
      size.width * 0.25,
      size.height * 0.2,
      size.width * 0.5,
      size.height * 0.6,
    );
    path2.quadraticBezierTo(
      size.width * 0.8,
      size.height * 1.0,
      size.width,
      size.height * 0.3,
    );
    path2.lineTo(size.width, size.height);
    path2.lineTo(0, size.height);
    path2.close();
    canvas.drawPath(path2, paint2);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
