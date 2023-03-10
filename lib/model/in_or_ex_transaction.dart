import 'package:cloud_firestore/cloud_firestore.dart';

class InOrExTransaction {
  final String id;
  final String name;
  final int amount;
  final String note;
  final String inCategory;
  final String exCategory;
  final tranType;
  final inOrEx;
  final DateTime date;

  InOrExTransaction(
      {this.id,
      this.name,
      this.amount,
      this.inCategory,
      this.exCategory,
      this.tranType,
      this.inOrEx,
      this.note,
      this.date});

  factory InOrExTransaction.fromJson(QueryDocumentSnapshot json) {
    Map<String, dynamic> jsonData = json.data();
    return InOrExTransaction(
      id: json.id,
      name: jsonData['name'],
      note: jsonData['note'],
      amount: jsonData['amount'],
      inCategory: jsonData['inCategory'],
      exCategory: jsonData['exCategory'],
      tranType: jsonData['tranType'],
      inOrEx: jsonData['inOrEx'],
      date: DateTime.parse(jsonData['date'].toDate().toString()),
    );
  }

  Map<String, dynamic> toJson(InOrExTransaction tran) {
    return <String, dynamic>{
      'name': tran.name,
      'amount': tran.amount,
      'note': tran.note,
      'tranType': tran.tranType,
      'inCategory': tran.inCategory,
      'exCategory': tran.exCategory,
      'inOrEx': tran.inOrEx,
      'date': tran.date,
    };
  }
}
