import 'package:cloud_firestore/cloud_firestore.dart';

class StockTransaction {
  final String id;
  final String tranType;
  final DateTime date;
  final String addOrSub;
  final List<StockTransactionItem> stockItems;

  StockTransaction(
      {this.id, this.tranType, this.addOrSub, this.date, this.stockItems});

  factory StockTransaction.fromJson(QueryDocumentSnapshot json) {
    Map<String, dynamic> jsonData = json.data();
    List<Map<String, dynamic>> stockItemList =
        jsonData['stockItems'].cast<Map<String, dynamic>>();
    List<StockTransactionItem> stockItems = stockItemList
        .map((stockItem) => StockTransactionItem.fromJson(stockItem))
        .toList();
    return StockTransaction(
      id: json.id,
      tranType: jsonData['tranType'],
      stockItems: stockItems,
      addOrSub: jsonData['addOrSub'],
      date: DateTime.parse(jsonData['date'].toDate().toString()),
    );
  }

  Map<String, dynamic> toJson(StockTransaction stockTran) {
    return <String, dynamic>{
      'tranType': stockTran.tranType,
      'addOrSub': stockTran.addOrSub,
      'stockItems': stockTran.stockItems
          .map((item) => StockTransactionItem().toJson(item))
          .toList(),
      'date': stockTran.date,
    };
  }
}

class StockTransactionItem {
  final String name;
  final int num;
  final int price;
  final int total;
  final String unit;
  final String stockUnit;
  final String useUnit;
  final String unitRatio;

  StockTransactionItem(
      {this.name,
      this.num,
      this.price,
      this.total,
      this.unit,
      this.stockUnit,
      this.useUnit,
      this.unitRatio});

  factory StockTransactionItem.fromJson(Map<String, dynamic> json) {
    return StockTransactionItem(
      name: json['name'],
      num: json['num'],
      price: json['price'],
      total: json['total'],
      unit: json['unit'],
      stockUnit: json['stockUnit'],
      useUnit: json['useUnit'],
      unitRatio: json['unitRatio'],
    );
  }

  Map<String, dynamic> toJson(StockTransactionItem item) {
    return <String, dynamic>{
      'name': item.name,
      'num': item.num,
      'price': item.price,
      'total': item.total,
      'unit': item.unit,
      'stockUnit': item.stockUnit,
      'useUnit': item.useUnit,
      'unitRatio': item.unitRatio,
    };
  }
}
