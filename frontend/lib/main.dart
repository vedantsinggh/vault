import 'package:flutter/material.dart';

void main() {
  runApp(VaultApp());
}

class VaultApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Vault - Personal Manager',
      theme: ThemeData.dark().copyWith(
        primaryColor: Colors.blue,
        scaffoldBackgroundColor: Color(0xFF121212),
        cardColor: Color(0xFF1E1E1E),
        textTheme: TextTheme(
          headlineLarge: TextStyle(
            color: Colors.white,
            fontSize: 32,
            fontWeight: FontWeight.bold,
          ),
          headlineMedium: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.w600,
          ),
          bodyLarge: TextStyle(color: Colors.white70, fontSize: 16),
          bodyMedium: TextStyle(color: Colors.white54, fontSize: 14),
        ),
      ),
      home: MainScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    DashboardScreen(),
    PlannerScreen(),
    TasksScreen(),
    ExpensesScreen(),
    HabitsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Color(0xFF1E1E1E),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) => setState(() => _currentIndex = index),
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.transparent,
          elevation: 0,
          selectedItemColor: Colors.blue,
          unselectedItemColor: Colors.grey,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.dashboard),
              label: 'Dashboard',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.calendar_month),
              label: 'Planner',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.check_box),
              label: 'Tasks',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.attach_money),
              label: 'Expenses',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.track_changes),
              label: 'Habits',
            ),
          ],
        ),
      ),
    );
  }
}

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int selectedMonthIndex = 2; // Start with March (index 2)
  final List<String> months = ['Jan', 'Feb', 'Mar'];

  int _getStreakForMonth(int monthIndex) {
    // Mock streak data for different months
    switch (monthIndex) {
      case 0:
        return 12; // Jan
      case 1:
        return 18; // Feb
      case 2:
        return 7; // Mar
      default:
        return 0;
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
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Dashboard',
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
                Row(
                  children: [
                    IconButton(
                      onPressed: () {},
                      icon: Icon(Icons.filter_list, color: Colors.white70),
                      style: IconButton.styleFrom(
                        backgroundColor: Color(0xFF2A2A2A),
                      ),
                    ),
                    SizedBox(width: 8),
                    IconButton(
                      onPressed: () {},
                      icon: Icon(Icons.add, color: Colors.white70),
                      style: IconButton.styleFrom(
                        backgroundColor: Color(0xFF2A2A2A),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 24),

            // Stats Cards Row
            Row(
              children: [
                Expanded(
                  child: StatsCard(
                    title: 'Tasks Today',
                    value: '8',
                    subtitle: 'of 12 completed',
                    progress: 0.67,
                    icon: Icons.check_circle_outline,
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: StatsCard(
                    title: 'Focus Hours',
                    value: '4.5h',
                    subtitle: 'Today',
                    progress: 0.75,
                    icon: Icons.timer,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),

            // Habit Heatmap Card
            Container(
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
                        children: months.asMap().entries.map((entry) {
                          int index = entry.key;
                          String month = entry.value;
                          bool isSelected = selectedMonthIndex == index;

                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedMonthIndex = index;
                              });
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                vertical: 4,
                                horizontal: 8,
                              ),
                              margin: EdgeInsets.only(bottom: 2),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? Colors.blue.withOpacity(0.2)
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                month,
                                style: TextStyle(
                                  color: isSelected
                                      ? Colors.blue
                                      : Colors.white70,
                                  fontSize: 12,
                                  fontWeight: isSelected
                                      ? FontWeight.w600
                                      : FontWeight.normal,
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                      // Month info and stats
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            '${months[selectedMonthIndex]} 2024',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Habit Streak: ${_getStreakForMonth(selectedMonthIndex)} days',
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
                  HeatmapWidget(monthIndex: selectedMonthIndex),
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
                          child: Icon(
                            Icons.trending_up,
                            color: Colors.blue,
                            size: 20,
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
                        style: TextStyle(color: Colors.white54, fontSize: 12),
                      ),
                      Text(
                        'Last 7 days',
                        style: TextStyle(color: Colors.white54, fontSize: 10),
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
}

class StatsCard extends StatelessWidget {
  final String title;
  final String value;
  final String subtitle;
  final double progress;
  final IconData icon;

  const StatsCard({
    required this.title,
    required this.value,
    required this.subtitle,
    required this.progress,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
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
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Center(
                  child: Text(
                    value.split('.')[0], // Show just the number part
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
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

class HeatmapWidget extends StatelessWidget {
  final int monthIndex;

  const HeatmapWidget({super.key, required this.monthIndex});

  // Different heatmap data for each month
  List<List<double>> getHeatmapDataForMonth(int monthIndex) {
    switch (monthIndex) {
      case 0: // January - Good consistency
        return [
          [0.8, 0.9, 0.7, 0.8, 0.9, 0.6, 0.0],
          [0.7, 0.8, 0.9, 0.8, 0.7, 0.9, 0.8],
          [0.9, 0.8, 0.7, 0.9, 0.8, 0.7, 0.9],
          [0.8, 0.9, 0.8, 0.7, 0.9, 0.8, 0.7],
          [0.7, 0.8, 0.9, 0.8, 0.7, 0.9, 0.8],
        ];
      case 1: // February - Excellent performance
        return [
          [0.9, 0.9, 0.8, 0.9, 0.9, 0.8, 0.9],
          [0.8, 0.9, 0.9, 0.9, 0.8, 0.9, 0.9],
          [0.9, 0.9, 0.8, 0.9, 0.9, 0.8, 0.9],
          [0.8, 0.9, 0.9, 0.8, 0.9, 0.9, 0.8],
        ];
      case 2: // March - Current month with some gaps
        return [
          [0.6, 0.7, 0.3, 0.8, 0.1, 0.9, 0.5],
          [0.2, 0.9, 0.6, 0.0, 0.7, 0.3, 0.8],
          [0.8, 0.1, 0.4, 0.9, 0.2, 0.6, 0.7],
          [0.3, 0.8, 0.0, 0.5, 0.9, 0.1, 0.4],
          [0.7, 0.2, 0.9, 0.3, 0.6, 0.8, 0.0],
        ];
      default:
        return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    final heatmapData = getHeatmapDataForMonth(monthIndex);

    if (heatmapData.isEmpty) {
      return Container(
        height: 100,
        child: Center(
          child: Text(
            'No data available',
            style: TextStyle(color: Colors.white54, fontSize: 12),
          ),
        ),
      );
    }

    return Column(
      children: [
        // Week labels
        Padding(
          padding: EdgeInsets.only(bottom: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: ['S', 'M', 'T', 'W', 'T', 'F', 'S'].map((day) {
              return SizedBox(
                width: 12,
                child: Text(
                  day,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white38,
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              );
            }).toList(),
          ),
        ),
        // Heatmap grid
        ...heatmapData.asMap().entries.map((weekEntry) {
          return Padding(
            padding: EdgeInsets.only(bottom: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: weekEntry.value.asMap().entries.map((dayEntry) {
                final day = dayEntry.value;
                return AnimatedContainer(
                  duration: Duration(milliseconds: 300),
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: day == 0.0
                        ? Colors.grey.withOpacity(0.2)
                        : Colors.blue.withOpacity(day.clamp(0.0, 1.0)),
                    borderRadius: BorderRadius.circular(2),
                    border: day > 0.8
                        ? Border.all(
                            color: Colors.blue.withOpacity(0.5),
                            width: 0.5,
                          )
                        : null,
                  ),
                );
              }).toList(),
            ),
          );
        }).toList(),
        SizedBox(height: 12),
        // Legend
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Less', style: TextStyle(color: Colors.white38, fontSize: 10)),
            SizedBox(width: 4),
            ...List.generate(5, (index) {
              return Container(
                width: 8,
                height: 8,
                margin: EdgeInsets.symmetric(horizontal: 2),
                decoration: BoxDecoration(
                  color: index == 0
                      ? Colors.grey.withOpacity(0.2)
                      : Colors.blue.withOpacity(
                          ((index + 1) * 0.25).clamp(0.0, 1.0),
                        ),
                  borderRadius: BorderRadius.circular(1),
                ),
              );
            }),
            SizedBox(width: 4),
            Text('More', style: TextStyle(color: Colors.white38, fontSize: 10)),
          ],
        ),
      ],
    );
  }
}

// Placeholder screens
class PlannerScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Planner Screen',
        style: TextStyle(color: Colors.white, fontSize: 24),
      ),
    );
  }
}

class TasksScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Tasks Screen',
        style: TextStyle(color: Colors.white, fontSize: 24),
      ),
    );
  }
}

class ExpensesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Expenses Screen',
        style: TextStyle(color: Colors.white, fontSize: 24),
      ),
    );
  }
}

class HabitsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Habits Screen',
        style: TextStyle(color: Colors.white, fontSize: 24),
      ),
    );
  }
}
