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

class TasksScreen extends StatefulWidget {
  @override
  _TasksScreenState createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  DateTime selectedDate = DateTime.now();
  List<Task> tasks = [
    Task(
      id: 1,
      title: 'Business meeting',
      description: 'Call about project costs',
      date: DateTime.now(),
      priority: TaskPriority.high,
      isCompleted: false,
    ),
    Task(
      id: 2,
      title: 'Call grandma',
      description: 'Birthday party discussion and hot whatsapp',
      date: DateTime.now(),
      priority: TaskPriority.medium,
      isCompleted: false,
    ),
    Task(
      id: 3,
      title: 'Study',
      description: 'Flutter development',
      date: DateTime.now(),
      priority: TaskPriority.low,
      isCompleted: true,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final tasksForSelectedDate = tasks
        .where(
          (task) =>
              task.date.day == selectedDate.day &&
              task.date.month == selectedDate.month &&
              task.date.year == selectedDate.year,
        )
        .toList();

    final completedTasks = tasksForSelectedDate
        .where((task) => task.isCompleted)
        .length;
    final inProgressTasks = tasksForSelectedDate
        .where((task) => !task.isCompleted)
        .length;

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
                  'Your task tracking',
                  style: Theme.of(
                    context,
                  ).textTheme.headlineMedium?.copyWith(fontSize: 20),
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
                      onPressed: () {},
                      icon: Icon(
                        Icons.notifications_outlined,
                        color: Colors.white70,
                      ),
                      style: IconButton.styleFrom(
                        backgroundColor: Color(0xFF2A2A2A),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Calendar Section
          Container(
            margin: EdgeInsets.symmetric(horizontal: 20),
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Color(0xFF1E1E1E),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                // Month Navigation
                Row(
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
                SizedBox(height: 16),

                // Week days header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: ['Mo', 'Tu', 'We', 'Th', 'Fr', 'Sa', 'Su'].map((
                    day,
                  ) {
                    return SizedBox(
                      width: 32,
                      child: Text(
                        day,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white54,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    );
                  }).toList(),
                ),
                SizedBox(height: 12),

                // Calendar Grid
                _buildCalendarGrid(),
              ],
            ),
          ),

          SizedBox(height: 20),

          // Stats Row
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    'All task',
                    tasksForSelectedDate.length.toString(),
                    'TODAYs',
                    Colors.blue,
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: _buildStatCard(
                    'Done',
                    completedTasks.toString(),
                    'TODAYs',
                    Colors.green,
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: _buildStatCard(
                    'In progress',
                    inProgressTasks.toString(),
                    'TODAYs',
                    Colors.orange,
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 20),

          // Tasks Header
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Tasks',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                GestureDetector(
                  onTap: () => _showAddTaskDialog(context),
                  child: Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(Icons.add, color: Colors.white, size: 20),
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 16),

          // Tasks List
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 20),
              itemCount: tasksForSelectedDate.length,
              itemBuilder: (context, index) {
                final task = tasksForSelectedDate[index];
                return _buildTaskTile(task);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCalendarGrid() {
    final daysInMonth = DateTime(
      selectedDate.year,
      selectedDate.month + 1,
      0,
    ).day;
    final firstDayOfMonth = DateTime(selectedDate.year, selectedDate.month, 1);
    final firstWeekday = firstDayOfMonth.weekday;

    List<Widget> dayWidgets = [];

    // Add empty spaces for days before the first day of month
    for (int i = 1; i < firstWeekday; i++) {
      dayWidgets.add(SizedBox(width: 32, height: 32));
    }

    // Add days of the month
    for (int day = 1; day <= daysInMonth; day++) {
      final date = DateTime(selectedDate.year, selectedDate.month, day);
      final isSelected =
          date.day == selectedDate.day &&
          date.month == selectedDate.month &&
          date.year == selectedDate.year;
      final isToday =
          date.day == DateTime.now().day &&
          date.month == DateTime.now().month &&
          date.year == DateTime.now().year;

      dayWidgets.add(
        GestureDetector(
          onTap: () {
            setState(() {
              selectedDate = date;
            });
          },
          child: Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: isSelected
                  ? Colors.blue
                  : isToday
                  ? Colors.blue.withOpacity(0.3)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Center(
              child: Text(
                day.toString(),
                style: TextStyle(
                  color: isSelected || isToday ? Colors.white : Colors.white70,
                  fontSize: 14,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ),
          ),
        ),
      );
    }

    // Create grid
    List<Widget> rows = [];
    for (int i = 0; i < dayWidgets.length; i += 7) {
      rows.add(
        Padding(
          padding: EdgeInsets.only(bottom: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: dayWidgets.sublist(
              i,
              i + 7 > dayWidgets.length ? dayWidgets.length : i + 7,
            ),
          ),
        ),
      );
    }

    return Column(children: rows);
  }

  Widget _buildStatCard(
    String title,
    String value,
    String subtitle,
    Color color,
  ) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(title, style: TextStyle(color: Colors.white54, fontSize: 12)),
          SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              color: color,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(subtitle, style: TextStyle(color: Colors.white38, fontSize: 10)),
        ],
      ),
    );
  }

  Widget _buildTaskTile(Task task) {
    Color priorityColor = task.priority == TaskPriority.high
        ? Colors.red
        : task.priority == TaskPriority.medium
        ? Colors.blue
        : Colors.green;

    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: priorityColor.withOpacity(0.3), width: 1),
      ),
      child: Row(
        children: [
          // Priority indicator
          Container(
            width: 4,
            height: 40,
            decoration: BoxDecoration(
              color: priorityColor,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          SizedBox(width: 12),

          // Task content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  task.title,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    decoration: task.isCompleted
                        ? TextDecoration.lineThrough
                        : null,
                  ),
                ),
                if (task.description.isNotEmpty) ...[
                  SizedBox(height: 4),
                  Text(
                    task.description,
                    style: TextStyle(color: Colors.white54, fontSize: 12),
                  ),
                ],
                SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.access_time, color: Colors.white38, size: 14),
                    SizedBox(width: 4),
                    Text(
                      '${task.date.hour.toString().padLeft(2, '0')}:${task.date.minute.toString().padLeft(2, '0')}',
                      style: TextStyle(color: Colors.white38, fontSize: 12),
                    ),
                    SizedBox(width: 16),
                    Icon(Icons.calendar_today, color: Colors.white38, size: 14),
                    SizedBox(width: 4),
                    Text(
                      '${task.date.day}/${task.date.month}/${task.date.year}',
                      style: TextStyle(color: Colors.white38, fontSize: 12),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Completion toggle
          GestureDetector(
            onTap: () {
              setState(() {
                task.isCompleted = !task.isCompleted;
              });
            },
            child: Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: task.isCompleted ? Colors.green : Colors.transparent,
                border: Border.all(
                  color: task.isCompleted ? Colors.green : Colors.white38,
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: task.isCompleted
                  ? Icon(Icons.check, color: Colors.white, size: 14)
                  : null,
            ),
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

  void _showAddTaskDialog(BuildContext context) {
    final titleController = TextEditingController();
    final descriptionController = TextEditingController();
    TaskPriority selectedPriority = TaskPriority.medium;
    DateTime selectedTaskDate = selectedDate;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          backgroundColor: Color(0xFF1E1E1E),
          title: Text('Add New Task', style: TextStyle(color: Colors.white)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Task Title',
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
              DropdownButtonFormField<TaskPriority>(
                value: selectedPriority,
                dropdownColor: Color(0xFF2A2A2A),
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Priority',
                  labelStyle: TextStyle(color: Colors.white54),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white38),
                  ),
                ),
                items: TaskPriority.values.map((priority) {
                  return DropdownMenuItem(
                    value: priority,
                    child: Text(
                      priority.toString().split('.').last.toUpperCase(),
                      style: TextStyle(color: Colors.white),
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  setDialogState(() {
                    selectedPriority = value!;
                  });
                },
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
                    tasks.add(
                      Task(
                        id: tasks.length + 1,
                        title: titleController.text,
                        description: descriptionController.text,
                        date: selectedTaskDate,
                        priority: selectedPriority,
                        isCompleted: false,
                      ),
                    );
                  });
                  Navigator.pop(context);
                }
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
              child: Text('Add Task', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}

// Task model
class Task {
  final int id;
  final String title;
  final String description;
  final DateTime date;
  final TaskPriority priority;
  bool isCompleted;

  Task({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.priority,
    required this.isCompleted,
  });
}

enum TaskPriority { low, medium, high }

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
