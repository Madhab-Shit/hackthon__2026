import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TermsPrivacyScreen extends StatelessWidget {
  const TermsPrivacyScreen({super.key});

  // Brand Colors
  final Color primaryOrange = const Color(0xFFFF7A00);
  final Color paleOrange = const Color(0xFFFFF3E8);
  final Color bgColor = const Color(0xFFFAFBFC);
  final Color textDark = const Color(0xFF1A1A1A);
  final Color textGrey = const Color(0xFF8C8C8C);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        backgroundColor: bgColor,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: textDark, size: 20),
          onPressed: () => Get.back(),
        ),
        title: Text(
          "Terms & Privacy",
          style: TextStyle(
            color: textDark,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Graphic & Update Info
            Center(
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: paleOrange,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.shield_outlined,
                      size: 50,
                      color: primaryOrange,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "Legal & Privacy Policy",
                    style: TextStyle(
                      color: textDark,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      "Last Updated: June 2026",
                      style: TextStyle(
                        color: textGrey,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Content Sections
            _buildPolicySection(
              icon: Icons.article_outlined,
              title: "1. Terms of Service",
              content:
                  "By using GreenTrack, you agree to our terms. Our smart budgeting assistant is designed to help college students manage their finances. You agree to provide accurate financial information for the best recommendations.",
            ),

            _buildPolicySection(
              icon: Icons.privacy_tip_outlined,
              title: "2. Privacy Policy",
              content:
                  "Your privacy is our priority. We collect data regarding your daily expenses, budget planning, and savings goals solely to provide personalized financial insights. We do not sell your personal data to third parties.",
            ),

            _buildPolicySection(
              icon: Icons.data_usage,
              title: "3. Data Usage & Protection",
              content:
                  "All financial data entered into GreenTrack is encrypted and stored securely. We use your data to predict budget sustainability and alert you during emergency survival modes as outlined in our mission.",
            ),

            _buildPolicySection(
              icon: Icons.gavel_outlined,
              title: "4. User Responsibilities",
              content:
                  "Users must not misuse the app to input fraudulent data. GreenTrack acts as an assistant and should not be considered professional financial or legal advice.",
            ),

            const SizedBox(height: 32),

            // Acknowledge Button
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: () => Get.back(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryOrange,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  shadowColor: primaryOrange.withOpacity(0.4),
                ),
                child: const Text(
                  'I Understand & Agree',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // --- WIDGET FUNCTIONS ---

  Widget _buildPolicySection({
    required IconData icon,
    required String title,
    required String content,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20.0),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: primaryOrange, size: 24),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    color: textDark,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            content,
            style: TextStyle(
              color: textGrey,
              fontSize: 14,
              height: 1.6, // Line height for better readability
            ),
          ),
        ],
      ),
    );
  }
}
