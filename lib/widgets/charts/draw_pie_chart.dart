import 'dart:math';
import '../../model/chart_models/income_per_shop.dart';
import '../../constants/colors.dart';
import '../../model/chart_models/set_per_month.dart';
import '../../provider/transaction_provider.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
// ignore: implementation_imports
import 'package:charts_flutter/src/text_element.dart';
// ignore: implementation_imports
import 'package:charts_flutter/src/text_style.dart' as style;
import 'package:provider/provider.dart';

class DrawPieChart extends StatefulWidget {
  @override
  _DrawPieChartState createState() => _DrawPieChartState();
}

class _DrawPieChartState extends State<DrawPieChart> {
  List<Color> colors = [
    Colors.red,
    Colors.green,
    Colors.blue,
    Colors.deepOrange,
    Colors.deepPurple,
    Colors.yellow,
    Colors.red,
    Colors.green,
    Colors.blue,
    Colors.deepOrange,
    Colors.deepPurple,
    Colors.yellow,
    Colors.red,
    Colors.green,
    Colors.blue,
    Colors.deepOrange,
    Colors.deepPurple,
    Colors.yellow,
  ];

  List<Map> _incomes = [];
  List<IncomePerShop> data = [];

  @override
  Widget build(BuildContext context) {
    final _deviceWith = MediaQuery.of(context).size.width;

    _incomes = Provider.of<TransactionProvider>(context).incomePerShop();
    data = _incomes
        .map((item) => IncomePerShop(item['Name'], int.parse(item['Amount']),
            colors[_incomes.indexOf(item)]))
        .toList();

    var series = [
      charts.Series(
        id: 'Income Per Shop',
        data: data,
        domainFn: (IncomePerShop cus, _) => cus.shopName,
        measureFn: (IncomePerShop cus, _) => cus.amount,
        colorFn: (IncomePerShop cus, _) => cus.color,
      )
    ];

    Widget chart = charts.PieChart(
      series,
      animate: true,
      defaultRenderer:
          charts.ArcRendererConfig(arcWidth: 20, arcRendererDecorators: [
        charts.ArcLabelDecorator(labelPosition: charts.ArcLabelPosition.outside)
      ]),
      defaultInteractions: true,
      behaviors: [
        charts.DatumLegend(
          position: charts.BehaviorPosition.bottom,
          desiredMaxColumns: 4,
          legendDefaultMeasure: charts.LegendDefaultMeasure.none,
        ),
      ],
      selectionModels: [
        charts.SelectionModelConfig(
            changedListener: (charts.SelectionModel model) {
          if (model.hasDatumSelection)
            //   print(model.selectedSeries[0]
            //       .measureFn(model.selectedDatum[0].index));
            // print(model.selectedSeries[0].domainFn(model.selectedDatum[0].index));
            CustomCircleSymbolRenderer.setString(model.selectedSeries[0]
                .measureFn(model.selectedDatum[0].index)
                .toStringAsFixed(0));
        })
      ],
    );

    var chartWidget = Padding(
      padding: EdgeInsets.symmetric(horizontal: 5, vertical: 3),
      child: Container(
        height: 175,
        width:
            _incomes.length < 5 ? _deviceWith : 73 * _incomes.length.toDouble(),
        child: chart,
      ),
    );

    if (_incomes.length == 0) {
      return Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Text(
                'No Items added yet!',
                style: TextStyle(color: Colors.black54, fontSize: 25),
              ),
            ),
          ],
        ),
      );
    }

    return chartWidget;
  }
}

class CustomCircleSymbolRenderer extends charts.CircleSymbolRenderer {
  static String amount;
  static void setString(String s) {
    amount = s;
  }

  @override
  void paint(
    charts.ChartCanvas canvas,
    Rectangle<num> bounds, {
    List<int> dashPattern,
    charts.Color fillColor,
    charts.FillPatternType fillPattern,
    charts.Color strokeColor,
    double strokeWidthPx,
  }) {
    super.paint(canvas, bounds,
        dashPattern: dashPattern,
        fillColor: fillColor,
        strokeColor: strokeColor,
        strokeWidthPx: strokeWidthPx);
    canvas.drawRect(
        Rectangle(bounds.left - 10, bounds.top - 30, bounds.width + 30,
            bounds.height + 10),
        fill: charts.Color.transparent);
    var textStyle = style.TextStyle();
    textStyle.color = charts.Color.fromHex(code: '#1C2833');
    textStyle.fontSize = 13;
    canvas.drawText(TextElement('$amount ', style: textStyle),
        (bounds.left + 5).round(), (bounds.top - 15).round());
  }
}
