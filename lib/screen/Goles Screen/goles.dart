import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class ExpenseAnalyticsScreen extends StatefulWidget {
  const ExpenseAnalyticsScreen({super.key});

  @override
  State<ExpenseAnalyticsScreen> createState() => _ExpenseAnalyticsScreenState();
}

class _ExpenseAnalyticsScreenState extends State<ExpenseAnalyticsScreen> {
  int touchedIndex = -1;

  // ডেমো ডেটা (পরবর্তীতে তুমি এটি Firebase বা Provider থেকে আনবে)
  final List<Map<String, dynamic>> expenses = [
    {
      'category': 'Food',
      'amount': 5500.0,
      'color': const Color(0xFFFF7B00),
    }, // Primary Orange
    {'category': 'Transport', 'amount': 2000.0, 'color': Colors.blue},
    {'category': 'Entertainment', 'amount': 1500.0, 'color': Colors.purple},
    {'category': 'Bills', 'amount': 3000.0, 'color': Colors.redAccent},
    {'category': 'Others', 'amount': 800.0, 'color': Colors.teal},
  ];

  @override
  Widget build(BuildContext context) {
    // সবচেয়ে বেশি খরচের অ্যামাউন্ট বের করা হচ্ছে যাতে তাকে হাইলাইট করা যায়
    double maxExpense = 0;
    double totalExpense = 0;
    for (var exp in expenses) {
      if (exp['amount'] > maxExpense) {
        maxExpense = exp['amount'];
      }
      totalExpense += exp['amount'];
    }

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 247, 238),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
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
      body: SafeArea(
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
                      "₹${totalExpense.toStringAsFixed(0)}",
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
                                      pieTouchResponse.touchedSection == null) {
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
                        sections: expenses.asMap().entries.map((entry) {
                          int index = entry.key;
                          var data = entry.value;

                          // যেটা সবচেয়ে বেশি খরচ, সেটার রেডিয়াস বড় হবে (Highlight)
                          bool isHighest = data['amount'] == maxExpense;
                          final isTouched = index == touchedIndex;

                          // টাচ করলে অথবা সর্বোচ্চ খরচ হলে সাইজ বড় দেখাবে
                          final double fontSize = isTouched || isHighest
                              ? 16.0
                              : 12.0;
                          final double radius = isTouched || isHighest
                              ? 60.0
                              : 45.0;

                          // শতকরা হিসাব
                          double percentage =
                              (data['amount'] / totalExpense) * 100;

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
                                Shadow(color: Colors.black26, blurRadius: 2),
                              ],
                            ),
                          );
                        }).toList(),
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
                        "You spent the most on Food (₹${maxExpense.toStringAsFixed(0)}). Try to reduce expenses here to reach your goal faster!",
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
                itemCount: expenses.length,
                itemBuilder: (context, index) {
                  final item = expenses[index];
                  bool isHighest = item['amount'] == maxExpense;

                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isHighest ? item['color'] : Colors.grey.shade200,
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
      ),
    );
  }
}
