class Income {
  final String name;
  final String category;

  Income({this.name, this.category});

  factory Income.fromJson(Map<String, dynamic> json) {
    Map<String, dynamic> jsonData = json;
    return Income(
      name: jsonData['name'],
      category: jsonData['category'],
    );
  }

  Map<String, dynamic> toJson(Income income) {
    return <String, dynamic>{
      'name': income.name,
      'category': income.category,
    };
  }
}
