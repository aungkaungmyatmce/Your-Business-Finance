import '../exp_name/ex_category_names_screen.dart';
import '../in_name/in_category_names_screen.dart';
import '../../language_change/app_localizations.dart';
import '../change_language_screen.dart';
import '../in_name/in_names_screen.dart';
import '../product_profile_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../constants/colors.dart';
import '../../constants/decoration.dart';
import '../../constants/style.dart';
import '../create_pdf_screen.dart';
import '../exp_name/exp_names_screen.dart';
import '../set/set_overview_screen.dart';
import '../shop/shop_names_screen.dart';
import 'package:flutter/material.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: primaryColor,
        body: Container(
          //margin: EdgeInsets.only(top: 90),
          decoration: boxDecorationWithRoundedCorners(
              borderRadius: BorderRadius.only(topRight: Radius.circular(32))),
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 6),
                        child: Text(
                          AppLocalizations.of(context).translate('setting'),
                          style: boldTextStyle(size: 16, height: 1),
                        ),
                      ),
                      Spacer(),
                      Container(
                          padding: EdgeInsets.all(6),
                          decoration: boxDecorationWithRoundedCorners(
                            boxShape: BoxShape.circle,
                            border:
                                Border.all(color: Colors.grey.withOpacity(0.3)),
                          ),
                          child: Icon(Icons.settings,
                              color: primaryColor, size: 20)),
                      //SizedBox(width: 10)
                    ],
                  ),
                ),
                Expanded(
                  child: ListView(
                    children: [
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
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ShopNamesScreen(),
                                      ));
                                },
                                leading: Icon(Icons.store_outlined,
                                    size: 24, color: primaryColor),
                                title: Text(
                                    AppLocalizations.of(context)
                                        .translate('shopNames'),
                                    style: secondaryTextStyle(
                                        color: Colors.black87, size: 16)),
                                trailing: Icon(Icons.arrow_forward_ios,
                                    color: Colors.grey[300], size: 16),
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 0.0, horizontal: 10.0),
                                visualDensity: VisualDensity(vertical: -3),
                                dense: true,
                              ),
                            ),
                            Divider(),
                            SizedBox(
                              height: 35,
                              child: ListTile(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => InNamesScreen(),
                                      ));
                                },
                                leading: SizedBox(
                                  width: 35,
                                  child: Stack(
                                    alignment: Alignment.centerLeft,
                                    children: [
                                      Positioned(
                                        right: 5,
                                        child: Icon(
                                            Icons
                                                .account_balance_wallet_outlined,
                                            size: 20,
                                            color: primaryColor),
                                      ),
                                      Positioned(
                                        right: 20,
                                        child: Icon(Icons.arrow_forward,
                                            size: 20, color: primaryColor),
                                      ),
                                    ],
                                  ),
                                ),
                                title: Text(
                                    AppLocalizations.of(context)
                                        .translate('incomeNames'),
                                    style: secondaryTextStyle(
                                        color: Colors.black87, size: 16)),
                                trailing: Icon(Icons.arrow_forward_ios,
                                    color: Colors.grey[300], size: 16),
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 0.0, horizontal: 10.0),
                                visualDensity: VisualDensity(vertical: -3),
                                dense: true,
                              ),
                            ),
                            Divider(),
                            SizedBox(
                              height: 35,
                              child: ListTile(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            InCategoryNamesScreen(),
                                      ));
                                },
                                leading: SizedBox(
                                  width: 35,
                                  child: Stack(
                                    alignment: Alignment.centerLeft,
                                    children: [
                                      Positioned(
                                        right: 5,
                                        child: Icon(Icons.category_outlined,
                                            size: 20, color: primaryColor),
                                      ),
                                      Positioned(
                                        right: 20,
                                        child: Icon(Icons.arrow_forward,
                                            size: 20, color: primaryColor),
                                      ),
                                    ],
                                  ),
                                ),
                                title: Text(
                                    AppLocalizations.of(context)
                                        .translate('incomeCategories'),
                                    style: secondaryTextStyle(
                                        color: Colors.black87, size: 16)),
                                trailing: Icon(Icons.arrow_forward_ios,
                                    color: Colors.grey[300], size: 16),
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 0.0, horizontal: 10.0),
                                visualDensity: VisualDensity(vertical: -3),
                                dense: true,
                              ),
                            ),
                            Divider(),
                            SizedBox(
                              height: 35,
                              child: ListTile(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ExpNamesScreen(),
                                      ));
                                },
                                leading: SizedBox(
                                  width: 35,
                                  child: Stack(
                                    alignment: Alignment.centerLeft,
                                    children: [
                                      Positioned(
                                        right: 17,
                                        child: Icon(
                                            Icons
                                                .account_balance_wallet_outlined,
                                            size: 20,
                                            color: primaryColor),
                                      ),
                                      Positioned(
                                        right: 5,
                                        child: Icon(Icons.arrow_forward,
                                            size: 20, color: primaryColor),
                                      ),
                                    ],
                                  ),
                                ),
                                title: Text(
                                    AppLocalizations.of(context)
                                        .translate('expenseNames'),
                                    style: secondaryTextStyle(
                                        color: Colors.black87, size: 16)),
                                trailing: Icon(Icons.arrow_forward_ios,
                                    color: Colors.grey[300], size: 16),
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 0.0, horizontal: 10.0),
                                visualDensity: VisualDensity(vertical: -3),
                                dense: true,
                              ),
                            ),
                            Divider(),
                            SizedBox(
                              height: 35,
                              child: ListTile(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            ExCategoryNamesScreen(),
                                      ));
                                },
                                leading: SizedBox(
                                  width: 35,
                                  child: Stack(
                                    alignment: Alignment.centerLeft,
                                    children: [
                                      Positioned(
                                        right: 17,
                                        child: Icon(Icons.category_outlined,
                                            size: 20, color: primaryColor),
                                      ),
                                      Positioned(
                                        right: 5,
                                        child: Icon(Icons.arrow_forward,
                                            size: 20, color: primaryColor),
                                      ),
                                    ],
                                  ),
                                ),
                                title: Text(
                                    AppLocalizations.of(context)
                                        .translate('expenseCategories'),
                                    style: secondaryTextStyle(
                                        color: Colors.black87, size: 16)),
                                trailing: Icon(Icons.arrow_forward_ios,
                                    color: Colors.grey[300], size: 16),
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 0.0, horizontal: 10.0),
                                visualDensity: VisualDensity(vertical: -3),
                                dense: true,
                              ),
                            ),
                            Divider(),
                            SizedBox(
                              height: 35,
                              child: ListTile(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            SetOverviewScreen(),
                                      ));
                                },
                                leading: Icon(Icons.analytics_outlined,
                                    size: 24, color: primaryColor),
                                title: Text(
                                    AppLocalizations.of(context)
                                        .translate('productNames'),
                                    style: secondaryTextStyle(
                                        color: Colors.black87, size: 16)),
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
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => CreatePdfScreen(),
                                      ));
                                },
                                leading: Icon(Icons.picture_as_pdf_outlined,
                                    size: 24, color: primaryColor),
                                title: Text(
                                    AppLocalizations.of(context)
                                        .translate('generatePdf'),
                                    style: secondaryTextStyle(
                                        color: Colors.black87, size: 16)),
                                trailing: Icon(Icons.arrow_forward_ios,
                                    color: Colors.grey[300], size: 16),
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 0.0, horizontal: 10.0),
                                visualDensity: VisualDensity(vertical: -3),
                                dense: true,
                              ),
                            ),
                            Divider(),
                            SizedBox(
                              height: 35,
                              child: ListTile(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            ChangeLanguageScreen(),
                                      ));
                                },
                                leading: Icon(Icons.language,
                                    size: 24, color: primaryColor),
                                title: Text(
                                    AppLocalizations.of(context)
                                        .translate('changeLanguage'),
                                    style: secondaryTextStyle(
                                        color: Colors.black87, size: 16)),
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
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            ProductProfileScreen(),
                                      ));
                                },
                                leading: Icon(Icons.developer_mode,
                                    size: 24,
                                    color: primaryColor.withOpacity(0.8)),
                                title: Text(
                                    AppLocalizations.of(context)
                                        .translate('aboutTheApp'),
                                    style: secondaryTextStyle(
                                        color: Colors.black87, size: 16)),
                                trailing: Icon(Icons.arrow_forward_ios,
                                    color: Colors.grey[300], size: 16),
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 0.0, horizontal: 10.0),
                                visualDensity: VisualDensity(vertical: -3),
                                dense: true,
                              ),
                            ),
                            Divider(),
                            SizedBox(
                              height: 35,
                              child: ListTile(
                                onTap: () async {
                                  showDialog(
                                    context: context,
                                    builder: (ctx) => AlertDialog(
                                      title: Text('Are you sure?'),
                                      content: Text('Do you want to log out ?'),
                                      actions: <Widget>[
                                        TextButton(
                                          child: Text('No'),
                                          onPressed: () async {
                                            Navigator.of(context).pop(false);
                                          },
                                        ),
                                        TextButton(
                                          child: Text('Yes'),
                                          onPressed: () async {
                                            FirebaseAuth.instance.signOut();
                                            Navigator.of(context).pop(true);
                                          },
                                        ),
                                      ],
                                    ),
                                  );
                                },
                                leading: Icon(Icons.logout,
                                    size: 24,
                                    color: primaryColor.withOpacity(0.8)),
                                title: Text(
                                    AppLocalizations.of(context)
                                        .translate('logOut'),
                                    style: secondaryTextStyle(
                                        color: Colors.black87, size: 16)),
                                trailing: Icon(Icons.logout,
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
                    ],
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
