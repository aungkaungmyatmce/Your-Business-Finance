import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';

class SetPerMon {
  final String customerName;
  final int number;
  final charts.Color color;

  SetPerMon(this.customerName, this.number, Color color)
      : this.color = new charts.Color(
            r: color.red, g: color.green, b: color.blue, a: color.alpha);
}
