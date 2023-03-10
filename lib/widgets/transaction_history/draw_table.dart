import 'package:flutter/material.dart';
import '../../language_change/app_localizations.dart';

class DrawTable extends StatelessWidget {
  const DrawTable({
    Key key,
    @required this.tableDataList,
  }) : super(key: key);

  final List<Map> tableDataList;

  @override
  Widget build(BuildContext context) {
    return DataTable(
      columnSpacing: 35,
      dividerThickness: 0.000001,
      dataRowHeight: 27,
      headingRowHeight: 25,
      columns: [
        DataColumn(
            label: Text(AppLocalizations.of(context).translate('name'),
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold))),
        DataColumn(
            label: Text(AppLocalizations.of(context).translate('amount'),
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold))),
        if (tableDataList.first['Price'] != null)
          DataColumn(
              label: Text(AppLocalizations.of(context).translate('price'),
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold))),
      ],
      rows: tableDataList.map((data) {
        return DataRow(cells: <DataCell>[
          DataCell(Container(
            width: 130,
            child:
                Text(data['Name'], style: TextStyle(fontSize: 14, height: 1)),
          )),
          DataCell(Container(
            width: 55,
            child: Text(data['No'],
                style: TextStyle(fontSize: 14, color: Colors.black54)),
          )),
          if (data['Price'] != null)
            DataCell(Container(
              width: 55,
              child: Text(data['Price'],
                  style: TextStyle(fontSize: 14, color: Colors.black54)),
            )),
        ]);
      }).toList(),
    );
  }
}
