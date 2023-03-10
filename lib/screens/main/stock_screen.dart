import '../../language_change/app_localizations.dart';
import '../../constants/colors.dart';
import '../../constants/decoration.dart';
import '../../constants/style.dart';
import '../../model/stock.dart';
import '../../provider/allProvider.dart';
import '../stock/stock_edit_screen.dart';
import '../../widgets/indicator_bar.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class StockScreen extends StatefulWidget {
  const StockScreen({Key key}) : super(key: key);

  @override
  _StockScreenState createState() => _StockScreenState();
}

class _StockScreenState extends State<StockScreen> {
  @override
  Widget build(BuildContext context) {
    List<Stock> stockList = Provider.of<AllProvider>(context).allStocks;
    final width = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        backgroundColor: primaryColor,
        body: Container(
          //margin: EdgeInsets.only(top: 90),
          decoration: boxDecorationWithRoundedCorners(
              borderRadius: BorderRadius.only(topRight: Radius.circular(32))),
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Text(
                        AppLocalizations.of(context).translate('stockList'),
                        style: boldTextStyle(size: 16),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => StockEditScreen(),
                        ));
                      },
                      icon: FaIcon(
                        FontAwesomeIcons.solidEdit,
                        color: primaryColor,
                        size: 20,
                      ),
                    ),
                  ],
                ),
                //Divider(thickness: 1),
                SizedBox(height: 10),
                if (stockList.length == 0)
                  Center(
                    child: Text(
                      AppLocalizations.of(context)
                          .translate('noStocksAddedYet'),
                      style: boldTextStyle(color: primaryColor),
                    ),
                  ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: ListView.separated(
                      itemCount: stockList.length,
                      separatorBuilder: (context, index) =>
                          Divider(thickness: 1),
                      itemBuilder: (context, index) {
                        var percent = (stockList[index].curAmount %
                            stockList[index].stockRatio);
                        var curAmt = (stockList[index].curAmount /
                                stockList[index].stockRatio)
                            .toStringAsFixed(2);
                        var indicatorAmt =
                            curAmt.substring(0, curAmt.indexOf('.'));
                        // if (percent != 0) {
                        //   curAmt = (int.parse(curAmt) + 1).toStringAsFixed(0);
                        // }
                        return Container(
                          padding: EdgeInsets.only(top: 8),
                          height: 45,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${index + 1}.',
                                      style: boldTextStyle(size: 15, height: 1),
                                    ),
                                    Container(
                                      width: width - (165 + 115),
                                      child: Text(
                                        ' ${stockList[index].name} ',
                                        style:
                                            boldTextStyle(size: 15, height: 1),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Spacer(),
                              Container(
                                width: 70,
                                child: Text(
                                  '- ${curAmt.substring(0, curAmt.indexOf('.'))} ${stockList[index].unitForStock}',
                                  style:
                                      primaryTextStyle(size: 14, height: 1.2),
                                ),
                              ),
                              //SizedBox(width: 10),
                              Container(
                                child: IndicatorBar(
                                  minValue: (stockList[index].limitAmount /
                                          stockList[index].stockRatio)
                                      .toStringAsFixed(0),
                                  curValue: indicatorAmt,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
