class MockData {
  static final List<Map<String, dynamic>> expenses = [
    {
      "id": 1,
      "title": "Groceries",
      "amount": 1250.0,
      "category": "Food",
      "date": "2024-03-15",
      "description": "Weekly grocery shopping",
      "paymentMethod": "Credit Card",
    },
    {
      "id": 2,
      "title": "Internet Bill",
      "amount": 899.0,
      "category": "Utilities",
      "date": "2024-03-10",
      "description": "Monthly internet subscription",
      "paymentMethod": "UPI",
    },
    {
      "id": 3,
      "title": "Dinner Out",
      "amount": 650.0,
      "category": "Dining",
      "date": "2024-03-12",
      "description": "Dinner with friends",
      "paymentMethod": "Cash",
    },
  ];

  static final List<Map<String, dynamic>> expenseCategories = [
    {
      "id": 1,
      "name": "Food",
      "icon": "local_grocery_store",
      "color": "FF4CAF50",
    },
    {
      "id": 2,
      "name": "Transport",
      "icon": "directions_car",
      "color": "FF2196F3",
    },
    {"id": 3, "name": "Utilities", "icon": "flash_on", "color": "FFFFC107"},
    {"id": 4, "name": "Shopping", "icon": "shopping_bag", "color": "FF9C27B0"},
    {"id": 5, "name": "Dining", "icon": "restaurant", "color": "FFE91E63"},
    {"id": 6, "name": "Entertainment", "icon": "movie", "color": "FF3F51B5"},
  ];

  static final List<Map<String, dynamic>> habits = [
    {
      "id": 1,
      "title": "Morning Run",
      "description": "30 minute run every morning",
      "streak": 12,
      "frequency": "Daily",
      "completionDays": [
        "2024-03-01",
        "2024-03-02",
        "2024-03-03",
        "2024-03-05",
        "2024-03-07",
      ],
      "color": "FF4CAF50",
    },
    {
      "id": 2,
      "title": "Read Book",
      "description": "Read 20 pages daily",
      "streak": 7,
      "frequency": "Daily",
      "completionDays": [
        "2024-03-10",
        "2024-03-11",
        "2024-03-12",
        "2024-03-13",
      ],
      "color": "FF2196F3",
    },
    {
      "id": 3,
      "title": "Meditation",
      "description": "10 minute meditation",
      "streak": 5,
      "frequency": "Weekdays",
      "completionDays": ["2024-03-12", "2024-03-13", "2024-03-14"],
      "color": "FF9C27B0",
    },
  ];

  static final List<Map<String, dynamic>> monthlyExpenseSummary = [
    {"month": "Jan", "amount": 12500.0},
    {"month": "Feb", "amount": 10850.0},
    {"month": "Mar", "amount": 7850.0},
  ];

  static final Map<String, dynamic> expenseStats = {
    "total": 31200.0,
    "average": 10400.0,
    "highestCategory": "Food",
    "highestAmount": 12500.0,
  };
}
