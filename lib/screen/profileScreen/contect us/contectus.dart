import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactUsScreen extends StatefulWidget {
  const ContactUsScreen({super.key});

  @override
  State<ContactUsScreen> createState() => _ContactUsScreenState();
}

class _ContactUsScreenState extends State<ContactUsScreen> {
  // Brand Colors matching your Profile Screen
  final Color primaryOrange = const Color(0xFFFF7A00);
  final Color paleOrange = const Color(0xFFFFF3E8);
  final Color bgColor = const Color(0xFFFAFBFC);
  final Color textDark = const Color(0xFF1A1A1A);
  final Color textGrey = const Color(0xFF8C8C8C);

  // Form Key & Controllers
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController messageController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    messageController.dispose();
    super.dispose();
  }

  bool isLoading = false;

  Future<void> _launchEmail() async {
    setState(() => isLoading = true);

    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: 'abhinandan2024gayen@gmail.com',
    );

    await launchUrl(emailUri);

    setState(() => isLoading = false);
  }

  Future<void> _launchPhone() async {
    setState(() => isLoading = true);

    final Uri phoneUri = Uri(scheme: 'tel', path: '+919735833466');

    await launchUrl(phoneUri);

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColor,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: textDark, size: 20),
          onPressed: () => Get.back(),
        ),
        title: Text(
          "Contact Us",
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
            // Top Illustration & Text
            Center(
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: paleOrange,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.support_agent_rounded,
                      size: 60,
                      color: primaryOrange,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "We're Here to Help!",
                    style: TextStyle(
                      color: textDark,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Have a question about GreenTrack or need support? Send us a message.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: textGrey,
                      fontSize: 14,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Quick Contact Cards
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: _launchEmail,
                    child: _buildContactCard(
                      icon: Icons.email_outlined,
                      title: 'Email Us',
                      subtitle: 'abhinandan2024gayen@gmail.com',
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: GestureDetector(
                    onTap: _launchPhone,
                    child: _buildContactCard(
                      icon: Icons.phone_outlined,
                      title: 'Call Us',
                      subtitle: '+919735833466',
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),

            // // Message Form
            // Text(
            //   "Send a Message",
            //   style: TextStyle(
            //     color: textDark,
            //     fontSize: 18,
            //     fontWeight: FontWeight.bold,
            //   ),
            // ),
            // const SizedBox(height: 16),

            // Form(
            //   key: _formKey,
            //   child: Column(
            //     children: [
            //       _buildInputField(
            //         label: 'Your Name',
            //         hint: 'Enter your full name',
            //         controller: nameController,
            //         icon: Icons.person_outline,
            //       ),
            //       const SizedBox(height: 16),
            //       _buildInputField(
            //         label: 'Email Address',
            //         hint: 'Enter your email',
            //         controller: emailController,
            //         icon: Icons.email_outlined,
            //         keyboardType: TextInputType.emailAddress,
            //       ),
            //       const SizedBox(height: 16),
            //       _buildInputField(
            //         label: 'Message',
            //         hint: 'How can we help you?',
            //         controller: messageController,
            //         icon: Icons.message_outlined,
            //         maxLines: 4,
            //       ),
            //     ],
            //   ),
            // ),

            // const SizedBox(height: 32),
            // _buildSubmitButton(),
            const SizedBox(height: 20),
            if (isLoading)
              Container(
                color: Colors.black26,
                child: const Center(child: CircularProgressIndicator()),
              ),
          ],
        ),
      ),
    );
  }

  // --- WIDGET FUNCTIONS ---

  Widget _buildContactCard({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: primaryOrange, size: 28),
          const SizedBox(height: 12),
          Text(
            title,
            style: TextStyle(
              color: textDark,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(subtitle, style: TextStyle(color: textGrey, fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildInputField({
    required String label,
    required String hint,
    required TextEditingController controller,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: textDark,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.02),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: TextFormField(
            controller: controller,
            keyboardType: keyboardType,
            maxLines: maxLines,
            style: TextStyle(color: textDark, fontSize: 15),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'This field is required';
              }
              return null;
            },
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(color: Colors.grey.shade400),
              prefixIcon: maxLines == 1
                  ? Icon(icon, color: primaryOrange, size: 22)
                  : Padding(
                      padding: const EdgeInsets.only(bottom: 70.0),
                      child: Icon(icon, color: primaryOrange, size: 22),
                    ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: Colors.transparent,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 16,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            // TODO: Implement actual send message functionality
            Get.snackbar(
              'Message Sent',
              'Thank you for contacting us. We will get back to you soon!',
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: Colors.green.shade600,
              colorText: Colors.white,
              margin: const EdgeInsets.all(20),
              borderRadius: 12,
              icon: const Icon(Icons.check_circle, color: Colors.white),
            );

            // Clear fields after submission
            nameController.clear();
            emailController.clear();
            messageController.clear();
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryOrange,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          shadowColor: primaryOrange.withValues(alpha: 0.4),
        ),
        child: const Text(
          'Send Message',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
        ),
      ),
    );
  }
}
