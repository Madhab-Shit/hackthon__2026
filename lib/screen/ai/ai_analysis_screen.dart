import 'package:flutter/material.dart';
import 'package:hacathon_2026/controller/dashbord_controller.dart';
import 'package:hacathon_2026/screen/ai/ai_chat_screen.dart';
import 'package:hacathon_2026/screen/ai/weekly_report_screen.dart';
import 'package:hacathon_2026/service/ai_budget_service.dart';
import 'package:provider/provider.dart';

class AiAnalysisScreen extends StatelessWidget {
  const AiAnalysisScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final dashboard = context.watch<DashboardProvider>();
    final prediction = AiBudgetService().buildPrediction(
      monthlyBudget: dashboard.monthlyBudget,
      totalSpent: dashboard.totalSpent,
      daysLeftInMonth: dashboard.daysLeftInMonth,
    );
    final dailyGoal = dashboard.daysLeftInMonth <= 0
        ? 0.0
        : dashboard.targetAmount / dashboard.daysLeftInMonth;
    final goalProgress = dashboard.targetAmount <= 0
        ? 0.0
        : (dashboard.savings / dashboard.targetAmount)
              .clamp(0.0, 1.0)
              .toDouble();
    final alerts = _buildAlerts(dashboard, prediction.safeToSpendPerDay);

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 247, 238),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 255, 247, 238),
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'AI Analysis',
          style: TextStyle(
            color: Color(0xFF1A1A1A),
            fontWeight: FontWeight.w800,
          ),
        ),
        iconTheme: const IconThemeData(color: Color(0xFF1A1A1A)),
      ),
      body: RefreshIndicator(
        color: const Color(0xFFFF7B00),
        onRefresh: dashboard.fetchDashboardData,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            _SectionCard(
              title: 'Budget Prediction',
              icon: Icons.query_stats_rounded,
              children: [
                _MetricRow(
                  'Total spent',
                  '₹${prediction.totalSpent.toStringAsFixed(0)}',
                ),
                _MetricRow(
                  'Remaining budget',
                  '₹${prediction.remainingBudget.toStringAsFixed(0)}',
                ),
                _MetricRow('Days left', '${prediction.daysLeftInMonth}'),
                _MetricRow(
                  'Safe to spend/day',
                  '₹${prediction.safeToSpendPerDay.toStringAsFixed(0)}',
                ),
                _MetricRow(
                  'Predicted month-end spend',
                  '₹${prediction.predictedMonthEndSpend.toStringAsFixed(0)}',
                ),
                _MetricRow(
                  'Risk percentage',
                  '${prediction.riskPercentage.toStringAsFixed(0)}%',
                ),
              ],
            ),
            const SizedBox(height: 16),
            _SectionCard(
              title: 'Savings Goal Advisor',
              icon: Icons.savings_rounded,
              children: [
                LinearProgressIndicator(
                  value: goalProgress,
                  minHeight: 8,
                  backgroundColor: const Color(0xFFFFE0C2),
                  valueColor: const AlwaysStoppedAnimation(Color(0xFFFF7B00)),
                ),
                const SizedBox(height: 12),
                Text(
                  dashboard.targetAmount <= 0
                      ? 'Set a savings target to get daily goal advice.'
                      : 'To save ₹${dashboard.targetAmount.toStringAsFixed(0)} in ${dashboard.daysLeftInMonth} days, save ₹${dailyGoal.toStringAsFixed(0)} daily.',
                  style: const TextStyle(
                    color: Color(0xFF5D4037),
                    fontWeight: FontWeight.w700,
                    height: 1.4,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _SectionCard(
              title: 'Smart Alerts',
              icon: Icons.notifications_active_rounded,
              children: alerts.isEmpty
                  ? [
                      const Text(
                        'No urgent alerts. Keep tracking your spending.',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ]
                  : alerts
                        .map(
                          (alert) => Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Icon(
                                  Icons.warning_amber_rounded,
                                  color: Color(0xFFFF7B00),
                                  size: 20,
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    alert,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w700,
                                      color: Color(0xFF4A3B32),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                        .toList(),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 52,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const WeeklyReportScreen(),
                          ),
                        );
                      },
                      icon: const Icon(Icons.calendar_month_rounded, size: 20),
                      label: const FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          'Weekly Report',
                          maxLines: 1,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFF7A00),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: SizedBox(
                    height: 52,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const AiChatScreen(),
                          ),
                        );
                      },
                      icon: const Icon(Icons.chat_bubble_rounded, size: 20),
                      label: const FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          'AI Chat',
                          maxLines: 1,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFF7A00),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  List<String> _buildAlerts(DashboardProvider dashboard, double safePerDay) {
    final alerts = <String>[];
    if (dashboard.monthlyBudget > 0 && dashboard.progress > 0.85) {
      alerts.add('You are spending too fast.');
    }
    if (dashboard.remainingBudget < 0) {
      alerts.add('Safe limit crossed today.');
    }
    if (dashboard.targetAmount > 0 && dashboard.daysLeftInMonth > 0) {
      final daily = dashboard.targetAmount / dashboard.daysLeftInMonth;
      alerts.add(
        'Goal is achievable if you save ₹${daily.toStringAsFixed(0)} daily.',
      );
    }
    if (safePerDay > 0 && safePerDay < 150) {
      alerts.add('Safe daily limit is low. Avoid non-essential spending.');
    }
    return alerts;
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({
    required this.title,
    required this.icon,
    required this.children,
  });

  final String title;
  final IconData icon;
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
          Row(
            children: [
              Icon(icon, color: const Color(0xFFFF7B00)),
              const SizedBox(width: 10),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF1A1A1A),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...children,
        ],
      ),
    );
  }
}

class _MetricRow extends StatelessWidget {
  const _MetricRow(this.label, this.value);

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Expanded(
            child: Text(label, style: TextStyle(color: Colors.grey.shade700)),
          ),
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
