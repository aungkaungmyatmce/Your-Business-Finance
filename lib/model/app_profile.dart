import 'package:cloud_firestore/cloud_firestore.dart';

class AppProfile {
  final String productId;
  final String appVersion;
  final String userName;
  final DateTime expireDate;

  AppProfile({this.productId, this.appVersion, this.userName, this.expireDate});

  factory AppProfile.fromJson(QueryDocumentSnapshot json) {
    Map<String, dynamic> jsonData = json.data();
    return AppProfile(
      productId: jsonData['productId'],
      appVersion: jsonData['appVersion'],
      userName: jsonData['userName'],
      expireDate: DateTime.parse(jsonData['expireDate'].toDate().toString()),
    );
  }
}
