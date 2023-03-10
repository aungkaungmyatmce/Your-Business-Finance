class Stock {
  final String name;
  final String unitForStock;
  final String unitForUse;
  final int stockRatio;
  final int curAmount;
  final int limitAmount;
  final int price;

  Stock({
    this.name,
    this.unitForStock,
    this.unitForUse,
    this.stockRatio,
    this.curAmount,
    this.limitAmount,
    this.price,
  });

  factory Stock.fromJson(Map<String, dynamic> json) {
    Map<String, dynamic> jsonData = json;
    return Stock(
      name: jsonData['name'],
      unitForStock: jsonData['unit_for_stock'],
      unitForUse: jsonData['unit_for_use'],
      curAmount: jsonData['cur_amount'],
      limitAmount: jsonData['limit_amount'],
      stockRatio: jsonData['stock_ratio'],
      price: jsonData['price'],
    );
  }

  Map<String, dynamic> toJson(Stock sto) {
    return <String, dynamic>{
      'name': sto.name,
      'unit_for_stock': sto.unitForStock,
      'unit_for_use': sto.unitForUse,
      'stock_ratio': sto.stockRatio,
      'cur_amount': sto.curAmount,
      'limit_amount': sto.limitAmount,
      'price': sto.price,
    };
  }
}
