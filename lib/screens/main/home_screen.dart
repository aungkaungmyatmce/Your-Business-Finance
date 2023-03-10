import '../../language_change/app_localizations.dart';
import '../../constants/colors.dart';
import '../../constants/decoration.dart';
import '../../constants/style.dart';
import '../../model/stock.dart';
import '../../provider/allProvider.dart';
import '../../provider/date_and_tabIndex_provider.dart';
import '../../provider/transaction_provider.dart';
import '../../widgets/charts/draw_set_chart.dart';
import '../../widgets/indicator_bar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    DateTime _selectedDate =
        Provider.of<DateAndTabIndex>(context, listen: false).date;
    List<Stock> stockList =
        Provider.of<AllProvider>(context).runningOutStocks();
    DateTime date = Provider.of<DateAndTabIndex>(context).date;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(
          'Your Business Finance',
          textAlign: TextAlign.center,
          style: boldTextStyle(color: Colors.white, size: 18),
        ),
        leading: Padding(
          padding: const EdgeInsets.only(left: 20),
          child: Align(
            child: Image.asset(
              'assets/images/cart.png',
              width: 40,
            ),
          ),
        ),
        actions: [
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
                height: 40,
                padding: EdgeInsets.all(10),
                //decoration: boxDecoration(radius: 8, showShadow: true),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white.withOpacity(0.8)),
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
          SizedBox(width: 10),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 180,
              width: MediaQuery.of(context).size.width,
              margin: EdgeInsets.only(bottom: 16.0),
              decoration: boxDecorationWithRoundedCorners(
                backgroundColor: primaryColor,
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.elliptical(
                      MediaQuery.of(context).size.width, 120.0),
                ),
              ),
              child: Column(
                children: [
                  Container(
                    height: 170,
                    margin: EdgeInsets.only(right: 16.0, left: 16.0),
                    padding: EdgeInsets.all(10),
                    transform: Matrix4.translationValues(0, 10.0, 0),
                    alignment: Alignment.center,
                    decoration: boxDecorationRoundedWithShadow(
                      12,
                    ),
                    child: Column(
                      children: [
                        Text(
                          AppLocalizations.of(context)
                              .translate('outOfStockList'),
                          style: boldTextStyle(size: 16),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 10),
                        // Text(
                        //   'No items for today',
                        //   textAlign: TextAlign.center,
                        // ),
                        if (stockList.length == 0)
                          Center(
                            heightFactor: 5,
                            child: Text(
                              AppLocalizations.of(context)
                                  .translate('noStockAddedYet'),
                              style: boldTextStyle(color: primaryColor),
                            ),
                          ),
                        Expanded(
                          child: ListView.separated(
                            itemCount: stockList.length,
                            separatorBuilder: (context, index) =>
                                Divider(thickness: 1),
                            itemBuilder: (context, index) {
                              var percent = (stockList[index].curAmount %
                                  stockList[index].stockRatio);
                              var curAmt = (stockList[index].curAmount /
                                      stockList[index].stockRatio)
                                  .toStringAsFixed(0);
                              if (percent != 0) {
                                curAmt =
                                    (int.parse(curAmt) + 1).toStringAsFixed(0);
                              }
                              Color bgColor = stockList[index].curAmount <=
                                      stockList[index].limitAmount
                                  ? Colors.red
                                  : Colors.black;
                              return Container(
                                padding: EdgeInsets.only(top: 3),
                                height: 38,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      '${index + 1}. ${stockList[index].name} ',
                                      style: boldTextStyle(
                                          size: 15,
                                          height: 1.2,
                                          color: bgColor),
                                    ),
                                    Spacer(),
                                    // Container(
                                    //   width: 75,
                                    //   child: Text(
                                    //     '- $curAmt ${stockList[index].unitForStock}',
                                    //     style: boldTextStyle(size: 16, height: 1.2),
                                    //   ),
                                    // ),
                                    IndicatorBar(
                                      minValue: (stockList[index].limitAmount /
                                              stockList[index].stockRatio)
                                          .toStringAsFixed(0),
                                      curValue: curAmt,
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            /// draw chart
            Container(
              height: 230,
              width: double.infinity,
              //margin: EdgeInsets.only(right: 16.0, left: 16.0),
              padding: EdgeInsets.all(10),
              transform: Matrix4.translationValues(0, 16.0, 0),
              alignment: Alignment.center,
              decoration: boxDecorationRoundedWithShadow(12),
              child: Column(
                children: [
                  Text(
                    AppLocalizations.of(context).translate('productChart'),
                    style: boldTextStyle(size: 16),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 8),
                  Expanded(
                      child: DrawSetChart(
                    date: date,
                    shopName: 'All Shop',
                  ))
                ],
              ),
            ),
            SizedBox(height: 20), //draw chart
            Container(
              height: 177,
              width: double.infinity,
              //margin: EdgeInsets.only(right: 16.0, left: 16.0),
              padding: EdgeInsets.all(15),
              transform: Matrix4.translationValues(0, 16.0, 0),
              alignment: Alignment.center,
              decoration: boxDecorationRoundedWithShadow(12),
              child: Consumer<TransactionProvider>(
                builder: (context, tranProvider, child) {
                  Map total = tranProvider.inAndExTotal();
                  return Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            height: 40,
                            width: 40,
                            alignment: Alignment.center,
                            decoration: boxDecorationWithRoundedCorners(
                              boxShape: BoxShape.circle,
                              backgroundColor: Colors.green.withOpacity(0.1),
                            ),
                            child: ImageIcon(
                              AssetImage('assets/images/income.png'),
                              size: 22,
                              color: Colors.green,
                            ),
                          ),
                          SizedBox(width: 10),
                          Text(
                            AppLocalizations.of(context).translate('income'),
                            style: boldTextStyle(color: Colors.green, size: 18),
                            textAlign: TextAlign.center,
                          ),
                          Spacer(),
                          Text(
                            total['allIncomeTotal'].toString(),
                            style: boldTextStyle(color: Colors.green, size: 16),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            height: 40,
                            width: 40,
                            alignment: Alignment.center,
                            decoration: boxDecorationWithRoundedCorners(
                              boxShape: BoxShape.circle,
                              backgroundColor: Colors.red.withOpacity(0.1),
                            ),
                            child: ImageIcon(
                              AssetImage('assets/images/expense.png'),
                              size: 22,
                              color: Colors.red,
                            ),
                          ),
                          SizedBox(width: 10),
                          Text(
                            AppLocalizations.of(context).translate('expense'),
                            style: boldTextStyle(color: Colors.red, size: 18),
                            textAlign: TextAlign.center,
                          ),
                          Spacer(),
                          Text(
                            total['allExpenseTotal'].toString(),
                            style: boldTextStyle(color: Colors.red, size: 16),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                      Divider(),
                      // SizedBox(height: 5),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            height: 40,
                            width: 40,
                            alignment: Alignment.center,
                            decoration: boxDecorationWithRoundedCorners(
                              boxShape: BoxShape.circle,
                              backgroundColor: Colors.red.withOpacity(0.1),
                            ),
                            child: ImageIcon(
                              AssetImage('assets/images/net_profit.png'),
                              size: 35,
                              color: primaryColor,
                            ),
                          ),
                          SizedBox(width: 10),
                          Text(
                            AppLocalizations.of(context).translate('netProfit'),
                            style: boldTextStyle(color: primaryColor, size: 18),
                            textAlign: TextAlign.center,
                          ),
                          Spacer(),
                          Text(
                            (total['allIncomeTotal'] - total['allExpenseTotal'])
                                .toString(),
                            style: boldTextStyle(
                                color: (total['allIncomeTotal'] -
                                            total['allExpenseTotal']) >
                                        0
                                    ? Colors.green
                                    : Colors.red,
                                size: 16),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ],
                  );
                },
              ),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
