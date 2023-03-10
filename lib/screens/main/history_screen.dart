import '../../language_change/app_localizations.dart';
import '../../constants/colors.dart';
import '../../constants/decoration.dart';
import '../../constants/style.dart';
import '../../provider/date_and_tabIndex_provider.dart';
import '../../widgets/transaction_history/expense_transaction_screen.dart';
import '../../widgets/transaction_history/income_transaction_screen.dart';
import '../../widgets/transaction_history/overall_transaction_screen.dart';
import '../../widgets/transaction_history/stock_transaction_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';
import 'package:provider/provider.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({Key key}) : super(key: key);

  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen>
    with SingleTickerProviderStateMixin {
  //var _selectedDate = DateTime.now();
  TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 4, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    DateTime _selectedDate =
        Provider.of<DateAndTabIndex>(context, listen: false).date;
    return SafeArea(
        child: Scaffold(
      backgroundColor: primaryColor,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  AppLocalizations.of(context).translate('transactionHistory'),
                  style: boldTextStyle(size: 16, color: Colors.white),
                ),
                InkWell(
                  onTap: () {
                    showMonthPicker(
                      context: context,
                      firstDate: DateTime(DateTime.now().year - 1, 5),
                      lastDate: DateTime(DateTime.now().year + 1, 9),
                      initialDate: _selectedDate,
                    ).then((date) {
                      if (date != null) {
                        setState(() {
                          _selectedDate = date;
                          Provider.of<DateAndTabIndex>(context, listen: false)
                              .setDate(_selectedDate);
                        });
                      }
                    });
                  },
                  child: Align(
                    child: Container(
                      height: 38,
                      padding: EdgeInsets.all(10),
                      //decoration: boxDecoration(radius: 8, showShadow: true),
                      decoration: BoxDecoration(
                        border:
                            Border.all(color: Colors.white.withOpacity(0.8)),
                        color: Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Row(
                        children: [
                          Text(
                            DateFormat.yMMM().format(_selectedDate),
                            style: TextStyle(color: Colors.white, fontSize: 14),
                          ),
                          SizedBox(width: 5),
                          Icon(
                            Icons.date_range,
                            color: Colors.white,
                            size: 15,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              decoration: boxDecorationWithRoundedCorners(
                  borderRadius:
                      BorderRadius.only(topRight: Radius.circular(30))),
              width: MediaQuery.of(context).size.width,
              // height: MediaQuery.of(context).size.height,
              child: Column(
                children: [
                  TabBar(
                      controller: _tabController,
                      labelColor: primaryColor,
                      indicatorColor: Colors.deepOrange,
                      indicatorSize: TabBarIndicatorSize.label,
                      unselectedLabelColor: Colors.grey,
                      labelStyle: primaryTextStyle(size: 14),
                      tabs: [
                        Tab(
                            text: AppLocalizations.of(context)
                                .translate('overall')),
                        Tab(
                            text: AppLocalizations.of(context)
                                .translate('income')),
                        Tab(
                            text: AppLocalizations.of(context)
                                .translate('expense')),
                        Tab(
                            text: AppLocalizations.of(context)
                                .translate('stock')),
                      ]),
                  Expanded(
                    child: TabBarView(controller: _tabController, children: [
                      OverallTransactionScreen(date: _selectedDate),
                      IncomeTransactionScreen(date: _selectedDate),
                      ExpenseTransactionScreen(date: _selectedDate),
                      StockTransactionScreen(date: _selectedDate),
                    ]),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    ));
  }
}
