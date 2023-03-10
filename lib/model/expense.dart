class Expense {
  final String name;
  final String category;

  Expense({this.name, this.category});

  factory Expense.fromJson(Map<String, dynamic> json) {
    Map<String, dynamic> jsonData = json;
    return Expense(
      name: jsonData['name'],
      category: jsonData['category'],
    );
  }

  Map<String, dynamic> toJson(Expense expense) {
    return <String, dynamic>{
      'name': expense.name,
      'category': expense.category,
    };
  }
}
