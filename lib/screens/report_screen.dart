import 'package:intl/intl.dart';

import '../../constants/colors.dart';
import '../../language_change/app_localizations.dart';
import '../../provider/transaction_provider.dart';
import '../../widgets/charts/draw_pie_chart.dart';
import 'package:provider/provider.dart';

import '../constants/style.dart';
import '../widgets/charts/draw_set_chart.dart';
import 'package:flutter/material.dart';

class ReportScreen extends StatefulWidget {
  final DateTime date;
  final String shopName;
  const ReportScreen({Key key, this.date, this.shopName}) : super(key: key);

  @override
  _ReportScreenState createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  @override
  Widget build(BuildContext context) {
    List<Map> tableDataList =
        Provider.of<TransactionProvider>(context).incomePerShop();
    return Scaffold(
      appBar: AppBar(
        title: Text('Report', style: boldTextStyle(color: Colors.white)),
        actions: [
          Padding(
            padding: const EdgeInsets.only(top: 20, right: 30),
            child: Text('${DateFormat.yMMM().format(widget.date)}',
                style: boldTextStyle(color: Colors.white)),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 10),
            Text(
              widget.shopName,
              style: boldTextStyle(size: 16),
            ),
            DrawSetChart(
              date: widget.date,
              shopName: widget.shopName,
            ),
            SizedBox(height: 10),
            DrawPieChart(),
            SizedBox(height: 10),
            Divider(
              thickness: 1.5,
              indent: 20,
              endIndent: 20,
            ),
            DataTable(
              columnSpacing: 35,
              dividerThickness: 0.00000001,
              dataRowHeight: 27,
              headingRowHeight: 25,
              columns: [
                DataColumn(
                    label: Text(AppLocalizations.of(context).translate('name'),
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.bold))),
                DataColumn(
                    label: Text(
                        AppLocalizations.of(context).translate('amount'),
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.bold))),
              ],
              rows: tableDataList.map((data) {
                return DataRow(
                    color: MaterialStateProperty.resolveWith<Color>(
                        (Set<MaterialState> states) {
                      // Even rows will have a grey color.
                      if (tableDataList.indexOf(data) % 2 == 0) {
                        return primaryColor.withOpacity(0.4);
                      } else {
                        return null;
                      }
                      // Use default value for other states and odd rows.
                    }),
                    cells: <DataCell>[
                      DataCell(Container(
                        width: 120,
                        child: Text(data['Name'],
                            style: TextStyle(fontSize: 14, height: 1)),
                      )),
                      DataCell(Container(
                        width: 55,
                        child: Text(data['Amount'],
                            style:
                                TextStyle(fontSize: 14, color: Colors.black54)),
                      )),
                    ]);
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
