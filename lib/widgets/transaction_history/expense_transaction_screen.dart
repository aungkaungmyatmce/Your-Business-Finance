import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:ybf_sample_version_2/constants/colors.dart';

import '../../language_change/app_localizations.dart';
import '../../provider/allProvider.dart';
import '../../constants/decoration.dart';
import '../../constants/style.dart';
import '../../provider/date_and_tabIndex_provider.dart';
import '../../provider/transaction_provider.dart';
import '../../services/confirm_delete_tran.dart';
import '../../services/ui_helper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'draw_table.dart';

enum FilterOptions {
  Stock,
  Expense,
  All,
}

class ExpenseTransactionScreen extends StatefulWidget {
  final DateTime date;

  const ExpenseTransactionScreen({Key key, this.date}) : super(key: key);

  @override
  _ExpenseTransactionScreenState createState() =>
      _ExpenseTransactionScreenState();
}

class _ExpenseTransactionScreenState extends State<ExpenseTransactionScreen> {
  FilterOptions _selectedOption = FilterOptions.All;
  int total = 0;
  List<Map> allTranList = [];
  String _selectedCategory = 'All Category';
  List<String> categoryNames = ['All Category'];
  List<Map> tableDataList = [];

  @override
  void initState() {
    Provider.of<DateAndTabIndex>(context, listen: false).setTabIndex(2);
    _getCatData();
    super.initState();
  }

  Future<void> _getCatData() async {
    WidgetsFlutterBinding.ensureInitialized();
    var prefs = await SharedPreferences.getInstance();
    //print(prefs.getString('filterData'));
    if (prefs.getString('filterData') == null) {
      setState(() {
        _selectedOption = FilterOptions.All;
      });
    } else {
      final extractedData =
          jsonDecode(prefs.getString('filterData')) as Map<String, dynamic>;
      if (extractedData['filter_option'] == 'All') {
        setState(() {
          _selectedOption = FilterOptions.All;
        });
      } else if (extractedData['filter_option'] == 'Stock') {
        setState(() {
          _selectedOption = FilterOptions.Stock;
        });
      } else {
        setState(() {
          _selectedOption = FilterOptions.Expense;
        });
      }
    }
  }

  Future<void> _saveCatData(FilterOptions filter) async {
    var prefs = await SharedPreferences.getInstance();
    String dataString = '';
    if (filter == FilterOptions.All) {
      dataString = 'All';
    } else if (filter == FilterOptions.Stock) {
      dataString = 'Stock';
    } else {
      dataString = 'Expense';
    }
    final data = jsonEncode({
      'filter_option': dataString,
    });
    prefs.setString('filterData', data);
  }

  @override
  void didChangeDependencies() {
    categoryNames = ['All Category'];
    categoryNames += Provider.of<AllProvider>(context).exCategoryList;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    if (_selectedOption == FilterOptions.Stock) {
      tableDataList = Provider.of<TransactionProvider>(context)
          .stockTransactionsForDataTable(date: widget.date, addTotalSum: false);
    } else if (_selectedOption == FilterOptions.Expense) {
      tableDataList = Provider.of<TransactionProvider>(context)
          .inOrExTransactionsForDataTable(date: widget.date, inOrEx: 'ex');
    }

    allTranList = Provider.of<TransactionProvider>(context)
        .allTransactionsForOneMon(
            date: widget.date, expenseCategory: _selectedCategory);
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(color: Colors.white),
            padding: EdgeInsets.only(top: 5, bottom: 8),
            child: Container(
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(color: Colors.white),
              padding: EdgeInsets.only(top: 5, bottom: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Container(
                        width: (MediaQuery.of(context).size.width / 2) - 10,
                        child: PopupMenuButton(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(15.0),
                            ),
                          ),
                          child: Row(
                            children: [
                              if (_selectedOption == FilterOptions.All)
                                Container(
                                  width:
                                      (MediaQuery.of(context).size.width / 2) -
                                          50,
                                  child: Text(
                                    AppLocalizations.of(context)
                                        .translate('allExpense'),
                                    textAlign: TextAlign.end,
                                    overflow: TextOverflow.ellipsis,
                                    style: boldTextStyle(size: 16),
                                  ),
                                ),
                              if (_selectedOption == FilterOptions.Stock)
                                Container(
                                  width:
                                      (MediaQuery.of(context).size.width / 2) -
                                          50,
                                  child: Text(
                                    AppLocalizations.of(context)
                                        .translate('stockExpense'),
                                    textAlign: TextAlign.end,
                                    overflow: TextOverflow.ellipsis,
                                    style: boldTextStyle(size: 16),
                                  ),
                                ),
                              if (_selectedOption == FilterOptions.Expense)
                                Container(
                                  width:
                                      (MediaQuery.of(context).size.width / 2) -
                                          50,
                                  child: Text(
                                    AppLocalizations.of(context)
                                        .translate('otherExpense'),
                                    textAlign: TextAlign.end,
                                    overflow: TextOverflow.ellipsis,
                                    style: boldTextStyle(size: 16),
                                  ),
                                ),
                              SizedBox(width: 10),
                              Icon(Icons.filter_list),
                            ],
                          ),
                          onSelected: (FilterOptions selectedValue) {
                            setState(
                              () {
                                _selectedOption = selectedValue;
                              },
                            );
                            _saveCatData(_selectedOption);
                          },
                          // icon: Icon(Icons.filter_list),
                          itemBuilder: (_) => [
                            PopupMenuItem(
                              child: Text(AppLocalizations.of(context)
                                  .translate('showAll')),
                              value: FilterOptions.All,
                            ),
                            PopupMenuItem(
                              child: Text(AppLocalizations.of(context)
                                  .translate('showOnlyStock')),
                              value: FilterOptions.Stock,
                            ),
                            PopupMenuItem(
                              child: Text(AppLocalizations.of(context)
                                  .translate('showOnlyExpense')),
                              value: FilterOptions.Expense,
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: (MediaQuery.of(context).size.width / 2) - 10,
                        child: Row(
                          children: [
                            if (_selectedOption == FilterOptions.Expense)
                              PopupMenuButton<String>(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(15.0),
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      width:
                                          (MediaQuery.of(context).size.width /
                                                  2) -
                                              50,
                                      child: Text(
                                        _selectedCategory,
                                        textAlign: TextAlign.end,
                                        overflow: TextOverflow.ellipsis,
                                        style: boldTextStyle(size: 16),
                                      ),
                                    ),
                                    SizedBox(width: 10),
                                    Icon(Icons.filter_list),
                                  ],
                                ),
                                onSelected: (String selectedValue) {
                                  setState(
                                    () {
                                      _selectedCategory = selectedValue;
                                    },
                                  );
                                },
                                //icon: Icon(Icons.filter_list),
                                itemBuilder: (context) => categoryNames
                                    .map((name) => PopupMenuItem<String>(
                                          child: Text(name),
                                          value: name,
                                        ))
                                    .toList(),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        if ((_selectedOption == FilterOptions.Expense ||
                                _selectedOption == FilterOptions.Stock) &&
                            tableDataList.isNotEmpty)
                          DrawTable(tableDataList: tableDataList),

                        ///
                        if ((_selectedOption == FilterOptions.Expense ||
                                _selectedOption == FilterOptions.Stock) &&
                            tableDataList.isNotEmpty)
                          SizedBox(
                            width: _selectedOption == FilterOptions.Stock
                                ? 315
                                : 250,
                            child: Align(
                              alignment: Alignment.center,
                              child: Divider(
                                thickness: 1,
                              ),
                            ),
                          ),
                        Consumer<TransactionProvider>(
                          builder: (context, tranProvider, _) => Container(
                            width: _selectedOption == FilterOptions.Stock
                                ? 315
                                : 200,
                            child: Column(
                              children: [
                                if (_selectedOption == FilterOptions.All ||
                                    _selectedOption == FilterOptions.Stock)
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                          _selectedOption == FilterOptions.All
                                              ? AppLocalizations.of(context)
                                                  .translate('stock')
                                              : AppLocalizations.of(context)
                                                  .translate('total'),
                                          style: boldTextStyle(
                                              size: 15, height: 1)),
                                      Text(
                                          tranProvider
                                                  .inAndExTotal()['stockTotal']
                                                  .toString() +
                                              '  ',
                                          style:
                                              boldTextStyle(color: Colors.red)),
                                    ],
                                  ),
                                SizedBox(height: 5),
                                if (_selectedOption == FilterOptions.All ||
                                    _selectedOption == FilterOptions.Expense)
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                          _selectedOption == FilterOptions.All
                                              ? AppLocalizations.of(context)
                                                  .translate('expense')
                                              : AppLocalizations.of(context)
                                                  .translate('total'),
                                          style: boldTextStyle(
                                              size: 15, height: 1.5)),
                                      Text(
                                          tranProvider
                                                  .inAndExTotal()[
                                                      'expenseTotal']
                                                  .toString() +
                                              '  ',
                                          style:
                                              boldTextStyle(color: Colors.red)),
                                    ],
                                  ),
                                if (_selectedOption == FilterOptions.All)
                                  SizedBox(
                                    width: 310,
                                    child: Divider(
                                      thickness: 1,
                                    ),
                                  ),
                                if (_selectedOption == FilterOptions.All)
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                          AppLocalizations.of(context)
                                              .translate('total'),
                                          style: boldTextStyle(
                                              size: 15, height: 1)),
                                      Text(
                                          tranProvider
                                                  .inAndExTotal()[
                                                      'allExpenseTotal']
                                                  .toString() +
                                              '  ',
                                          style:
                                              boldTextStyle(color: Colors.red)),
                                    ],
                                  ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: 10),
                ],
              ),
            ),
          ),
          ListView.separated(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: allTranList.length,
            separatorBuilder: (context, index) => SizedBox(height: 10),
            itemBuilder: (context, index) {
              if (_selectedOption == FilterOptions.All) {
                total = (allTranList[index]['stockTotal'] ?? 0) +
                    (allTranList[index]['expenseTotal'] ?? 0);
              } else if (_selectedOption == FilterOptions.Stock) {
                total = allTranList[index]['stockTotal'] ?? 0;
              } else {
                total = allTranList[index]['expenseTotal'] ?? 0;
              }

              if (total == 0) {
                return Container();
              }

              return Container(
                margin: EdgeInsets.only(top: 5),
                padding: EdgeInsets.all(14),
                decoration: boxDecorationRoundedWithShadow(12),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(allTranList[index]['date'],
                            style: boldTextStyle(weight: FontWeight.w600)),
                        Text(
                          '${total.toString()}',
                          style:
                              secondaryTextStyle(color: Colors.red, size: 15),
                        ),
                      ],
                    ),
                    Divider(),

                    /// Expense TranList
                    if (allTranList[index]['expenseTranList'].isNotEmpty &&
                        (_selectedOption == FilterOptions.All ||
                            _selectedOption == FilterOptions.Expense))
                      ListView.separated(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: allTranList[index]['expenseTranList'].length,
                        separatorBuilder: (context, index2) =>
                            SizedBox(height: 10),
                        itemBuilder: (context, index2) {
                          return Dismissible(
                            key: ValueKey(
                                allTranList[index]['expenseTranList'][index2]),
                            confirmDismiss: (direction) {
                              return confirmDeleteTran(context);
                            },
                            onDismissed: (direction) async {
                              Provider.of<TransactionProvider>(context,
                                      listen: false)
                                  .deleteInOrExTransaction(
                                      inOrExTran: allTranList[index]
                                          ['expenseTranList'][index2],
                                      date: widget.date);
                              UIHelper.showSuccessFlushbar(
                                  context, 'Transaction deleted!');
                            },
                            direction: DismissDirection.endToStart,
                            background: Container(
                              decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.circular(5)),
                              child: Icon(
                                Icons.delete,
                                color: Colors.white,
                                size: 15,
                              ),
                              alignment: Alignment.centerRight,
                              padding: EdgeInsets.symmetric(horizontal: 5),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width / 2.15,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        allTranList[index]['expenseTranList']
                                                [index2]
                                            .name,
                                        style: primaryTextStyle(size: 15),
                                      ),
                                      if (allTranList[index]['expenseTranList']
                                                  [index2]
                                              .note !=
                                          null)
                                        Text(
                                          allTranList[index]['expenseTranList']
                                                  [index2]
                                              .note,
                                          style: secondaryTextStyle(),
                                        )
                                    ],
                                  ),
                                ),
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width / 2.6,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        width: 75,
                                        height: 30,
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 3, vertical: 2),
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(13),
                                            border: Border.all(
                                                color: Colors.black26)),
                                        child: Center(
                                          child: Text(
                                            allTranList[index]
                                                    ['expenseTranList'][index2]
                                                .exCategory,
                                            overflow: TextOverflow.ellipsis,
                                            style: secondaryTextStyle(
                                                height: 1.3,
                                                size: 13,
                                                color: primaryColor),
                                          ),
                                        ),
                                      ),
                                      Text(
                                        allTranList[index]['expenseTranList']
                                                [index2]
                                            .amount
                                            .toString(),
                                        style: secondaryTextStyle(),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          );
                        },
                      ),

                    /// Stock TranList
                    if (allTranList[index]['stockTranList'].isNotEmpty &&
                        (_selectedOption == FilterOptions.All ||
                            _selectedOption == FilterOptions.Stock))
                      Padding(
                        padding: const EdgeInsets.only(top: 5),
                        child: ListView.separated(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: allTranList[index]['stockTranList'].length,
                          separatorBuilder: (context, index2) =>
                              SizedBox(height: 5),
                          itemBuilder: (context, index2) {
                            return ListView.separated(
                              shrinkWrap: true,
                              separatorBuilder: (context, index) =>
                                  SizedBox(height: 5),
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: allTranList[index]['stockTranList']
                                      [index2]
                                  .stockItems
                                  .length,
                              itemBuilder: (context, index3) {
                                if (allTranList[index]['stockTranList'][index2]
                                        .addOrSub ==
                                    'sub') {
                                  return Container();
                                }
                                return Dismissible(
                                  key: ValueKey(allTranList[index]
                                          ['stockTranList'][index2]
                                      .stockItems[index3]),
                                  confirmDismiss: (direction) {
                                    return confirmDeleteTran(context);
                                  },
                                  onDismissed: (direction) async {
                                    Provider.of<TransactionProvider>(context,
                                            listen: false)
                                        .deleteStockTransaction(
                                            stockTran: allTranList[index]
                                                ['stockTranList'][index2],
                                            stockItem: allTranList[index]
                                                    ['stockTranList'][index2]
                                                .stockItems[index3],
                                            date: widget.date);
                                    Provider.of<AllProvider>(context,
                                            listen: false)
                                        .addToStockByStockTran(items: [
                                      allTranList[index]['stockTranList']
                                              [index2]
                                          .stockItems[index3]
                                    ], isAdd: false);

                                    UIHelper.showSuccessFlushbar(
                                        context, 'Transaction deleted!');
                                  },
                                  direction: DismissDirection.endToStart,
                                  background: Container(
                                    decoration: BoxDecoration(
                                        color: Colors.red,
                                        borderRadius: BorderRadius.circular(5)),
                                    child: Icon(
                                      Icons.delete,
                                      color: Colors.white,
                                      size: 15,
                                    ),
                                    alignment: Alignment.centerRight,
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 5),
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width /
                                                2.15,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                                allTranList[index]
                                                            ['stockTranList']
                                                        [index2]
                                                    .stockItems[index3]
                                                    .name,
                                                style: boldTextStyle()),
                                          ],
                                        ),
                                      ),
                                      SizedBox(width: 5),
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width /
                                                2.6,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 15),
                                              child: Text(
                                                  '${allTranList[index]['stockTranList'][index2].stockItems[index3].num} ${allTranList[index]['stockTranList'][index2].stockItems[index3].unit}',
                                                  style: secondaryTextStyle()),
                                            ),
                                            Text(
                                                allTranList[index]
                                                            ['stockTranList']
                                                        [index2]
                                                    .stockItems[index3]
                                                    .total
                                                    .toString(),
                                                style: secondaryTextStyle()),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
