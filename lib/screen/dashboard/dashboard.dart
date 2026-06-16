import 'package:flutter/material.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Data for the Grid Cards
    final List<Map<String, dynamic>> dashboardStats = [
      {
        'title': 'Monthly Budget',
        'value': '1',
        'icon': Icons.alt_route_rounded,
        'color': const Color(0xFFE69A00), // Amber/Orange
      },
      {
        'title': 'Spent Amount',
        'value': '1',
        'icon': Icons.access_time_rounded,
        'color': const Color(0xFF6B4EE6), // Deep Purple
      },
      {
        'title': 'Remaining Amoun',
        'value': '₹2,970',
        'icon': Icons.local_shipping_outlined,
        'color': const Color(0xFFE53935), // Red
      },
      {
        'title': 'Savings Goal Progress',
        'value': '₹123',
        'icon': Icons.local_gas_station_outlined,
        'color': const Color(0xFFFF8F00), // Orange
      },
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Dashboard',
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
        ),
        centerTitle: false,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Responsive Grid View
              LayoutBuilder(
                builder: (context, constraints) {
                  // Determine columns based on screen width
                  int crossAxisCount = constraints.maxWidth > 600 ? 4 : 2;

                  // Calculate Aspect Ratio to keep cards looking good
                  double childAspectRatio = constraints.maxWidth > 600
                      ? 1.6
                      : 1.35;

                  return GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: childAspectRatio,
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

              // Recent Records Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Recent Records",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF1A1A1A),
                    ),
                  ),
                  TextButton(
                    onPressed: () {},
                    style: TextButton.styleFrom(
                      foregroundColor: const Color(0xFFFF8F00), // Orange text
                    ),
                    child: const Text(
                      "See all",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Recent Records List
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: 3, // Dummy count for UI
                itemBuilder: (context, index) {
                  return _buildRecentRecordCard();
                },
              ),

              // Extra space at bottom for floating button
              const SizedBox(height: 80),
            ],
          ),
        ),
      ),

      // Floating Action Button
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        backgroundColor: const Color(0xFFFF7B00), // Primary Orange Color
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        icon: const Icon(Icons.add, color: Colors.white, size: 24),
        label: const Text(
          "Add Record",
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
  // Widget Builder: Statistics Card
  // --------------------------------------------------------
  Widget _buildStatCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade200, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.01),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Icon and Title Row
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.12), // Soft background color
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 20),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF4A4A4A),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),

          // Value Text
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w800,
              color: color, // The value text takes the theme color
            ),
          ),
        ],
      ),
    );
  }

  // --------------------------------------------------------
  // Widget Builder: Recent Record Card
  // --------------------------------------------------------
  Widget _buildRecentRecordCard() {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Container(
          decoration: const BoxDecoration(
            border: Border(
              left: BorderSide(
                color: Color(0xFF2E7D32),
                width: 5,
              ), // Green left border
            ),
          ),
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Left Section: Vehicle Number
              Row(
                children: [
                  const Icon(
                    Icons.local_shipping,
                    color: Color(0xFF2E7D32),
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    "HE12AB1234",
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey.shade800,
                    ),
                  ),
                ],
              ),

              // Middle Section: Date
              Text(
                "15 Jun 2026",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey.shade600,
                ),
              ),

              // Right Section: Status Chip
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF2E7D32).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFF2E7D32), width: 1),
                ),
                child: const Text(
                  "Completed",
                  style: TextStyle(
                    color: Color(0xFF2E7D32),
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
