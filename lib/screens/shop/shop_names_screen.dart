import '../../language_change/app_localizations.dart';
import '../../services/ui_helper.dart';
import '../../constants/colors.dart';
import '../../constants/decoration.dart';
import '../../constants/style.dart';
import '../../provider/allProvider.dart';
import 'shop_name_edit_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ShopNamesScreen extends StatefulWidget {
  const ShopNamesScreen({Key key}) : super(key: key);

  @override
  _ShopNamesScreenState createState() => _ShopNamesScreenState();
}

class _ShopNamesScreenState extends State<ShopNamesScreen> {
  bool _isLoading = false;

  Future<void> _showDialog(String shopName) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: new Text("Confirm delete"),
              content: Text("Are you sure ?"),
              actions: <Widget>[
                new TextButton(
                  child: _isLoading
                      ? SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator())
                      : new Text("Yes"),
                  onPressed: () async {
                    setState(() {
                      _isLoading = true;
                    });
                    await Provider.of<AllProvider>(context, listen: false)
                        .deleteShopName(shopName: shopName);
                    setState(() {
                      _isLoading = false;
                    });
                    Navigator.of(context).pop(true);
                  },
                ),
                new TextButton(
                  child: new Text("No"),
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    List<String> shopList = Provider.of<AllProvider>(context).allShop;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
            title: Text(
          AppLocalizations.of(context).translate('shopNames'),
          style: boldTextStyle(size: 16, color: Colors.white),
        )),
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                      child: ListView.separated(
                        separatorBuilder: (context, index) =>
                            SizedBox(height: 3),
                        itemCount: shopList.length,
                        itemBuilder: (context, index) {
                          return Container(
                              //height: 150,
                              margin: EdgeInsets.all(3),
                              padding: EdgeInsets.all(10),
                              decoration: boxDecorationRoundedWithShadow(10),
                              child: Row(
                                children: [
                                  Text(
                                    '${index + 1}. ${shopList[index]}',
                                    style: boldTextStyle(),
                                  ),
                                  Spacer(),
                                  IconButton(
                                      onPressed: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  ShopNameEditScreen(
                                                      shopName:
                                                          shopList[index]),
                                            ));
                                      },
                                      icon: Icon(
                                        Icons.edit,
                                        color: Colors.green,
                                      )),
                                  IconButton(
                                      onPressed: () async {
                                        if (shopList.length <= 1) {
                                          UIHelper.showSuccessFlushbar(context,
                                              'At least one shop name must have',
                                              icon: Icons.clear_rounded);
                                        } else {
                                          _showDialog(shopList[index]);
                                        }
                                      },
                                      icon: Icon(
                                        Icons.delete,
                                        color: Colors.red,
                                      )),
                                ],
                              ));
                        },
                      ),
                    ),
                    SizedBox(height: 60),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ShopNameEditScreen(),
                              ));
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Text(
                            AppLocalizations.of(context)
                                .translate('addNewShop'),
                            style: primaryTextStyle(
                                size: 14, height: 0.8, color: Colors.white),
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          shape: new RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(10.0),
                          ),
                        ),
                      ),
                    ),
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
