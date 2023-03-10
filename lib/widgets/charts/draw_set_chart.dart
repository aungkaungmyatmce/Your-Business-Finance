import 'dart:math';
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

class DrawSetChart extends StatefulWidget {
  final DateTime date;
  final String shopName;
  const DrawSetChart({Key key, this.date, this.shopName}) : super(key: key);

  @override
  _DrawSetChartState createState() => _DrawSetChartState();
}

class _DrawSetChartState extends State<DrawSetChart> {
  List<SetPerMon> sampleData = [
    SetPerMon('Hamburger', 90, Colors.lightBlue),
    SetPerMon('Kaung', 70, Colors.lightBlue),
    SetPerMon('Khin', 65, Colors.lightBlue),
    SetPerMon('g', 64, Colors.lightBlue),
    SetPerMon('f', 67, Colors.lightBlue),
    SetPerMon('b', 69, Colors.lightBlue),
    SetPerMon('gf', 65, Colors.lightBlue),
    SetPerMon('ghj', 64, Colors.lightBlue),
    SetPerMon('rtr', 67, Colors.lightBlue),
    SetPerMon('op', 69, Colors.lightBlue),
  ];

  List<Map> _sets = [];
  List<SetPerMon> data = [];

  ScrollController _verScrollController = ScrollController();
  ScrollController _horScrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    final _deviceWith = MediaQuery.of(context).size.width;

    _sets = Provider.of<TransactionProvider>(context)
        .setTransactionsForDataTable(
            date: widget.date, addTotalSum: false, shopName: widget.shopName);
    data = _sets
        .map((item) =>
            SetPerMon(item['Name'], int.parse(item['No']), Colors.cyan[900]))
        .toList();

    var series = [
      charts.Series(
        id: 'Sets',
        data: data,
        domainFn: (SetPerMon cus, _) => cus.customerName,
        measureFn: (SetPerMon cus, _) => cus.number,
        colorFn: (SetPerMon cus, _) => cus.color,
      )
    ];

    Widget chart = charts.BarChart(
      series,
      animate: true,
      primaryMeasureAxis: new charts.NumericAxisSpec(
        tickProviderSpec: new charts.BasicNumericTickProviderSpec(
          desiredTickCount: 5,
          desiredMinTickCount: 5,
          desiredMaxTickCount: 5,
        ),
      ),
      defaultRenderer: new charts.BarRendererConfig(
        maxBarWidthPx: 20,
      ),
      domainAxis: new charts.OrdinalAxisSpec(
          renderSpec: new charts.SmallTickRendererSpec(
              labelRotation: 0,
              //minimumPaddingBetweenLabelsPx: 10,
              // Tick and Label styling here.
              labelStyle: new charts.TextStyleSpec(
                  fontSize: 12, // size in Pts.
                  color: charts.MaterialPalette.black),

              // Change the line colors to match text color.
              lineStyle: new charts.LineStyleSpec(
                  color: charts.MaterialPalette.black))),
      behaviors: [
        charts.LinePointHighlighter(
          symbolRenderer: CustomCircleSymbolRenderer(),
        ),
        //new charts.SlidingViewport(),
        //new charts.PanAndZoomBehavior(),
        // charts.ChartTitle('Category',
        //     titleStyleSpec: charts.TextStyleSpec(fontSize: 15),
        //     behaviorPosition: charts.BehaviorPosition.bottom,
        //     titleOutsideJustification:
        //         charts.OutsideJustification.middleDrawArea),
        // charts.ChartTitle('Amount',
        //     titleStyleSpec: charts.TextStyleSpec(fontSize: 15),
        //     behaviorPosition: charts.BehaviorPosition.start,
        //     titleOutsideJustification:
        //         charts.OutsideJustification.middleDrawArea),
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
      child: SingleChildScrollView(
        controller: _verScrollController,
        scrollDirection: Axis.vertical,
        child: SingleChildScrollView(
          controller: _horScrollController,
          scrollDirection: Axis.horizontal,
          child: Column(
            children: [
              Container(
                height: 175,
                width: _sets.length < 5
                    ? _deviceWith
                    : 73 * _sets.length.toDouble(),
                child: chart,
              )
            ],
          ),
        ),
      ),
    );

    if (_sets.length == 0) {
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
