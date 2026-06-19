import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hacathon_2026/controller/dashbord_controller.dart';
import 'package:hacathon_2026/controller/goal_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void showPremiumGoalDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return const PremiumGoalDialog();
    },
  );
}

class PremiumGoalDialog extends StatelessWidget {
  const PremiumGoalDialog({super.key});

  final Color primaryOrange = Colors.orange;
  final Color darkBrownText = const Color(0xFF4A3B32);

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
              child: Consumer<GoalProvider>(
                builder: (context, goalProvider, child) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 10),

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

                      _buildLabel("Monthly Income"),
                      _buildTextField(
                        controller: goalProvider.incomeController,
                        hintText: "e.g. 5000",
                        icon: Icons.account_balance_wallet_rounded,
                      ),

                      // const SizedBox(height: 16),

                      // _buildLabel("Monthly Budget"),
                      // _buildTextField(
                      // controller: goalProvider.budgetController,
                      //   hintText: "e.g. 4000",
                      //   icon: Icons.pie_chart_rounded,
                      // ),
                      const SizedBox(height: 20),

                      _buildLabel("Select Your Goal"),

                      const SizedBox(height: 8),

                      Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: goalProvider.predefinedGoals.map((goal) {
                          final bool isSelected =
                              goalProvider.selectedGoal == goal;

                          return ChoiceChip(
                            label: Text(goal),
                            selected: isSelected,
                            selectedColor: primaryOrange.withOpacity(0.15),
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
                                goalProvider.setSelectedGoal(goal);
                              }
                            },
                          );
                        }).toList(),
                      ),

                      const SizedBox(height: 16),

                      if (goalProvider.selectedGoal == "Other") ...[
                        _buildTextField(
                          controller: goalProvider.customGoalController,
                          hintText: "Type your custom goal",
                          icon: Icons.edit_rounded,
                          isNumeric: false,
                        ),
                        const SizedBox(height: 16),
                      ],

                      _buildLabel("Target Amount"),
                      _buildTextField(
                        controller: goalProvider.targetController,
                        hintText: "e.g. 10000",
                        icon: Icons.track_changes_rounded,
                      ),

                      const SizedBox(height: 32),

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
                            shadowColor: primaryOrange.withOpacity(0.5),
                          ),
                          onPressed: goalProvider.isLoading
                              ? null
                              : () async {
                                  final bool success = await goalProvider
                                      .saveGoalToFirebase();

                                  if (!success && context.mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          goalProvider.errorMessage ??
                                              "Please fill all required fields!",
                                        ),
                                        backgroundColor: Colors.redAccent,
                                      ),
                                    );
                                  } else if (success && context.mounted) {
                                    final prefs =
                                        await SharedPreferences.getInstance();

                                    await prefs.setBool(
                                      'popup_completed',
                                      true,
                                    );

                                    goalProvider.clearControllers();

                                    Get.back();

                                    context
                                        .read<DashboardProvider>()
                                        .fetchDashboardData();

                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          "Goal Saved Successfully!",
                                        ),
                                        backgroundColor: Colors.green,
                                      ),
                                    );
                                  }
                                },
                          child: goalProvider.isLoading
                              ? const CircularProgressIndicator(
                                  color: Colors.white,
                                )
                              : const Text(
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
                    ],
                  );
                },
              ),
            ),

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
                  onPressed: () {
                    context.read<GoalProvider>().clearControllers();
                    Navigator.pop(context);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

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
