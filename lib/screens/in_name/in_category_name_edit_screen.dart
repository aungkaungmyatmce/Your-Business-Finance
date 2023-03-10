import '../../language_change/app_localizations.dart';
import '../../constants/colors.dart';
import '../../constants/decoration.dart';
import '../../constants/style.dart';
import '../../provider/allProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class InCategoryNameEditScreen extends StatefulWidget {
  final String inCategoryName;
  const InCategoryNameEditScreen({Key key, this.inCategoryName})
      : super(key: key);

  @override
  _InCategoryNameEditScreenState createState() =>
      _InCategoryNameEditScreenState();
}

class _InCategoryNameEditScreenState extends State<InCategoryNameEditScreen> {
  final _inCategoryNameController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    if (widget.inCategoryName != null) {
      _inCategoryNameController.text = widget.inCategoryName;
    }
    super.initState();
  }

  @override
  void dispose() {
    _inCategoryNameController.dispose();
    super.dispose();
  }

  Future<void> _onSave() async {
    print(_inCategoryNameController.text);
    if (_inCategoryNameController.text.isEmpty) {
      return;
    }
    setState(() {
      _isLoading = true;
    });
    print(_inCategoryNameController.text);
    await Provider.of<AllProvider>(context, listen: false)
        .addOrEditInCategoryNames(
      oldName: widget.inCategoryName,
      newName: _inCategoryNameController.text,
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
                        widget.inCategoryName == null
                            ? AppLocalizations.of(context)
                                .translate('addNewIncomeCategory')
                            : AppLocalizations.of(context)
                                .translate('editIncomeCategory'),
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
                    controller: _inCategoryNameController,
                    decoration: InputDecoration(
                        labelText: AppLocalizations.of(context)
                            .translate('incomeCategory')),
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
