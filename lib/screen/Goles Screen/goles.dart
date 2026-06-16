import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:hacathon_2026/controller/expense_provider.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class ExpenseAnalyticsScreen extends StatefulWidget {
  const ExpenseAnalyticsScreen({super.key});

  @override
  State<ExpenseAnalyticsScreen> createState() => _ExpenseAnalyticsScreenState();
}

class _ExpenseAnalyticsScreenState extends State<ExpenseAnalyticsScreen> {
  int touchedIndex = -1;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<GolesProvider>().fetchExpenses();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 247, 238),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 255, 247, 238),
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Color(0xFF1A1A1A)),
        title: const Text(
          "Expense Analytics",
          style: TextStyle(
            color: Color(0xFF1A1A1A),
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
      // Consumer ব্যবহার করে UI ডাইনামিক করা হলো
      body: Consumer<GolesProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return _buildShimmerLoading();
          }

          if (provider.categoryExpenses.isEmpty) {
            return const Center(
              child: Text(
                "No expenses added yet! 📊",
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            );
          }

          return SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // --- Total Expense Card ---
                  Center(
                    child: Column(
                      children: [
                        Text(
                          "Total Spent This Month",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey.shade600,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "₹${provider.totalExpense.toStringAsFixed(0)}",
                          style: const TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF1A1A1A),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),

                  // --- Pie Chart Section ---
                  SizedBox(
                    height: 250,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        PieChart(
                          PieChartData(
                            pieTouchData: PieTouchData(
                              touchCallback:
                                  (FlTouchEvent event, pieTouchResponse) {
                                    setState(() {
                                      if (!event.isInterestedForInteractions ||
                                          pieTouchResponse == null ||
                                          pieTouchResponse.touchedSection ==
                                              null) {
                                        touchedIndex = -1;
                                        return;
                                      }
                                      touchedIndex = pieTouchResponse
                                          .touchedSection!
                                          .touchedSectionIndex;
                                    });
                                  },
                            ),
                            borderData: FlBorderData(show: false),
                            sectionsSpace: 4,
                            centerSpaceRadius: 60,
                            sections: provider.categoryExpenses
                                .asMap()
                                .entries
                                .map((entry) {
                                  int index = entry.key;
                                  var data = entry.value;

                                  // যেটা সবচেয়ে বেশি খরচ, সেটার রেডিয়াস বড় হবে (Highlight)
                                  bool isHighest =
                                      data['amount'] == provider.maxExpense;
                                  final isTouched = index == touchedIndex;

                                  final double fontSize = isTouched || isHighest
                                      ? 16.0
                                      : 12.0;
                                  final double radius = isTouched || isHighest
                                      ? 60.0
                                      : 45.0;

                                  // শতকরা হিসাব
                                  double percentage =
                                      (data['amount'] / provider.totalExpense) *
                                      100;

                                  return PieChartSectionData(
                                    color: data['color'],
                                    value: data['amount'],
                                    title: '${percentage.toStringAsFixed(1)}%',
                                    radius: radius,
                                    titleStyle: TextStyle(
                                      fontSize: fontSize,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      shadows: const [
                                        Shadow(
                                          color: Colors.black26,
                                          blurRadius: 2,
                                        ),
                                      ],
                                    ),
                                  );
                                })
                                .toList(),
                          ),
                        ),
                        // চার্টের মাঝখানের টেক্সট
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.account_balance_wallet_rounded,
                              color: Color(0xFFFF7B00),
                              size: 30,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "Overview",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey.shade700,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),

                  // --- Highest Expense Warning/Insight ---
                  if (provider.maxExpense > 0)
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFF7B00).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: const Color(0xFFFF7B00).withOpacity(0.3),
                        ),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.trending_up_rounded,
                            color: Color(0xFFFF7B00),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              "You spent the most on ${provider.maxCategory} (₹${provider.maxExpense.toStringAsFixed(0)}). Try to reduce expenses here to reach your goal faster!",
                              style: TextStyle(
                                color: Colors.orange.shade900,
                                fontWeight: FontWeight.w600,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  const SizedBox(height: 24),

                  // --- Expense Categories List ---
                  const Text(
                    "Expense Breakdown",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1A1A1A),
                    ),
                  ),
                  const SizedBox(height: 16),

                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: provider.categoryExpenses.length,
                    itemBuilder: (context, index) {
                      final item = provider.categoryExpenses[index];
                      bool isHighest = item['amount'] == provider.maxExpense;

                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: isHighest
                                ? item['color']
                                : Colors.grey.shade200,
                            width: isHighest ? 2 : 1,
                          ),
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
                              width: 16,
                              height: 16,
                              decoration: BoxDecoration(
                                color: item['color'],
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Text(
                                item['category'],
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF1A1A1A),
                                ),
                              ),
                            ),
                            Text(
                              "₹${item['amount'].toStringAsFixed(0)}",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: isHighest
                                    ? item['color']
                                    : const Color(0xFF1A1A1A),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

Widget _buildShimmerLoading() {
  return SingleChildScrollView(
    padding: const EdgeInsets.all(20),
    child: Column(
      children: [
        // Total Expense
        Shimmer.fromColors(
          baseColor: Colors.grey.shade300,
          highlightColor: Colors.grey.shade100,
          child: Column(
            children: [
              Container(height: 18, width: 150, color: Colors.white),
              const SizedBox(height: 12),
              Container(height: 40, width: 120, color: Colors.white),
            ],
          ),
        ),

        const SizedBox(height: 40),

        // Pie Chart Placeholder
        Shimmer.fromColors(
          baseColor: Colors.grey.shade300,
          highlightColor: Colors.grey.shade100,
          child: Container(
            height: 250,
            width: 250,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
          ),
        ),

        const SizedBox(height: 30),

        // Insight Card
        Shimmer.fromColors(
          baseColor: Colors.grey.shade300,
          highlightColor: Colors.grey.shade100,
          child: Container(
            height: 80,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        ),

        const SizedBox(height: 20),

        // List Items
        ...List.generate(
          5,
          (index) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Shimmer.fromColors(
              baseColor: Colors.grey.shade300,
              highlightColor: Colors.grey.shade100,
              child: Container(
                height: 70,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
          ),
        ),
      ],
    ),
  );
}
