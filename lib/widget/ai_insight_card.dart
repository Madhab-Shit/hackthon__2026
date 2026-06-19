import 'package:flutter/material.dart';
import 'package:hacathon_2026/controller/dashbord_controller.dart';
import 'package:hacathon_2026/controller/emergency_mode_provider.dart';
import 'package:hacathon_2026/model/ai_insight_model.dart';
import 'package:hacathon_2026/screen/ai/ai_analysis_screen.dart';
import 'package:hacathon_2026/service/ai_budget_service.dart';
import 'package:provider/provider.dart';

class AiInsightCard extends StatefulWidget {
  const AiInsightCard({super.key, required this.dashboardProvider});

  final DashboardProvider dashboardProvider;

  @override
  State<AiInsightCard> createState() => _AiInsightCardState();
}

class _AiInsightCardState extends State<AiInsightCard> {
  final AiBudgetService _service = AiBudgetService();
  AiInsight? _insight;
  bool _isGenerating = false;

  @override
  Widget build(BuildContext context) {
    final emergency = context.watch<EmergencyModeProvider>();
    final dashboard = widget.dashboardProvider;
    final autoEmergency = emergency.shouldSuggestEmergency(
      remainingBudget: dashboard.remainingBudget,
      daysLeftInMonth: dashboard.daysLeftInMonth,
    );
    final emergencyActive = emergency.isEmergencyActive(
      remainingBudget: dashboard.remainingBudget,
      daysLeftInMonth: dashboard.daysLeftInMonth,
    );

    final prediction = _service.buildPrediction(
      monthlyBudget: dashboard.monthlyBudget,
      totalSpent: dashboard.totalSpent,
      daysLeftInMonth: dashboard.daysLeftInMonth,
    );
    final fallbackInsight =
        _insight ??
        AiInsight(
          health: prediction.riskPercentage >= 100
              ? 'Danger'
              : prediction.riskPercentage >= 80
              ? 'Warning'
              : 'Good',
          suggestion:
              'Generate an AI insight to get a student-friendly spending plan.',
          riskLevel: prediction.riskPercentage >= 100
              ? 'High'
              : prediction.riskPercentage >= 80
              ? 'Medium'
              : 'Low',
          safeToSpendPerDay: prediction.safeToSpendPerDay,
          budgetWarning: prediction.remainingBudget < 0
              ? 'Budget crossed.'
              : 'Budget tracking active.',
          riskPercentage: prediction.riskPercentage,
          predictedMonthEndSpend: prediction.predictedMonthEndSpend,
        );

    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0xFFF2E8DD), width: 1.5),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFFF7B00).withValues(alpha: 0.07),
                blurRadius: 18,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFF7B00).withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Icon(
                      Icons.auto_awesome_rounded,
                      color: Color(0xFFFF7B00),
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text(
                      'AI Financial Insight',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF1A1A1A),
                      ),
                    ),
                  ),
                  _HealthPill(health: fallbackInsight.health),
                ],
              ),
              const SizedBox(height: 14),
              Text(
                fallbackInsight.suggestion,
                style: TextStyle(
                  color: Colors.grey.shade700,
                  fontSize: 14,
                  height: 1.4,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 14),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _MiniMetric(
                    label: 'Risk',
                    value:
                        '${fallbackInsight.riskLevel} (${fallbackInsight.riskPercentage.toStringAsFixed(0)}%)',
                  ),
                  _MiniMetric(
                    label: 'Safe/day',
                    value:
                        '₹${fallbackInsight.safeToSpendPerDay.toStringAsFixed(0)}',
                  ),
                  _MiniMetric(
                    label: 'Month-end',
                    value:
                        '₹${fallbackInsight.predictedMonthEndSpend.toStringAsFixed(0)}',
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                fallbackInsight.budgetWarning,
                style: TextStyle(
                  color: fallbackInsight.health == 'Danger'
                      ? Colors.red.shade700
                      : Colors.orange.shade900,
                  fontWeight: FontWeight.w700,
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _isGenerating ? null : _generateInsight,
                      icon: _isGenerating
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Icon(Icons.bolt_rounded),
                      label: Text(
                        _isGenerating ? 'Generating...' : 'Generate AI Insight',
                        style: const TextStyle(fontSize: 14),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  IconButton.filledTonal(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const AiAnalysisScreen(),
                        ),
                      );
                    },
                    icon: const Icon(Icons.analytics_rounded),
                    tooltip: 'AI Analysis',
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: emergencyActive
                ? const Color(0xFFFFEBE6)
                : const Color(0xFFFFF9F2),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: emergencyActive
                  ? const Color(0xFFFF7043)
                  : const Color(0xFFF2E8DD),
            ),
          ),
          child: Column(
            children: [
              SwitchListTile.adaptive(
                value: emergency.manualEmergencyMode,
                onChanged: emergency.setManualEmergencyMode,
                activeColor: const Color(0xFFFF7B00),
                contentPadding: EdgeInsets.zero,
                title: const Text(
                  'Emergency Survival Mode',
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF1A1A1A),
                  ),
                ),
                subtitle: Text(
                  autoEmergency
                      ? 'Auto suggestion: remaining budget is low for the days left.'
                      : 'Manual ON/OFF for strict essential-only spending.',
                ),
              ),

              if (emergencyActive)
                const Padding(
                  padding: EdgeInsets.only(top: 8),
                  child: Text(
                    'Emergency Mode ON: Spend only on essentials like food, travel, study, medicine.',
                    style: TextStyle(
                      color: Color(0xFFD84315),
                      fontWeight: FontWeight.w800,
                      height: 1.35,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _generateInsight() async {
    setState(() => _isGenerating = true);
    try {
      final dashboard = widget.dashboardProvider;
      final insight = await _service.generateInsight(
        monthlyBudget: dashboard.monthlyBudget,
        totalSpent: dashboard.totalSpent,
        daysLeftInMonth: dashboard.daysLeftInMonth,
        targetAmount: dashboard.targetAmount,
        goalName: dashboard.goalName,
      );
      if (mounted) setState(() => _insight = insight);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Could not generate insight: $e')));
    } finally {
      if (mounted) setState(() => _isGenerating = false);
    }
  }
}

class _HealthPill extends StatelessWidget {
  const _HealthPill({required this.health});

  final String health;

  @override
  Widget build(BuildContext context) {
    final MaterialColor color = health == 'Danger'
        ? Colors.red
        : health == 'Warning'
        ? Colors.orange
        : Colors.green;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        health,
        style: TextStyle(color: color.shade700, fontWeight: FontWeight.w800),
      ),
    );
  }
}

class _MiniMetric extends StatelessWidget {
  const _MiniMetric({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF4E8),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        '$label: $value',
        style: const TextStyle(
          color: Color(0xFF5D4037),
          fontWeight: FontWeight.w700,
          fontSize: 12,
        ),
      ),
    );
  }
}
