import 'package:flutter/material.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color(
        0xFFFBFBFD,
      ), // iOS subtle off-white background
      body: Stack(
        children: [
          // Background subtle particles
          Positioned(
            top: size.height * 0.15,
            right: size.width * 0.25,
            child: _buildDot(),
          ),
          Positioned(
            top: size.height * 0.25,
            left: size.width * 0.2,
            child: _buildDot(),
          ),
          Positioned(
            top: size.height * 0.4,
            right: size.width * 0.15,
            child: _buildDot(),
          ),

          Positioned(
            top: size.height * 0.14,
            left: size.width * 0.12,
            child: _buildFloatingIcon(
              Icons.account_balance_wallet_rounded,
              const Color(0xFFFF9500),
            ),
          ),
          Positioned(
            top: size.height * 0.18,
            right: size.width * 0.10,
            child: _buildFloatingIcon(
              Icons.insert_chart_rounded,
              const Color(0xFFFF9500),
            ),
          ),
          Positioned(
            top: size.height * 0.40,
            left: size.width * 0.10,
            child: _buildFloatingIcon(
              Icons.pie_chart_rounded,
              const Color(0xFFFF5E3A),
            ),
          ),
          Positioned(
            top: size.height * 0.43,
            right: size.width * 0.12,
            child: _buildFloatingIcon(
              Icons.savings_rounded,
              const Color(0xFFFF5E3A),
            ),
          ),

          // Central Logo and Text Content
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: size.height * 0.05),

              // Main Glowing Logo (Premium iOS feel)
              Center(
                child: Container(
                  width: 160,
                  height: 160,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFFFF9500).withOpacity(0.15),
                        blurRadius: 50,
                        spreadRadius: 10,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Container(
                      width: 110,
                      height: 110,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30), // iOS Squircle
                        gradient: const LinearGradient(
                          colors: [
                            Color(0xFFFFB74D),
                            Color(0xFFFF5E3A),
                          ], // Apple Orange Gradient
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFFFF5E3A).withOpacity(0.4),
                            blurRadius: 20,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.energy_savings_leaf_rounded, // Leaf icon
                        color: Colors.white,
                        size: 55,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 55),

              // Welcome Text (Clean iOS Typography)
              const Text(
                "Welcome to",
                style: TextStyle(
                  fontSize: 32, // Slightly larger
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.5, // Tighter tracking for iOS look
                  color: Color(0xFF1C1C1E), // iOS System Black
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text(
                    "GreenTrack ",
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.5,
                      color: Color(0xFFFF5E3A), // Vibrant Apple Orange
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Subtitle Text
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 40.0),
                child: Text(
                  "Take control of your finances and\nachieve your savings goals effortlessly.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF8E8E93), // iOS System Gray
                    height: 1.4,
                    letterSpacing: -0.2,
                  ),
                ),
              ),
              SizedBox(height: size.height * 0.25), // Space for bottom wave
            ],
          ),

          // Bottom Orange Wave (Smoother Gradient)
          Align(
            alignment: Alignment.bottomCenter,
            child: ClipPath(
              clipper: BottomWaveClipper(),
              child: Container(
                height: size.height * 0.25,
                width: double.infinity,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color(0xFFFF9500),
                      Color(0xFFFF5E3A),
                    ], // Apple System Oranges
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(
                    bottom: 40.0,
                    left: 32.0,
                    right: 32.0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const SizedBox(width: 60), // Spacer
                      // Page Indicators (Pill shaped for active)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildPageIndicator(false),
                          const SizedBox(width: 8),
                          _buildPageIndicator(true),
                          const SizedBox(width: 8),
                          _buildPageIndicator(false),
                        ],
                      ),

                      // Next Button (Clean Minimalist)
                      GestureDetector(
                        onTap: () {
                          // Navigation logic
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            children: const [
                              Text(
                                "Next",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: -0.3,
                                ),
                              ),
                              SizedBox(width: 6),
                              Icon(
                                Icons.arrow_forward_ios_rounded,
                                color: Colors.white,
                                size: 16,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // iOS Style Squircle Floating Icons
  Widget _buildFloatingIcon(IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18), // Squircles instead of circles
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(
              0.04,
            ), // Very soft, large spread shadow
            blurRadius: 20,
            spreadRadius: 2,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Icon(icon, color: color, size: 26),
    );
  }

  // Subtle background elements
  Widget _buildDot() {
    return Container(
      width: 8,
      height: 8,
      decoration: BoxDecoration(
        color: const Color(0xFFFF9500).withOpacity(0.2),
        shape: BoxShape.circle,
      ),
    );
  }

  // iOS pill-shaped active indicator
  Widget _buildPageIndicator(bool isActive) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      height: 8,
      width: isActive ? 24 : 8, // Pill shape when active
      decoration: BoxDecoration(
        color: isActive ? Colors.white : Colors.white.withOpacity(0.4),
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}

// Wave remains the same, as it provides a nice structural base
class BottomWaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, size.height * 0.4);

    var firstControlPoint = Offset(size.width * 0.35, size.height * 0.7);
    var firstEndPoint = Offset(size.width * 0.65, size.height * 0.45);
    path.quadraticBezierTo(
      firstControlPoint.dx,
      firstControlPoint.dy,
      firstEndPoint.dx,
      firstEndPoint.dy,
    );

    var secondControlPoint = Offset(size.width * 0.85, size.height * 0.3);
    var secondEndPoint = Offset(size.width, size.height * 0.2);
    path.quadraticBezierTo(
      secondControlPoint.dx,
      secondControlPoint.dy,
      secondEndPoint.dx,
      secondEndPoint.dy,
    );

    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
