import 'package:cloud_firestore/cloud_firestore.dart';

class SetTransaction {
  final String id;
  final String tranType;
  final String shop;
  final int total;
  final List<SetTransactionItem> setItems;
  final DateTime date;

  SetTransaction(
      {this.id,
      this.total,
      this.setItems,
      this.tranType,
      this.shop,
      this.date});

  factory SetTransaction.fromJson(QueryDocumentSnapshot json) {
    Map<String, dynamic> jsonData = json.data();
    List<Map<String, dynamic>> setItemList =
        jsonData['setItems'].cast<Map<String, dynamic>>();
    List<SetTransactionItem> setItems = setItemList
        .map((setItem) => SetTransactionItem.fromJson(setItem))
        .toList();
    return SetTransaction(
      id: json.id,
      tranType: jsonData['tranType'],
      shop: jsonData['shop'],
      setItems: setItems,
      total: jsonData['total'],
      date: DateTime.parse(jsonData['date'].toDate().toString()),
    );
  }

  Map<String, dynamic> toJson(SetTransaction tran) {
    return <String, dynamic>{
      'tranType': tran.tranType,
      'shop': tran.shop,
      'setItems': tran.setItems
          .map((setItem) => SetTransactionItem().toJson(setItem))
          .toList(),
      'total': tran.total,
      'date': tran.date,
    };
  }
}

class SetTransactionItem {
  final String name;
  final int num;
  final int price;

  SetTransactionItem({this.name, this.num, this.price});

  factory SetTransactionItem.fromJson(Map<String, dynamic> json) {
    return SetTransactionItem(
        name: json['name'], num: json['num'], price: json['price']);
  }

  Map<String, dynamic> toJson(SetTransactionItem item) {
    return <String, dynamic>{
      'name': item.name,
      'num': item.num,
      'price': item.price,
    };
  }
}
