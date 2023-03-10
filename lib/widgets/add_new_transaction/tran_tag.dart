import '../../constants/decoration.dart';
import 'package:flutter/material.dart';

class TranTag extends StatelessWidget {
  final String title;
  final Color textColor;
  final Color backColor;
  final Function onTap;

  const TranTag({
    Key key,
    this.title,
    this.textColor,
    this.backColor,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 100,
        padding: EdgeInsets.symmetric(horizontal: 7, vertical: 5),
        decoration: boxDecorations(bgColor: backColor, radius: 15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icon(
            //   Icons.date_range,
            //   color: textColor,
            //   size: 17,
            // ),
            // SizedBox(width: 2),
            Text(
              title,
              style: TextStyle(
                //height: 1.4,
                color: textColor,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
