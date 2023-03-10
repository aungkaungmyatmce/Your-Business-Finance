import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/in_or_ex_transaction.dart';
import '../model/set_transaction.dart';
import '../model/stock_transaction.dart';
import '../services/pdf_api.dart';
import 'package:intl/intl.dart';
import 'package:jiffy/jiffy.dart';

class CreatePdf {
  CollectionReference transactionCollection =
      FirebaseFirestore.instance.collection('allTransactions');
  List<SetTransaction> _setTransactionList = [];
  List<StockTransaction> _stockTransactionList = [];
  List<InOrExTransaction> _inOrExTransactionList = [];
  List<QueryDocumentSnapshot> docList = [];

  Future<void> create({DateTime startDate, DateTime endDate}) async {
    await getData(startDate: startDate, endDate: endDate);
  }

  Future<void> getData({DateTime startDate, DateTime endDate}) async {
    List<DateTime> dateList = [];
    DateTime date;

    int i = 0;
    while (date != endDate) {
      date = Jiffy(startDate).add(months: i).dateTime;
      dateList.add(date);
      i += 1;
    }
    docList = await getFirebaseData(dateList);
    addAllTransactions(docList);
    List allTranList = allTransactionsBetweenTowMons(dateList: dateList);
    List allTotalList = totalInAndEx(allTranList);
    final pdfFile = await PdfApi.generate(
        allTranList: allTranList, allTotalList: allTotalList);
    PdfApi.openFile(pdfFile);
  }

  Future<List<QueryDocumentSnapshot>> getFirebaseData(
      List<DateTime> dateList) async {
    for (var date in dateList) {
      //print(DateFormat.yMMM().format(date));
      final docQsn = await transactionCollection
          .doc(DateFormat.yMMM().format(date))
          .collection('transactions')
          .get();
      docList += docQsn.docs;
    }
    return docList;
  }

  void addAllTransactions(List docList) {
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
  }

  List<Map<String, dynamic>> allTransactionsForOneMon({DateTime date}) {
    List<SetTransaction> setTranList = _setTransactionList
        .where((tran) =>
            tran.date.year == date.year && tran.date.month == date.month)
        .toList();
    List<InOrExTransaction> inOrExTranList = _inOrExTransactionList
        .where((tran) =>
            tran.date.year == date.year && tran.date.month == date.month)
        .toList();
    List<StockTransaction> stockTranList = _stockTransactionList
        .where((tran) =>
            tran.date.year == date.year && tran.date.month == date.month)
        .toList();

    List<Map<String, dynamic>> dailyTranList = [];

    for (int day = 0; day <= 31; day++) {
      int setTotalSum = 0;
      int incomeTotalSum = 0;
      int expenseTotalSum = 0;
      int stockTotalSum = 0;
      DateTime _selDate;

      List<SetTransaction> setDayTranList =
          setTranList.where((tran) => tran.date.day == day).toList();
      List<InOrExTransaction> incomeDayTranList = inOrExTranList
          .where((tran) => tran.date.day == day && tran.inOrEx == 'in')
          .toList();
      List<InOrExTransaction> expenseDayTranList = inOrExTranList
          .where((tran) => tran.date.day == day && tran.inOrEx == 'ex')
          .toList();
      List<StockTransaction> stockDayTranList =
          stockTranList.where((tran) => tran.date.day == day).toList();
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
              stockTotalSum += stockItem.total;
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
          'numDate': DateFormat('dd / MM / yyyy').format(_selDate).toString(),
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

  List<Map<String, dynamic>> allTransactionsBetweenTowMons(
      {List<DateTime> dateList}) {
    List<Map<String, dynamic>> allTranList = [];
    dateList.forEach((date) {
      allTranList += allTransactionsForOneMon(date: date);
    });
    return allTranList;
  }

  List<Map<String, dynamic>> totalInAndEx(
      List<Map<String, dynamic>> allTranList) {
    List<Map<String, dynamic>> totalTranList = [];
    String date = allTranList.first['date'].substring(3);
    int totalIn = 0;
    int totalEx = 0;
    // print(allTranList);
    allTranList.forEach((tran) {
      if (tran['date'].substring(3) == date) {
        totalIn += tran['setTotal'];
        totalEx += tran['expenseTotal'];
        totalEx += tran['stockTotal'];
      } else {
        totalTranList
            .add({'date': date, 'totalIn': totalIn, 'totalEx': totalEx});
        totalIn = 0;
        totalEx = 0;
        date = tran['date'].substring(3);
        totalIn += tran['setTotal'];
        totalEx += tran['expenseTotal'];
        totalEx += tran['stockTotal'];
      }
      if (tran == allTranList.last) {
        totalTranList
            .add({'date': date, 'totalIn': totalIn, 'totalEx': totalEx});
      }
    });
    return totalTranList;
  }
}
