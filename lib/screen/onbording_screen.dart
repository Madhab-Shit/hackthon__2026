import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

// ------------------------------------------------------------------
// 1. MAIN ONBOARDING CONTROLLER
// ------------------------------------------------------------------
class OnboardingFlow extends StatefulWidget {
  const OnboardingFlow({super.key});

  @override
  State<OnboardingFlow> createState() => _OnboardingFlowState();
}

class _OnboardingFlowState extends State<OnboardingFlow> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  // User Data State
  double income = 0;
  double budget = 0;
  String goal = '';
  double target = 0;

  void _nextPage() {
    if (_currentPage < 3) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeOutQuart, // iOS style smooth curve
      );
    }
  }

  void _finishOnboarding() {
    Navigator.of(context).pushReplacement(
      CupertinoPageRoute(
        builder: (context) => HomeDashboard(
          income: income,
          budget: budget,
          goal: goal,
          target: target,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(), // Disable manual swipe
        onPageChanged: (index) => setState(() => _currentPage = index),
        children: [
          IncomeScreen(
            onNext: (val) {
              setState(() => income = val);
              _nextPage();
            },
          ),
          BudgetScreen(
            income: income,
            onNext: (val) {
              setState(() => budget = val);
              _nextPage();
            },
          ),
          GoalScreen(
            onComplete: (selectedGoal, targetAmount) {
              setState(() {
                goal = selectedGoal;
                target = targetAmount;
              });
              _finishOnboarding();
            },
          ),
        ],
      ),
    );
  }
}

// ------------------------------------------------------------------
// REUSABLE BASE SCREEN (Clean UI with Bottom Button)
// ------------------------------------------------------------------
class BaseScreen extends StatelessWidget {
  final Widget content;
  final VoidCallback onNext;
  final String buttonText;

  const BaseScreen({
    super.key,
    required this.content,
    required this.onNext,
    this.buttonText = "Next",
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color(0xFFFBFBFD),
      body: Stack(
        children: [
          // Background subtle particles
          Positioned(
            top: size.height * 0.15,
            right: size.width * 0.25,
            child: _buildDot(),
          ),
          Positioned(
            top: size.height * 0.25,
            left: size.width * 0.2,
            child: _buildDot(),
          ),
          Positioned(
            top: size.height * 0.4,
            right: size.width * 0.15,
            child: _buildDot(),
          ),

          // Main Content
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: content,
            ),
          ),

          // Bottom Navigation Button
          Align(
            alignment: Alignment.bottomCenter,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.only(
                  left: 30.0,
                  right: 30.0,
                  bottom: 24.0,
                ),
                child: GestureDetector(
                  onTap: onNext,
                  child: Container(
                    width: double.infinity,
                    height: 56,
                    decoration: BoxDecoration(
                      // gradient: const LinearGradient(
                      //   colors: [Color(0xFFFF9500), Color(0xFFFF5E3A)],
                      //   begin: Alignment.centerLeft,
                      //   end: Alignment.centerRight,
                      // ),
                      color: Color(0xffFF7B00),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFFFF5E3A).withOpacity(0.3),
                          blurRadius: 15,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          buttonText,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.5,
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Icon(
                          Icons.arrow_forward_rounded,
                          color: Colors.white,
                          size: 22,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDot() {
    return Container(
      width: 8,
      height: 8,
      decoration: BoxDecoration(
        color: const Color(0xFFFF9500).withOpacity(0.2),
        shape: BoxShape.circle,
      ),
    );
  }
}

// ------------------------------------------------------------------
// 2. WELCOME SCREEN
// ------------------------------------------------------------------
class WelcomeScreen extends StatelessWidget {
  final VoidCallback onNext;
  const WelcomeScreen({super.key, required this.onNext});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return BaseScreen(
      buttonText: "Start Journey",
      onNext: onNext,
      content: Stack(
        children: [
          // Floating Icons around the center
          Positioned(
            top: size.height * 0.10,
            left: 0,
            child: _buildFloatingIcon(
              Icons.account_balance_wallet_rounded,
              const Color(0xFFFF9500),
            ),
          ),
          Positioned(
            top: size.height * 0.14,
            right: 0,
            child: _buildFloatingIcon(
              Icons.insert_chart_rounded,
              const Color(0xFFFF9500),
            ),
          ),
          Positioned(
            top: size.height * 0.36,
            left: 0,
            child: _buildFloatingIcon(
              Icons.pie_chart_rounded,
              const Color(0xFFFF5E3A),
            ),
          ),
          Positioned(
            top: size.height * 0.39,
            right: 0,
            child: _buildFloatingIcon(
              Icons.savings_rounded,
              const Color(0xFFFF5E3A),
            ),
          ),

          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Main Glowing Logo
              Center(
                child: Container(
                  width: 160,
                  height: 160,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFFFF9500).withOpacity(0.15),
                        blurRadius: 50,
                        spreadRadius: 10,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Container(
                      width: 110,
                      height: 110,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        gradient: const LinearGradient(
                          colors: [Color(0xFFFFB74D), Color(0xFFFF5E3A)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFFFF5E3A).withOpacity(0.4),
                            blurRadius: 20,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.energy_savings_leaf_rounded,
                        color: Colors.white,
                        size: 55,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 55),
              const Text(
                "Welcome to",
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.5,
                  color: Color(0xFF1C1C1E),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text(
                    "GreenTrack ",
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.5,
                      color: Color(0xFFFF5E3A),
                    ),
                  ),
                  Text("👋", style: TextStyle(fontSize: 28)),
                ],
              ),
              const SizedBox(height: 16),
              const Text(
                "Take control of your finances and\nachieve your savings goals effortlessly.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF8E8E93),
                  height: 1.4,
                  letterSpacing: -0.2,
                ),
              ),
              const SizedBox(height: 80), // To clear bottom button
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFloatingIcon(IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 20,
            spreadRadius: 2,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Icon(icon, color: color, size: 26),
    );
  }
}

// ------------------------------------------------------------------
// 3. INCOME SCREEN
// ------------------------------------------------------------------
class IncomeScreen extends StatefulWidget {
  final Function(double) onNext;
  const IncomeScreen({super.key, required this.onNext});

  @override
  State<IncomeScreen> createState() => _IncomeScreenState();
}

class _IncomeScreenState extends State<IncomeScreen> {
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      onNext: () => widget.onNext(double.tryParse(_controller.text) ?? 0),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Step Indicator
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFF10B981).withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text(
              "Step 1 of 3",
              style: TextStyle(
                color: Color(0xFF059669),
                fontWeight: FontWeight.w700,
                fontSize: 14,
                letterSpacing: 0.5,
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Main Headline
          const Text(
            "What is your\nmonthly income?",
            style: TextStyle(
              fontSize: 38,
              fontWeight: FontWeight.w900,
              letterSpacing: -1.0,
              height: 1.15,
              color: Color(0xFF0F172A),
            ),
          ),
          const SizedBox(height: 40),

          // Premium Input Field
          _buildInputField(_controller, "e.g. 5000"),
          const SizedBox(height: 32),

          // Animated Suggestion Chips
          const Text(
            "Quick Select",
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color(0xFF94A3B8),
              letterSpacing: 0.3,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: ['3000', '5000', '10000'].map((val) {
              bool isSelected = _controller.text == val;

              return GestureDetector(
                onTap: () {
                  _controller.text = val;
                  _controller.selection = TextSelection.fromPosition(
                    TextPosition(offset: _controller.text.length),
                  );
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  curve: Curves.easeOutCubic,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected ? const Color(0xFF059669) : Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isSelected
                          ? Colors.transparent
                          : const Color(0xFFE2E8F0),
                      width: 1.5,
                    ),
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: const Color(0xFF059669).withOpacity(0.3),
                              blurRadius: 15,
                              offset: const Offset(0, 6),
                            ),
                          ]
                        : [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.02),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                  ),
                  child: Text(
                    "₹$val",
                    style: TextStyle(
                      color: isSelected
                          ? Colors.white
                          : const Color(0xFF475569),
                      fontWeight: isSelected
                          ? FontWeight.w800
                          : FontWeight.w600,
                      fontSize: 16,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 80), // To clear bottom button
        ],
      ),
    );
  }
}

// ------------------------------------------------------------------
// PREMIUM HELPER FOR INPUT FIELDS
// ------------------------------------------------------------------
Widget _buildInputField(
  TextEditingController controller,
  String hint, {
  Function(String)? onChanged,
}) {
  return Container(
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(24),
      border: Border.all(color: const Color(0xFFF1F5F9), width: 2),
      boxShadow: [
        BoxShadow(
          color: const Color(0xFF0F172A).withOpacity(0.04),
          blurRadius: 24,
          spreadRadius: 0,
          offset: const Offset(0, 10),
        ),
      ],
    ),
    child: TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      onChanged: onChanged,
      style: const TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.w900,
        color: Color(0xFF0F172A),
        letterSpacing: 1.0,
      ),
      decoration: InputDecoration(
        prefixIcon: const Padding(
          padding: EdgeInsets.only(left: 24.0, right: 12.0),
          child: Text(
            "₹",
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w800,
              color: Color(0xFF10B981),
            ),
          ),
        ),
        prefixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
        border: InputBorder.none,
        contentPadding: const EdgeInsets.symmetric(vertical: 24),
        hintText: hint,
        hintStyle: const TextStyle(
          color: Color(0xFFCBD5E1),
          fontWeight: FontWeight.w600,
          letterSpacing: 1.0,
        ),
      ),
    ),
  );
}

// ------------------------------------------------------------------
// 4. BUDGET SCREEN
// ------------------------------------------------------------------
class BudgetScreen extends StatefulWidget {
  final double income;
  final Function(double) onNext;
  const BudgetScreen({super.key, required this.income, required this.onNext});

  @override
  State<BudgetScreen> createState() => _BudgetScreenState();
}

class _BudgetScreenState extends State<BudgetScreen> {
  final TextEditingController _controller = TextEditingController();
  double budget = 0;

  @override
  Widget build(BuildContext context) {
    double savings = widget.income - budget;

    return BaseScreen(
      onNext: () => widget.onNext(budget),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            "Step 2 of 3",
            style: TextStyle(
              color: Color(0xFF8E8E93),
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            "How much do you\nwant to spend?",
            style: TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.5,
              height: 1.2,
              color: Color(0xFF1C1C1E),
            ),
          ),
          const SizedBox(height: 40),

          _buildInputField(
            _controller,
            "e.g. 4000",
            onChanged: (val) =>
                setState(() => budget = double.tryParse(val) ?? 0),
          ),
          const SizedBox(height: 30),

          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: savings >= 0
                    ? const Color(0xFF34C759).withOpacity(0.3)
                    : const Color(0xFFFF3B30).withOpacity(0.3),
                width: 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.02),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Row(
              children: [
                Icon(
                  savings >= 0
                      ? Icons.check_circle_rounded
                      : Icons.error_rounded,
                  color: savings >= 0
                      ? const Color(0xFF34C759)
                      : const Color(0xFFFF3B30),
                  size: 28,
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Potential Savings",
                      style: TextStyle(
                        color: Color(0xFF8E8E93),
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      "₹${savings.toStringAsFixed(0)}",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        color: savings >= 0
                            ? const Color(0xFF1C1C1E)
                            : const Color(0xFFFF3B30),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 80), // To clear bottom button
        ],
      ),
    );
  }
}

// ------------------------------------------------------------------
// 5. GOAL SCREEN
// ------------------------------------------------------------------
class GoalScreen extends StatefulWidget {
  final Function(String, double) onComplete;
  const GoalScreen({super.key, required this.onComplete});

  @override
  State<GoalScreen> createState() => _GoalScreenState();
}

class _GoalScreenState extends State<GoalScreen> {
  String selectedGoal = 'Phone';
  final TextEditingController _targetController = TextEditingController();

  final List<Map<String, dynamic>> goals = [
    {'icon': Icons.smartphone_rounded, 'name': 'Phone'},
    {'icon': Icons.laptop_mac_rounded, 'name': 'Laptop'},
    {'icon': Icons.school_rounded, 'name': 'Education'},
    {'icon': Icons.flight_takeoff_rounded, 'name': 'Travel'},
  ];

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      buttonText: "Finish",
      onNext: () => widget.onComplete(
        selectedGoal,
        double.tryParse(_targetController.text) ?? 0,
      ),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: MediaQuery.of(context).size.height * 0.15),
            const Text(
              "Step 3 of 3",
              style: TextStyle(
                color: Color(0xFF8E8E93),
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              "What are you\nsaving for?",
              style: TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.w800,
                letterSpacing: -0.5,
                height: 1.2,
                color: Color(0xFF1C1C1E),
              ),
            ),
            const SizedBox(height: 30),

            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 2.2,
              ),
              itemCount: goals.length,
              itemBuilder: (context, index) {
                bool isActive = selectedGoal == goals[index]['name'];
                return GestureDetector(
                  onTap: () =>
                      setState(() => selectedGoal = goals[index]['name']),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    decoration: BoxDecoration(
                      gradient: isActive
                          ? const LinearGradient(
                              colors: [Color(0xFFFF9500), Color(0xFFFF5E3A)],
                            )
                          : null,
                      color: isActive ? null : Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: isActive
                          ? [
                              BoxShadow(
                                color: const Color(0xFFFF5E3A).withOpacity(0.3),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ]
                          : [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.02),
                                blurRadius: 10,
                              ),
                            ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          goals[index]['icon'],
                          color: isActive
                              ? Colors.white
                              : const Color(0xFF8E8E93),
                          size: 22,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          goals[index]['name'],
                          style: TextStyle(
                            color: isActive
                                ? Colors.white
                                : const Color(0xFF1C1C1E),
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 30),
            const Text(
              "Target Amount",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1C1C1E),
              ),
            ),
            const SizedBox(height: 12),
            _buildInputField(_targetController, "e.g. 10000"),
            const SizedBox(
              height: 100,
            ), // Spacing to prevent overlay with Finish button
          ],
        ),
      ),
    );
  }
}

// ------------------------------------------------------------------
// 6. HOME DASHBOARD (Unchanged)
// ------------------------------------------------------------------
class HomeDashboard extends StatelessWidget {
  final double income, budget, target;
  final String goal;
  const HomeDashboard({
    super.key,
    required this.income,
    required this.budget,
    required this.goal,
    required this.target,
  });

  @override
  Widget build(BuildContext context) {
    double expectedSaving = income - budget;
    double progress = target > 0
        ? (expectedSaving / target).clamp(0.0, 1.0)
        : 0;

    return Scaffold(
      backgroundColor: const Color(0xFFFBFBFD),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          "Dashboard",
          style: TextStyle(
            color: Color(0xFF1C1C1E),
            fontWeight: FontWeight.w800,
            fontSize: 28,
            letterSpacing: -0.5,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFFFB74D), Color(0xFFFF5E3A)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFFF5E3A).withOpacity(0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Remaining Budget",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "₹${budget.toStringAsFixed(0)}",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 40,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.03),
                    blurRadius: 15,
                  ),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        goal,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        "${(progress * 100).toStringAsFixed(0)}%",
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFFFF9500),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  LinearProgressIndicator(
                    value: progress,
                    minHeight: 10,
                    backgroundColor: const Color(0xFFF2F2F7),
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      Color(0xFFFF9500),
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
