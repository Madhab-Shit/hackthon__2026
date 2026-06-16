import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hacathon_2026/controller/add_expresscontroller.dart';
import 'package:provider/provider.dart';

class AddExpenseScreen extends StatefulWidget {
  const AddExpenseScreen({super.key});

  @override
  State<AddExpenseScreen> createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends State<AddExpenseScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();

  String _selectedAccount = 'UPI'; // Default Payment Method
  DateTime _selectedDate = DateTime.now();
  String _selectedCategory = 'Food'; // Default Category

  final List<String> _accounts = [
    'Cash',
    'UPI',
    'Bank Transfer',
    'Credit Card',
  ];

  // Categories list (Ekhon dropdown-e use hobe)
  final List<Map<String, dynamic>> _categories = [
    {'name': 'Food', 'icon': Icons.fastfood_rounded, 'color': Colors.orange},
    {'name': 'Transport', 'icon': Icons.train_rounded, 'color': Colors.blue},
    {'name': 'Entertainment', 'icon': Icons.movie_rounded, 'color': Colors.red},
    {
      'name': 'Academics',
      'icon': Icons.menu_book_rounded,
      'color': Colors.purple,
    },
    {
      'name': 'Others',
      'icon': Icons.card_giftcard_rounded,
      'color': Colors.teal,
    },
  ];

  final List<int> _quickAmounts = [50, 100, 200, 500, 1000];

  @override
  void dispose() {
    _amountController.dispose();
    _titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 247, 238),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Color(0xFF1A1A1A),
          ),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          'Add Expense',
          style: TextStyle(
            color: Color(0xFF1A1A1A),
            fontWeight: FontWeight.w800,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                children: [
                  Text(
                    "Enter Amount",
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // FIXED: Perfect centering using a Row and IntrinsicWidth
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        "₹ ",
                        style: TextStyle(
                          fontSize: 48,
                          fontWeight: FontWeight.w900,
                          color: Color(0xFFFF7B00),
                        ),
                      ),
                      IntrinsicWidth(
                        child: TextFormField(
                          controller: _amountController,
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 48,
                            fontWeight: FontWeight.w900,
                            color: Color(0xFFFF7B00),
                          ),
                          validator: (val) =>
                              val == null || val.isEmpty || val == '0'
                              ? "Enter amount"
                              : null,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "0",
                            hintStyle: TextStyle(
                              fontSize: 48,
                              fontWeight: FontWeight.w900,
                              color: const Color(0xFFFF7B00).withOpacity(0.2),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 10),

              // --- FIXED: Quick Amount Buttons (Added Horizontal Scroll) ---
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                physics:
                    const BouncingScrollPhysics(), // Adds a nice bounce effect
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: _quickAmounts
                      .map(
                        (amt) => Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 6),
                          child: ActionChip(
                            label: Text(
                              "+₹$amt",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            onPressed: () {
                              int cur =
                                  int.tryParse(_amountController.text) ?? 0;
                              _amountController.text = (cur + amt).toString();
                            },
                            backgroundColor: Colors.white,
                            side: const BorderSide(color: Color(0xFFEFE8E1)),
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),

              const SizedBox(height: 28),

              // --- 2. PAYMENT METHOD (Dropdown) ---
              const Text(
                "Payment Method",
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1A1A1A),
                ),
              ),
              const SizedBox(height: 10),
              _buildPaymentDropdown(),

              const SizedBox(height: 18),

              // --- 3. DATE PICKER ---
              const Text(
                "Select Date",
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1A1A1A),
                ),
              ),
              const SizedBox(height: 10),

              _buildDatePicker(context),
              const SizedBox(height: 18),

              // --- 4. TITLE / DESCRIPTION ---
              const Text(
                "What was this for?",
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1A1A1A),
                ),
              ),
              const SizedBox(height: 10),
              _buildPremiumTextFormField(
                controller: _titleController,
                hint: "e.g., Dinner, Bus Fare, Xerox",
                icon: Icons.edit_note_rounded,
              ),

              const SizedBox(height: 18),

              // --- 5. CATEGORY SELECTOR (Dropdown) ---
              const Text(
                "Select Category",
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1A1A1A),
                ),
              ),
              const SizedBox(height: 10),
              _buildCategoryDropdown(),

              const SizedBox(height: 40),

              // --- SAVE BUTTON ---
              _buildSaveButton(),
            ],
          ),
        ),
      ),
    );
  }

  // --- Widget Helper Methods ---

  Widget _buildPaymentDropdown() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFF2F2F7), width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      // Theme wrap kora hoyeche default grey color remove korar jonno
      child: Theme(
        data: Theme.of(context).copyWith(
          // Ekhane orange color with 10% opacity dewa hoyeche highlight r splash er jonno
          focusColor: const Color(0xFFFF7B00).withOpacity(0.1),
          splashColor: const Color(0xFFFF7B00).withOpacity(0.1),
          highlightColor: const Color(0xFFFF7B00).withOpacity(0.1),
          hoverColor: const Color(0xFFFF7B00).withOpacity(0.1),
        ),
        child: DropdownButtonFormField<String>(
          value: _selectedAccount,
          dropdownColor: Colors.white,
          elevation: 8,
          borderRadius: BorderRadius.circular(16),
          items: _accounts.map((a) {
            bool isSelected = _selectedAccount == a;
            return DropdownMenuItem(
              value: a,
              child: Text(a, style: TextStyle(color: Colors.black)),
            );
          }).toList(),
          onChanged: (val) => setState(() => _selectedAccount = val!),
          icon: const Padding(
            padding: EdgeInsets.only(right: 16.0),
            child: Icon(
              Icons.unfold_more_rounded,
              color: Color(0xFF8E8E93),
              size: 20,
            ),
          ),
          decoration: const InputDecoration(
            prefixIcon: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Icon(
                Icons.account_balance_wallet_rounded,
                color: Color(0xFFFF7B00),
                size: 22,
              ),
            ),
            prefixIconConstraints: BoxConstraints(minWidth: 54),
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(vertical: 18),
          ),
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Color(0xFF1C1C1E),
            letterSpacing: -0.4,
          ),
        ),
      ),
    );
  }

  DateTime selectedDate = DateTime.now();

  String formatDate(DateTime date) {
    const months = [
      "Jan",
      "Feb",
      "Mar",
      "Apr",
      "May",
      "Jun",
      "Jul",
      "Aug",
      "Sep",
      "Oct",
      "Nov",
      "Dec",
    ];

    return "${date.day} ${months[date.month - 1]} ${date.year}";
  }

  Widget _buildDatePicker(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final DateTime? picked = await showDatePicker(
          context: context,
          initialDate: selectedDate,
          firstDate: DateTime(2000),
          lastDate: DateTime.now(),
          helpText: 'SELECT DATE',
          cancelText: 'CANCEL',
          confirmText: 'SELECT',
        );

        if (picked != null) {
          setState(() {
            selectedDate = picked;
          });
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFFF3EBE3), width: 1.2),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.orange.withOpacity(.12),
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Icon(
                Icons.calendar_today_rounded,
                color: Colors.orange,
                size: 22,
              ),
            ),

            const SizedBox(width: 16),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Selected Date",
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
                  ),

                  const SizedBox(height: 4),

                  Text(
                    formatDate(selectedDate),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),

            Icon(
              Icons.arrow_forward_ios_rounded,
              color: Colors.grey.shade400,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryDropdown() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFEFE8E1), width: 1.5),
      ),
      child: DropdownButtonFormField<String>(
        value: _selectedCategory,
        items: _categories.map((cat) {
          return DropdownMenuItem<String>(
            value: cat['name'],
            child: Row(
              children: [
                Icon(cat['icon'], color: cat['color'], size: 22),
                const SizedBox(width: 12),
                Text(cat['name']),
              ],
            ),
          );
        }).toList(),
        onChanged: (val) => setState(() => _selectedCategory = val!),
        icon: const Padding(
          padding: EdgeInsets.only(right: 16.0),
          child: Icon(
            Icons.keyboard_arrow_down_rounded,
            color: Color(0xFFFF7B00),
          ),
        ),
        decoration: const InputDecoration(
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(vertical: 18, horizontal: 16),
        ),
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Colors.black,
        ),
      ),
    );
  }

  Widget _buildPremiumTextFormField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFEFE8E1), width: 1.5),
      ),
      child: TextFormField(
        controller: controller,
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return "Please enter a title";
          }
          if (value.trim().length < 3) {
            return "Title must be at least 3 characters";
          }
          return null;
        },
        decoration: InputDecoration(
          hintText: hint,
          prefixIcon: Icon(icon, color: const Color(0xFFFF7B00)),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 18),
        ),
      ),
    );
  }

  Widget _buildSaveButton() {
    return Consumer<ExpenseProvider>(
      builder: (context, provider, child) {
        return GestureDetector(
          onTap: provider.isLoading
              ? null
              : () async {
                  if (!_formKey.currentState!.validate()) {
                    return;
                  }

                  await provider.saveExpense(
                    amount: _amountController.text,
                    title: _titleController.text,
                    category: _selectedCategory,
                    paymentMethod: _selectedAccount,
                    date: selectedDate,
                  );
                },

          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 20),
            decoration: BoxDecoration(
              color: const Color(0xFFFF7B00),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Center(
              child: provider.isLoading
                  ? const SizedBox(
                      height: 24,
                      width: 24,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 3,
                      ),
                    )
                  : const Text(
                      "Save Expense",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            ),
          ),
        );
      },
    );
  }

  String _getMonthName(int month) {
    const m = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return m[month - 1];
  }
}
