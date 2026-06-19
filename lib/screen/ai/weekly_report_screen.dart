import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hacathon_2026/service/ai_budget_service.dart';

class WeeklyReportScreen extends StatelessWidget {
  const WeeklyReportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 247, 238),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 255, 247, 238),
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Color(0xFF1A1A1A)),
        title: const Text(
          'Weekly AI Report',
          style: TextStyle(
            color: Color(0xFF1A1A1A),
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      body: user == null
          ? const Center(child: Text('Please log in to view reports.'))
          : FutureBuilder<_WeeklyReport>(
              future: _loadReport(user.uid),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(color: Color(0xFFFF7B00)),
                  );
                }

                if (snapshot.hasError) {
                  return Center(
                    child: Text('Could not load report: ${snapshot.error}'),
                  );
                }

                final report = snapshot.data ?? _WeeklyReport.empty();
                if (report.expenses.isEmpty) {
                  return const Center(
                    child: Text(
                      'No expenses this week yet.',
                      style: TextStyle(color: Colors.grey, fontSize: 16),
                    ),
                  );
                }

                return ListView(
                  padding: const EdgeInsets.all(20),
                  children: [
                    _ReportCard(
                      title: 'Weekly Summary',
                      children: [
                        _ReportRow('Total spending', '₹${report.total.toStringAsFixed(0)}'),
                        _ReportRow('Top category', report.topCategory),
                        _ReportRow('Essential spending', '₹${report.essential.toStringAsFixed(0)}'),
                        _ReportRow('Non-essential spending', '₹${report.nonEssential.toStringAsFixed(0)}'),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _ReportCard(
                      title: 'AI Recommendation',
                      children: [
                        Text(
                          report.recommendation,
                          style: const TextStyle(
                            color: Color(0xFF5D4037),
                            fontWeight: FontWeight.w700,
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    ...report.expenses.map(
                      (expense) => Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: const Color(0xFFF2E8DD)),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.receipt_long_rounded,
                              color: Color(0xFFFF7B00),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                '${expense.title} • ${expense.category}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                            Text(
                              '₹${expense.amount.toStringAsFixed(0)}',
                              style: const TextStyle(
                                fontWeight: FontWeight.w800,
                                color: Color(0xFFE53935),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
    );
  }

  Future<_WeeklyReport> _loadReport(String uid) async {
    final now = DateTime.now();
    final weekStart = DateTime(now.year, now.month, now.day)
        .subtract(Duration(days: now.weekday - 1));
    final snap = await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('expenses')
        .get();

    final expenses = snap.docs.map((doc) {
      final data = doc.data();
      final createdAt = data['createdAt'] ?? data['date'] ?? data['created_at'];
      DateTime date;
      if (createdAt is Timestamp) {
        date = createdAt.toDate();
      } else {
        date = DateTime.tryParse(createdAt?.toString() ?? '') ?? now;
      }
      return _WeeklyExpense(
        title: (data['title'] ?? 'Expense').toString(),
        category: (data['category'] ?? 'Other').toString(),
        amount: _toDouble(data['amount']),
        isEssential: data['isEssential'] == true ||
            AiBudgetService.essentialCategories.contains(data['category']),
        date: date,
      );
    }).where((expense) => !expense.date.isBefore(weekStart)).toList();

    final report = _WeeklyReport.fromExpenses(expenses);
    await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('weekly_reports')
        .doc(_weekKey(now))
        .set(report.toJson(), SetOptions(merge: true));
    return report;
  }

  static String _weekKey(DateTime date) {
    final start = DateTime(date.year, date.month, date.day)
        .subtract(Duration(days: date.weekday - 1));
    return '${start.year}-${start.month.toString().padLeft(2, '0')}-${start.day.toString().padLeft(2, '0')}';
  }

  static double _toDouble(dynamic value) {
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0;
    return 0;
  }
}

class _WeeklyExpense {
  const _WeeklyExpense({
    required this.title,
    required this.category,
    required this.amount,
    required this.isEssential,
    required this.date,
  });

  final String title;
  final String category;
  final double amount;
  final bool isEssential;
  final DateTime date;
}

class _WeeklyReport {
  const _WeeklyReport({
    required this.expenses,
    required this.total,
    required this.topCategory,
    required this.essential,
    required this.nonEssential,
    required this.recommendation,
  });

  final List<_WeeklyExpense> expenses;
  final double total;
  final String topCategory;
  final double essential;
  final double nonEssential;
  final String recommendation;

  factory _WeeklyReport.empty() {
    return const _WeeklyReport(
      expenses: [],
      total: 0,
      topCategory: 'Other',
      essential: 0,
      nonEssential: 0,
      recommendation: 'Add expenses to get a weekly recommendation.',
    );
  }

  factory _WeeklyReport.fromExpenses(List<_WeeklyExpense> expenses) {
    final categoryTotals = <String, double>{};
    double total = 0;
    double essential = 0;
    double nonEssential = 0;

    for (final expense in expenses) {
      total += expense.amount;
      categoryTotals[expense.category] =
          (categoryTotals[expense.category] ?? 0) + expense.amount;
      if (expense.isEssential) {
        essential += expense.amount;
      } else {
        nonEssential += expense.amount;
      }
    }

    String top = 'Other';
    double topAmount = 0;
    categoryTotals.forEach((category, amount) {
      if (amount > topAmount) {
        top = category;
        topAmount = amount;
      }
    });

    final recommendation = nonEssential > essential
        ? 'Your non-essential spending is high this week. Pause shopping and entertainment first.'
        : 'Essentials are taking most of the budget. Keep meals and travel planned to avoid surprise costs.';

    return _WeeklyReport(
      expenses: expenses,
      total: total,
      topCategory: top,
      essential: essential,
      nonEssential: nonEssential,
      recommendation: recommendation,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'total': total,
      'topCategory': topCategory,
      'essential': essential,
      'nonEssential': nonEssential,
      'recommendation': recommendation,
      'createdAt': FieldValue.serverTimestamp(),
    };
  }
}

class _ReportCard extends StatelessWidget {
  const _ReportCard({required this.title, required this.children});

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFF2E8DD)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: Color(0xFF1A1A1A),
            ),
          ),
          const SizedBox(height: 14),
          ...children,
        ],
      ),
    );
  }
}

class _ReportRow extends StatelessWidget {
  const _ReportRow(this.label, this.value);

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Expanded(child: Text(label, style: TextStyle(color: Colors.grey.shade700))),
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.w800,
              color: Color(0xFF1A1A1A),
            ),
          ),
        ],
      ),
    );
  }
}
