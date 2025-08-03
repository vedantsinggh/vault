import 'package:flutter/material.dart';
import '../mock_data.dart';

class ExpensesScreen extends StatefulWidget {
  @override
  _ExpensesScreenState createState() => _ExpensesScreenState();
}

class _ExpensesScreenState extends State<ExpensesScreen> {
  DateTime selectedDate = DateTime.now();
  String selectedCategory = 'All';

  @override
  Widget build(BuildContext context) {
    final filteredExpenses = MockData.expenses.where((expense) {
      final expenseDate = DateTime.parse(expense['date']);
      final categoryMatch =
          selectedCategory == 'All' || expense['category'] == selectedCategory;
      return expenseDate.year == selectedDate.year &&
          expenseDate.month == selectedDate.month &&
          categoryMatch;
    }).toList();

    final totalAmount = filteredExpenses.fold(
      0.0,
      (sum, expense) => sum + expense['amount'],
    );

    return SafeArea(
      child: Column(
        children: [
          // Header
          Padding(
            padding: EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Expenses',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                Row(
                  children: [
                    IconButton(
                      onPressed: () {},
                      icon: Icon(Icons.search, color: Colors.white70),
                      style: IconButton.styleFrom(
                        backgroundColor: Color(0xFF2A2A2A),
                      ),
                    ),
                    SizedBox(width: 8),
                    IconButton(
                      onPressed: () => _showAddExpenseDialog(context),
                      icon: Icon(Icons.add, color: Colors.white70),
                      style: IconButton.styleFrom(
                        backgroundColor: Color(0xFF2A2A2A),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Month selector
          Container(
            margin: EdgeInsets.symmetric(horizontal: 20),
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Color(0xFF1E1E1E),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: () {
                    setState(() {
                      selectedDate = DateTime(
                        selectedDate.year,
                        selectedDate.month - 1,
                        1,
                      );
                    });
                  },
                  icon: Icon(Icons.chevron_left, color: Colors.white70),
                ),
                Text(
                  '${_getMonthName(selectedDate.month)} ${selectedDate.year}',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    setState(() {
                      selectedDate = DateTime(
                        selectedDate.year,
                        selectedDate.month + 1,
                        1,
                      );
                    });
                  },
                  icon: Icon(Icons.chevron_right, color: Colors.white70),
                ),
              ],
            ),
          ),

          SizedBox(height: 16),

          // Category filter
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: SizedBox(
              height: 50,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  _buildCategoryChip('All'),
                  ...MockData.expenseCategories.map((category) {
                    return _buildCategoryChip(category['name']);
                  }).toList(),
                ],
              ),
            ),
          ),

          SizedBox(height: 16),

          // Stats Card
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Color(0xFF1E1E1E),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Total Spent',
                          style: TextStyle(color: Colors.white54, fontSize: 14),
                        ),
                        SizedBox(height: 8),
                        Text(
                          '₹${totalAmount.toStringAsFixed(2)}',
                          style: TextStyle(
                            color: Colors.redAccent,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Transactions',
                          style: TextStyle(color: Colors.white54, fontSize: 14),
                        ),
                        SizedBox(height: 8),
                        Text(
                          filteredExpenses.length.toString(),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          SizedBox(height: 16),

          // Expenses List Header
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Recent Transactions',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  '${filteredExpenses.length} items',
                  style: TextStyle(color: Colors.white54, fontSize: 12),
                ),
              ],
            ),
          ),

          SizedBox(height: 8),

          // Expenses List
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 20),
              itemCount: filteredExpenses.length,
              itemBuilder: (context, index) {
                final expense = filteredExpenses[index];
                final category = MockData.expenseCategories.firstWhere(
                  (cat) => cat['name'] == expense['category'],
                  orElse: () => {"icon": "receipt", "color": "FF9E9E9E"},
                );
                final color = Color(int.parse('0x${category['color']}'));

                return _buildExpenseTile(expense, category['icon'], color);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryChip(String category) {
    final isSelected = selectedCategory == category;
    return Padding(
      padding: EdgeInsets.only(right: 8),
      child: ChoiceChip(
        label: Text(category),
        selected: isSelected,
        onSelected: (selected) {
          setState(() {
            selectedCategory = selected ? category : 'All';
          });
        },
        selectedColor: Colors.blue,
        labelStyle: TextStyle(
          color: isSelected ? Colors.white : Colors.white70,
        ),
        backgroundColor: Color(0xFF1E1E1E),
      ),
    );
  }

  IconData _getIconFromName(String iconName) {
    switch (iconName) {
      case 'local_grocery_store':
        return Icons.local_grocery_store;
      case 'directions_car':
        return Icons.directions_car;
      case 'flash_on':
        return Icons.flash_on;
      case 'shopping_bag':
        return Icons.shopping_bag;
      case 'restaurant':
        return Icons.restaurant;
      case 'movie':
        return Icons.movie;
      case 'receipt':
        return Icons.receipt;
      default:
        return Icons.receipt;
    }
  }

  Widget _buildExpenseTile(
    Map<String, dynamic> expense,
    String icon,
    Color color,
  ) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Center(
              child: Icon(
                _getIconFromName(icon), // Use this helper method
                color: color,
                size: 20,
              ),
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  expense['title'],
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  expense['category'],
                  style: TextStyle(color: Colors.white54, fontSize: 12),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '₹${expense['amount'].toStringAsFixed(2)}',
                style: TextStyle(
                  color: Colors.redAccent,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                expense['date'],
                style: TextStyle(color: Colors.white54, fontSize: 10),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _getMonthName(int month) {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    return months[month - 1];
  }

  void _showAddExpenseDialog(BuildContext context) {
    final titleController = TextEditingController();
    final amountController = TextEditingController();
    final descriptionController = TextEditingController();
    String selectedCategory = MockData.expenseCategories[0]['name'];
    String selectedPaymentMethod = 'Cash';
    DateTime selectedExpenseDate = DateTime.now();

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          backgroundColor: Color(0xFF1E1E1E),
          title: Text('Add Expense', style: TextStyle(color: Colors.white)),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleController,
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: 'Title',
                    labelStyle: TextStyle(color: Colors.white54),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white38),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue),
                    ),
                  ),
                ),
                SizedBox(height: 16),
                TextField(
                  controller: amountController,
                  keyboardType: TextInputType.number,
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: 'Amount',
                    labelStyle: TextStyle(color: Colors.white54),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white38),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue),
                    ),
                  ),
                ),
                SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: selectedCategory,
                  dropdownColor: Color(0xFF2A2A2A),
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: 'Category',
                    labelStyle: TextStyle(color: Colors.white54),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white38),
                    ),
                  ),
                  items:
                      [
                        'Cash',
                        'Credit Card',
                        'Debit Card',
                        'UPI',
                        'Net Banking',
                      ].map<DropdownMenuItem<String>>((method) {
                        // Explicitly specify type here
                        return DropdownMenuItem<String>(
                          value: method,
                          child: Text(
                            method,
                            style: TextStyle(color: Colors.white),
                          ),
                        );
                      }).toList(),
                  onChanged: (value) {
                    setDialogState(() {
                      selectedCategory = value!;
                    });
                  },
                ),
                SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: selectedPaymentMethod,
                  dropdownColor: Color(0xFF2A2A2A),
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: 'Payment Method',
                    labelStyle: TextStyle(color: Colors.white54),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white38),
                    ),
                  ),
                  items:
                      [
                        'Cash',
                        'Credit Card',
                        'Debit Card',
                        'UPI',
                        'Net Banking',
                      ].map((method) {
                        return DropdownMenuItem(
                          value: method,
                          child: Text(
                            method,
                            style: TextStyle(color: Colors.white),
                          ),
                        );
                      }).toList(),
                  onChanged: (value) {
                    setDialogState(() {
                      selectedPaymentMethod = value!;
                    });
                  },
                ),
                SizedBox(height: 16),
                TextField(
                  controller: descriptionController,
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: 'Description',
                    labelStyle: TextStyle(color: Colors.white54),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white38),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue),
                    ),
                  ),
                ),
                SizedBox(height: 16),
                GestureDetector(
                  onTap: () async {
                    final date = await showDatePicker(
                      context: context,
                      initialDate: selectedExpenseDate,
                      firstDate: DateTime(2020),
                      lastDate: DateTime(2030),
                      builder: (context, child) {
                        return Theme(
                          data: Theme.of(context).copyWith(
                            colorScheme: ColorScheme.dark(
                              primary: Colors.blue,
                              onPrimary: Colors.white,
                              surface: Color(0xFF1E1E1E),
                              onSurface: Colors.white,
                            ),
                            dialogBackgroundColor: Color(0xFF1E1E1E),
                          ),
                          child: child!,
                        );
                      },
                    );
                    if (date != null) {
                      setDialogState(() {
                        selectedExpenseDate = date;
                      });
                    }
                  },
                  child: Container(
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.white38),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.calendar_today,
                          color: Colors.white54,
                          size: 20,
                        ),
                        SizedBox(width: 12),
                        Text(
                          '${selectedExpenseDate.day}/${selectedExpenseDate.month}/${selectedExpenseDate.year}',
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel', style: TextStyle(color: Colors.white54)),
            ),
            ElevatedButton(
              onPressed: () {
                if (titleController.text.isNotEmpty &&
                    amountController.text.isNotEmpty) {
                  setState(() {
                    MockData.expenses.add({
                      "id": MockData.expenses.length + 1,
                      "title": titleController.text,
                      "amount": double.parse(amountController.text),
                      "category": selectedCategory,
                      "date":
                          "${selectedExpenseDate.year}-${selectedExpenseDate.month.toString().padLeft(2, '0')}-${selectedExpenseDate.day.toString().padLeft(2, '0')}",
                      "description": descriptionController.text,
                      "paymentMethod": selectedPaymentMethod,
                    });
                  });
                  Navigator.pop(context);
                }
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
              child: Text('Add Expense', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}
