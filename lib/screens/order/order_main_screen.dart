import '../../constants/colors.dart';
import '../../constants/decoration.dart';
import '../../constants/style.dart';
import 'order_category_screen.dart';
import 'package:flutter/material.dart';

class OrderMainScreen extends StatelessWidget {
  const OrderMainScreen({Key key}) : super(key: key);

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
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 6),
                      child: Text(
                        'Order',
                        style: boldTextStyle(size: 20),
                      ),
                    ),
                    Spacer(),
                    Icon(
                      Icons.settings,
                      color: primaryColor,
                      size: 20,
                    ),
                    SizedBox(width: 10)
                  ],
                ),
                Divider(thickness: 1),
                SizedBox(height: 10),
                InkWell(
                  onTap: () {},
                  child: Container(
                    margin: EdgeInsets.only(bottom: 10.0),
                    padding: EdgeInsets.all(12.0),
                    decoration: boxDecorationRoundedWithShadow(8),
                    child: Row(
                      children: [
                        Icon(Icons.article_outlined,
                            size: 24, color: primaryColor),
                        SizedBox(width: 8),
                        Text('Orders',
                            style: secondaryTextStyle(
                                color: Colors.black, size: 16)),
                        Spacer(),
                        Icon(Icons.arrow_forward_ios,
                            color: Colors.grey[300], size: 16),
                      ],
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => OrderCategoryScreen(),
                        ));
                  },
                  child: Container(
                    margin: EdgeInsets.only(bottom: 10.0),
                    padding: EdgeInsets.all(12.0),
                    decoration: boxDecorationRoundedWithShadow(8),
                    child: Row(
                      children: [
                        Icon(Icons.article_outlined,
                            size: 24, color: primaryColor),
                        SizedBox(width: 8),
                        Text('Items',
                            style: secondaryTextStyle(
                                color: Colors.black, size: 16)),
                        Spacer(),
                        Icon(Icons.arrow_forward_ios,
                            color: Colors.grey[300], size: 16),
                      ],
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {},
                  child: Container(
                    margin: EdgeInsets.only(bottom: 10.0),
                    padding: EdgeInsets.all(12.0),
                    decoration: boxDecorationRoundedWithShadow(8),
                    child: Row(
                      children: [
                        Icon(Icons.analytics_outlined,
                            size: 24, color: primaryColor),
                        SizedBox(width: 8),
                        Text('Site',
                            style: secondaryTextStyle(
                                color: Colors.black, size: 16)),
                        Spacer(),
                        Icon(Icons.arrow_forward_ios,
                            color: Colors.grey[300], size: 16),
                      ],
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {},
                  child: Container(
                    margin: EdgeInsets.only(bottom: 10.0),
                    padding: EdgeInsets.all(12.0),
                    decoration: boxDecorationRoundedWithShadow(8),
                    child: Row(
                      children: [
                        Icon(Icons.picture_as_pdf_outlined,
                            size: 24, color: primaryColor),
                        SizedBox(width: 8),
                        Text('History',
                            style: secondaryTextStyle(
                                color: Colors.black, size: 16)),
                        Spacer(),
                        Icon(Icons.arrow_forward_ios,
                            color: Colors.grey[300], size: 16),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
