import 'package:flutter/material.dart';
import 'package:hacathon_2026/screen/Expenses%20all%20value/expenses_list.dart';
import 'package:provider/provider.dart';
import 'package:hacathon_2026/controller/expense_provider.dart';
import 'package:hacathon_2026/screen/Goles%20Screen/goles.dart';
import 'package:hacathon_2026/screen/ai/ai_analysis_screen.dart';
import 'package:hacathon_2026/screen/dashboard/dashboard.dart';
import 'package:hacathon_2026/screen/profileScreen/profile_screen.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    DashboardScreen(),
    ExpensesScreen(),
    ExpenseAnalyticsScreen(),
    AiAnalysisScreen(),
    ProfileScreen(),
  ];

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });

    if (index == 2) {
      context.read<GolesProvider>().fetchExpenses();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F9),
      body: IndexedStack(index: _currentIndex, children: _pages),
      bottomNavigationBar: CustomBottomNavBar(
        selectedIndex: _currentIndex,
        onItemTapped: _onTabTapped,
      ),
    );
  }
}

class CustomBottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  const CustomBottomNavBar({
    super.key,
    required this.selectedIndex,
    required this.onItemTapped,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.only(top: 8, bottom: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 15,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: _buildNavItem(
                index: 0,
                icon: Icons.space_dashboard_rounded,
                label: 'Dashboard',
              ),
            ),
            Expanded(
              child: _buildNavItem(
                index: 1,
                icon: Icons.receipt_long_rounded,
                label: 'Expenses',
              ),
            ),
            Expanded(
              child: _buildNavItem(
                index: 2,
                icon: Icons.insights_rounded,
                label: 'Goals',
              ),
            ),
            Expanded(
              child: _buildNavItem(
                index: 3,
                icon: Icons.auto_awesome_rounded,
                label: 'AI',
              ),
            ),
            Expanded(
              child: _buildNavItem(
                index: 4,
                icon: Icons.person_outline_rounded,
                label: 'Profile',
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required int index,
    required IconData icon,
    required String label,
  }) {
    final bool isSelected = selectedIndex == index;

    const Color activeColor = Color(0xFFFF7A00);
    const Color inactiveColor = Color(0xFFC0C0D0);

    return GestureDetector(
      onTap: () => onItemTapped(index),
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        height: 62,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              height: 3,
              width: isSelected ? 26 : 0,
              decoration: BoxDecoration(
                color: isSelected ? activeColor : Colors.transparent,
                borderRadius: BorderRadius.circular(20),
              ),
            ),

            const SizedBox(height: 6),

            Icon(
              icon,
              color: isSelected ? activeColor : inactiveColor,
              size: 25,
            ),

            const SizedBox(height: 4),

            FittedBox(
              child: Text(
                label,
                maxLines: 1,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: isSelected ? activeColor : inactiveColor,
                  fontSize: 11.5,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
