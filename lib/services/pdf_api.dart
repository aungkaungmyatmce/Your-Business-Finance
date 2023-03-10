import 'dart:io';
import 'package:flutter/services.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';

class PdfApi {
  static Future<File> generate(
      {List<Map<String, dynamic>> allTranList,
      List<Map<String, dynamic>> allTotalList}) async {
    int i = 0;
    final pdf = Document();

    final customFont =
        Font.ttf(await rootBundle.load('assets/fonts/Pyidaungsu.ttf'));

    // final Uint8List fontData =
    //     File('assets/fonts/Pyidaungsu.ttf').readAsBytesSync();
    // final customFont = Font.ttf(fontData.buffer.asByteData());

    // PdfFont f = PdfFontFactory.createFont(
    //     "/fonts/NotoSansMyanmar-Regular.ttf", PdfEncodings.IDENTITY_H, true);

    pdf.addPage(
      MultiPage(
        build: (context) => <Widget>[
          // buildCustomHeader(),
          // SizedBox(height: 0.5 * PdfPageFormat.cm),
          // // Paragraph(
          // //   text:
          // //       'This is my custom font that displays also characters such as €, Ł, ...',
          // //   style: TextStyle(fontSize: 20),
          // // ),
          buildCustomHeadline(),
          // buildLink(),
          // ...buildBulletPoints(),
          // Header(child: Text('My Headline')),
          // Paragraph(text: LoremText().paragraph(60)),
          // Paragraph(text: LoremText().paragraph(60)),
          // Paragraph(text: LoremText().paragraph(60)),
          // Paragraph(text: LoremText().paragraph(60)),
          // Paragraph(text: LoremText().paragraph(60)),
          ListView.separated(
            itemCount: allTranList.length,
            separatorBuilder: (context, index) => Divider(
              thickness: 0.5,
              color: PdfColors.grey600,
              height: 30,
            ),
            itemBuilder: (context, index) {
              if (index > 0 &&
                  allTranList[index]['date'].substring(3) !=
                      allTranList[index - 1]['date'].substring(3)) {
                i += 1;
              }
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (index == 0)
                    Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 6),
                            child: Text(
                              allTranList[index]['date'].substring(3),
                              style: TextStyle(
                                  decoration: TextDecoration.underline,
                                  fontSize: 16,
                                  font: customFont,
                                  color: PdfColors.orange),
                            ),
                          ),
                          SizedBox(height: 5),
                          Text('Total Income: ${allTotalList.first['totalIn']}',
                              style: TextStyle(
                                fontSize: 13,
                                font: customFont,
                              )),
                          SizedBox(height: 5),
                          Text(
                              'Total Expense: ${allTotalList.first['totalEx']}',
                              style: TextStyle(
                                fontSize: 13,
                                font: customFont,
                              )),
                          SizedBox(height: 5),
                        ]),
                  if (index > 0 &&
                      allTranList[index]['date'].substring(3) !=
                          allTranList[index - 1]['date'].substring(3))
                    Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 6),
                            child: Text(
                              allTranList[index]['date'].substring(3),
                              style: TextStyle(
                                  decoration: TextDecoration.underline,
                                  fontSize: 16,
                                  font: customFont,
                                  color: PdfColors.orange),
                            ),
                          ),
                          SizedBox(height: 5),
                          Text('Total Income: ${allTotalList[i]['totalIn']}',
                              style: TextStyle(
                                fontSize: 13,
                                font: customFont,
                              )),
                          SizedBox(height: 5),
                          Text('Total Expense: ${allTotalList[i]['totalEx']}',
                              style: TextStyle(
                                fontSize: 13,
                                font: customFont,
                              )),
                          SizedBox(height: 5),
                        ]),
                  Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      child: Text(
                        allTranList[index]['numDate'],
                      ),
                    ),
                  ]),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        /// Income List
                        if (allTranList[index]['setTranList'].isNotEmpty ||
                            allTranList[index]['incomeTranList'].isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: Column(
                              children: [
                                Text(
                                  'Income',
                                  style: TextStyle(
                                      fontSize: 16,
                                      font: customFont,
                                      color: PdfColors.green),
                                ),
                                SizedBox(height: 10),
                                if (allTranList[index]['setTranList']
                                    .isNotEmpty)
                                  ListView.separated(
                                    itemCount: allTranList[index]['setTranList']
                                        .length,
                                    separatorBuilder: (context, index2) =>
                                        SizedBox(height: 10),
                                    itemBuilder: (context, index2) {
                                      return ListView.separated(
                                        separatorBuilder: (context, index) =>
                                            SizedBox(height: 10),
                                        itemCount: allTranList[index]
                                                ['setTranList'][index2]
                                            .setItems
                                            .length,
                                        itemBuilder: (context, index3) {
                                          return Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Container(
                                                width: 100,
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                      allTranList[index][
                                                                  'setTranList']
                                                              [index2]
                                                          .setItems[index3]
                                                          .name,
                                                      style: TextStyle(
                                                          font: customFont,
                                                          fontStyle:
                                                              FontStyle.normal),
                                                    ),
                                                    Text(
                                                      allTranList[index][
                                                                  'setTranList']
                                                              [index2]
                                                          .setItems[index3]
                                                          .num
                                                          .toString(),
                                                      style: TextStyle(
                                                          font: customFont),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              SizedBox(width: 10),
                                              Container(
                                                width: 110,
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Container(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 4,
                                                              vertical: 1),
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(8),
                                                          border: Border.all(
                                                              color: PdfColors
                                                                  .black)),
                                                      child: Text(
                                                        allTranList[index][
                                                                    'setTranList']
                                                                [index2]
                                                            .shop,
                                                        style: TextStyle(
                                                            fontSize: 10,
                                                            font: customFont),
                                                      ),
                                                    ),
                                                    Text(
                                                      (allTranList[index]['setTranList']
                                                                      [index2]
                                                                  .setItems[
                                                                      index3]
                                                                  .num *
                                                              allTranList[index]
                                                                          [
                                                                          'setTranList']
                                                                      [index2]
                                                                  .setItems[
                                                                      index3]
                                                                  .price)
                                                          .toString(),
                                                      style: TextStyle(
                                                          font: customFont),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    },
                                  ),
                                Container(
                                  width: 220,
                                  child: Divider(),
                                ),
                                Container(
                                    width: 220,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Text(
                                          'Total : ',
                                          style: TextStyle(font: customFont),
                                        ),
                                        Text(
                                          ((allTranList[index]['setTotal'] ??
                                                      0) +
                                                  (allTranList[index]
                                                          ['incomeTotal'] ??
                                                      0))
                                              .toString(),
                                          style: TextStyle(font: customFont),
                                        ),
                                      ],
                                    )),
                              ],
                            ),
                          ),

                        /// Expense List
                        if (allTranList[index]['expenseTranList'].isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: Column(
                              children: [
                                Text(
                                  'Expense',
                                  style: TextStyle(
                                      fontSize: 16,
                                      font: customFont,
                                      color: PdfColors.red),
                                ),
                                SizedBox(height: 10),
                                if (allTranList[index]['expenseTranList']
                                    .isNotEmpty)
                                  ListView.separated(
                                    itemCount: allTranList[index]
                                            ['expenseTranList']
                                        .length,
                                    separatorBuilder: (context, index2) =>
                                        SizedBox(height: 10),
                                    itemBuilder: (context, index2) {
                                      return Container(
                                        width: 220,
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  allTranList[index][
                                                              'expenseTranList']
                                                          [index2]
                                                      .name,
                                                  style: TextStyle(
                                                      font: customFont),
                                                ),
                                                SizedBox(height: 2),
                                                if (allTranList[index][
                                                                'expenseTranList']
                                                            [index2]
                                                        .note !=
                                                    null)
                                                  Text(
                                                    allTranList[index][
                                                                'expenseTranList']
                                                            [index2]
                                                        .note,
                                                    style: TextStyle(
                                                        font: customFont,
                                                        fontSize: 10,
                                                        color:
                                                            PdfColors.grey700),
                                                  )
                                              ],
                                            ),
                                            Text(
                                              allTranList[index]
                                                          ['expenseTranList']
                                                      [index2]
                                                  .amount
                                                  .toString(),
                                              style:
                                                  TextStyle(font: customFont),
                                            )
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                if (allTranList[index]['stockTranList']
                                    .isNotEmpty)
                                  ListView.separated(
                                    itemCount: allTranList[index]
                                            ['stockTranList']
                                        .length,
                                    separatorBuilder: (context, index2) =>
                                        SizedBox(height: 10),
                                    itemBuilder: (context, index2) {
                                      return ListView.separated(
                                        separatorBuilder: (context, index) =>
                                            SizedBox(height: 10),
                                        itemCount: allTranList[index]
                                                ['stockTranList'][index2]
                                            .stockItems
                                            .length,
                                        itemBuilder: (context, index3) {
                                          if (allTranList[index]
                                                      ['stockTranList'][index2]
                                                  .addOrSub ==
                                              'sub') {
                                            return Container();
                                          }
                                          return Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Container(
                                                width: 100,
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
                                                      style: TextStyle(
                                                          font: customFont),
                                                    ),
                                                    Text(
                                                      '${allTranList[index]['stockTranList'][index2].stockItems[index3].num} ${allTranList[index]['stockTranList'][index2].stockItems[index3].unit}',
                                                      style: TextStyle(
                                                          font: customFont),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              SizedBox(width: 10),
                                              Container(
                                                width: 110,
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.end,
                                                  children: [
                                                    Text(
                                                      allTranList[index][
                                                                  'stockTranList']
                                                              [index2]
                                                          .stockItems[index3]
                                                          .total
                                                          .toString(),
                                                      style: TextStyle(
                                                          font: customFont),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    },
                                  ),
                                Container(width: 220, child: Divider()),
                                Container(
                                    width: 220,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Text(
                                          'Total : ',
                                          style: TextStyle(font: customFont),
                                        ),
                                        Text(
                                          ((allTranList[index][
                                                              'expenseTotal'] ??
                                                          0) +
                                                      allTranList[index]
                                                          ['stockTotal'] ??
                                                  0)
                                              .toString(),
                                          style: TextStyle(font: customFont),
                                        ),
                                      ],
                                    )),
                              ],
                            ),
                          ),
                      ]),
                ],
              );
            },
          ),
        ],
        footer: (context) {
          final text = 'Page ${context.pageNumber} of ${context.pagesCount}';

          return Container(
            alignment: Alignment.centerRight,
            margin: EdgeInsets.only(top: 1 * PdfPageFormat.cm),
            child: Text(
              text,
              style: TextStyle(color: PdfColors.black),
            ),
          );
        },
      ),
    );
    return PdfApi.saveDocument(name: 'my_example.pdf', pdf: pdf);
  }

  static Future<File> saveDocument({
    String name,
    Document pdf,
  }) async {
    final bytes = await pdf.save();

    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/$name');

    await file.writeAsBytes(bytes);

    return file;
  }

  static Future openFile(File file) async {
    final url = file.path;

    await OpenFile.open(url);
  }

  static Widget buildCustomHeader() => Container(
        padding: EdgeInsets.only(bottom: 3 * PdfPageFormat.mm),
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(width: 2, color: PdfColors.blue)),
        ),
        child: Row(
          children: [
            PdfLogo(),
            SizedBox(width: 0.5 * PdfPageFormat.cm),
            Text(
              'Create Your PDF',
              style: TextStyle(fontSize: 20, color: PdfColors.blue),
            ),
          ],
        ),
      );

  static Widget buildCustomHeadline() => Header(
        child: Center(
            child: Text(
          'Transaction History',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: PdfColors.white,
          ),
        )),
        padding: EdgeInsets.all(4),
        decoration: BoxDecoration(color: PdfColors.orange),
      );

  static Widget buildLink() => UrlLink(
        destination: 'https://flutter.dev',
        child: Text(
          'Go to flutter.dev',
          style: TextStyle(
            decoration: TextDecoration.underline,
            color: PdfColors.blue,
          ),
        ),
      );

  static List<Widget> buildBulletPoints() => [
        Bullet(text: 'First Bullet'),
        Bullet(text: 'Second Bullet'),
        Bullet(text: 'Third Bullet'),
      ];
}
