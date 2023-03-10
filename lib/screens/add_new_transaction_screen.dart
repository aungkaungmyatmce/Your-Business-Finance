import '../../language_change/app_localizations.dart';
import '../../widgets/add_new_transaction/add_income.dart';
import '../constants/colors.dart';
import '../constants/decoration.dart';
import '../constants/style.dart';
import '../provider/date_and_tabIndex_provider.dart';
import '../widgets/add_new_transaction/add_expense.dart';
import '../widgets/add_new_transaction/add_set.dart';
import '../widgets/add_new_transaction/add_stock.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class AddNewTransactionScreen extends StatefulWidget {
  const AddNewTransactionScreen({Key key}) : super(key: key);

  @override
  _AddNewTransactionScreenState createState() =>
      _AddNewTransactionScreenState();
}

class _AddNewTransactionScreenState extends State<AddNewTransactionScreen>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  var _selectedDate = DateTime.now();

  @override
  void initState() {
    _tabController = TabController(length: 4, vsync: this);
    _tabController.addListener(() {
      Provider.of<DateAndTabIndex>(context, listen: false)
          .setTabIndex(_tabController.index);
    });
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    int index = Provider.of<DateAndTabIndex>(context, listen: false).tabIndex;
    _tabController.index = index;
    super.didChangeDependencies();
  }

  void _datePick() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(DateTime.now().year + 1),
    ).then((pickedDate) {
      if (pickedDate == null) {
        return;
      }
      setState(() {
        _selectedDate = pickedDate;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: primaryColor,
      body: Container(
        padding: EdgeInsets.only(top: 10, bottom: 3, left: 5, right: 5),
        decoration: boxDecorationWithRoundedCorners(
            borderRadius: BorderRadius.only(topRight: Radius.circular(30))),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Column(
          children: [
            Row(
              children: [
                IconButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: Icon(Icons.arrow_back_ios_rounded)),
                Text(
                  AppLocalizations.of(context).translate('addNewTransaction'),
                  style: boldTextStyle(size: 16, color: Colors.black),
                ),
                Spacer(),
                InkWell(
                  onTap: _datePick,
                  child: Align(
                    child: Container(
                      height: 38,
                      padding: EdgeInsets.all(10),
                      //decoration: boxDecoration(radius: 8, showShadow: true),
                      // decoration: boxDecorationRoundedWithShadow(20
                      //     // backgroundColor: Colors.grey.shade100,
                      //     // borderRadius: BorderRadius.only(
                      //     //     topRight: Radius.circular(15),
                      //     //     bottomLeft: Radius.circular(15)),
                      //     ),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black12),
                        //color: Colors.grey.withOpacity(0.8),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Row(
                        children: [
                          Text(
                            DateFormat.yMMMd().format(_selectedDate),
                            style:
                                TextStyle(color: Colors.black87, fontSize: 14),
                          ),
                          SizedBox(width: 5),
                          Icon(
                            Icons.date_range,
                            color: primaryColor,
                            size: 15,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 8),
              ],
            ),
            TabBar(
                controller: _tabController,
                labelColor: primaryColor,
                indicatorColor: Colors.deepOrange,
                indicatorSize: TabBarIndicatorSize.label,
                unselectedLabelColor: Colors.grey,
                labelStyle: primaryTextStyle(size: 14),
                tabs: [
                  Tab(text: AppLocalizations.of(context).translate('products')),
                  Tab(text: AppLocalizations.of(context).translate('income')),
                  Tab(text: AppLocalizations.of(context).translate('expense')),
                  Tab(text: AppLocalizations.of(context).translate('stock')),
                ]),
            Expanded(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                child: TabBarView(controller: _tabController, children: [
                  AddSet(date: _selectedDate),
                  AddIncome(date: _selectedDate),
                  AddExpense(date: _selectedDate),
                  AddStock(date: _selectedDate),
                ]),
              ),
            )
          ],
        ),
      ),
    ));
  }
}
