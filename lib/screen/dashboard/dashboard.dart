import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hacathon_2026/screen/add%20Expense/add_expese.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Data for the Grid Cards tailored for students
    final List<Map<String, dynamic>> dashboardStats = [
      {
        'title': 'Monthly Budget',
        'value': '₹15,000',
        'icon': Icons.account_balance_wallet_rounded,
        'color': const Color(0xFFFF7B00), // Primary Orange
      },
      {
        'title': 'Total Spent',
        'value': '₹12,030',
        'icon': Icons.outbound_rounded,
        'color': const Color(0xFFE53935), // Red (Standard for expense)
      },
      {
        'title': 'Safe to Spend/Day',
        'value': '₹198',
        'icon': Icons.today_rounded,
        'color': const Color(0xFF00BFA5), // Teal (Standard for safe)
      },
      {
        'title': 'Savings Goal',
        'value': '₹2,500',
        'icon': Icons.savings_rounded,
        'color': const Color(0xFFFFA03A), // Light Orange
      },
    ];

    return Scaffold(
      // Premium Off-White background matching your Login screen
      backgroundColor: const Color.fromARGB(255, 255, 247, 238),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- App Bar / Header ---
              Row(
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
                    backgroundColor: Color(0xFFFF7B00), // Main Orange
                    child: Icon(Icons.person, color: Colors.white),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // --- Main Balance Card (Orange Premium Look) ---
              _buildMainBalanceCard(),
              const SizedBox(height: 24),

              // --- Smart Insights / AI Suggestions ---
              _buildSmartInsightCard(),
              const SizedBox(height: 24),

              // --- Quick Stats Grid ---
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
                  int crossAxisCount = constraints.maxWidth > 600 ? 4 : 2;

                  return GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
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

              // --- Recent Expenses Header ---
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
                  TextButton(
                    onPressed: () {},
                    style: TextButton.styleFrom(
                      foregroundColor: const Color(0xFFFF7B00), // Main Orange
                    ),
                    child: const Text(
                      "See all",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // --- Recent Expenses List ---
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: 3,
                itemBuilder: (context, index) {
                  return _buildRecentExpenseCard(index);
                },
              ),

              const SizedBox(height: 80), // Padding for FAB
            ],
          ),
        ),
      ),

      // --- Floating Action Button ---
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Get.to(() => AddExpenseScreen());
        },
        backgroundColor: const Color(0xFFFF7B00), // Main Orange
        elevation: 6,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        icon: const Icon(Icons.add_rounded, color: Colors.white, size: 24),
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
  }

  // --------------------------------------------------------
  // Widget: Main Balance Card with Progress Bar (Orange Gradient)
  // --------------------------------------------------------
  Widget _buildMainBalanceCard() {
    double budget = 15000;
    double spent = 12030;
    double remaining = budget - spent;
    double progress = spent / budget;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFFFF7B00), // Main Orange
            Color(0xFFFFA03A), // Lighter Orange for smooth gradient
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color(
              0xFFFF7B00,
            ).withOpacity(0.35), // Orange glowing shadow
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
                "Remaining Budget",
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
                child: const Text(
                  "15 Days Left",
                  style: TextStyle(
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
            "₹${remaining.toStringAsFixed(0)}",
            style: const TextStyle(
              color: Colors.white,
              fontSize: 36,
              fontWeight: FontWeight.bold,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 24),
          // Progress Bar
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 8,
              backgroundColor: Colors.white.withOpacity(0.3),
              valueColor: AlwaysStoppedAnimation<Color>(
                progress > 0.85
                    ? const Color(0xFFFF3B30)
                    : Colors.white, // Turns red if almost empty
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
                "Total: ₹${budget.toStringAsFixed(0)}",
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

  // --------------------------------------------------------
  // Widget: Smart AI Insight Card
  // --------------------------------------------------------
  Widget _buildSmartInsightCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFF2F2F7), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: const Color(
              0xFFFF7B00,
            ).withOpacity(0.05), // Subtle orange shadow
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
                    color: Color(0xFFFF7B00), // Main Orange
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "You have spent 40% of your budget on Food this week. Consider cooking at home to save ₹500.",
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

  // --------------------------------------------------------
  // Widget: Recent Expense Card
  // --------------------------------------------------------
  Widget _buildRecentExpenseCard(int index) {
    List<Map<String, dynamic>> expenses = [
      {
        'title': 'Netflix Subscription',
        'cat': 'Entertainment',
        'amount': '-₹199',
        'icon': Icons.movie_rounded,
        'color': Colors.red,
      },
      {
        'title': 'College Canteen',
        'cat': 'Food',
        'amount': '-₹120',
        'icon': Icons.fastfood_rounded,
        'color': const Color(0xFFFF7B00),
      }, // Match theme
      {
        'title': 'Metro Recharge',
        'cat': 'Transport',
        'amount': '-₹500',
        'icon': Icons.train_rounded,
        'color': Colors.blue,
      },
    ];

    final expense = expenses[index];

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
              color: expense['color'].withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(expense['icon'], color: expense['color'], size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  expense['title'],
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Color(0xFF1A1A1A),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  expense['cat'],
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
            expense['amount'],
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Color(0xFF1A1A1A),
            ),
          ),
        ],
      ),
    );
  }
}
