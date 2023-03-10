import 'package:cloud_firestore/cloud_firestore.dart' hide Transaction;
import '../model/in_or_ex_transaction.dart';
import '../model/set_transaction.dart';
import '../model/stock_transaction.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TransactionProvider with ChangeNotifier {
  CollectionReference transactionCollection =
      FirebaseFirestore.instance.collection('allTransactions');
  List<SetTransaction> _setTransactionList = [];
  List<SetTransaction> get setTransactions => [..._setTransactionList];

  List<StockTransaction> _stockTransactionList = [];
  List<StockTransaction> get stockTransactions => [..._stockTransactionList];

  List<InOrExTransaction> _inOrExTransactionList = [];
  List<InOrExTransaction> get inOrExTransactions => [..._inOrExTransactionList];

  void addAllTransactions(QuerySnapshot snapshots) {
    List docList = snapshots.docs;
    _setTransactionList = [];
    _stockTransactionList = [];
    _inOrExTransactionList = [];

    docList.map((doc) {
      Map<String, dynamic> docData = doc.data();
      if (docData['tranType'] == 'set') {
        _setTransactionList.add(SetTransaction.fromJson(doc));
      }
      if (docData['tranType'] == 'stock') {
        _stockTransactionList.add(StockTransaction.fromJson(doc));
      }
      if (docData['tranType'] == 'inOrEx') {
        _inOrExTransactionList.add(InOrExTransaction.fromJson(doc));
      }
    }).toList();
    //print(_stockTransactionList);
    notifyListeners();
  }

  List<Map<String, dynamic>> allTransactionsForOneMon(
      {DateTime date,
      String shopName,
      String incomeCategory,
      String expenseCategory}) {
    List<SetTransaction> setTranList = [];
    setTranList = _setTransactionList;
    if (shopName != null && shopName != 'All Shop') {
      setTranList =
          _setTransactionList.where((tran) => tran.shop == shopName).toList();
    }

    List<InOrExTransaction> inTranList =
        _inOrExTransactionList.where((tran) => tran.inOrEx == 'in').toList();
    if (incomeCategory != null && incomeCategory != 'All Category') {
      inTranList = _inOrExTransactionList
          .where((tran) => tran.inCategory == incomeCategory)
          .toList();
    }

    List<InOrExTransaction> exTranList =
        _inOrExTransactionList.where((tran) => tran.inOrEx == 'ex').toList();
    if (expenseCategory != null && expenseCategory != 'All Category') {
      exTranList = _inOrExTransactionList
          .where((tran) => tran.exCategory == expenseCategory)
          .toList();
    }

    List<StockTransaction> stockTranList = _stockTransactionList
        .where((tran) =>
            tran.date.year == date.year && tran.date.month == date.month)
        .toList();

    List<Map<String, dynamic>> dailyTranList = [];

    for (int day = 31; day >= 0; day--) {
      int setTotalSum = 0;
      int incomeTotalSum = 0;
      int expenseTotalSum = 0;
      int stockTotalSum = 0;
      DateTime _selDate;

      List<SetTransaction> setDayTranList =
          setTranList.where((tran) => tran.date.day == day).toList();
      List<InOrExTransaction> incomeDayTranList = inTranList
          .where((tran) => tran.date.day == day && tran.inOrEx == 'in')
          .toList();
      List<InOrExTransaction> expenseDayTranList = exTranList
          .where((tran) => tran.date.day == day && tran.inOrEx == 'ex')
          .toList();
      List<StockTransaction> stockDayTranList = stockTranList
          .where((tran) => tran.date.day == day && tran.addOrSub == 'add')
          .toList();
      stockDayTranList.sort((a, b) => a.addOrSub.compareTo(b.addOrSub));
      stockDayTranList = stockDayTranList.reversed.toList();

      if (setDayTranList.isNotEmpty) {
        _selDate = setDayTranList.first.date;
        setDayTranList.forEach((tran) {
          tran.setItems.forEach((setItem) {
            setTotalSum += setItem.num * setItem.price;
          });
        });
      }

      if (incomeDayTranList.isNotEmpty) {
        _selDate = incomeDayTranList.first.date;
        incomeDayTranList.forEach((tran) {
          incomeTotalSum += tran.amount;
        });
      }

      if (expenseDayTranList.isNotEmpty) {
        _selDate = expenseDayTranList.first.date;
        expenseDayTranList.forEach((tran) {
          expenseTotalSum += tran.amount;
        });
      }
      if (stockDayTranList.isNotEmpty) {
        _selDate = stockDayTranList.first.date;
        stockDayTranList.forEach((tran) {
          if (tran.addOrSub == 'add') {
            tran.stockItems.forEach((stockItem) {
              stockTotalSum += stockItem.num * stockItem.price;
            });
          }
        });
      }

      if (setDayTranList.isNotEmpty ||
          incomeDayTranList.isNotEmpty ||
          expenseDayTranList.isNotEmpty ||
          stockDayTranList.isNotEmpty) {
        Map<String, dynamic> dayMap = {
          'date': DateFormat('dd MMMM, yyyy').format(_selDate).toString(),
          'setTranList': setDayTranList,
          'setTotal': setTotalSum,
          'incomeTranList': incomeDayTranList,
          'incomeTotal': incomeTotalSum,
          'expenseTranList': expenseDayTranList,
          'expenseTotal': expenseTotalSum,
          'stockTranList': stockDayTranList,
          'stockTotal': stockTotalSum,
        };
        dailyTranList.add(dayMap);
      }
    }
    return dailyTranList;
  }

  List<Map<String, dynamic>> stockTransactionsForOneMon() {
    List<StockTransaction> stockTranList = _stockTransactionList;
    List<Map<String, dynamic>> dataList = [];

    for (int day = 31; day >= 0; day--) {
      List<String> addItemNameList = [];
      List<String> useItemNameList = [];
      List<int> addAmountList = [];
      List<int> useAmountList = [];
      List<String> addStockUnitList = [];
      List<String> addUseUnitList = [];
      List<int> addUnitRatioList = [];
      List<String> useUnitList = [];
      DateTime _selDate;

      List<StockTransaction> stockDayTranList =
          stockTranList.where((tran) => tran.date.day == day).toList();

      stockDayTranList.forEach((tran) {
        _selDate = tran.date;
        tran.stockItems.forEach((item) {
          if (tran.addOrSub == 'add' && !addItemNameList.contains(item.name)) {
            addItemNameList.add(item.name);
          }
          if (tran.addOrSub == 'sub' && !useItemNameList.contains(item.name)) {
            useItemNameList.add(item.name);
          }
        });
      });

      addItemNameList.forEach((addName) {
        int amount = 0;
        String stockUnit = '';
        String useUnit = '';
        int unitRatio;
        stockDayTranList.forEach((tran) {
          tran.stockItems.forEach((item) {
            if (item.name == addName && tran.addOrSub == 'add') {
              if (item.unit == item.stockUnit) {
                amount += item.num * int.parse(item.unitRatio);
              } else {
                amount += item.num;
              }
              stockUnit = item.stockUnit;
              useUnit = item.useUnit;
              unitRatio = int.parse(item.unitRatio);
            }
          });
        });
        addAmountList.add(amount);
        addStockUnitList.add(stockUnit);
        addUseUnitList.add(useUnit);
        addUnitRatioList.add(unitRatio);
      });

      useItemNameList.forEach((useName) {
        int amount = 0;
        String unit = '';
        stockDayTranList.forEach((tran) {
          tran.stockItems.forEach((item) {
            if (item.name == useName && tran.addOrSub == 'sub') {
              if (item.unit == item.stockUnit) {
                amount += item.num * int.parse(item.unitRatio);
              } else {
                amount += item.num;
              }
              unit = item.useUnit;
            }
          });
        });
        useAmountList.add(amount);
        useUnitList.add(unit);
      });

      List<Map> addItemList = List.generate(
          addItemNameList.length,
          (index) => {
                'name': addItemNameList[index],
                'amount': addAmountList[index],
                'stockUnit': addStockUnitList[index],
                'useUnit': addUseUnitList[index],
                'unitRatio': addUnitRatioList[index],
              });

      List<Map> useItemList = List.generate(
          useItemNameList.length,
          (index) => {
                'name': useItemNameList[index],
                'amount': useAmountList[index],
                'unit': useUnitList[index],
              });

      if (addItemList.isNotEmpty || useItemList.isNotEmpty) {
        dataList.add({
          'date': DateFormat('dd MMMM, yyyy').format(_selDate).toString(),
          'addItems': addItemList,
          'useItems': useItemList,
        });
      }
    }
    return dataList;
  }

  List<Map> setTransactionsForDataTable(
      {DateTime date,
      bool addTotalSum = false,
      String shopName,
      String setOrIncome}) {
    List<String> productNames = [];
    List<int> numList = [];
    List<int> priceList = [];
    int totalNum = 0;
    int totalPrice = 0;
    List<SetTransaction> tranList = [];

    tranList = _setTransactionList
        .where((tran) =>
            tran.date.year == date.year && tran.date.month == date.month)
        .toList();
    if (shopName != 'All Shop') {
      tranList = _setTransactionList
          .where((tran) =>
              tran.date.year == date.year &&
              tran.date.month == date.month &&
              tran.shop == shopName)
          .toList();
    }

    tranList.forEach((tran) {
      tran.setItems.forEach((setItem) {
        if (!productNames.contains(setItem.name)) {
          productNames.add(setItem.name);
        }
      });
    });

    productNames.forEach((prodName) {
      int num = 0;
      int price = 0;
      tranList.forEach((tran) {
        tran.setItems.forEach((setItem) {
          if (prodName == setItem.name) {
            num += setItem.num;
            price += setItem.price * setItem.num;
          }
        });
      });
      numList.add(num);
      totalNum += num;
      priceList.add(price);
      totalPrice += price;
    });

    List<Map> dataList = List.generate(
        productNames.length,
        (index) => {
              'Name': productNames[index],
              'No': numList[index].toString(),
              'Price': priceList[index].toString(),
            });
    if (addTotalSum) {
      dataList.add({
        'totalNum': totalNum.toString(),
        'totalPrice': totalPrice.toString()
      });
    }
    return dataList;
  }

  List<Map> inOrExTransactionsForDataTable(
      {DateTime date, bool addTotalSum = false, String inOrEx}) {
    List<String> categoryNames = [];
    List<int> numList = [];
    int totalNum = 0;

    List<InOrExTransaction> tranList = [];

    tranList = inOrEx == 'in'
        ? _inOrExTransactionList.where((tran) => tran.inOrEx == 'in').toList()
        : _inOrExTransactionList.where((tran) => tran.inOrEx == 'ex').toList();

    tranList.forEach((tran) {
      if (inOrEx == 'in') {
        if (!categoryNames.contains(tran.inCategory)) {
          categoryNames.add(tran.inCategory);
        }
      } else {
        if (!categoryNames.contains(tran.exCategory)) {
          categoryNames.add(tran.exCategory);
        }
      }
    });

    categoryNames.forEach((catName) {
      int num = 0;
      int price = 0;
      tranList.forEach((tran) {
        if (inOrEx == 'in') {
          if (catName == tran.inCategory) {
            num += tran.amount;
          }
        } else {
          if (catName == tran.exCategory) {
            num += tran.amount;
          }
        }
      });
      numList.add(num);
      totalNum += num;
    });

    List<Map> dataList = List.generate(
        categoryNames.length,
        (index) => {
              'Name': categoryNames[index],
              'No': numList[index].toString(),
            });
    if (addTotalSum) {
      dataList.add({
        'totalNum': totalNum.toString(),
      });
    }
    return dataList;
  }

  List<Map> incomePerShop() {
    List<String> shopNames = [];
    List<int> amountList = [];
    List<SetTransaction> tranList = _setTransactionList;
    tranList.forEach((tran) {
      if (!shopNames.contains(tran.shop)) {
        shopNames.add(tran.shop);
      }
    });

    shopNames.forEach((shopName) {
      int amount = 0;
      tranList.forEach((tran) {
        if (shopName == tran.shop) {
          tran.setItems.forEach((set) {
            amount += set.price * set.num;
          });
        }
      });
      amountList.add(amount);
    });

    List<Map> dataList = List.generate(
        shopNames.length,
        (index) => {
              'Name': shopNames[index],
              'Amount': amountList[index].toString(),
            });
    dataList.sort((b, a) => a['Amount'].compareTo(b['Amount']));
    return dataList;
  }

  List<Map> stockTransactionsForDataTable(
      {DateTime date, bool addTotalSum = false}) {
    List<String> stockNames = [];
    List<int> numList = [];
    List<int> priceList = [];
    int totalNum = 0;
    int totalPrice = 0;

    List<StockTransaction> tranList = _stockTransactionList
        .where((tran) =>
            tran.date.year == date.year && tran.date.month == date.month)
        .toList();

    tranList.forEach((tran) {
      tran.stockItems.forEach((stockItem) {
        if (!stockNames.contains(stockItem.name) && tran.addOrSub == 'add') {
          stockNames.add(stockItem.name);
        }
      });
    });

    stockNames.forEach((stName) {
      int num = 0;
      int price = 0;
      tranList.forEach((tran) {
        tran.stockItems.forEach((stockItem) {
          if (stName == stockItem.name) {
            num += stockItem.num;
            price += stockItem.price * stockItem.num;
          }
        });
      });
      numList.add(num);
      totalNum += num;
      priceList.add(price);
      totalPrice += price;
    });

    List<Map> dataList = List.generate(
        stockNames.length,
        (index) => {
              'Name': stockNames[index],
              'No': numList[index].toString(),
              'Price': priceList[index].toString(),
            });
    if (addTotalSum) {
      dataList.add({
        'totalNum': totalNum.toString(),
        'totalPrice': totalPrice.toString()
      });
    }
    return dataList;
  }

  Future<void> addSet(
      {DateTime date, String shop, List<SetTransactionItem> setItems}) async {
    SetTransaction item = SetTransaction(
        date: date, setItems: setItems, shop: shop, tranType: 'set', total: 0);
    await transactionCollection
        .doc(DateFormat.yMMM().format(date).toString())
        .collection('transactions')
        .add(SetTransaction().toJson(item));
    notifyListeners();
  }

  Future<void> addIncomeAndExpense(
      {DateTime date,
      String name,
      int amount,
      String note,
      String inCategory,
      String exCategory,
      String inOrEx}) async {
    InOrExTransaction tran = InOrExTransaction(
        name: name,
        tranType: 'inOrEx',
        date: date,
        amount: amount,
        inCategory: inCategory,
        exCategory: exCategory,
        note: note,
        inOrEx: inOrEx);
    await transactionCollection
        .doc(DateFormat.yMMM().format(date).toString())
        .collection('transactions')
        .add(InOrExTransaction().toJson(tran));
    notifyListeners();
  }

  Future<void> addStock(
      {List<StockTransactionItem> stockItems,
      bool isAdd,
      DateTime date,
      bool isReAdd}) async {
    if (isAdd && !isReAdd) {
      StockTransaction item = StockTransaction(
        tranType: 'stock',
        addOrSub: 'add',
        date: date,
        stockItems: stockItems,
      );
      await transactionCollection
          .doc(DateFormat.yMMM().format(date).toString())
          .collection('transactions')
          .add(StockTransaction().toJson(item));
      //_stockTransactionList.add(item);
    } else {
      var snapshots = await transactionCollection
          .doc(DateFormat.yMMM().format(date).toString())
          .collection('transactions')
          .get();
      List docList = snapshots.docs;
      List<StockTransaction> _stockTranList = [];
      docList.map((doc) {
        Map<String, dynamic> docData = doc.data();
        if (docData['tranType'] == 'stock') {
          _stockTranList.add(StockTransaction.fromJson(doc));
        }
      }).toList();
      var stockTran = _stockTranList.firstWhere((tran) {
        return tran.date.year == date.year &&
            tran.date.month == date.month &&
            tran.date.day == date.day &&
            tran.addOrSub == 'sub';
      }, orElse: () => null);

      if (stockTran == null && !isReAdd) {
        StockTransaction item = StockTransaction(
          tranType: 'stock',
          addOrSub: isAdd ? 'add' : 'sub',
          date: date,
          stockItems: stockItems,
        );

        await transactionCollection
            .doc(DateFormat.yMMM().format(date).toString())
            .collection('transactions')
            .add(StockTransaction().toJson(item));
      } else if (stockTran != null && !isReAdd) {
        List<StockTransactionItem> newStockItems = stockTran.stockItems;
        stockItems.forEach((item) {
          newStockItems.add(item);
        });

        var updateStockTran = StockTransaction(
          id: stockTran.id,
          tranType: stockTran.tranType,
          addOrSub: stockTran.addOrSub,
          date: stockTran.date,
          stockItems: newStockItems,
        );
        await transactionCollection
            .doc(DateFormat.yMMM().format(date).toString())
            .collection('transactions')
            .doc(updateStockTran.id)
            .update(StockTransaction().toJson(updateStockTran));
      } else if (stockTran != null) {
        List<StockTransactionItem> newStockItems = stockTran.stockItems;

        stockItems.forEach((stItem) {
          bool done = false;
          for (int i = 0; i < stockTran.stockItems.length; i++) {
            if (stockTran.stockItems[i].name == stItem.name &&
                stockTran.stockItems[i].num == stItem.num &&
                done == false) {
              newStockItems.remove(stockTran.stockItems[i]);
              done = true;
            }
          }
        });
        var updateStockTran = StockTransaction(
          id: stockTran.id,
          tranType: stockTran.tranType,
          addOrSub: stockTran.addOrSub,
          date: stockTran.date,
          stockItems: newStockItems,
        );
        await transactionCollection
            .doc(DateFormat.yMMM().format(date).toString())
            .collection('transactions')
            .doc(updateStockTran.id)
            .update(StockTransaction().toJson(updateStockTran));
      }
    }
    notifyListeners();
  }

  List<String> expSugNames() {
    List<String> sugNames = [];
    List<InOrExTransaction> tranList =
        _inOrExTransactionList.where((tran) => tran.inOrEx == 'ex').toList();

    tranList.sort((a, b) => a.date.compareTo(b.date));
    List list = tranList.reversed.toList();
    list.forEach((tran) {
      if (!sugNames.contains(tran.name)) {
        sugNames.add(tran.name);
      }
    });
    if (sugNames.length > 5) {
      sugNames = sugNames.sublist(0, 5);
    }

    return sugNames;
  }

  List<String> inSugNames() {
    List<String> sugNames = [];
    List<InOrExTransaction> tranList =
        _inOrExTransactionList.where((tran) => tran.inOrEx == 'in').toList();

    tranList.sort((a, b) => a.date.compareTo(b.date));
    List list = tranList.reversed.toList();
    list.forEach((tran) {
      if (!sugNames.contains(tran.name)) {
        sugNames.add(tran.name);
      }
    });
    if (sugNames.length > 5) {
      sugNames = sugNames.sublist(0, 5);
    }

    return sugNames;
  }

  Map<String, int> inAndExTotal(
      {String shopName, String inCategory, String exCategory}) {
    int inTotal = 0;
    int exTotal = 0;
    int setTotal = 0;
    int stockTotal = 0;

    if (shopName != 'All Shop' && shopName != null) {
      _setTransactionList.forEach((tran) {
        if (tran.shop == shopName) {
          tran.setItems.forEach((setItem) {
            setTotal += setItem.num * setItem.price;
          });
        }
      });
    } else {
      _setTransactionList.forEach((tran) {
        tran.setItems.forEach((setItem) {
          setTotal += setItem.num * setItem.price;
        });
      });
    }

    if (inCategory != 'All Category' && inCategory != null) {
      _inOrExTransactionList.forEach((tran) {
        if (tran.inOrEx == 'in' && tran.inCategory == inCategory) {
          inTotal += tran.amount;
        }
      });
    } else {
      _inOrExTransactionList.forEach((tran) {
        if (tran.inOrEx == 'in') {
          inTotal += tran.amount;
        }
      });
    }

    if (exCategory != 'All Category' && exCategory != null) {
      _inOrExTransactionList.forEach((tran) {
        if (tran.inOrEx == 'ex' && tran.inCategory == exCategory) {
          exTotal += tran.amount;
        }
      });
    } else {
      _inOrExTransactionList.forEach((tran) {
        if (tran.inOrEx == 'ex') {
          exTotal += tran.amount;
        }
      });
    }

    _stockTransactionList.forEach((tran) {
      if (tran.addOrSub == 'add') {
        tran.stockItems.forEach((stItem) {
          stockTotal += stItem.total;
        });
      }
    });
    return {
      'setTotal': setTotal,
      'incomeTotal': inTotal,
      'allIncomeTotal': setTotal + inTotal,
      'stockTotal': stockTotal,
      'expenseTotal': exTotal,
      'allExpenseTotal': stockTotal + exTotal,
    };
  }

  Future<void> deleteSetTransaction(
      {SetTransaction setTran,
      SetTransactionItem setItem,
      DateTime date}) async {
    _setTransactionList.removeWhere((tran) => tran.id == setTran.id);
    if (setTran.setItems.length > 1) {
      setTran.setItems.removeWhere((item) => item.name == setItem.name);
      _setTransactionList.add(setTran);
      await transactionCollection
          .doc(DateFormat.yMMM().format(date).toString())
          .collection('transactions')
          .doc(setTran.id)
          .update(SetTransaction().toJson(setTran));
      notifyListeners();
      return;
    }
    await transactionCollection
        .doc(DateFormat.yMMM().format(date).toString())
        .collection('transactions')
        .doc(setTran.id)
        .delete();
    notifyListeners();
  }

  Future<void> deleteStockTransaction(
      {StockTransaction stockTran,
      StockTransactionItem stockItem,
      DateTime date}) async {
    _stockTransactionList.removeWhere((tran) => tran.id == stockTran.id);
    if (stockTran.stockItems.length > 1) {
      stockTran.stockItems.removeWhere((item) => item.name == stockItem.name);
      _stockTransactionList.add(stockTran);
      await transactionCollection
          .doc(stockTran.id)
          .update(StockTransaction().toJson(stockTran));
      notifyListeners();
      return;
    }
    await transactionCollection
        .doc(DateFormat.yMMM().format(date).toString())
        .collection('transactions')
        .doc(stockTran.id)
        .delete();
    notifyListeners();
  }

  Future<void> deleteInOrExTransaction(
      {InOrExTransaction inOrExTran, DateTime date}) async {
    _inOrExTransactionList.removeWhere((tran) => tran.id == inOrExTran.id);
    transactionCollection
        .doc(DateFormat.yMMM().format(date).toString())
        .collection('transactions')
        .doc(inOrExTran.id)
        .delete();
    notifyListeners();
  }

  // Future<void> updateStockTransaction(
  //     {List<SetTransactionItem> items, int amount, DateTime date})async{
  //   List<StockTransaction> tranList = _stockTransactionList
  //       .where((tran) =>
  //           tran.date.year == date.year &&
  //           tran.date.month == date.month &&
  //           tran.date.day == date.day)
  //       .toList();
  //
  //   var updateTran = tranList.firstWhere((tran) {
  //     tran.stockItems.where((item) {
  //       if (item.name == items. && item.num == amount) {
  //         return true;
  //       }
  //       return false;
  //     });
  //     return false;
  //   });
  //
  //   updateTran.stockItems.removeWhere((item) => item.name == stockName && item.num == amount);
  //   await transactionCollection
  //       .doc(updateTran.id)
  //       .update(StockTransaction().toJson(updateTran));
  //   notifyListeners();
  // }
}
