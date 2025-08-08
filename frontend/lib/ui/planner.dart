import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as material;
import '../api_service.dart';
import '../models/timeblock.dart';

class PlannerScreen extends StatefulWidget {
  @override
  _PlannerScreenState createState() => _PlannerScreenState();
}

class _PlannerScreenState extends State<PlannerScreen> {
  DateTime selectedDate = DateTime.now();
  List<TimeBlock> timeBlocks = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadTimeBlocks();
  }

  Future<void> _loadTimeBlocks() async {
    try {
      final dateStr =
          "${selectedDate.year}-${selectedDate.month.toString().padLeft(2, '0')}-${selectedDate.day.toString().padLeft(2, '0')}";
      final response = await ApiService.get('timeblocks/?date=$dateStr');
      setState(() {
        timeBlocks = (response as List)
            .map((t) => TimeBlock.fromJson(t))
            .toList();
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        material.SnackBar(content: Text('Failed to load time blocks: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return material.SafeArea(
      child: Column(
        children: [
          material.Padding(
            padding: material.EdgeInsets.all(20),
            child: material.Row(
              mainAxisAlignment: material.MainAxisAlignment.spaceBetween,
              children: [
                material.Text(
                  'Day Planner',
                  style: Theme.of(
                    context,
                  ).textTheme.headlineLarge?.copyWith(fontSize: 28),
                ),
                material.Row(
                  children: [
                    _buildIconButton(material.Icons.filter_list),
                    material.SizedBox(width: 8),
                    _buildIconButton(
                      material.Icons.add,
                      onPressed: _showAddBlockDialog,
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Date Selector
          material.Container(
            margin: material.EdgeInsets.symmetric(horizontal: 20),
            padding: material.EdgeInsets.all(16),
            decoration: material.BoxDecoration(
              color: material.Color(0xFF1E1E1E),
              borderRadius: material.BorderRadius.circular(16),
            ),
            child: material.Row(
              mainAxisAlignment: material.MainAxisAlignment.spaceBetween,
              children: [
                material.IconButton(
                  onPressed: () => setState(() {
                    selectedDate = selectedDate.subtract(
                      const Duration(days: 1),
                    );
                    _loadTimeBlocks();
                  }),
                  icon: material.Icon(
                    material.Icons.chevron_left,
                    color: material.Colors.white70,
                  ),
                ),
                material.Column(
                  children: [
                    material.Text(
                      _getWeekdayName(selectedDate.weekday),
                      style: material.TextStyle(
                        color: material.Colors.white54,
                        fontSize: 14,
                      ),
                    ),
                    material.Text(
                      '${selectedDate.day} ${_getMonthName(selectedDate.month)}',
                      style: material.TextStyle(
                        color: material.Colors.white,
                        fontSize: 20,
                        fontWeight: material.FontWeight.bold,
                      ),
                    ),
                    material.Text(
                      selectedDate.year.toString(),
                      style: material.TextStyle(
                        color: material.Colors.white54,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                material.IconButton(
                  onPressed: () => setState(() {
                    selectedDate = selectedDate.add(Duration(days: 1));
                    _loadTimeBlocks();
                  }),
                  icon: material.Icon(
                    material.Icons.chevron_right,
                    color: material.Colors.white70,
                  ),
                ),
              ],
            ),
          ),

          material.SizedBox(height: 20),

          // Stats Row
          material.Padding(
            padding: material.EdgeInsets.symmetric(horizontal: 20),
            child: material.Row(
              children: [
                material.Expanded(
                  child: _buildStatCard(
                    'Blocks',
                    timeBlocks.length.toString(),
                    'scheduled',
                    material.Colors.blue,
                  ),
                ),
                material.SizedBox(width: 12),
                material.Expanded(
                  child: _buildStatCard(
                    'Hours',
                    _calculateTotalHours(timeBlocks).toStringAsFixed(1),
                    'planned',
                    material.Colors.green,
                  ),
                ),
                material.SizedBox(width: 12),
                material.Expanded(
                  child: _buildStatCard(
                    'Free',
                    (24 - _calculateTotalHours(timeBlocks)).toStringAsFixed(1),
                    'hours left',
                    material.Colors.orange,
                  ),
                ),
              ],
            ),
          ),

          material.SizedBox(height: 20),

          // Time Blocks List
          material.Expanded(
            child: material.Container(
              margin: material.EdgeInsets.symmetric(horizontal: 20),
              padding: material.EdgeInsets.all(16),
              decoration: material.BoxDecoration(
                color: material.Color(0xFF1E1E1E),
                borderRadius: material.BorderRadius.circular(16),
              ),
              child: material.Column(
                crossAxisAlignment: material.CrossAxisAlignment.start,
                children: [
                  material.Text(
                    "Today's Schedule",
                    style: material.TextStyle(
                      color: material.Colors.white,
                      fontSize: 18,
                      fontWeight: material.FontWeight.w600,
                    ),
                  ),
                  material.SizedBox(height: 16),
                  material.Expanded(
                    child: _isLoading
                        ? material.Center(
                            child: material.CircularProgressIndicator(),
                          )
                        : _buildTimelineView(timeBlocks),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimelineView(List<TimeBlock> blocks) {
    return material.ListView.builder(
      itemCount: 24, // 24 hours
      itemBuilder: (context, hour) {
        final currentHour = hour;
        final blocksAtThisHour = blocks
            .where(
              (block) =>
                  block.startTime.hour <= currentHour &&
                  block.endTime.hour > currentHour,
            )
            .toList();

        return material.Container(
          height: 60,
          child: material.Row(
            children: [
              material.SizedBox(
                width: 60,
                child: material.Text(
                  '${currentHour.toString().padLeft(2, '0')}:00',
                  style: material.TextStyle(
                    color: material.Colors.white54,
                    fontSize: 12,
                    fontWeight: material.FontWeight.w500,
                  ),
                ),
              ),
              material.Container(
                width: 2,
                height: 60,
                color: material.Colors.white12,
                margin: material.EdgeInsets.symmetric(horizontal: 12),
              ),
              material.Expanded(
                child: blocksAtThisHour.isEmpty
                    ? material.GestureDetector(
                        onTap: () => _showAddBlockDialog(
                          material.TimeOfDay(hour: currentHour, minute: 0),
                        ),
                        child: material.Container(
                          height: 50,
                          decoration: material.BoxDecoration(
                            color: material.Colors.transparent,
                            borderRadius: material.BorderRadius.circular(8),
                            border: material.Border.all(
                              color: material.Colors.white12,
                              style: material.BorderStyle.solid,
                            ),
                          ),
                          child: material.Center(
                            child: material.Text(
                              'Tap to add block',
                              style: material.TextStyle(
                                color: material.Colors.white38,
                                fontSize: 11,
                              ),
                            ),
                          ),
                        ),
                      )
                    : material.Column(
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
    final color = material.Color(
      int.parse(block.color.replaceFirst('#', '0xFF')),
    );

    return material.Container(
      height: 50,
      margin: material.EdgeInsets.only(bottom: 4),
      padding: material.EdgeInsets.all(12),
      decoration: material.BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: material.BorderRadius.circular(8),
        border: material.Border.all(color: color.withOpacity(0.5), width: 1),
      ),
      child: material.Row(
        children: [
          material.Container(
            width: 4,
            height: 30,
            decoration: material.BoxDecoration(
              color: color,
              borderRadius: material.BorderRadius.circular(2),
            ),
          ),
          material.SizedBox(width: 12),
          material.Expanded(
            child: material.Column(
              crossAxisAlignment: material.CrossAxisAlignment.start,
              mainAxisAlignment: material.MainAxisAlignment.center,
              children: [
                material.Text(
                  block.title,
                  style: material.TextStyle(
                    color: material.Colors.white,
                    fontSize: 14,
                    fontWeight: material.FontWeight.w600,
                  ),
                  overflow: material.TextOverflow.ellipsis,
                ),
                if (block.description.isNotEmpty)
                  material.Text(
                    block.description,
                    style: material.TextStyle(
                      color: material.Colors.white70,
                      fontSize: 11,
                    ),
                    overflow: material.TextOverflow.ellipsis,
                  ),
              ],
            ),
          ),
          material.Text(
            '${_formatTime(block.startTime)} - ${_formatTime(block.endTime)}',
            style: material.TextStyle(
              color: material.Colors.white54,
              fontSize: 10,
            ),
          ),
          material.SizedBox(width: 8),
          material.GestureDetector(
            onTap: () => _deleteTimeBlock(block),
            child: material.Icon(
              material.Icons.close,
              color: material.Colors.white54,
              size: 16,
            ),
          ),
        ],
      ),
    );
  }

  double _calculateTotalHours(List<TimeBlock> blocks) {
    double total = 0;
    for (var block in blocks) {
      total +=
          (block.endTime.hour - block.startTime.hour) +
          (block.endTime.minute - block.startTime.minute) / 60;
    }
    return total;
  }

  String _formatTime(DateTime time) {
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

  Widget _buildStatCard(
    String title,
    String value,
    String subtitle,
    material.Color color,
  ) {
    return material.Container(
      padding: material.EdgeInsets.all(16),
      decoration: material.BoxDecoration(
        color: material.Color(0xFF1E1E1E),
        borderRadius: material.BorderRadius.circular(12),
      ),
      child: material.Column(
        crossAxisAlignment: material.CrossAxisAlignment.center,
        children: [
          material.Text(
            title,
            style: material.TextStyle(
              color: material.Colors.white54,
              fontSize: 12,
            ),
          ),
          material.SizedBox(height: 8),
          material.Text(
            value,
            style: material.TextStyle(
              color: color,
              fontSize: 24,
              fontWeight: material.FontWeight.bold,
            ),
          ),
          material.Text(
            subtitle,
            style: material.TextStyle(
              color: material.Colors.white38,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIconButton(
    material.IconData icon, {
    material.VoidCallback? onPressed,
  }) {
    return material.IconButton(
      onPressed: onPressed,
      icon: material.Icon(icon, color: material.Colors.white70),
      style: material.IconButton.styleFrom(
        backgroundColor: material.Color(0xFF2A2A2A),
        fixedSize: material.Size(48, 48),
      ),
    );
  }

  Future<void> _deleteTimeBlock(TimeBlock block) async {
    try {
      await ApiService.delete('timeblocks/${block.id}');
      setState(() {
        timeBlocks.remove(block);
      });
    } catch (e) {
      material.ScaffoldMessenger.of(context).showSnackBar(
        material.SnackBar(
          content: material.Text('Failed to delete time block: $e'),
        ),
      );
    }
  }

  void _showAddBlockDialog([material.TimeOfDay? defaultStartTime]) {
    // Implement time block creation dialog
  }
}
