import 'package:flutter/material.dart';
import '../api_service.dart';
import '../models/habit.dart';

class HabitsScreen extends StatefulWidget {
  @override
  _HabitsScreenState createState() => _HabitsScreenState();
}

class _HabitsScreenState extends State<HabitsScreen> {
  List<Habit> habits = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadHabits();
  }

  Future<void> _loadHabits() async {
    try {
      final response = await ApiService.get('habits/');
      setState(() {
        habits = (response as List).map((h) => Habit.fromJson(h)).toList();
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to load habits: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Habit Tracker',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                _buildIconButton(Icons.add, onPressed: _showAddHabitDialog),
              ],
            ),
            SizedBox(height: 24),

            // Stats Cards
            Row(
              children: [
                Expanded(
                  child: _buildHabitStatCard(
                    'Current Streak',
                    habits.isNotEmpty
                        ? habits
                              .map((h) => h.streak)
                              .reduce((a, b) => a > b ? a : b)
                              .toString()
                        : '0',
                    Icons.local_fire_department,
                    Colors.orange,
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: _buildHabitStatCard(
                    'Total Habits',
                    habits.length.toString(),
                    Icons.track_changes,
                    Colors.blue,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),

            // Habits List
            Expanded(
              child: _isLoading
                  ? Center(child: CircularProgressIndicator())
                  : ListView.builder(
                      itemCount: habits.length,
                      itemBuilder: (context, index) {
                        return _buildHabitCard(habits[index]);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHabitCard(Habit habit) {
    final today = DateTime.now().toIso8601String().split('T')[0];
    final isCompletedToday = habit.completionDays.contains(today);
    final color = Color(int.parse(habit.color.replaceFirst('#', '0xFF')));

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
                habit.title,
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
                  habit.frequency,
                  style: TextStyle(color: color, fontSize: 12),
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          Text(
            habit.description,
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
                    '${habit.streak} day streak',
                    style: TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                ],
              ),
              GestureDetector(
                onTap: () => _toggleHabitCompletion(habit),
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

  Future<void> _toggleHabitCompletion(Habit habit) async {
    try {
      final today = DateTime.now().toIso8601String().split('T')[0];
      final isCompletedToday = habit.completionDays.contains(today);

      // Create a new list for completion days
      final updatedCompletionDays = List<String>.from(habit.completionDays);
      if (isCompletedToday) {
        updatedCompletionDays.remove(today);
      } else {
        updatedCompletionDays.add(today);
      }

      // Create a new habit with updated values
      final updatedHabit = Habit(
        id: habit.id,
        title: habit.title,
        description: habit.description,
        streak: isCompletedToday
            ? (habit.streak - 1).clamp(0, double.infinity).toInt()
            : habit.streak + 1,
        frequency: habit.frequency,
        completionDays: updatedCompletionDays,
        color: habit.color, // Make sure to include all required parameters
      );

      // Update the backend
      await ApiService.put('habits/${habit.id}', updatedHabit.toJson());

      // Update the UI
      setState(() {
        final index = habits.indexWhere((h) => h.id == habit.id);
        if (index != -1) {
          habits[index] = updatedHabit;
        }
      });
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to update habit: $e')));
    }
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

  Widget _buildIconButton(IconData icon, {VoidCallback? onPressed}) {
    return IconButton(
      onPressed: onPressed,
      icon: Icon(icon, color: Colors.white70),
      style: IconButton.styleFrom(
        backgroundColor: Color(0xFF2A2A2A),
        fixedSize: Size(48, 48),
      ),
    );
  }

  void _showAddHabitDialog() {
    // Implement habit creation dialog
  }
}
