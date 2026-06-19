import 'package:flutter/material.dart';

// এই ফাংশনটি কল করে ডায়লগটি ওপেন করতে পারবেন (যেমন সাইন-আপ বাটনের onPressed-এ)
void showPremiumGoalDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible:
        false, // বাইরে ক্লিক করে কাটা যাবে না, স্কিপ বাটন চাপতে হবে
    builder: (context) {
      return const PremiumGoalDialog();
    },
  );
}

class PremiumGoalDialog extends StatefulWidget {
  const PremiumGoalDialog({super.key});

  @override
  State<PremiumGoalDialog> createState() => _PremiumGoalDialogState();
}

class _PremiumGoalDialogState extends State<PremiumGoalDialog> {
  final Color primaryOrange = Colors.orange;
  final Color darkBrownText = const Color(0xFF4A3B32);

  final TextEditingController _incomeController = TextEditingController();
  final TextEditingController _budgetController = TextEditingController();
  final TextEditingController _targetController = TextEditingController();
  final TextEditingController _customGoalController = TextEditingController();

  final List<String> _predefinedGoals = [
    "New Phone",
    "Laptop",
    "Course",
    "Bike",
    "Other",
  ];
  String _selectedGoal = "New Phone";

  @override
  void dispose() {
    _incomeController.dispose();
    _budgetController.dispose();
    _targetController.dispose();
    _customGoalController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      elevation: 10,
      backgroundColor: Colors.white,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: SingleChildScrollView(
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
                  // হেডার টেক্সট
                  Center(
                    child: Text(
                      "Set Your Goals! 🎯",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: darkBrownText,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Center(
                    child: Text(
                      "Plan your monthly budget and save for your dream.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade500,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Monthly Income Field
                  _buildLabel("Monthly Income"),
                  _buildTextField(
                    controller: _incomeController,
                    hintText: "e.g. 5000",
                    icon: Icons.account_balance_wallet_rounded,
                  ),
                  const SizedBox(height: 16),

                  // Monthly Budget Field
                  _buildLabel("Monthly Budget"),
                  _buildTextField(
                    controller: _budgetController,
                    hintText: "e.g. 4000",
                    icon: Icons.pie_chart_rounded,
                  ),
                  const SizedBox(height: 20),

                  // Goal Selection (Chips)
                  _buildLabel("Select Your Goal"),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: _predefinedGoals.map((goal) {
                      bool isSelected = _selectedGoal == goal;
                      return ChoiceChip(
                        label: Text(goal),
                        selected: isSelected,
                        selectedColor: primaryOrange.withValues(alpha: 0.15),
                        backgroundColor: Colors.grey.shade100,
                        labelStyle: TextStyle(
                          color: isSelected
                              ? primaryOrange
                              : Colors.grey.shade600,
                          fontWeight: isSelected
                              ? FontWeight.bold
                              : FontWeight.w500,
                        ),
                        side: BorderSide(
                          color: isSelected
                              ? primaryOrange
                              : Colors.transparent,
                          width: 1.5,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        onSelected: (selected) {
                          if (selected) {
                            setState(() {
                              _selectedGoal = goal;
                            });
                          }
                        },
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 16),

                  // Custom Goal Text Field (শুধু 'Other' সিলেক্ট করলে দেখাবে)
                  if (_selectedGoal == "Other") ...[
                    _buildTextField(
                      controller: _customGoalController,
                      hintText: "Type your custom goal",
                      icon: Icons.edit_rounded,
                      isNumeric: false,
                    ),
                    const SizedBox(height: 16),
                  ],

                  // Target Amount Field
                  _buildLabel("Target Amount"),
                  _buildTextField(
                    controller: _targetController,
                    hintText: "e.g. 10000",
                    icon: Icons.track_changes_rounded,
                  ),
                  const SizedBox(height: 32),

                  // Action Buttons (Save & Skip)
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryOrange,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 4,
                        shadowColor: primaryOrange.withValues(alpha: 0.5),
                      ),
                      onPressed: () {
                        // Data Save Logic Here
                        String finalGoal = _selectedGoal == "Other"
                            ? _customGoalController.text
                            : _selectedGoal;

                        print("Income: ${_incomeController.text}");
                        print("Budget: ${_budgetController.text}");
                        print("Goal: $finalGoal");
                        print("Target: ${_targetController.text}");

                        Navigator.pop(context); // Dialog ক্লোজ করার জন্য
                      },
                      child: const Text(
                        "Save & Continue",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Skip Button
                  Center(
                    child: TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text(
                        "Skip for now",
                        style: TextStyle(
                          color: Colors.grey.shade500,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // ডায়লগের উপরের ডানদিকের Close (X) বাটন
            Positioned(
              top: 12,
              right: 12,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: const Icon(
                    Icons.close_rounded,
                    size: 20,
                    color: Colors.grey,
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // লেবেল বানানোর জন্য হেল্পার উইজেট
  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0, left: 4),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w700,
          color: darkBrownText,
        ),
      ),
    );
  }

  // ইনপুট ফিল্ড বানানোর জন্য হেল্পার উইজেট
  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required IconData icon,
    bool isNumeric = true,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200, width: 1.5),
      ),
      child: TextField(
        controller: controller,
        keyboardType: isNumeric ? TextInputType.number : TextInputType.text,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
          prefixIcon: Icon(icon, color: Colors.orange.shade300, size: 22),
          // টাকার অংক হলে রুপি বা টাকার সাইন দেখানোর জন্য
          prefixText: isNumeric ? "₹ " : null,
          prefixStyle: TextStyle(
            color: darkBrownText,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
        ),
      ),
    );
  }
}
