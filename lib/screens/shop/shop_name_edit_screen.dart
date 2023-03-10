import '../../language_change/app_localizations.dart';
import '../../constants/colors.dart';
import '../../constants/decoration.dart';
import '../../constants/style.dart';
import '../../provider/allProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ShopNameEditScreen extends StatefulWidget {
  final String shopName;
  const ShopNameEditScreen({Key key, this.shopName}) : super(key: key);

  @override
  _ShopNameEditScreenState createState() => _ShopNameEditScreenState();
}

class _ShopNameEditScreenState extends State<ShopNameEditScreen> {
  final _shopNameController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    if (widget.shopName != null) {
      _shopNameController.text = widget.shopName;
    }
    super.initState();
  }

  @override
  void dispose() {
    _shopNameController.dispose();
    super.dispose();
  }

  Future<void> _onSave() async {
    if (_shopNameController.text.isEmpty) {
      return;
    }
    setState(() {
      _isLoading = true;
    });
    await Provider.of<AllProvider>(context, listen: false).addOrEditShopNames(
      oldName: widget.shopName,
      newName: _shopNameController.text,
    );
    setState(() {
      _isLoading = false;
    });
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: primaryColor,
        body: Container(
          //margin: EdgeInsets.only(top: 30),
          decoration: boxDecorationWithRoundedCorners(
              borderRadius: BorderRadius.only(topRight: Radius.circular(32))),
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Padding(
            padding: const EdgeInsets.all(14.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 6),
                      child: Text(
                        widget.shopName == null
                            ? AppLocalizations.of(context)
                                .translate('addNewShop')
                            : AppLocalizations.of(context)
                                .translate('editShopNames'),
                        style: boldTextStyle(size: 16),
                      ),
                    ),
                    IconButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        icon: Icon(
                          Icons.close,
                          color: primaryColor,
                        )),
                  ],
                ),
                Divider(thickness: 1),
                SizedBox(
                  height: 60,
                  child: TextField(
                    controller: _shopNameController,
                    decoration: InputDecoration(
                        labelText:
                            AppLocalizations.of(context).translate('shopName')),
                    textInputAction: TextInputAction.next,
                  ),
                ),
                SizedBox(height: 30),
                SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                        onPressed: _onSave,
                        child: _isLoading
                            ? SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                    color: Colors.white),
                              )
                            : Text(
                                AppLocalizations.of(context).translate('save'),
                                style: TextStyle(fontSize: 14),
                              ))),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
