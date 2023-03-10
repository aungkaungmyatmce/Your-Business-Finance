import 'package:flutter/material.dart';

class IndicatorBar extends StatelessWidget {
  final String minValue;
  final String curValue;
  const IndicatorBar({@required this.minValue, @required this.curValue});

  @override
  Widget build(BuildContext context) {
    var minContWidth;
    var curContWidth;
    double minVal = int.parse(minValue).toDouble();
    double curVal = int.parse(curValue).toDouble();

    if (minVal / curVal > 0.142) {
      minContWidth = 25;
      curContWidth = (25 * curVal / minVal);
    } else {
      curContWidth = 165;
      minContWidth = (165 * minVal / curVal);
    }

    return Container(
      height: 50,
      width: 165,
      child: Stack(
        alignment: Alignment.topLeft,
        children: [
          Positioned(
            top: 2,
            left: 0,
            child: Container(
              width: curContWidth.toDouble(),
              height: 15,
              decoration: BoxDecoration(
                color: curVal >= minVal ? Colors.green : Colors.red,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          if (curVal >= minVal)
            Positioned(
              top: 2,
              left: 0,
              child: Container(
                width: minContWidth.toDouble(),
                height: 15,
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    bottomLeft: Radius.circular(10),
                  ),
                ),
              ),
            ),
          if (curVal > minVal)
            Positioned(
                top: 20,
                left: (curVal / minVal) <= 2
                    ? minContWidth.toDouble() - 20
                    : minContWidth.toDouble() - 7,
                child: Text(
                  minValue,
                  style: TextStyle(color: Colors.red),
                )),
          //if (int.parse(curValue) < int.parse(minValue))
          Positioned(
              top: 20,
              left: (curVal / minVal) < 2
                  ? curContWidth.toDouble() - 1
                  : curContWidth.toDouble() - 22,
              child: Text(
                curValue,
                style: TextStyle(color: Colors.green),
              ))
        ],
      ),
    );
  }
}
