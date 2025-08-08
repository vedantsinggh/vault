class Expense {
  final int id;
  final String title;
  final double amount;
  final String category;
  final DateTime date;
  final String description;
  final String paymentMethod;

  Expense({
    required this.id,
    required this.title,
    required this.amount,
    required this.category,
    required this.date,
    required this.description,
    required this.paymentMethod,
  });

  factory Expense.fromJson(Map<String, dynamic> json) {
    return Expense(
      id: json['id'],
      title: json['title'],
      amount: json['amount'].toDouble(),
      category: json['category'],
      date: DateTime.parse(json['date']),
      description: json['description'] ?? '',
      paymentMethod: json['payment_method'],
    );
  }
}
