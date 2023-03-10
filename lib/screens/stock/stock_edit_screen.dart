import '../../language_change/app_localizations.dart';
import '../../constants/colors.dart';
import '../../constants/decoration.dart';
import '../../constants/style.dart';
import '../../model/stock.dart';
import '../../provider/allProvider.dart';
import 'add_new_stock_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StockEditScreen extends StatefulWidget {
  const StockEditScreen({Key key}) : super(key: key);

  @override
  _StockEditScreenState createState() => _StockEditScreenState();
}

class _StockEditScreenState extends State<StockEditScreen> {
  bool _isLoading = false;

  Future<void> _showDialog(Stock sto) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Confirm delete"),
          content: new Text("Are you sure ?"),
          actions: <Widget>[
            new TextButton(
              child: _isLoading ? CircularProgressIndicator() : new Text("Yes"),
              onPressed: () async {
                setState(() {
                  _isLoading = true;
                });
                await Provider.of<AllProvider>(context, listen: false)
                    .deleteStock(sto);
                setState(() {
                  _isLoading = false;
                });
                Navigator.of(context).pop();
              },
            ),
            new TextButton(
              child: new Text("No"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Stock> stockList = Provider.of<AllProvider>(context).allStocks;
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
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 0, left: 10),
                          child: Text(
                            AppLocalizations.of(context)
                                .translate('editStockList'),
                            style: boldTextStyle(size: 16),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 0, left: 10),
                          child: IconButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              icon: Icon(
                                Icons.close,
                                color: primaryColor,
                              )),
                        )
                      ],
                    ),
                    SizedBox(height: 20),
                    if (stockList.length == 0)
                      Center(
                        child: Text(
                          AppLocalizations.of(context)
                              .translate('noStockAddedYet'),
                          style: boldTextStyle(color: primaryColor),
                        ),
                      ),
                    Expanded(
                      child: ListView.separated(
                        separatorBuilder: (context, index) =>
                            SizedBox(height: 10),
                        itemCount: stockList.length,
                        itemBuilder: (context, index) {
                          var percent = (stockList[index].curAmount %
                              stockList[index].stockRatio);
                          var curAmt1 = (stockList[index].curAmount /
                                  stockList[index].stockRatio)
                              .toStringAsFixed(2);
                          // if (percent != 0) {
                          //   curAmt1 = (int.parse(curAmt1) + 1).toStringAsFixed(0);
                          // }

                          return Container(
                            height: 180,
                            margin: EdgeInsets.all(3),
                            padding: EdgeInsets.all(10),
                            decoration: boxDecorationRoundedWithShadow(10),
                            child: Stack(
                              children: [
                                Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        //SizedBox(width: 50),
                                        Text(
                                          stockList[index].name,
                                          style: boldTextStyle(size: 18),
                                        ),

                                        Spacer(),
                                        InkWell(
                                          onTap: () {
                                            Navigator.of(context)
                                                .push(MaterialPageRoute(
                                              builder: (context) =>
                                                  AddNewStockScreen(
                                                stock: stockList[index],
                                              ),
                                            ));
                                          },
                                          child: Icon(
                                            Icons.edit,
                                            color: Colors.green,
                                          ),
                                        ),
                                        SizedBox(width: 20),
                                        InkWell(
                                          onTap: () {
                                            _showDialog(stockList[index]);
                                          },
                                          child: Icon(
                                            Icons.delete,
                                            color: Colors.red,
                                          ),
                                        )
                                      ],
                                    ),
                                    SizedBox(height: 8),
                                    Row(
                                      children: [
                                        Text(
                                          '${AppLocalizations.of(context).translate('stock')}               : ',
                                          style: primaryTextStyle(size: 14),
                                        ),
                                        Text(
                                            '${curAmt1.substring(0, curAmt1.indexOf('.'))} ${stockList[index].unitForStock} ',
                                            style: primaryTextStyle(
                                                height: 1.3,
                                                size: 14,
                                                color: Colors.black54)),
                                        if (percent != 0)
                                          Text(
                                              '$percent ${stockList[index].unitForUse}',
                                              style: primaryTextStyle(
                                                  height: 1.3,
                                                  size: 14,
                                                  color: Colors.black54)),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          '${AppLocalizations.of(context).translate('unitForStock')}  : ',
                                          style: primaryTextStyle(size: 14),
                                        ),
                                        Text(
                                          '${stockList[index].unitForStock} ',
                                          style: primaryTextStyle(
                                              height: 1.3,
                                              size: 14,
                                              color: Colors.black54),
                                        ),
                                      ],
                                    ),
                                    //SizedBox(height: 3),
                                    Row(
                                      children: [
                                        Text(
                                          '${AppLocalizations.of(context).translate('unitForUse')}     :  ',
                                          textAlign: TextAlign.start,
                                          style: primaryTextStyle(size: 14),
                                        ),
                                        Text(
                                          '${stockList[index].unitForUse}   ',
                                          textAlign: TextAlign.start,
                                          style: primaryTextStyle(
                                              height: 1.3,
                                              size: 14,
                                              color: Colors.black54),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                if (stockList[index].stockRatio != 1)
                                  Positioned(
                                    top: 105,
                                    right: 15,
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 5),
                                      decoration: BoxDecoration(
                                        color: primaryColor,
                                        borderRadius: BorderRadius.circular(17),
                                      ),
                                      child: Text(
                                        '1 ${stockList[index].unitForStock} = ${stockList[index].stockRatio} ${stockList[index].unitForUse} ',
                                        style: primaryTextStyle(
                                            size: 12, color: Colors.white),
                                      ),
                                    ),
                                  )
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                    SizedBox(height: 60),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => AddNewStockScreen(),
                          ));
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Text(
                            AppLocalizations.of(context)
                                .translate('addNewStock'),
                            style: primaryTextStyle(
                                size: 16, height: 1.1, color: Colors.white),
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          shape: new RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(10.0),
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
