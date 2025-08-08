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
