import 'package:flutter/material.dart';

class TimeBlock {
  final int id;
  final TimeOfDay startTime;
  final TimeOfDay endTime;
  final String title;
  final String description;
  final Color color;
  final DateTime date;

  TimeBlock({
    required this.id,
    required this.startTime,
    required this.endTime,
    required this.title,
    required this.description,
    required this.color,
    required this.date,
  });
}

class PlannerScreen extends StatefulWidget {
  @override
  _PlannerScreenState createState() => _PlannerScreenState();
}

class _PlannerScreenState extends State<PlannerScreen> {
  DateTime selectedDate = DateTime.now();
  List<TimeBlock> timeBlocks = [
    TimeBlock(
      id: 1,
      startTime: TimeOfDay(hour: 9, minute: 0),
      endTime: TimeOfDay(hour: 10, minute: 30),
      title: 'Morning workout',
      description: 'Gym session',
      color: Colors.green,
      date: DateTime.now(),
    ),
    TimeBlock(
      id: 2,
      startTime: TimeOfDay(hour: 11, minute: 0),
      endTime: TimeOfDay(hour: 12, minute: 0),
      title: 'Team meeting',
      description: 'Project discussion',
      color: Colors.blue,
      date: DateTime.now(),
    ),
    TimeBlock(
      id: 3,
      startTime: TimeOfDay(hour: 14, minute: 0),
      endTime: TimeOfDay(hour: 16, minute: 0),
      title: 'Deep work',
      description: 'Code review and development',
      color: Colors.purple,
      date: DateTime.now(),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final blocksForSelectedDate = timeBlocks
        .where(
          (block) =>
              block.date.day == selectedDate.day &&
              block.date.month == selectedDate.month &&
              block.date.year == selectedDate.year,
        )
        .toList();

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
                  'Day Planner',
                  style: Theme.of(
                    context,
                  ).textTheme.headlineLarge?.copyWith(fontSize: 28),
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
                      onPressed: () => _showAddBlockDialog(context),
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

          // Date Selector
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
                      selectedDate = selectedDate.subtract(Duration(days: 1));
                    });
                  },
                  icon: Icon(Icons.chevron_left, color: Colors.white70),
                ),
                Column(
                  children: [
                    Text(
                      _getWeekdayName(selectedDate.weekday),
                      style: TextStyle(color: Colors.white54, fontSize: 14),
                    ),
                    Text(
                      '${selectedDate.day} ${_getMonthName(selectedDate.month)}',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      selectedDate.year.toString(),
                      style: TextStyle(color: Colors.white54, fontSize: 12),
                    ),
                  ],
                ),
                IconButton(
                  onPressed: () {
                    setState(() {
                      selectedDate = selectedDate.add(Duration(days: 1));
                    });
                  },
                  icon: Icon(Icons.chevron_right, color: Colors.white70),
                ),
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
                    'Blocks',
                    blocksForSelectedDate.length.toString(),
                    'scheduled',
                    Colors.blue,
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: _buildStatCard(
                    'Hours',
                    _calculateTotalHours(
                      blocksForSelectedDate,
                    ).toStringAsFixed(1),
                    'planned',
                    Colors.green,
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: _buildStatCard(
                    'Free',
                    (24 - _calculateTotalHours(blocksForSelectedDate))
                        .toStringAsFixed(1),
                    'hours left',
                    Colors.orange,
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 20),

          // Time Blocks List
          Expanded(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 20),
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Color(0xFF1E1E1E),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Today\'s Schedule',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 16),
                  Expanded(child: _buildTimelineView(blocksForSelectedDate)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
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

  Widget _buildTimelineView(List<TimeBlock> blocks) {
    return ListView.builder(
      itemCount: 24, // 24 hours
      itemBuilder: (context, hour) {
        final currentHour = hour;
        final blocksAtThisHour = blocks
            .where(
              (block) =>
                  block.startTime.hour <= currentHour &&
                  _timeToHour(block.endTime) > currentHour,
            )
            .toList();

        return Container(
          height: 60,
          child: Row(
            children: [
              // Time label
              SizedBox(
                width: 60,
                child: Text(
                  '${currentHour.toString().padLeft(2, '0')}:00',
                  style: TextStyle(
                    color: Colors.white54,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),

              // Timeline line
              Container(
                width: 2,
                height: 60,
                color: Colors.white12,
                margin: EdgeInsets.symmetric(horizontal: 12),
              ),

              // Time blocks
              Expanded(
                child: blocksAtThisHour.isEmpty
                    ? GestureDetector(
                        onTap: () => _showAddBlockDialog(
                          context,
                          TimeOfDay(hour: currentHour, minute: 0),
                        ),
                        child: Container(
                          height: 50,
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: Colors.white12,
                              style: BorderStyle.solid,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              'Tap to add block',
                              style: TextStyle(
                                color: Colors.white38,
                                fontSize: 11,
                              ),
                            ),
                          ),
                        ),
                      )
                    : Column(
                        children: blocksAtThisHour
                            .map((block) => _buildTimeBlockTile(block))
                            .toList(),
                      ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTimeBlockTile(TimeBlock block) {
    final duration = _calculateBlockDuration(block);

    return Container(
      height: 50,
      margin: EdgeInsets.only(bottom: 4),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: block.color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: block.color.withOpacity(0.5), width: 1),
      ),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 30,
            decoration: BoxDecoration(
              color: block.color,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  block.title,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                if (block.description.isNotEmpty)
                  Text(
                    block.description,
                    style: TextStyle(color: Colors.white70, fontSize: 11),
                    overflow: TextOverflow.ellipsis,
                  ),
              ],
            ),
          ),
          Text(
            '${_formatTime(block.startTime)} - ${_formatTime(block.endTime)}',
            style: TextStyle(color: Colors.white54, fontSize: 10),
          ),
          SizedBox(width: 8),
          GestureDetector(
            onTap: () {
              setState(() {
                timeBlocks.remove(block);
              });
            },
            child: Icon(Icons.close, color: Colors.white54, size: 16),
          ),
        ],
      ),
    );
  }

  double _calculateTotalHours(List<TimeBlock> blocks) {
    double total = 0;
    for (var block in blocks) {
      total += _calculateBlockDuration(block);
    }
    return total;
  }

  double _calculateBlockDuration(TimeBlock block) {
    final startMinutes = block.startTime.hour * 60 + block.startTime.minute;
    final endMinutes = block.endTime.hour * 60 + block.endTime.minute;
    return (endMinutes - startMinutes) / 60.0;
  }

  double _timeToHour(TimeOfDay time) {
    return time.hour + (time.minute / 60.0);
  }

  String _formatTime(TimeOfDay time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }

  String _getWeekdayName(int weekday) {
    const weekdays = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday',
    ];
    return weekdays[weekday - 1];
  }

  String _getMonthName(int month) {
    const months = [
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
    return months[month - 1];
  }

  void _showAddBlockDialog(
    BuildContext context, [
    TimeOfDay? defaultStartTime,
  ]) {
    final titleController = TextEditingController();
    final descriptionController = TextEditingController();
    TimeOfDay startTime = defaultStartTime ?? TimeOfDay(hour: 9, minute: 0);
    TimeOfDay endTime = TimeOfDay(
      hour: (defaultStartTime?.hour ?? 9) + 1,
      minute: defaultStartTime?.minute ?? 0,
    );
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
          title: Text('Add Time Block', style: TextStyle(color: Colors.white)),
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

                // Time pickers
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () async {
                          final time = await showTimePicker(
                            context: context,
                            initialTime: startTime,
                            builder: (context, child) {
                              return Theme(
                                data: Theme.of(context).copyWith(
                                  timePickerTheme: TimePickerThemeData(
                                    backgroundColor: Color(0xFF1E1E1E),
                                    dialBackgroundColor: Color(0xFF2A2A2A),
                                    hourMinuteTextColor: Colors.white,
                                  ),
                                ),
                                child: child!,
                              );
                            },
                          );
                          if (time != null) {
                            setDialogState(() {
                              startTime = time;
                            });
                          }
                        },
                        child: Container(
                          padding: EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.white38),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(
                            children: [
                              Text(
                                'Start Time',
                                style: TextStyle(
                                  color: Colors.white54,
                                  fontSize: 12,
                                ),
                              ),
                              Text(
                                _formatTime(startTime),
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: GestureDetector(
                        onTap: () async {
                          final time = await showTimePicker(
                            context: context,
                            initialTime: endTime,
                            builder: (context, child) {
                              return Theme(
                                data: Theme.of(context).copyWith(
                                  timePickerTheme: TimePickerThemeData(
                                    backgroundColor: Color(0xFF1E1E1E),
                                    dialBackgroundColor: Color(0xFF2A2A2A),
                                    hourMinuteTextColor: Colors.white,
                                  ),
                                ),
                                child: child!,
                              );
                            },
                          );
                          if (time != null) {
                            setDialogState(() {
                              endTime = time;
                            });
                          }
                        },
                        child: Container(
                          padding: EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.white38),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(
                            children: [
                              Text(
                                'End Time',
                                style: TextStyle(
                                  color: Colors.white54,
                                  fontSize: 12,
                                ),
                              ),
                              Text(
                                _formatTime(endTime),
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 16),

                // Color picker
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
                    timeBlocks.add(
                      TimeBlock(
                        id: timeBlocks.length + 1,
                        startTime: startTime,
                        endTime: endTime,
                        title: titleController.text,
                        description: descriptionController.text,
                        color: selectedColor,
                        date: selectedDate,
                      ),
                    );
                  });
                  Navigator.pop(context);
                }
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
              child: Text('Add Block', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}
