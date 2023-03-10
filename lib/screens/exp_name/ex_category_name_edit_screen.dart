import '../../language_change/app_localizations.dart';
import '../../constants/colors.dart';
import '../../constants/decoration.dart';
import '../../constants/style.dart';
import '../../provider/allProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ExCategoryNameEditScreen extends StatefulWidget {
  final String exCategoryName;
  const ExCategoryNameEditScreen({Key key, this.exCategoryName})
      : super(key: key);

  @override
  _ExCategoryNameEditScreenState createState() =>
      _ExCategoryNameEditScreenState();
}

class _ExCategoryNameEditScreenState extends State<ExCategoryNameEditScreen> {
  final _exCategoryNameController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    if (widget.exCategoryName != null) {
      _exCategoryNameController.text = widget.exCategoryName;
    }
    super.initState();
  }

  @override
  void dispose() {
    _exCategoryNameController.dispose();
    super.dispose();
  }

  Future<void> _onSave() async {
    print(_exCategoryNameController.text);
    if (_exCategoryNameController.text.isEmpty) {
      return;
    }
    setState(() {
      _isLoading = true;
    });

    await Provider.of<AllProvider>(context, listen: false)
        .addOrEditExCategoryNames(
      oldName: widget.exCategoryName,
      newName: _exCategoryNameController.text,
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
          // margin: EdgeInsets.only(top: 30),
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
                        widget.exCategoryName == null
                            ? AppLocalizations.of(context)
                                .translate('addNewExpenseCategory')
                            : AppLocalizations.of(context)
                                .translate('editExpenseCategory'),
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
                    controller: _exCategoryNameController,
                    decoration: InputDecoration(
                        labelText: AppLocalizations.of(context)
                            .translate('expenseCategory')),
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
