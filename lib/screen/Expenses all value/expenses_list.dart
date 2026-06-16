import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:hacathon_2026/controller/expenses_list_controller.dart';

class ExpensesScreen extends StatefulWidget {
  const ExpensesScreen({super.key});

  @override
  State<ExpensesScreen> createState() => _ExpensesScreenState();
}

class _ExpensesScreenState extends State<ExpensesScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ExpensesListProvider>().fetchExpenses();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ExpensesListProvider>(
      builder: (context, provider, child) {
        return Scaffold(
          backgroundColor: const Color.fromARGB(255, 255, 247, 238),
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            centerTitle: true,
            iconTheme: const IconThemeData(color: Color(0xFF1A1A1A)),
            title: const Text(
              "All Expenses",
              style: TextStyle(
                color: Color(0xFF1A1A1A),
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ),
          body: provider.isLoading
              ? const Center(
                  child: CircularProgressIndicator(
                    color: Color(0xFFFF7B00),
                  ),
                )
              : RefreshIndicator(
                  color: const Color(0xFFFF7B00),
                  onRefresh: () async {
                    await context.read<ExpensesListProvider>().fetchExpenses();
                  },
                  child: provider.expenseGroups.isEmpty
                      ? ListView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          children: [
                            const SizedBox(height: 160),
                            Icon(
                              Icons.receipt_long_rounded,
                              size: 70,
                              color: Colors.grey.shade400,
                            ),
                            const SizedBox(height: 16),
                            const Center(
                              child: Text(
                                "No expenses added yet!",
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        )
                      : ListView.builder(
                          physics: const AlwaysScrollableScrollPhysics(),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 12,
                          ),
                          itemCount: provider.expenseGroups.length + 1,
                          itemBuilder: (context, index) {
                            if (index == 0) {
                              return _buildTotalExpenseCard(provider);
                            }

                            final group = provider.expenseGroups[index - 1];

                            final List<Map<String, dynamic>> items =
                                List<Map<String, dynamic>>.from(
                              group['items'],
                            );

                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildDateHeader(group),
                                ListView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: items.length,
                                  itemBuilder: (context, itemIndex) {
                                    final expense = items[itemIndex];

                                    return _buildExpenseCard(expense);
                                  },
                                ),
                              ],
                            );
                          },
                        ),
                ),
        );
      },
    );
  }

  Widget _buildTotalExpenseCard(ExpensesListProvider provider) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFFF7B00), Color(0xFFFFA03A)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFFF7B00).withOpacity(0.25),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.22),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.account_balance_wallet_rounded,
              color: Colors.white,
              size: 30,
            ),
          ),

          const SizedBox(width: 16),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Total Expenses",
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  "₹${provider.totalExpense.toStringAsFixed(0)}",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 34,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateHeader(Map<String, dynamic> group) {
    final String title = group['title'] ?? '';
    final double dayTotal = group['dayTotal'] ?? 0.0;

    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 10),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 20,
            decoration: BoxDecoration(
              color: const Color(0xFFFF7B00),
              borderRadius: BorderRadius.circular(12),
            ),
          ),

          const SizedBox(width: 10),

          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w900,
                color: Color(0xFF1A1A1A),
              ),
            ),
          ),

          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 5,
            ),
            decoration: BoxDecoration(
              color: const Color(0xFFFF7B00).withOpacity(0.12),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              "₹${dayTotal.toStringAsFixed(0)}",
              style: const TextStyle(
                color: Color(0xFFFF7B00),
                fontSize: 13,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExpenseCard(Map<String, dynamic> expense) {
    final double amount = expense['amount'] ?? 0.0;
    final String title = expense['title'] ?? 'Expense';
    final String category = expense['category'] ?? 'Other';
    final String timeText = expense['timeText'] ?? '';

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: const Color(0xFFF2F2F7),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.025),
            blurRadius: 12,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          _buildCategoryIcon(category),

          const SizedBox(width: 16),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 16,
                    color: Color(0xFF1A1A1A),
                  ),
                ),
                const SizedBox(height: 5),
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

          const SizedBox(width: 10),

          Text(
            "-₹${amount.toStringAsFixed(0)}",
            style: const TextStyle(
              fontWeight: FontWeight.w900,
              fontSize: 16,
              color: Color(0xFFE53935),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryIcon(String category) {
    IconData icon;
    Color color;

    switch (category) {
      case 'Food':
        icon = Icons.fastfood_rounded;
        color = const Color(0xFFFF7B00);
        break;
      case 'Transport':
        icon = Icons.directions_bus_rounded;
        color = Colors.blue;
        break;
      case 'Entertainment':
        icon = Icons.movie_rounded;
        color = Colors.purple;
        break;
      case 'Bills':
        icon = Icons.receipt_rounded;
        color = Colors.redAccent;
        break;
      case 'Shopping':
        icon = Icons.shopping_bag_rounded;
        color = Colors.pink;
        break;
      case 'Health':
        icon = Icons.health_and_safety_rounded;
        color = Colors.green;
        break;
      case 'Education':
        icon = Icons.school_rounded;
        color = Colors.orange;
        break;
      default:
        icon = Icons.category_rounded;
        color = Colors.teal;
    }

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        shape: BoxShape.circle,
      ),
      child: Icon(
        icon,
        color: color,
        size: 24,
      ),
    );
  }
}