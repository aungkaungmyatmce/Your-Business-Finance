import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../language_change/app_localizations.dart';
import '../../provider/allProvider.dart';
import '../../constants/colors.dart';
import '../../constants/decoration.dart';
import '../../constants/style.dart';
import '../../provider/date_and_tabIndex_provider.dart';
import '../../provider/transaction_provider.dart';
import '../../screens/report_screen.dart';
import '../../services/confirm_delete_tran.dart';
import '../../services/ui_helper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'draw_table.dart';

enum FilterOptions {
  Set,
  Extra,
  All,
}

class IncomeTransactionScreen extends StatefulWidget {
  final DateTime date;

  const IncomeTransactionScreen({Key key, this.date}) : super(key: key);

  @override
  _IncomeTransactionScreenState createState() =>
      _IncomeTransactionScreenState();
}

class _IncomeTransactionScreenState extends State<IncomeTransactionScreen> {
  FilterOptions _selectedOption = FilterOptions.All;
  int total = 0;
  List<Map> allTranList = [];
  String _selectedShop = 'All Shop';
  List<String> shopNames = ['All Shop'];
  String _selectedCategory = 'All Category';
  List<String> categoryNames = ['All Category'];
  bool isAdd;
  List<Map> tableDataList = [];

  @override
  void initState() {
    Provider.of<DateAndTabIndex>(context, listen: false).setTabIndex(1);
    _getCatData();
    super.initState();
  }

  Future<void> _getCatData() async {
    WidgetsFlutterBinding.ensureInitialized();
    var prefs = await SharedPreferences.getInstance();
    //print(prefs.getString('filterData'));
    if (prefs.getString('filterData') == null) {
      setState(() {
        _selectedOption = FilterOptions.Set;
      });
    } else {
      final extractedData =
          jsonDecode(prefs.getString('filterData')) as Map<String, dynamic>;
      if (extractedData['filter_option'] == 'All') {
        setState(() {
          _selectedOption = FilterOptions.All;
        });
      } else if (extractedData['filter_option'] == 'Set') {
        setState(() {
          _selectedOption = FilterOptions.Set;
        });
      } else {
        setState(() {
          _selectedOption = FilterOptions.Extra;
        });
      }
    }
  }

  Future<void> _saveCatData(FilterOptions filter) async {
    var prefs = await SharedPreferences.getInstance();
    String dataString = '';
    if (filter == FilterOptions.All) {
      dataString = 'All';
    } else if (filter == FilterOptions.Set) {
      dataString = 'Set';
    } else {
      dataString = 'Extra';
    }
    final data = jsonEncode({
      'filter_option': dataString,
    });
    prefs.setString('filterData', data);
  }

  @override
  void didChangeDependencies() {
    shopNames = ['All Shop'];
    shopNames += Provider.of<AllProvider>(context).allShop;
    categoryNames = ['All Category'];
    categoryNames += Provider.of<AllProvider>(context).inCategoryList;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    if (_selectedOption == FilterOptions.Set) {
      tableDataList = Provider.of<TransactionProvider>(context)
          .setTransactionsForDataTable(
              date: widget.date, addTotalSum: false, shopName: _selectedShop);
    } else if (_selectedOption == FilterOptions.Extra) {
      tableDataList = Provider.of<TransactionProvider>(context)
          .inOrExTransactionsForDataTable(date: widget.date, inOrEx: 'in');
    }

    allTranList = Provider.of<TransactionProvider>(context)
        .allTransactionsForOneMon(
            date: widget.date,
            shopName: _selectedShop,
            incomeCategory: _selectedCategory);

    // if (allTranList.isEmpty) {
    //   return Center(
    //     child: Text(
    //         AppLocalizations.of(context)
    //             .translate('noTransactionsForThisMonth'),
    //         style: boldTextStyle()),
    //   );
    // }

    return SingleChildScrollView(
      child: Column(
        children: [
          ///Data Table
          Container(
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
                                width: (MediaQuery.of(context).size.width / 2) -
                                    50,
                                child: Text(
                                  AppLocalizations.of(context)
                                      .translate('allIncome'),
                                  textAlign: TextAlign.end,
                                  overflow: TextOverflow.ellipsis,
                                  style: boldTextStyle(size: 16),
                                ),
                              ),
                            if (_selectedOption == FilterOptions.Set)
                              Container(
                                width: (MediaQuery.of(context).size.width / 2) -
                                    50,
                                child: Text(
                                  AppLocalizations.of(context)
                                      .translate('productIncome'),
                                  textAlign: TextAlign.end,
                                  overflow: TextOverflow.ellipsis,
                                  style: boldTextStyle(size: 16),
                                ),
                              ),
                            if (_selectedOption == FilterOptions.Extra)
                              Container(
                                width: (MediaQuery.of(context).size.width / 2) -
                                    50,
                                child: Text(
                                  AppLocalizations.of(context)
                                      .translate('extraIncome'),
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
                                .translate('showOnlyProduct')),
                            value: FilterOptions.Set,
                          ),
                          PopupMenuItem(
                            child: Text(AppLocalizations.of(context)
                                .translate('showOnlyExtra')),
                            value: FilterOptions.Extra,
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: (MediaQuery.of(context).size.width / 2) - 10,
                      child: Row(
                        children: [
                          if (_selectedOption == FilterOptions.Set)
                            PopupMenuButton<String>(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(15.0),
                                ),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    width: (MediaQuery.of(context).size.width /
                                            2) -
                                        50,
                                    child: Text(
                                      _selectedShop,
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
                                    _selectedShop = selectedValue;
                                  },
                                );
                              },
                              //icon: Icon(Icons.filter_list),
                              itemBuilder: (context) => shopNames
                                  .map((name) => PopupMenuItem<String>(
                                        child: Text(name),
                                        value: name,
                                      ))
                                  .toList(),
                            ),
                          if (_selectedOption == FilterOptions.Extra)
                            PopupMenuButton<String>(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(15.0),
                                ),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    width: (MediaQuery.of(context).size.width /
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
                      if ((_selectedOption == FilterOptions.Extra ||
                              _selectedOption == FilterOptions.Set) &&
                          tableDataList.isNotEmpty)
                        DrawTable(tableDataList: tableDataList),

                      ///
                      if ((_selectedOption == FilterOptions.Extra ||
                              _selectedOption == FilterOptions.Set) &&
                          tableDataList.isNotEmpty)
                        SizedBox(
                          width:
                              _selectedOption == FilterOptions.Set ? 315 : 250,
                          child: Align(
                            alignment: Alignment.center,
                            child: Divider(
                              thickness: 1,
                            ),
                          ),
                        ),
                      Consumer<TransactionProvider>(
                        builder: (context, tranProvider, _) => Container(
                          width:
                              _selectedOption == FilterOptions.Set ? 315 : 200,
                          child: Column(
                            children: [
                              if (_selectedOption == FilterOptions.All ||
                                  _selectedOption == FilterOptions.Set)
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                        _selectedOption == FilterOptions.All
                                            ? AppLocalizations.of(context)
                                                .translate('product')
                                            : AppLocalizations.of(context)
                                                .translate('total'),
                                        style:
                                            boldTextStyle(size: 15, height: 1)),
                                    Text(
                                        tranProvider
                                                .inAndExTotal(
                                                    shopName:
                                                        _selectedShop)[
                                                    'setTotal']
                                                .toString() +
                                            '  ',
                                        style:
                                            boldTextStyle(color: Colors.green)),
                                  ],
                                ),
                              SizedBox(height: 5),
                              if (_selectedOption == FilterOptions.All ||
                                  _selectedOption == FilterOptions.Extra)
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                        _selectedOption == FilterOptions.All
                                            ? AppLocalizations.of(context)
                                                .translate('extra')
                                            : AppLocalizations.of(context)
                                                .translate('total'),
                                        style: boldTextStyle(
                                            size: 15, height: 1.4)),
                                    Text(
                                        tranProvider
                                                .inAndExTotal(
                                                    shopName: _selectedShop,
                                                    inCategory:
                                                        'All Category')[
                                                    'incomeTotal']
                                                .toString() +
                                            '  ',
                                        style:
                                            boldTextStyle(color: Colors.green)),
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
                                        style:
                                            boldTextStyle(size: 15, height: 1)),
                                    Text(
                                        tranProvider
                                                .inAndExTotal(
                                                    shopName:
                                                        _selectedShop)[
                                                    'allIncomeTotal']
                                                .toString() +
                                            '  ',
                                        style:
                                            boldTextStyle(color: Colors.green)),
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
                if (_selectedOption == FilterOptions.Set)
                  InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ReportScreen(
                              date: widget.date,
                              shopName: _selectedShop,
                            ),
                          ));
                    },
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                      decoration: BoxDecoration(
                        color:
                            primaryColor, //Colors.lightBlue.withOpacity(0.17),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        AppLocalizations.of(context)
                            .translate('viewReportForThisPeriod'),
                        style: TextStyle(color: Colors.white, fontSize: 15),
                      ),
                    ),
                  ),
              ],
            ),
          ),

          /// Data List
          ListView.separated(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: allTranList.length,
            separatorBuilder: (context, index) => SizedBox(height: 10),
            itemBuilder: (context, index) {
              if (_selectedOption == FilterOptions.All) {
                total = (allTranList[index]['setTotal'] ?? 0) +
                    (allTranList[index]['incomeTotal'] ?? 0);
              } else if (_selectedOption == FilterOptions.Set) {
                total = allTranList[index]['setTotal'] ?? 0;
              } else {
                total = allTranList[index]['incomeTotal'] ?? 0;
              }

              if (total == 0) {
                return Container();
              }
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 1),
                child: Container(
                  margin: EdgeInsets.only(top: 10),
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
                            total.toString(),
                            style: secondaryTextStyle(
                                color: Colors.green, size: 15),
                          ),
                        ],
                      ),
                      Divider(),
                      if (allTranList[index]['setTranList'].isNotEmpty &&
                          (_selectedOption == FilterOptions.All ||
                              _selectedOption == FilterOptions.Set))
                        ListView.separated(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: allTranList[index]['setTranList'].length,
                          separatorBuilder: (context, index2) =>
                              SizedBox(height: 12),
                          itemBuilder: (context, index2) {
                            return ListView.separated(
                              shrinkWrap: true,
                              separatorBuilder: (context, index) =>
                                  SizedBox(height: 12),
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: allTranList[index]['setTranList']
                                      [index2]
                                  .setItems
                                  .length,
                              itemBuilder: (context, index3) {
                                return Dismissible(
                                  key: ValueKey(allTranList[index]
                                          ['setTranList'][index2]
                                      .setItems[index3]),
                                  confirmDismiss: (direction) async {
                                    bool confirm =
                                        await confirmDeleteTran(context);
                                    if (confirm != false) {
                                      await showDialog(
                                        context: context,
                                        builder: (ctx) => AlertDialog(
                                          title: Text('Are you sure?'),
                                          content: Text(
                                              'ကုန်ကြမ်းတွေ စာရင်းထဲပြန်ထည့်မှာလား ?'),
                                          actions: <Widget>[
                                            TextButton(
                                              child: Text('No'),
                                              onPressed: () async {
                                                isAdd = false;
                                                Navigator.of(context)
                                                    .pop(false);
                                              },
                                            ),
                                            TextButton(
                                              child: Text('Yes, Re-Add'),
                                              onPressed: () async {
                                                isAdd = true;
                                                Navigator.of(context).pop(true);
                                              },
                                            ),
                                          ],
                                        ),
                                      );
                                    }

                                    return confirm;
                                  },
                                  onDismissed: (direction) async {
                                    if (isAdd) {
                                      Provider.of<AllProvider>(context,
                                              listen: false)
                                          .addOrSubFromStockBySetTran(
                                              items: [
                                            allTranList[index]['setTranList']
                                                    [index2]
                                                .setItems[index3]
                                          ],
                                              date: widget.date,
                                              isAdd: true,
                                              reAdd: true);
                                    }

                                    Provider.of<TransactionProvider>(context,
                                            listen: false)
                                        .deleteSetTransaction(
                                            setTran: allTranList[index]
                                                ['setTranList'][index2],
                                            setItem: allTranList[index]
                                                    ['setTranList'][index2]
                                                .setItems[index3],
                                            date: widget.date);
                                    // UIHelper.showSuccessFlushbar(
                                    //     context, 'Transaction deleted!');
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
                                        height: 20,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                                allTranList[index]
                                                        ['setTranList'][index2]
                                                    .setItems[index3]
                                                    .name,
                                                style: primaryTextStyle(
                                                    height: 1, size: 15)),
                                            Text(
                                                allTranList[index]
                                                        ['setTranList'][index2]
                                                    .setItems[index3]
                                                    .num
                                                    .toString(),
                                                style: secondaryTextStyle()),
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
                                                              ['setTranList']
                                                          [index2]
                                                      .shop,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: secondaryTextStyle(
                                                      size: 13,
                                                      color: primaryColor),
                                                ),
                                              ),
                                            ),
                                            Text(
                                                (allTranList[index]['setTranList']
                                                                [index2]
                                                            .setItems[index3]
                                                            .num *
                                                        allTranList[index][
                                                                    'setTranList']
                                                                [index2]
                                                            .setItems[index3]
                                                            .price)
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

                      ///
                      if (allTranList[index]['incomeTranList'].isNotEmpty &&
                          (_selectedOption == FilterOptions.All ||
                              _selectedOption == FilterOptions.Extra))
                        Padding(
                          padding: const EdgeInsets.only(top: 12),
                          child: ListView.separated(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount:
                                allTranList[index]['incomeTranList'].length,
                            separatorBuilder: (context, index2) =>
                                SizedBox(height: 12),
                            itemBuilder: (context, index2) {
                              return Dismissible(
                                key: ValueKey(allTranList[index]
                                    ['incomeTranList'][index2]),
                                confirmDismiss: (direction) {
                                  return confirmDeleteTran(context);
                                },
                                onDismissed: (direction) async {
                                  Provider.of<TransactionProvider>(context,
                                          listen: false)
                                      .deleteInOrExTransaction(
                                          inOrExTran: allTranList[index]
                                              ['incomeTranList'][index2],
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      width: MediaQuery.of(context).size.width /
                                          2.15,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            allTranList[index]['incomeTranList']
                                                    [index2]
                                                .name,
                                            style: primaryTextStyle(size: 15),
                                          ),
                                          if (allTranList[index]
                                                      ['incomeTranList'][index2]
                                                  .note !=
                                              null)
                                            Text(
                                              allTranList[index]
                                                              ['incomeTranList']
                                                          [index2]
                                                      .note ??
                                                  '',
                                              style: secondaryTextStyle(),
                                            )
                                        ],
                                      ),
                                    ),
                                    Container(
                                      width: MediaQuery.of(context).size.width /
                                          2.6,
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
                                                            ['incomeTranList']
                                                        [index2]
                                                    .inCategory,
                                                overflow: TextOverflow.ellipsis,
                                                style: secondaryTextStyle(
                                                    height: 1.3,
                                                    size: 13,
                                                    color: primaryColor),
                                              ),
                                            ),
                                          ),
                                          Text(
                                            allTranList[index]['incomeTranList']
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
                        ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
