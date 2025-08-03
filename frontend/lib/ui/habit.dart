import 'package:flutter/material.dart';
import '../mock_data.dart';
import 'dart:math';

class HabitsScreen extends StatefulWidget {
  @override
  _HabitsScreenState createState() => _HabitsScreenState();
}

class _HabitsScreenState extends State<HabitsScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Habit Tracker',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                IconButton(
                  onPressed: () => _showAddHabitDialog(context),
                  icon: Icon(Icons.add, color: Colors.white70),
                  style: IconButton.styleFrom(
                    backgroundColor: Color(0xFF2A2A2A),
                  ),
                ),
              ],
            ),
            SizedBox(height: 24),

            // Stats Cards
            Row(
              children: [
                Expanded(
                  child: _buildHabitStatCard(
                    'Current Streak',
                    '12 days',
                    Icons.local_fire_department,
                    Colors.orange,
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: _buildHabitStatCard(
                    'Total Habits',
                    MockData.habits.length.toString(),
                    Icons.track_changes,
                    Colors.blue,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),

            // Habits List Header
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                'Your Habits',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            SizedBox(height: 8),

            // Habits List
            Expanded(
              child: ListView.builder(
                itemCount: MockData.habits.length,
                itemBuilder: (context, index) {
                  final habit = MockData.habits[index];
                  final color = Color(int.parse('0x${habit['color']}'));
                  return _buildHabitCard(habit, color);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHabitStatCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(16),
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
            child: Center(child: Icon(icon, color: color, size: 20)),
          ),
          SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(color: Colors.white54, fontSize: 12),
              ),
              Text(
                value,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHabitCard(Map<String, dynamic> habit, Color color) {
    final today = DateTime.now();
    final todayFormatted =
        "${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}";
    final isCompletedToday = habit['completionDays'].contains(todayFormatted);

    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                habit['title'],
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  habit['frequency'],
                  style: TextStyle(color: color, fontSize: 12),
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          Text(
            habit['description'],
            style: TextStyle(color: Colors.white54, fontSize: 14),
          ),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.local_fire_department,
                    color: Colors.orange,
                    size: 16,
                  ),
                  SizedBox(width: 4),
                  Text(
                    '${habit['streak']} day streak',
                    style: TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                ],
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    if (isCompletedToday) {
                      habit['completionDays'].remove(todayFormatted);
                      habit['streak'] = max(0, habit['streak'] - 1);
                    } else {
                      habit['completionDays'].add(todayFormatted);
                      habit['streak'] = habit['streak'] + 1;
                    }
                  });
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: isCompletedToday
                        ? Colors.green.withOpacity(0.2)
                        : color.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isCompletedToday ? Colors.green : color,
                      width: 1,
                    ),
                  ),
                  child: Text(
                    isCompletedToday ? 'Completed' : 'Mark Complete',
                    style: TextStyle(
                      color: isCompletedToday ? Colors.green : color,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showAddHabitDialog(BuildContext context) {
    final titleController = TextEditingController();
    final descriptionController = TextEditingController();
    String selectedFrequency = 'Daily';
    Color selectedColor = Colors.blue;

    final colors = [
      Colors.blue,
      Colors.green,
      Colors.purple,
      Colors.orange,
      Colors.red,
      Colors.teal,
    ];

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          backgroundColor: Color(0xFF1E1E1E),
          title: Text('Add New Habit', style: TextStyle(color: Colors.white)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Habit Name',
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
              DropdownButtonFormField<String>(
                value: selectedFrequency,
                dropdownColor: Color(0xFF2A2A2A),
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Frequency',
                  labelStyle: TextStyle(color: Colors.white54),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white38),
                  ),
                ),
                items: ['Daily', 'Weekdays', 'Weekly', 'Monthly'].map((
                  frequency,
                ) {
                  return DropdownMenuItem(
                    value: frequency,
                    child: Text(
                      frequency,
                      style: TextStyle(color: Colors.white),
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  setDialogState(() {
                    selectedFrequency = value!;
                  });
                },
              ),
              SizedBox(height: 16),
              Text(
                'Color',
                style: TextStyle(color: Colors.white54, fontSize: 14),
              ),
              SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: colors.map((color) {
                  return GestureDetector(
                    onTap: () {
                      setDialogState(() {
                        selectedColor = color;
                      });
                    },
                    child: Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: color,
                        borderRadius: BorderRadius.circular(16),
                        border: selectedColor == color
                            ? Border.all(color: Colors.white, width: 2)
                            : null,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel', style: TextStyle(color: Colors.white54)),
            ),
            ElevatedButton(
              onPressed: () {
                if (titleController.text.isNotEmpty) {
                  setState(() {
                    MockData.habits.add({
                      "id": MockData.habits.length + 1,
                      "title": titleController.text,
                      "description": descriptionController.text,
                      "streak": 0,
                      "frequency": selectedFrequency,
                      "completionDays": [],
                      "color": selectedColor.value
                          .toRadixString(16)
                          .substring(2),
                    });
                  });
                  Navigator.pop(context);
                }
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
              child: Text('Add Habit', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}
