import '../../language_change/app_localizations.dart';
import '../../constants/colors.dart';
import '../../constants/decoration.dart';
import '../../constants/style.dart';
import '../../provider/date_and_tabIndex_provider.dart';
import '../../provider/transaction_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StockTransactionScreen extends StatefulWidget {
  final DateTime date;

  const StockTransactionScreen({Key key, this.date}) : super(key: key);

  @override
  _StockTransactionScreenState createState() => _StockTransactionScreenState();
}

class _StockTransactionScreenState extends State<StockTransactionScreen> {
  @override
  void initState() {
    Provider.of<DateAndTabIndex>(context, listen: false).setTabIndex(3);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<Map> stockTranList =
        Provider.of<TransactionProvider>(context).stockTransactionsForOneMon();

    if (stockTranList.isEmpty) {
      return Center(
        child: Text(
            AppLocalizations.of(context)
                .translate('noTransactionsForThisMonth'),
            style: boldTextStyle()),
      );
    }
    return SingleChildScrollView(
      child: ListView.separated(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: stockTranList.length,
        separatorBuilder: (context, index) => SizedBox(height: 10),
        itemBuilder: (context, index) {
          if (stockTranList[index]['date'].isEmpty) {
            return Container();
          }
          return Container(
            margin: EdgeInsets.only(top: 5),
            padding: EdgeInsets.all(14),
            decoration: boxDecorationRoundedWithShadow(12),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(stockTranList[index]['date'],
                        style: boldTextStyle(weight: FontWeight.w600)),
                  ],
                ),
                Divider(
                  thickness: 1,
                ),

                /// Add List
                ListView.separated(
                  shrinkWrap: true,
                  separatorBuilder: (context, index) => SizedBox(height: 8),
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: stockTranList[index]['addItems'].length,
                  itemBuilder: (context, index2) {
                    print(stockTranList[index]['addItems'][index2]['amount']);
                    double firstIndex = stockTranList[index]['addItems'][index2]
                            ['amount'] /
                        stockTranList[index]['addItems'][index2]['unitRatio'];
                    print(firstIndex);
                    var secIndex = stockTranList[index]['addItems'][index2]
                            ['amount'] %
                        stockTranList[index]['addItems'][index2]['unitRatio'];
                    print(secIndex);
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width / 2.15,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                  stockTranList[index]['addItems'][index2]
                                      ['name'],
                                  style: primaryTextStyle()),
                              Row(
                                children: [
                                  if (firstIndex >= 1)
                                    Text(
                                        '${firstIndex.toString().substring(0, firstIndex.toString().indexOf('.'))} ${stockTranList[index]['addItems'][index2]['stockUnit']}',
                                        style: secondaryTextStyle()),
                                  if (secIndex != 0)
                                    Text(
                                        '$secIndex ${stockTranList[index]['addItems'][index2]['useUnit']}',
                                        style: secondaryTextStyle()),
                                ],
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 5),
                        Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 3, vertical: 2),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.black26)),
                          child: Text('Add',
                              style: secondaryTextStyle(
                                  color: primaryColor, size: 12)),
                        ),
                      ],
                    );
                  },
                ),

                if (stockTranList[index]['addItems'].isNotEmpty &&
                    stockTranList[index]['useItems'].isNotEmpty)
                  Divider(
                    indent: 5,
                    endIndent: 5,
                  ),

                /// Use List
                ListView.separated(
                  shrinkWrap: true,
                  separatorBuilder: (context, index) => SizedBox(height: 6),
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: stockTranList[index]['useItems'].length,
                  itemBuilder: (context, index2) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width / 2.15,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                  stockTranList[index]['useItems'][index2]
                                      ['name'],
                                  style: primaryTextStyle()),
                              Text(
                                  '${stockTranList[index]['useItems'][index2]['amount'].toString()} ${stockTranList[index]['useItems'][index2]['unit']}',
                                  style: secondaryTextStyle()),
                            ],
                          ),
                        ),
                        SizedBox(width: 5),
                        Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 3, vertical: 2),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.black26)),
                          child: Text('Use',
                              style: secondaryTextStyle(
                                  color: primaryColor, size: 12)),
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
