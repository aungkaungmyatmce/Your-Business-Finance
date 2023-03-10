import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';

class IncomePerShop {
  final String shopName;
  final int amount;
  final charts.Color color;

  IncomePerShop(this.shopName, this.amount, Color color)
      : this.color = new charts.Color(
            r: color.red, g: color.green, b: color.blue, a: color.alpha);
}
