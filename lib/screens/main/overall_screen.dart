import 'package:cloud_firestore/cloud_firestore.dart' hide Transaction;
import 'package:url_launcher/url_launcher.dart';
import '../../language_change/app_localizations.dart';
import '../../constants/colors.dart';
import '../../model/set_transaction.dart';
import '../../provider/allProvider.dart';
import '../../provider/transaction_provider.dart';
import '../add_new_transaction_screen.dart';
import 'home_screen.dart';
import 'setting_screen.dart';
import 'stock_screen.dart';
import '../../provider/date_and_tabIndex_provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'history_screen.dart';

class OverallScreen extends StatefulWidget {
  const OverallScreen({Key key}) : super(key: key);

  @override
  _OverallScreenState createState() => _OverallScreenState();
}

class _OverallScreenState extends State<OverallScreen> {
  final CollectionReference transactionCollection =
      FirebaseFirestore.instance.collection('transactions');
  List<SetTransaction> allTransactionList = [];

  void tranMessageStream() async {
    final fs = FirebaseFirestore.instance;
    DateTime date = Provider.of<DateAndTabIndex>(context).date;
    await for (var tranSnapshot in fs
        .collection('allTransactions')
        .doc(DateFormat.yMMM().format(date))
        .collection('transactions')
        .snapshots()) {
      Provider.of<TransactionProvider>(context, listen: false)
          .addAllTransactions(tranSnapshot);
    }
  }

  void allMessageStream() async {
    final fs = FirebaseFirestore.instance;
    await for (var snapshot in fs.collection('all').snapshots()) {
      Provider.of<AllProvider>(context, listen: false).addAllOfAll(snapshot);
    }
  }

  List<Object> _pages;

  @override
  void didChangeDependencies() {
    tranMessageStream();
    allMessageStream();
    super.didChangeDependencies();
  }

  @override
  void initState() {
    _pages = [
      HomeScreen(),
      StockScreen(),
      HistoryScreen(),
      SettingScreen(),
    ];
    super.initState();
  }

  int selectedPos = 0;
  @override
  Widget build(BuildContext context) {
    Widget tabItem(var pos, String title, var image, var size) {
      return GestureDetector(
        onTap: () {
          setState(() {
            selectedPos = pos;
          });
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 7),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Image.asset(
                'assets/images/$image.png',
                color: selectedPos == pos ? primaryColor : Colors.black54,
                width: size,
              ),
              Text(
                title,
                style: TextStyle(
                  fontSize: 12,
                  //height: 0.7,
                  color: selectedPos == pos ? primaryColor : Colors.black54,
                ),
              )
            ],
          ),
        ),
      );
    }

    return Scaffold(
      body: _pages[selectedPos],
      bottomNavigationBar: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            height: 65,
            decoration: BoxDecoration(color: Colors.white, boxShadow: [
              BoxShadow(
                color: shadowColor,
                blurRadius: 10,
                spreadRadius: 2,
                offset: Offset(0, 3),
              )
            ]),
            child: Padding(
              padding: EdgeInsets.only(left: 14, right: 14),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  tabItem(0, AppLocalizations.of(context).translate('home'),
                      'home', 20.0),
                  tabItem(1, AppLocalizations.of(context).translate('stock'),
                      'stock', 22.0),
                  Container(width: 45, height: 45),
                  tabItem(2, AppLocalizations.of(context).translate('history'),
                      'tran_history', 20.0),
                  tabItem(3, AppLocalizations.of(context).translate('setting'),
                      'setting', 20.0),
                ],
              ),
            ),
          ),
          Container(
            child: Consumer<AllProvider>(
              builder: (context, all, child) => FloatingActionButton(
                backgroundColor: primaryColor,
                onPressed: () {
                  if (all.appProfile.expireDate.isBefore(DateTime.now())) {
                    showDialog(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        title: Text('Your app is expired'),
                        content: Text('Please renew your subscription.'),
                        actions: <Widget>[
                          TextButton(
                            child: Text('Renew'),
                            onPressed: () async {
                              await launch('fb://page/108446008386191',
                                  forceSafariVC: false, forceWebView: false);
                            },
                          ),
                          TextButton(
                            child: Text('Ok'),
                            onPressed: () async {
                              Navigator.of(context).pop(false);
                            },
                          ),
                        ],
                      ),
                    );
                  } else {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => AddNewTransactionScreen(),
                    ));
                  }
                },
                child: Icon(Icons.add, color: Colors.white),
              ),
            ),
          )
        ],
      ),
    );
  }
}
