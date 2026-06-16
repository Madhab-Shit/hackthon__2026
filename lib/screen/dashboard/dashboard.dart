import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hacathon_2026/controller/dashbord_controller.dart';
import 'package:hacathon_2026/controller/goal_provider.dart';
import 'package:hacathon_2026/screen/add%20Expense/add_expese.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

Future<bool> isPopupCompleted() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getBool('popup_completed') ?? false;
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DashboardProvider>().startDashboardListener();
    });

    _checkPopup();
  }

  Future<void> _checkPopup() async {
    final completed = await isPopupCompleted();

    if (completed || !mounted) return;

    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    showPremiumGoalDialog(context);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DashboardProvider>(
      builder: (context, dashboardProvider, child) {
        final List<Map<String, dynamic>> dashboardStats = [
          {
            'title': 'Monthly Income',
            'value': '₹${dashboardProvider.monthlyIncome.toStringAsFixed(0)}',
            'icon': Icons.account_balance_wallet_rounded,
            'color': const Color(0xFFFF7B00),
          },
          {
            'title': 'Total Spent',
            'value': '₹${dashboardProvider.totalSpent.toStringAsFixed(0)}',
            'icon': Icons.outbound_rounded,
            'color': const Color(0xFFE53935),
          },
          {
            'title': 'Safe to Spend/Day',
            'value':
                '₹${dashboardProvider.safeToSpendPerDay.toStringAsFixed(0)}',
            'icon': Icons.today_rounded,
            'color': const Color(0xFF00BFA5),
          },
          {
            'title': 'Save Money',
            'value': '₹${dashboardProvider.targetAmount.toStringAsFixed(0)}',
            'icon': Icons.savings_rounded,
            'color': const Color(0xFFFFA03A),
          },
        ];
        return Scaffold(
          backgroundColor: const Color.fromARGB(255, 255, 247, 238),
          body: dashboardProvider.isLoading
              ? const Center(
                  child: CircularProgressIndicator(color: Color(0xFFFF7B00)),
                )
              : SafeArea(
                  child: RefreshIndicator(
                    color: const Color(0xFFFF7B00),
                    onRefresh: () async {
                      await context
                          .read<DashboardProvider>()
                          .fetchDashboardData();
                    },
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20.0,
                        vertical: 10.0,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildHeader(),

                          const SizedBox(height: 24),

                          _buildMainBalanceCard(dashboardProvider),

                          const SizedBox(height: 24),

                          _buildSmartInsightCard(dashboardProvider),

                          const SizedBox(height: 24),

                          const Text(
                            "Quick Overview",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1A1A1A),
                            ),
                          ),

                          const SizedBox(height: 16),

                          LayoutBuilder(
                            builder: (context, constraints) {
                              int crossAxisCount = constraints.maxWidth > 600
                                  ? 4
                                  : 2;

                              return GridView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: crossAxisCount,
                                      crossAxisSpacing: 16,
                                      mainAxisSpacing: 16,
                                      childAspectRatio: 1.2,
                                    ),
                                itemCount: dashboardStats.length,
                                itemBuilder: (context, index) {
                                  final stat = dashboardStats[index];

                                  return _buildStatCard(
                                    title: stat['title'],
                                    value: stat['value'],
                                    icon: stat['icon'],
                                    color: stat['color'],
                                  );
                                },
                              );
                            },
                          ),

                          const SizedBox(height: 32),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                "Recent Expenses",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF1A1A1A),
                                ),
                              ),
                              Text(
                                "Latest 5",
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.grey.shade500,
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 8),

                          dashboardProvider.recentExpenseGroups.isEmpty
                              ? _buildEmptyExpenseCard()
                              : Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: dashboardProvider
                                      .recentExpenseGroups
                                      .map((group) {
                                        final List<Map<String, dynamic>> items =
                                            List<Map<String, dynamic>>.from(
                                              group['items'],
                                            );

                                        return Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                top: 12,
                                                bottom: 8,
                                              ),
                                              child: Text(
                                                group['title'],
                                                style: const TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w800,
                                                  color: Color(0xFFFF7B00),
                                                ),
                                              ),
                                            ),
                                            ...items.map((expense) {
                                              return _buildRecentExpenseCardFromFirebase(
                                                expense,
                                              );
                                            }).toList(),
                                          ],
                                        );
                                      })
                                      .toList(),
                                ),

                          const SizedBox(height: 80),
                        ],
                      ),
                    ),
                  ),
                ),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () async {
              await Get.to(() => const AddExpenseScreen());

              if (context.mounted) {
                context.read<DashboardProvider>().fetchDashboardData();
              }
            },
            backgroundColor: const Color(0xFFFF7B00),
            elevation: 6,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            icon: const Icon(Icons.add_rounded, color: Colors.white, size: 24),
            heroTag: null,
            label: const Text(
              "Add Expense",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Hello, Student! 👋",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              "Your Financial Health",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w800,
                color: Color(0xFF1A1A1A),
              ),
            ),
          ],
        ),
        const CircleAvatar(
          radius: 22,
          backgroundColor: Color(0xFFFF7B00),
          child: Icon(Icons.person, color: Colors.white),
        ),
      ],
    );
  }

  Widget _buildMainBalanceCard(DashboardProvider provider) {
    final double budget = provider.monthlyBudget;
    final double spent = provider.totalSpent;
    final double remaining = provider.remainingBudget;
    final double progress = provider.progress;

    final bool isOverBudget = remaining < 0;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isOverBudget
              ? const [Color(0xFFE53935), Color(0xFFFF7043)]
              : const [Color(0xFFFF7B00), Color(0xFFFFA03A)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFFF7B00).withOpacity(0.35),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                isOverBudget ? "Over Budget" : "Remaining Budget",
                style: TextStyle(
                  color: Colors.white.withOpacity(0.9),
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.25),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  "${provider.daysLeftInMonth} Days Left",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          Text(
            isOverBudget
                ? "-₹${remaining.abs().toStringAsFixed(0)}"
                : "₹${remaining.toStringAsFixed(0)}",
            style: const TextStyle(
              color: Colors.white,
              fontSize: 36,
              fontWeight: FontWeight.bold,
              letterSpacing: 1,
            ),
          ),

          const SizedBox(height: 24),

          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 8,
              backgroundColor: Colors.white.withOpacity(0.3),
              valueColor: AlwaysStoppedAnimation<Color>(
                progress > 0.85 ? const Color(0xFFFF3B30) : Colors.white,
              ),
            ),
          ),

          const SizedBox(height: 10),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Spent: ₹${spent.toStringAsFixed(0)}",
                style: TextStyle(
                  color: Colors.white.withOpacity(0.9),
                  fontSize: 12,
                ),
              ),
              Text(
                "Budget: ₹${budget.toStringAsFixed(0)}",
                style: TextStyle(
                  color: Colors.white.withOpacity(0.9),
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSmartInsightCard(DashboardProvider provider) {
    String message;

    if (provider.monthlyBudget <= 0) {
      message = "Set your monthly budget to start tracking your spending.";
    } else if (provider.remainingBudget < 0) {
      message =
          "You have crossed your monthly budget. Try to reduce extra expenses.";
    } else {
      message =
          "You can safely spend ₹${provider.safeToSpendPerDay.toStringAsFixed(0)} per day for the rest of this month.";
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFF2F2F7), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFFF7B00).withOpacity(0.05),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFFFF7B00).withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.lightbulb_rounded,
              color: Color(0xFFFF7B00),
              size: 24,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Smart Insight",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFFF7B00),
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  message,
                  style: TextStyle(
                    color: Colors.grey.shade700,
                    fontSize: 13,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyExpenseCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFF2F2F7), width: 1.5),
      ),
      child: const Text(
        "No expenses added yet.",
        style: TextStyle(
          color: Colors.grey,
          fontSize: 15,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildRecentExpenseCardFromFirebase(Map<String, dynamic> expense) {
    final double amount = expense['amount'] ?? 0.0;
    final String title = expense['title'] ?? 'Expense';
    final String category = expense['category'] ?? 'Other';
    final String timeText = expense['timeText'] ?? '';

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFF2F2F7), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFFF7B00).withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.receipt_long_rounded,
              color: Color(0xFFFF7B00),
              size: 24,
            ),
          ),

          const SizedBox(width: 16),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Color(0xFF1A1A1A),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  timeText.isEmpty ? category : "$category • $timeText",
                  style: TextStyle(
                    color: Colors.grey.shade500,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),

          Text(
            "-₹${amount.toStringAsFixed(0)}",
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Color(0xFFE53935),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFF2F2F7), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: color, size: 20),
              ),
            ],
          ),
          const Spacer(),
          Text(
            value,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: Color(0xFF1A1A1A),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: Colors.grey.shade600,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

// ----------------------------------------------------------------------
// Premium Goal Dialog
// ----------------------------------------------------------------------

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

                      const SizedBox(height: 16),

                      _buildLabel("Monthly Budget"),
                      _buildTextField(
                        controller: goalProvider.budgetController,
                        hintText: "e.g. 4000",
                        icon: Icons.pie_chart_rounded,
                      ),

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
                                      const SnackBar(
                                        content: Text(
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
