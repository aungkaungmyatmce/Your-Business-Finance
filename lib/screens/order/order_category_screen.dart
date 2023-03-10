import '../../constants/colors.dart';
import '../../constants/decoration.dart';
import '../../constants/style.dart';
import 'package:flutter/material.dart';

class OrderCategoryScreen extends StatefulWidget {
  const OrderCategoryScreen({Key key}) : super(key: key);

  @override
  _OrderCategoryScreenState createState() => _OrderCategoryScreenState();
}

class _OrderCategoryScreenState extends State<OrderCategoryScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: primaryColor,
        body: Container(
          //margin: EdgeInsets.only(top: 90),
          decoration: boxDecorationWithRoundedCorners(
              borderRadius: BorderRadius.only(topRight: Radius.circular(50))),
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Padding(
            padding: const EdgeInsets.all(14.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Icon(
                        Icons.arrow_back,
                        color: primaryColor,
                        size: 20,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 6),
                      child: Text(
                        'Items',
                        style: boldTextStyle(size: 20),
                      ),
                    ),
                  ],
                ),
                Divider(thickness: 1),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Category', style: boldTextStyle()),
                    ElevatedButton.icon(
                      onPressed: () {},
                      icon: Icon(Icons.add),
                      label: Text(
                        'Add',
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
