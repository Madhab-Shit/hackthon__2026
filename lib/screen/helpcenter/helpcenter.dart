import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HelpCenterScreen extends StatelessWidget {
  const HelpCenterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFFFF7B00);

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FB),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: true,
        title: const Text(
          "Help Center",
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: Icon(Icons.arrow_back_ios),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            /// Header Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: primaryColor,
                borderRadius: BorderRadius.circular(24),
              ),
              child: const Column(
                children: [
                  Icon(
                    Icons.support_agent_rounded,
                    color: Colors.white,
                    size: 50,
                  ),
                  SizedBox(height: 12),
                  Text(
                    "How can we help you?",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "Find answers to common questions about GreenTrack.",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white70),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            _faqTile(
              "How do I add an expense?",
              "Go to Expenses tab and tap the + button to add a new expense.",
            ),

            _faqTile(
              "How do I create a savings goal?",
              "Navigate to Goals section and set your target amount.",
            ),

            _faqTile(
              "What is Emergency Mode?",
              "Emergency Mode provides spending reduction suggestions during financial difficulties.",
            ),

            _faqTile(
              "How are insights generated?",
              "GreenTrack analyzes your spending habits and provides personalized recommendations.",
            ),

            _faqTile(
              "Is my data secure?",
              "Yes, your data is securely stored using Firebase Authentication and Firestore.",
            ),

            const SizedBox(height: 25),

            /// Contact Support
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(.04),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                children: [
                  const Text(
                    "Need More Help?",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 15),

                  ListTile(
                    leading: CircleAvatar(
                      backgroundColor: primaryColor.withOpacity(.15),
                      child: const Icon(
                        Icons.email_outlined,
                        color: primaryColor,
                      ),
                    ),
                    title: const Text("support@greentrack.com"),
                  ),

                  ListTile(
                    leading: CircleAvatar(
                      backgroundColor: primaryColor.withOpacity(.15),
                      child: const Icon(
                        Icons.phone_outlined,
                        color: primaryColor,
                      ),
                    ),
                    title: const Text("+91 9876543210"),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Widget _faqTile(String title, String answer) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ExpansionTile(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Text(answer, style: const TextStyle(color: Colors.black54)),
          ),
        ],
      ),
    );
  }
}
