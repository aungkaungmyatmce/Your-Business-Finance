import '../../provider/date_and_tabIndex_provider.dart';
import '../../language_change/app_localizations.dart';
import '../../constants/colors.dart';
import '../../constants/decoration.dart';
import '../../constants/style.dart';
import '../../provider/transaction_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OverallTransactionScreen extends StatefulWidget {
  final DateTime date;

  const OverallTransactionScreen({Key key, this.date}) : super(key: key);

  @override
  _OverallTransactionScreenState createState() =>
      _OverallTransactionScreenState();
}

class _OverallTransactionScreenState extends State<OverallTransactionScreen> {
  @override
  void initState() {
    Provider.of<DateAndTabIndex>(context, listen: false).setTabIndex(0);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<Map> allTranList = Provider.of<TransactionProvider>(context)
        .allTransactionsForOneMon(date: widget.date);
    if (allTranList.isEmpty) {
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
        itemCount: allTranList.length,
        separatorBuilder: (context, index) => Divider(
          thickness: 3,
        ),
        itemBuilder: (context, index) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                child: Text(allTranList[index]['date'],
                    style: boldTextStyle(weight: FontWeight.w600)),
              ),

              /// Income List
              if (allTranList[index]['setTranList'].isNotEmpty ||
                  allTranList[index]['incomeTranList'].isNotEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Stack(
                    alignment: Alignment.topLeft,
                    children: [
                      Container(
                        margin: EdgeInsets.only(top: 15),
                        padding: EdgeInsets.only(
                            top: 20, left: 14, right: 14, bottom: 8),
                        decoration: boxDecorationRoundedWithShadow(12),
                        child: Column(
                          children: [
                            if (allTranList[index]['setTranList'].isNotEmpty)
                              ListView.separated(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount:
                                    allTranList[index]['setTranList'].length,
                                separatorBuilder: (context, index2) =>
                                    SizedBox(height: 15),
                                itemBuilder: (context, index2) {
                                  return ListView.separated(
                                    shrinkWrap: true,
                                    separatorBuilder: (context, index) =>
                                        SizedBox(height: 15),
                                    physics: NeverScrollableScrollPhysics(),
                                    itemCount: allTranList[index]['setTranList']
                                            [index2]
                                        .setItems
                                        .length,
                                    itemBuilder: (context, index3) {
                                      return Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                2.15,
                                            height: 20,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                    allTranList[index]
                                                                ['setTranList']
                                                            [index2]
                                                        .setItems[index3]
                                                        .name,
                                                    style: primaryTextStyle(
                                                        height: 1, size: 15)),
                                                Text(
                                                    allTranList[index]
                                                                ['setTranList']
                                                            [index2]
                                                        .setItems[index3]
                                                        .num
                                                        .toString(),
                                                    style:
                                                        secondaryTextStyle()),
                                              ],
                                            ),
                                          ),
                                          SizedBox(width: 5),
                                          Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                2.6,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Container(
                                                  width: 75,
                                                  height: 30,
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 3,
                                                      vertical: 2),
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              13),
                                                      border: Border.all(
                                                          color:
                                                              Colors.black26)),
                                                  child: Center(
                                                    child: Text(
                                                      allTranList[index][
                                                                  'setTranList']
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
                                                                .setItems[
                                                                    index3]
                                                                .num *
                                                            allTranList[index][
                                                                        'setTranList']
                                                                    [index2]
                                                                .setItems[
                                                                    index3]
                                                                .price)
                                                        .toString(),
                                                    style:
                                                        secondaryTextStyle()),
                                              ],
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                              ),
                            if (allTranList[index]['incomeTranList'].isNotEmpty)
                              Padding(
                                padding: const EdgeInsets.only(top: 12),
                                child: ListView.separated(
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemCount: allTranList[index]
                                          ['incomeTranList']
                                      .length,
                                  separatorBuilder: (context, index2) =>
                                      SizedBox(height: 12),
                                  itemBuilder: (context, index2) {
                                    return Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              2.15,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                allTranList[index]
                                                            ['incomeTranList']
                                                        [index2]
                                                    .name,
                                                style:
                                                    primaryTextStyle(size: 15),
                                              ),
                                              if (allTranList[index]
                                                              ['incomeTranList']
                                                          [index2]
                                                      .note !=
                                                  null)
                                                Text(
                                                  allTranList[index][
                                                                  'incomeTranList']
                                                              [index2]
                                                          .note ??
                                                      '',
                                                  style: secondaryTextStyle(),
                                                )
                                            ],
                                          ),
                                        ),
                                        Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width /
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
                                                        BorderRadius.circular(
                                                            13),
                                                    border: Border.all(
                                                        color: Colors.black26)),
                                                child: Center(
                                                  child: Text(
                                                    allTranList[index][
                                                                'incomeTranList']
                                                            [index2]
                                                        .inCategory,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: secondaryTextStyle(
                                                        height: 1.3,
                                                        size: 13,
                                                        color: primaryColor),
                                                  ),
                                                ),
                                              ),
                                              Text(
                                                allTranList[index]
                                                            ['incomeTranList']
                                                        [index2]
                                                    .amount
                                                    .toString(),
                                                style: secondaryTextStyle(),
                                              ),
                                            ],
                                          ),
                                        )
                                      ],
                                    );
                                  },
                                ),
                              ),
                            SizedBox(height: 3),
                            Divider(),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                    '${AppLocalizations.of(context).translate('total')} : ',
                                    style: boldTextStyle(size: 14, height: 1)),
                                Text(
                                  ((allTranList[index]['setTotal'] ?? 0) +
                                          (allTranList[index]['incomeTotal'] ??
                                              0))
                                      .toString(),
                                  style: secondaryTextStyle(
                                      color: Colors.green, size: 15),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                      Container(
                        width: 80,
                        height: 30,
                        margin: EdgeInsets.only(left: 16, bottom: 20),
                        padding:
                            EdgeInsets.symmetric(horizontal: 6, vertical: 0),
                        decoration: boxDecorationWithRoundedCorners(
                          backgroundColor: Colors.green,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Center(
                          child: Text(
                            AppLocalizations.of(context).translate('income'),
                            style: TextStyle(fontSize: 14, color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

              /// Expense List
              if (allTranList[index]['expenseTranList'].isNotEmpty ||
                  allTranList[index]['stockTranList'].isNotEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Stack(
                    alignment: Alignment.topLeft,
                    children: [
                      Container(
                        margin: EdgeInsets.only(top: 15),
                        padding: EdgeInsets.only(
                            top: 20, left: 14, right: 14, bottom: 8),
                        decoration: boxDecorationRoundedWithShadow(12),
                        child: Column(
                          children: [
                            SizedBox(height: 5),
                            if (allTranList[index]['expenseTranList']
                                .isNotEmpty)
                              ListView.separated(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: allTranList[index]['expenseTranList']
                                    .length,
                                separatorBuilder: (context, index2) =>
                                    SizedBox(height: 10),
                                itemBuilder: (context, index2) {
                                  return Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width /
                                                2.15,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              allTranList[index]
                                                          ['expenseTranList']
                                                      [index2]
                                                  .name,
                                              style: primaryTextStyle(size: 15),
                                            ),
                                            if (allTranList[index]
                                                            ['expenseTranList']
                                                        [index2]
                                                    .note !=
                                                null)
                                              Text(
                                                allTranList[index]
                                                            ['expenseTranList']
                                                        [index2]
                                                    .note,
                                                style: secondaryTextStyle(),
                                              )
                                          ],
                                        ),
                                      ),
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
                                                  allTranList[index][
                                                              'expenseTranList']
                                                          [index2]
                                                      .exCategory,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: secondaryTextStyle(
                                                      height: 1.3,
                                                      size: 13,
                                                      color: primaryColor),
                                                ),
                                              ),
                                            ),
                                            Text(
                                              allTranList[index]
                                                          ['expenseTranList']
                                                      [index2]
                                                  .amount
                                                  .toString(),
                                              style: secondaryTextStyle(),
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  );
                                },
                              ),
                            if (allTranList[index]['stockTranList'].isNotEmpty)
                              Padding(
                                padding: const EdgeInsets.only(top: 5),
                                child: ListView.separated(
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemCount: allTranList[index]['stockTranList']
                                      .length,
                                  separatorBuilder: (context, index2) =>
                                      SizedBox(height: 5),
                                  itemBuilder: (context, index2) {
                                    return ListView.separated(
                                      shrinkWrap: true,
                                      separatorBuilder: (context, index) =>
                                          SizedBox(height: 5),
                                      physics: NeverScrollableScrollPhysics(),
                                      itemCount: allTranList[index]
                                              ['stockTranList'][index2]
                                          .stockItems
                                          .length,
                                      itemBuilder: (context, index3) {
                                        if (allTranList[index]['stockTranList']
                                                    [index2]
                                                .addOrSub ==
                                            'sub') {
                                          return Container();
                                        }
                                        return Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Container(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  2.15,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                      allTranList[index][
                                                                  'stockTranList']
                                                              [index2]
                                                          .stockItems[index3]
                                                          .name,
                                                      style: primaryTextStyle(
                                                          size: 15)),
                                                ],
                                              ),
                                            ),
                                            SizedBox(width: 5),
                                            Container(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  2.6,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 15),
                                                    child: Text(
                                                        '${allTranList[index]['stockTranList'][index2].stockItems[index3].num} ${allTranList[index]['stockTranList'][index2].stockItems[index3].unit}',
                                                        style:
                                                            secondaryTextStyle()),
                                                  ),
                                                  Text(
                                                      allTranList[index][
                                                                  'stockTranList']
                                                              [index2]
                                                          .stockItems[index3]
                                                          .total
                                                          .toString(),
                                                      style:
                                                          secondaryTextStyle()),
                                                ],
                                              ),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                ),
                              ),
                            Divider(),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                    '${AppLocalizations.of(context).translate('total')} : ',
                                    style: boldTextStyle(size: 14, height: 1)),
                                Text(
                                  ((allTranList[index]['expenseTotal'] ?? 0) +
                                              allTranList[index]
                                                  ['stockTotal'] ??
                                          0)
                                      .toString(),
                                  style: secondaryTextStyle(
                                      color: Colors.red, size: 15),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                      Container(
                        width: 80,
                        height: 30,
                        margin: EdgeInsets.only(left: 16, bottom: 20),
                        padding:
                            EdgeInsets.symmetric(horizontal: 6, vertical: 0),
                        decoration: boxDecorationWithRoundedCorners(
                          backgroundColor: Colors.red,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Center(
                          child: Text(
                            AppLocalizations.of(context).translate('expense'),
                            style: TextStyle(fontSize: 14, color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}

/// Stock List
// if (allTranList[index]['stockTranList'].isNotEmpty)
// Padding(
// padding: const EdgeInsets.symmetric(vertical: 1),
// child: Stack(
// alignment: Alignment.topLeft,
// children: [
// Container(
// margin: EdgeInsets.only(top: 10),
// padding: EdgeInsets.all(14),
// decoration: boxDecorationRoundedWithShadow(12),
// child: Column(
// children: [
// if (allTranList[index]['stockTranList'].isNotEmpty)
// ListView.separated(
// shrinkWrap: true,
// physics: NeverScrollableScrollPhysics(),
// itemCount:
// allTranList[index]['stockTranList'].length,
// separatorBuilder: (context, index2) =>
// SizedBox(height: 10),
// itemBuilder: (context, index2) {
// return ListView.separated(
// shrinkWrap: true,
// separatorBuilder: (context, index) =>
// SizedBox(height: 8),
// physics: NeverScrollableScrollPhysics(),
// itemCount: allTranList[index]
// ['stockTranList'][index2]
//     .stockItems
//     .length,
// itemBuilder: (context, index3) {
// return Row(
// mainAxisAlignment:
// MainAxisAlignment.spaceBetween,
// children: [
// Container(
// width: MediaQuery.of(context)
//     .size
//     .width /
// 2.15,
// child: Row(
// mainAxisAlignment:
// MainAxisAlignment
//     .spaceBetween,
// children: [
// Text(
// allTranList[index][
// 'stockTranList']
// [index2]
//     .stockItems[index3]
//     .name,
// style: boldTextStyle()),
// Text(
// '${allTranList[index]['stockTranList'][index2].stockItems[index3].num} ${allTranList[index]['stockTranList'][index2].stockItems[index3].unit}',
// style:
// secondaryTextStyle()),
// ],
// ),
// ),
// SizedBox(width: 5),
// Container(
// width: MediaQuery.of(context)
//     .size
//     .width /
// 2.6,
// child: Row(
// mainAxisAlignment:
// MainAxisAlignment
//     .spaceBetween,
// children: [
// Container(
// padding: EdgeInsets.symmetric(
// horizontal: 3,
// vertical: 2),
// decoration: BoxDecoration(
// borderRadius:
// BorderRadius.circular(
// 8),
// border: Border.all(
// color:
// Colors.black26)),
// child: Text(
// allTranList[index]['stockTranList']
// [index2]
//     .addOrSub ==
// 'add'
// ? 'Add'
//     : 'Use',
// style: secondaryTextStyle(
// color: primaryColor)),
// ),
// if (allTranList[index][
// 'stockTranList']
// [index2]
//     .addOrSub ==
// 'add')
// Text(
// allTranList[index][
// 'stockTranList']
// [index2]
//     .stockItems[index3]
//     .price,
// style:
// secondaryTextStyle()),
// ],
// ),
// ),
// ],
// );
// },
// );
// },
// ),
// Divider(),
// Row(
// mainAxisAlignment: MainAxisAlignment.end,
// children: [
// Text('Total : ', style: boldTextStyle()),
// Text(
// ((allTranList[index]['setTotal'] ?? 0) +
// (allTranList[index]['incomeTotal'] ??
// 0))
//     .toString(),
// style: secondaryTextStyle(
// color: Colors.green, size: 15),
// ),
// ],
// )
// ],
// ),
// ),
// Container(
// margin: EdgeInsets.only(left: 16),
// padding:
// EdgeInsets.symmetric(horizontal: 6, vertical: 4),
// decoration: boxDecorationWithRoundedCorners(
// backgroundColor: primaryColor,
// borderRadius: BorderRadius.circular(20),
// ),
// child: Text(
// 'Stock',
// style: TextStyle(color: Colors.white),
// ),
// ),
// ],
// ),
// ),
