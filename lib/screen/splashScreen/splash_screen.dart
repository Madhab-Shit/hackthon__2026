import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hacathon_2026/screen/authcheck/authcheck.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _logoController;
  late AnimationController _fadeController;

  late Animation<double> _logoScale;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    _logoController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1100),
    );

    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _logoScale = Tween<double>(begin: 0.70, end: 1.0).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.easeOutBack),
    );

    _fadeAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _fadeController, curve: Curves.easeOut));

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.22), end: Offset.zero).animate(
          CurvedAnimation(parent: _fadeController, curve: Curves.easeOutCubic),
        );

    _logoController.forward();

    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) {
        _fadeController.forward();
      }
    });

    Timer(const Duration(seconds: 3), () {
      if (!mounted) return;

      Get.offAll(
        () => const AuthChecker(),
        transition: Transition.noTransition,
        duration: Duration.zero,
      );
    });
  }

  @override
  void dispose() {
    _logoController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFF7B00),
      body: Stack(
        children: [
          const _PremiumOrangeBackground(),

          SafeArea(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 28),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ScaleTransition(
                      scale: _logoScale,
                      child: Container(
                        height: 134,
                        width: 134,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.16),
                              blurRadius: 28,
                              offset: const Offset(0, 14),
                            ),
                          ],
                        ),
                        child: Center(
                          child: Container(
                            height: 88,
                            width: 88,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: const LinearGradient(
                                colors: [Color(0xFFFF7B00), Color(0xFFFFA33A)],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(
                                    0xFFFF7B00,
                                  ).withOpacity(0.35),
                                  blurRadius: 18,
                                  offset: const Offset(0, 8),
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.eco_rounded,
                              color: Colors.white,
                              size: 48,
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 34),

                    FadeTransition(
                      opacity: _fadeAnimation,
                      child: SlideTransition(
                        position: _slideAnimation,
                        child: Column(
                          children: [
                            const Text(
                              "Green Track",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 37,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 0.5,
                              ),
                            ),

                            const SizedBox(height: 10),

                            Text(
                              "Track money. Save smarter.",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.88),
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.2,
                              ),
                            ),

                            const SizedBox(height: 38),

                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 22,
                                vertical: 14,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.18),
                                borderRadius: BorderRadius.circular(24),
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.30),
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  SizedBox(
                                    height: 18,
                                    width: 18,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2.3,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white.withOpacity(0.95),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Text(
                                    "Loading your wallet...",
                                    style: TextStyle(
                                      color: Colors.white.withOpacity(0.95),
                                      fontWeight: FontWeight.w700,
                                      fontSize: 14,
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
            ),
          ),

          Positioned(
            bottom: 34,
            left: 0,
            right: 0,
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: Text(
                "Smart Finance App",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.75),
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.4,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PremiumOrangeBackground extends StatelessWidget {
  const _PremiumOrangeBackground();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFFF7B00), Color(0xFFFF8F1F), Color(0xFFFFB156)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),

        Positioned(
          top: -90,
          right: -80,
          child: _circle(230, Colors.white.withOpacity(0.16)),
        ),

        Positioned(
          top: 120,
          left: -95,
          child: _circle(210, Colors.white.withOpacity(0.10)),
        ),

        Positioned(
          bottom: -110,
          right: -70,
          child: _circle(260, Colors.white.withOpacity(0.13)),
        ),

        Positioned(top: 95, right: 38, child: _smallDot(12)),

        Positioned(bottom: 160, left: 38, child: _smallDot(9)),

        Positioned(bottom: 235, right: 62, child: _smallDot(7)),

        Positioned.fill(child: CustomPaint(painter: _TrackLinePainter())),
      ],
    );
  }

  Widget _circle(double size, Color color) {
    return Container(
      height: size,
      width: size,
      decoration: BoxDecoration(shape: BoxShape.circle, color: color),
    );
  }

  Widget _smallDot(double size) {
    return Container(
      height: size,
      width: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white.withOpacity(0.35),
      ),
    );
  }
}

class _TrackLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final linePaint = Paint()
      ..color = Colors.white.withOpacity(0.13)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round;

    final path = Path();

    path.moveTo(size.width * 0.10, size.height * 0.68);
    path.cubicTo(
      size.width * 0.28,
      size.height * 0.58,
      size.width * 0.44,
      size.height * 0.78,
      size.width * 0.64,
      size.height * 0.62,
    );
    path.cubicTo(
      size.width * 0.76,
      size.height * 0.52,
      size.width * 0.86,
      size.height * 0.56,
      size.width * 0.96,
      size.height * 0.46,
    );

    canvas.drawPath(path, linePaint);

    final dotPaint = Paint()
      ..color = Colors.white.withOpacity(0.30)
      ..style = PaintingStyle.fill;

    canvas.drawCircle(
      Offset(size.width * 0.64, size.height * 0.62),
      5,
      dotPaint,
    );

    canvas.drawCircle(
      Offset(size.width * 0.96, size.height * 0.46),
      5,
      dotPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
