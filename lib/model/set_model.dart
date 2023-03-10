class ProductSet {
  final String name;
  final int price;
  final List<SetItem> items;

  ProductSet({this.name, this.price, this.items});

  factory ProductSet.fromJson(Map<String, dynamic> json) {
    Map<String, dynamic> jsonData = json;
    List<Map<String, dynamic>> setList =
        jsonData['items'].cast<Map<String, dynamic>>();
    // print(setList);
    List<SetItem> setItemList =
        setList.map((setItem) => SetItem.fromJson(setItem)).toList();
    return ProductSet(
        name: jsonData['name'], price: jsonData['price'], items: setItemList);
  }

  Map<String, dynamic> toMap(ProductSet set) {
    return <String, dynamic>{
      'name': set.name,
      'price': set.price,
      'items': set.items.map((item) => SetItem().toMap(item)).toList(),
    };
  }
}

class SetItem {
  final String name;
  final int useAmount;

  SetItem({this.name, this.useAmount});

  factory SetItem.fromJson(Map<String, dynamic> json) {
    return SetItem(name: json['name'], useAmount: json['use_amount']);
  }

  Map<String, dynamic> toMap(SetItem setItem) {
    return <String, dynamic>{
      'name': setItem.name,
      'use_amount': setItem.useAmount,
    };
  }
}
