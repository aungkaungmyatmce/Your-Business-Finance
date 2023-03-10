import '../../constants/colors.dart';
import '../../constants/decoration.dart';
import '../../constants/style.dart';
import '../../language_change/app_localizations.dart';
import '../../model/app_profile.dart';
import '../../provider/allProvider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/services.dart';

class ProductProfileScreen extends StatelessWidget {
  const ProductProfileScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AppProfile profile = Provider.of<AllProvider>(context).appProfile;
    return Scaffold(
        backgroundColor: primaryColor,
        body: Column(
          children: [
            Container(
              height: 80,
              padding: EdgeInsets.only(top: 25, left: 10),
              child: Row(
                children: [
                  InkWell(
                    child: Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                    ),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                  SizedBox(width: 10),
                  Text(
                    'Product Profile',
                    style: boldTextStyle(color: Colors.white, size: 16),
                  ),
                  Spacer(),
                  Icon(
                    Icons.account_circle_outlined,
                    color: Colors.white,
                  ),
                  SizedBox(width: 20),
                ],
              ),
            ),
            Expanded(
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 30, horizontal: 10),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(25),
                        topRight: Radius.circular(25))),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Image.asset(
                        'assets/images/cart.png',
                        width: 60,
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 20),
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: boxDecorationRoundedWithShadow(5),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Row(
                                children: [
                                  Text(
                                    'Product ID   :  ${profile.productId}',
                                    style: secondaryTextStyle(size: 16),
                                  ),
                                  Spacer(),
                                  InkWell(
                                      onTap: () => Clipboard.setData(
                                                  ClipboardData(
                                                      text: profile.productId))
                                              .then((value) {
                                            //only if ->
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(SnackBar(
                                              content: const Text('Copied'),
                                              duration:
                                                  const Duration(seconds: 1),
                                            )); // -> show a notification
                                          }),
                                      child: Icon(
                                        Icons.copy,
                                        size: 18,
                                        color: primaryColor,
                                      ))
                                ],
                              ),
                            ),
                            Divider(),
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Text(
                                'User Name  :  ${profile.userName}',
                                style: secondaryTextStyle(size: 16),
                              ),
                            ),
                            Divider(),
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Text(
                                'Expire Date  :  ${DateFormat.yMMMd().format(profile.expireDate)}',
                                style: secondaryTextStyle(size: 16),
                              ),
                            ),
                            Divider(),
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Text(
                                'App Version :  ${profile.appVersion}',
                                style: secondaryTextStyle(size: 16),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        margin:
                            EdgeInsets.symmetric(vertical: 4, horizontal: 3),
                        padding: EdgeInsets.all(12.0),
                        decoration: boxDecorationRoundedWithShadow(8),
                        child: Column(
                          children: [
                            SizedBox(
                              height: 35,
                              child: ListTile(
                                onTap: () async {
                                  await launch('fb://page/108446008386191',
                                      forceSafariVC: false,
                                      forceWebView: false);
                                },
                                leading: Icon(Icons.phone_android,
                                    size: 24, color: primaryColor),
                                title: Text(
                                    AppLocalizations.of(context)
                                        .translate('contactAppCreator'),
                                    style: secondaryTextStyle(size: 16)),
                                trailing: Icon(Icons.arrow_forward_ios,
                                    color: Colors.grey[300], size: 16),
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 0.0, horizontal: 10.0),
                                visualDensity: VisualDensity(vertical: -3),
                                dense: true,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 30),
                      Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              ' Product of Appnity',
                              style: boldTextStyle(
                                  size: 18, color: Color(0xFF182F3C)),
                            ),
                            SizedBox(width: 10),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.asset(
                                'assets/images/appnity_logo.png',
                                width: 30,
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            )
          ],
        ));
  }
}
