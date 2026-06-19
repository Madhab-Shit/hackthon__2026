import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PersonalInfoScreen extends StatefulWidget {
  const PersonalInfoScreen({super.key});

  @override
  State<PersonalInfoScreen> createState() => _PersonalInfoScreenState();
}

class _PersonalInfoScreenState extends State<PersonalInfoScreen> {
  // Brand Colors matching your Profile Screen
  final Color primaryOrange = const Color(0xFFFF7A00);
  final Color bgColor = const Color(0xFFFAFBFC);
  final Color textDark = const Color(0xFF1A1A1A);
  final Color textGrey = const Color(0xFF8C8C8C);

  // Text Controllers (Dummy Data Inserted)
  final TextEditingController nameController = TextEditingController(
    text: 'Madhab',
  );
  final TextEditingController emailController = TextEditingController(
    text: 'madhabshit4142@gmail.com',
  );
  final TextEditingController phoneController = TextEditingController(
    text: '+880 1234 567890',
  );
  final TextEditingController dobController = TextEditingController(
    text: '15 August, 1998',
  );
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadUserData();
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    dobController.dispose();
    super.dispose();
  }

  bool isLoading = true;

  Future<void> loadUserData() async {
    try {
      final uid = FirebaseAuth.instance.currentUser?.uid;

      if (uid == null) return;

      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .get();

      if (doc.exists) {
        final data = doc.data()!;

        nameController.text = data['name'] ?? 'N/A';
        emailController.text = data['email'] ?? 'N/A';

        phoneController.text = data['phone']?.toString().isNotEmpty == true
            ? data['phone']
            : 'N/A';

        dobController.text = data['dob']?.toString().isNotEmpty == true
            ? data['dob']
            : 'N/A';
      }
    } catch (e) {
      debugPrint(e.toString());
    }

    setState(() {
      isLoading = false;
    });
  }

  Future<void> _selectDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
    );

    if (pickedDate != null) {
      dobController.text =
          "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
    }
  }

  bool savelogin = false;
  Future<void> updateProfile() async {
    setState(() {
      savelogin = true;
    });

    try {
      final uid = FirebaseAuth.instance.currentUser?.uid;

      if (uid == null) return;

      await FirebaseFirestore.instance.collection('users').doc(uid).update({
        "name": nameController.text.trim(),
        "phone": phoneController.text.trim(),
        "dob": dobController.text.trim(),
      });
    } catch (e) {
      Get.snackbar("Error", e.toString(), snackPosition: SnackPosition.BOTTOM);
    } finally {
      if (mounted) {
        setState(() {
          savelogin = false;
        });
      }
    }
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
          "Personal Information",
          style: TextStyle(
            color: textDark,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(color: Color(0xFFFF7A00)),
            )
          : SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  _buildProfileImagePicker(),
                  const SizedBox(height: 32),

                  // Input Fields
                  _buildInputField(
                    label: 'Full Name',
                    controller: nameController,
                    icon: Icons.person_outline,
                  ),
                  const SizedBox(height: 20),

                  _buildInputField(
                    label: 'Email Address',
                    controller: emailController,
                    icon: Icons.email_outlined,
                    isReadOnly: true, // Email is usually non-editable directly
                  ),
                  const SizedBox(height: 20),

                  _buildInputField(
                    label: 'Phone Number',
                    controller: phoneController,
                    icon: Icons.phone_outlined,
                    keyboardType: TextInputType.phone,
                  ),
                  const SizedBox(height: 20),

                  _buildInputField(
                    label: 'Date of Birth',
                    controller: dobController,
                    icon: Icons.calendar_today_outlined,
                    isReadOnly: true,
                    onTap: () {
                      _selectDate();
                    },
                  ),

                  const SizedBox(height: 40),
                  _buildSaveButton(),
                ],
              ),
            ),
    );
  }

  // --- WIDGET FUNCTIONS ---

  Widget _buildProfileImagePicker() {
    return Center(
      child: Stack(
        children: [
          Container(
            width: 110,
            height: 110,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 15,
                  offset: const Offset(0, 5),
                ),
              ],
              image: const DecorationImage(
                image: NetworkImage('https://i.pravatar.cc/150'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: GestureDetector(
              onTap: () {
                // TODO: Handle Image Picker
              },
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: primaryOrange,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 3),
                ),
                child: const Icon(
                  Icons.camera_alt,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputField({
    required String label,
    required TextEditingController controller,
    required IconData icon,
    bool isReadOnly = false,
    TextInputType keyboardType = TextInputType.text,
    VoidCallback? onTap,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: textGrey,
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
            readOnly: isReadOnly,
            keyboardType: keyboardType,
            onTap: onTap,
            style: TextStyle(
              color: isReadOnly ? textGrey : textDark,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
            decoration: InputDecoration(
              prefixIcon: Icon(icon, color: primaryOrange, size: 22),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: Colors.transparent,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 18,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSaveButton() {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: () async {
          updateProfile();

          Get.snackbar(
            "Success",
            "Profile updated successfully",
            backgroundColor: Colors.green,
            colorText: Colors.white,
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryOrange,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          shadowColor: primaryOrange.withValues(alpha: 0.4),
        ),
        child: savelogin
            ? Center(child: CircularProgressIndicator(color: Colors.white))
            : const Text(
                'Save Changes',
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
