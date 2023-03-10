import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ybf_sample_version_2/model/expense.dart';
import 'package:ybf_sample_version_2/model/income.dart';
import '../model/app_profile.dart';
import '../provider/transaction_provider.dart';
import 'package:provider/provider.dart';
import '../model/set_model.dart';
import '../model/set_transaction.dart';
import '../model/stock.dart';
import '../model/stock_transaction.dart';
import 'package:flutter/material.dart';

class AllProvider with ChangeNotifier {
  CollectionReference allCollection =
      FirebaseFirestore.instance.collection('all');
  AppProfile _appProfile;
  AppProfile get appProfile => _appProfile;
  List<Stock> _allStockList = [];
  List<Stock> get allStocks => [..._allStockList];
  List<ProductSet> _allSetList = [];
  List<ProductSet> get allSets => [..._allSetList];
  List<String> _allShopList = [];
  List<String> get allShop => [..._allShopList];
  List<Expense> _allExpenseList = [];
  List<Expense> get allExpense => [..._allExpenseList];
  List<Income> _allIncomeList = [];
  List<Income> get allIncome => [..._allIncomeList];
  List<String> _inCategoryList = [];
  List<String> get inCategoryList => [..._inCategoryList];
  List<String> _exCategoryList = [];
  List<String> get exCategoryList => [..._exCategoryList];

  void addAllOfAll(QuerySnapshot snapshots) {
    final profile = snapshots.docs
        .firstWhere((doc) => doc.id == 'appProfile', orElse: () => null);
    if (profile != null) {
      _appProfile = AppProfile.fromJson(profile);
    }

    final stockList = snapshots.docs
        .firstWhere((doc) => doc.id == 'stockList', orElse: () => null);
    if (stockList != null) {
      Map<String, dynamic> stockLi = stockList.data();
      final list =
          stockLi['stockList'].map((stock) => Stock.fromJson(stock)).toList();
      _allStockList = list.cast<Stock>();
    }

    final setList = snapshots.docs
        .firstWhere((doc) => doc.id == 'sets', orElse: () => null);
    if (setList != null) {
      Map<String, dynamic> setLi = setList.data();
      final setLists =
          setLi['setList'].map((set) => ProductSet.fromJson(set)).toList();
      _allSetList = setLists.cast<ProductSet>();
    }

    final shopList = snapshots.docs
        .firstWhere((doc) => doc.id == 'shopList', orElse: () => null);
    if (shopList != null) {
      Map<String, dynamic> shopLi = shopList.data();
      final shopLists = shopLi['shopList'];
      _allShopList = shopLists.cast<String>();
    }

    final expNameListDoc = snapshots.docs
        .firstWhere((doc) => doc.id == 'expNameList', orElse: () => null);
    if (expNameListDoc != null) {
      Map<String, dynamic> expNameLi = expNameListDoc.data();
      final expNameLists = expNameLi['expNameList']
          .map((expense) => Expense.fromJson(expense))
          .toList();
      _allExpenseList = expNameLists.cast<Expense>();
    }

    final inNameListDoc = snapshots.docs
        .firstWhere((doc) => doc.id == 'inNameList', orElse: () => null);
    if (inNameListDoc != null) {
      Map<String, dynamic> inNameLi = inNameListDoc.data();
      final inNameLists = inNameLi['inNameList']
          .map((income) => Income.fromJson(income))
          .toList();
      _allIncomeList = inNameLists.cast<Income>();
    }

    final inCategoryList = snapshots.docs
        .firstWhere((doc) => doc.id == 'inCategoryList', orElse: () => null);
    if (inCategoryList != null) {
      Map<String, dynamic> inCategoryLi = inCategoryList.data();
      final inCategoryLists = inCategoryLi['inCategoryList'];
      _inCategoryList = inCategoryLists.cast<String>();
    }

    final exCategoryList = snapshots.docs
        .firstWhere((doc) => doc.id == 'exCategoryList', orElse: () => null);
    if (exCategoryList != null) {
      Map<String, dynamic> exCategoryLi = exCategoryList.data();
      final exCategoryLists = exCategoryLi['exCategoryList'];
      _exCategoryList = exCategoryLists.cast<String>();
    }

    notifyListeners();
  }

  Future<void> addNewStock(Stock sto) async {
    if (_allStockList.any((stock) => stock.name == sto.name)) {
      _allStockList.removeWhere((stock) => stock.name == sto.name);
    }
    _allStockList.add(sto);
    await allCollection.doc('stockList').set(
        {'stockList': _allStockList.map((sto) => sto.toJson(sto)).toList()});
    notifyListeners();
  }

  List<Map<String, String>> setNamesAndPrices() {
    List<Map<String, String>> setNames = [];
    _allSetList.map((set) {
      setNames.add({
        'name': set.name,
        'price': set.price.toString(),
      });
    }).toList();
    return setNames;
  }

  List<Map<String, dynamic>> stockNamesAndUnits() {
    List<Map<String, dynamic>> stockNames = [];
    _allStockList.map((stock) {
      stockNames.add({
        'name': stock.name,
        'stockUnit': stock.unitForStock,
        'useUnit': stock.unitForUse,
        'unitRatio': stock.stockRatio,
        'price': stock.price,
      });
    }).toList();
    return stockNames;
  }

  Future<void> addOrSubFromStockBySetTran(
      {List<SetTransactionItem> items,
      DateTime date,
      bool isAdd,
      bool reAdd}) async {
    List<StockTransactionItem> stockItems = [];
    items.forEach((item) {
      var set = _allSetList.firstWhere((set) => set.name == item.name);
      set.items.forEach((setItem) {
        var stockItem =
            _allStockList.firstWhere((stock) => stock.name == setItem.name);
        _allStockList.removeWhere((stock) => stock.name == setItem.name);
        Stock newSt = Stock(
          name: stockItem.name,
          unitForUse: stockItem.unitForUse,
          unitForStock: stockItem.unitForStock,
          stockRatio: stockItem.stockRatio,
          limitAmount: stockItem.limitAmount,
          price: stockItem.price,
          curAmount: isAdd
              ? (stockItem.curAmount + (item.num * setItem.useAmount))
              : (stockItem.curAmount - (item.num * setItem.useAmount)),
        );
        _allStockList.add(newSt);
        stockItems.add(StockTransactionItem(
          name: stockItem.name,
          num: (item.num * setItem.useAmount),
          price: 0,
          stockUnit: stockItem.unitForStock,
          useUnit: stockItem.unitForUse,
          unitRatio: stockItem.stockRatio.toString(),
          unit: stockItem.unitForUse,
          total: 0,
        ));
      });
    });
    allCollection.doc('stockList').update({
      'stockList': _allStockList.map((stock) => Stock().toJson(stock)).toList()
    });
    await TransactionProvider().addStock(
        stockItems: stockItems, isAdd: isAdd, date: date, isReAdd: reAdd);
  }

  Future<void> addToStockByStockTran(
      {List<StockTransactionItem> items, bool isAdd}) async {
    items.forEach((item) {
      var stockItem =
          _allStockList.firstWhere((stock) => stock.name == item.name);
      _allStockList.removeWhere((stock) => stock.name == item.name);
      int amount = item.num;
      if (item.unit == stockItem.unitForStock) {
        amount = amount * stockItem.stockRatio;
      }
      Stock newSt = Stock(
        name: stockItem.name,
        unitForUse: stockItem.unitForUse,
        unitForStock: stockItem.unitForStock,
        stockRatio: stockItem.stockRatio,
        limitAmount: stockItem.limitAmount,
        price: stockItem.price,
        curAmount: isAdd
            ? (stockItem.curAmount + amount)
            : (stockItem.curAmount - amount),
      );
      _allStockList.add(newSt);
    });
    await allCollection.doc('stockList').update({
      'stockList': _allStockList.map((stock) => Stock().toJson(stock)).toList()
    });
  }

  Future<void> deleteStock(Stock sto) async {
    _allStockList.removeWhere((stock) => stock == sto);
    await allCollection.doc('stockList').update(
        {'stockList': _allStockList.map((sto) => sto.toJson(sto)).toList()});
    _allSetList.forEach((set) {
      set.items.removeWhere((item) => item.name == sto.name);
    });
    await allCollection.doc('sets').update({
      'setList': _allSetList.map((set) => ProductSet().toMap(set)).toList(),
    });
    notifyListeners();
  }

  Future<void> addOrEditShopNames({String oldName, String newName}) async {
    if (oldName != null) {
      int ind = _allShopList.indexOf(oldName);
      _allShopList.removeWhere((name) => name == oldName);
      _allShopList.insert(ind, newName);
    } else {
      _allShopList.add(newName);
    }
    if (oldName == null && _allShopList.length == 1) {
      await allCollection.doc('shopList').set({'shopList': _allShopList});
    } else {
      await allCollection.doc('shopList').update({'shopList': _allShopList});
    }

    notifyListeners();
  }

  Future<void> addOrEditExpNames(
      {Expense oldExpense, Expense newExpense}) async {
    if (oldExpense != null) {
      int ind = _allExpenseList.indexOf(oldExpense);
      _allExpenseList.removeWhere((name) => name == oldExpense);
      _allExpenseList.insert(ind, newExpense);
    } else {
      _allExpenseList.add(newExpense);
    }

    if (oldExpense == null && _allExpenseList.length == 1) {
      await allCollection.doc('expNameList').set({
        'expNameList':
            _allExpenseList.map((exp) => Expense().toJson(exp)).toList()
      });
    } else {
      await allCollection.doc('expNameList').update({
        'expNameList':
            _allExpenseList.map((exp) => Expense().toJson(exp)).toList()
      });
    }
    notifyListeners();
  }

  Future<void> addOrEditInNames({Income oldIncome, Income newIncome}) async {
    if (oldIncome != null) {
      int ind = _allIncomeList.indexOf(oldIncome);
      _allIncomeList.removeWhere((income) => income == oldIncome);
      _allIncomeList.insert(ind, newIncome);
    } else {
      _allIncomeList.add(newIncome);
    }
    if (oldIncome == null && _allIncomeList.length == 1) {
      await allCollection.doc('inNameList').set({
        'inNameList':
            _allIncomeList.map((income) => Income().toJson(income)).toList()
      });
    } else {
      await allCollection.doc('inNameList').update({
        'inNameList':
            _allIncomeList.map((income) => Income().toJson(income)).toList()
      });
    }
    notifyListeners();
  }

  Future<void> addOrEditInCategoryNames(
      {String oldName, String newName}) async {
    if (oldName != null) {
      int ind = _inCategoryList.indexOf(oldName);
      _inCategoryList.removeWhere((name) => name == oldName);
      _inCategoryList.insert(ind, newName);
    } else {
      _inCategoryList.add(newName);
    }

    if (oldName == null && _inCategoryList.length == 1) {
      await allCollection
          .doc('inCategoryList')
          .set({'inCategoryList': _inCategoryList});
    } else {
      await allCollection
          .doc('inCategoryList')
          .update({'inCategoryList': _inCategoryList});
    }
    notifyListeners();
  }

  Future<void> addOrEditExCategoryNames(
      {String oldName, String newName}) async {
    if (oldName != null) {
      int ind = _exCategoryList.indexOf(oldName);
      _exCategoryList.removeWhere((name) => name == oldName);
      _exCategoryList.insert(ind, newName);
    } else {
      _exCategoryList.add(newName);
    }

    if (oldName == null && _exCategoryList.length == 1) {
      await allCollection
          .doc('exCategoryList')
          .set({'exCategoryList': _exCategoryList});
    } else {
      await allCollection
          .doc('exCategoryList')
          .update({'exCategoryList': _exCategoryList});
    }
    notifyListeners();
  }

  Future<void> deleteShopName({String shopName}) async {
    _allShopList.removeWhere((name) => name == shopName);
    await allCollection.doc('shopList').update({'shopList': _allShopList});
    notifyListeners();
  }

  Future<void> deleteExpName({String expName}) async {
    _allExpenseList.removeWhere((exp) => exp.name == expName);
    await allCollection
        .doc('expNameList')
        .update({'expNameList': _allExpenseList});
    notifyListeners();
  }

  Future<void> deleteInName({String inName}) async {
    _allIncomeList.removeWhere((income) => income.name == inName);
    await allCollection.doc('inNameList').update({
      'inNameList':
          _allIncomeList.map((income) => Income().toJson(income)).toList()
    });
    notifyListeners();
  }

  Future<void> deleteInCategoryName({String inCategoryName}) async {
    List<Income> incList = [];
    WriteBatch batch = FirebaseFirestore.instance.batch();
    _inCategoryList.removeWhere((name) => name == inCategoryName);

    _allIncomeList.forEach((income) {
      if (income.category == inCategoryName) {
        incList.add(Income(name: income.name));
      } else {
        incList.add(income);
      }
    });
    _allIncomeList = incList;
    batch.update(allCollection.doc('inCategoryList'),
        {'inCategoryList': _inCategoryList});
    // await allCollection
    //     .doc('inCategoryList')
    //     .update({'inCategoryList': _inCategoryList});

    batch.update(allCollection.doc('inNameList'), {
      'inNameList':
          _allIncomeList.map((income) => Income().toJson(income)).toList()
    });
    // await allCollection.doc('inNameList').update({
    //   'inNameList':
    //       _allIncomeList.map((income) => Income().toJson(income)).toList()
    // });
    await batch.commit();
    notifyListeners();
  }

  Future<void> deleteExCategoryName({String exCategoryName}) async {
    List<Expense> expList = [];
    WriteBatch batch = FirebaseFirestore.instance.batch();
    _exCategoryList.removeWhere((name) => name == exCategoryName);

    _allExpenseList.forEach((expense) {
      if (expense.category == exCategoryName) {
        expList.add(Expense(name: expense.name));
      } else {
        expList.add(expense);
      }
    });
    _allExpenseList = expList;
    batch.update(allCollection.doc('exCategoryList'),
        {'exCategoryList': _exCategoryList});
    batch.update(allCollection.doc('expNameList'), {
      'expNameList':
          _allExpenseList.map((expense) => Expense().toJson(expense)).toList()
    });
    await batch.commit();
    notifyListeners();
  }

  Future<void> addOrEditSet({ProductSet setItem, bool isEdit}) async {
    if (isEdit) {
      int ind = _allSetList.indexWhere((set) => set.name == setItem.name);
      _allSetList.removeWhere((set) => set.name == setItem.name);
      _allSetList.insert(ind, setItem);
    } else {
      _allSetList.add(setItem);
    }

    if (!isEdit && _allSetList.length == 1) {
      await allCollection.doc('sets').set({
        'setList': _allSetList.map((set) => ProductSet().toMap(set)).toList(),
      });
    } else {
      await allCollection.doc('sets').update({
        'setList': _allSetList.map((set) => ProductSet().toMap(set)).toList(),
      });
    }

    notifyListeners();
  }

  Future<void> deleteSet({String setName}) async {
    _allSetList.removeWhere((set) => set.name == setName);
    await allCollection.doc('sets').update({
      'setList': _allSetList.map((set) => ProductSet().toMap(set)).toList(),
    });
    notifyListeners();
  }

  List<Stock> runningOutStocks() {
    List<Stock> stList = [];
    stList = _allStockList;
    stList.sort((a, b) =>
        (a.curAmount / a.limitAmount).compareTo(b.curAmount / b.limitAmount));
    // _allStockList.forEach((stock) {
    //   if ((int.parse(stock.curAmount) / int.parse(stock.limitAmount)) <= 2) {
    //     stList.add(stock);
    //   }
    // });
    return stList;
  }
}
