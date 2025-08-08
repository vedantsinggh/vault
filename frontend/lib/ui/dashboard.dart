import 'package:flutter/material.dart';
import '../api_service.dart';
import '../models/dashboard_stat.dart';

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  DashboardStats? _stats;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadDashboardData();
  }

  Future<void> _loadDashboardData() async {
    try {
      final today = DateTime.now().toIso8601String().split('T')[0];
      final tasks = await ApiService.get('tasks/stats/daily?date=$today');
      final habits = await ApiService.get('habits/stats/streaks');
      final expenses = await ApiService.get(
        'expenses/stats/monthly?year=2024&month=3',
      );

      setState(() {
        _stats = DashboardStats(
          tasksTotal: tasks['total'] ?? 0,
          tasksCompleted: tasks['completed'] ?? 0,
          currentStreak: habits['current_streak'] ?? 0,
          totalHabits: habits['total_habits'] ?? 0,
          monthlyExpenses: expenses,
        );
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load dashboard data: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.all(20),
        child: _isLoading
            ? Center(child: CircularProgressIndicator())
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width - 40,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Dashboard',
                          style: Theme.of(context).textTheme.headlineLarge,
                        ),
                        Row(
                          children: [
                            _buildIconButton(Icons.filter_list),
                            SizedBox(width: 8),
                            _buildIconButton(Icons.add),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 24),

                  // Stats Cards
                  AspectRatio(
                    aspectRatio: 16 / 9,
                    child: Row(
                      children: [
                        Expanded(
                          child: _buildStatCard(
                            'Tasks Today',
                            _stats!.tasksTotal.toString(),
                            '${_stats!.tasksCompleted} completed',
                            0.67,
                            Icons.check_circle_outline,
                            Colors.blue,
                          ),
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: _buildStatCard(
                            'Habit Streak',
                            _stats!.currentStreak.toString(),
                            'days',
                            0.75,
                            Icons.local_fire_department,
                            Colors.orange,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 16),

                  // Heatmap Card
                  Container(
                    height: 220,
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Color(0xFF1E1E1E),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: ['Jan', 'Feb', 'Mar'].map((month) {
                                return Container(
                                  padding: EdgeInsets.symmetric(
                                    vertical: 4,
                                    horizontal: 8,
                                  ),
                                  margin: EdgeInsets.only(bottom: 2),
                                  child: Text(
                                    month,
                                    style: TextStyle(
                                      color: month == 'Mar'
                                          ? Colors.blue
                                          : Colors.white70,
                                      fontSize: 12,
                                      fontWeight: month == 'Mar'
                                          ? FontWeight.w600
                                          : FontWeight.normal,
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  'Mar 2024',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  'Habit Streak: ${_stats!.currentStreak} days',
                                  style: TextStyle(
                                    color: Colors.white54,
                                    fontSize: 10,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: 16),
                        // Heatmap widget would go here
                      ],
                    ),
                  ),
                  SizedBox(height: 16),

                  // Bottom Stats
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.all(20),
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
                                  color: Colors.blue.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Center(
                                  child: Icon(
                                    Icons.trending_up,
                                    color: Colors.blue,
                                    size: 20,
                                  ),
                                ),
                              ),
                              SizedBox(width: 12),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Productivity',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                    ),
                                  ),
                                  Text(
                                    'This week',
                                    style: TextStyle(
                                      color: Colors.white54,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                              Spacer(),
                              Text(
                                '87%',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(width: 16),
                      Container(
                        padding: EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Color(0xFF1E1E1E),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          children: [
                            Text(
                              '₹2,450',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'Expenses',
                              style: TextStyle(
                                color: Colors.white54,
                                fontSize: 12,
                              ),
                            ),
                            Text(
                              'Last 7 days',
                              style: TextStyle(
                                color: Colors.white54,
                                fontSize: 10,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildIconButton(IconData icon) {
    return IconButton(
      onPressed: () {},
      icon: Icon(icon, color: Colors.white70),
      style: IconButton.styleFrom(
        backgroundColor: Color(0xFF2A2A2A),
        fixedSize: Size(48, 48),
      ),
    );
  }

  Widget _buildStatCard(
    String title,
    String value,
    String subtitle,
    double progress,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
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
              Spacer(),
            ],
          ),
          SizedBox(height: 16),
          Text(title, style: TextStyle(color: Colors.white, fontSize: 16)),
          Text(subtitle, style: TextStyle(color: Colors.white54, fontSize: 12)),
        ],
      ),
    );
  }
}

class DashboardStats {
  final int tasksTotal;
  final int tasksCompleted;
  final int currentStreak;
  final int totalHabits;
  final List<dynamic> monthlyExpenses;

  DashboardStats({
    required this.tasksTotal,
    required this.tasksCompleted,
    required this.currentStreak,
    required this.totalHabits,
    required this.monthlyExpenses,
  });
}
