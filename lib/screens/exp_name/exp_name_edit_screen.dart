import 'package:ybf_sample_version_2/model/expense.dart';

import '../../language_change/app_localizations.dart';
import '../../constants/colors.dart';
import '../../constants/decoration.dart';
import '../../constants/style.dart';
import '../../provider/allProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ExpNameEditScreen extends StatefulWidget {
  final Expense expense;
  const ExpNameEditScreen({Key key, this.expense}) : super(key: key);

  @override
  _ExpNameEditScreenState createState() => _ExpNameEditScreenState();
}

class _ExpNameEditScreenState extends State<ExpNameEditScreen> {
  final _expNameController = TextEditingController();
  List<String> categoryNames = [];
  String _categoryName;
  bool _isLoading = false;
  bool _categoryOn = false;

  @override
  void initState() {
    List<String> list =
        Provider.of<AllProvider>(context, listen: false).exCategoryList;
    categoryNames = list;
    if (widget.expense != null) {
      _expNameController.text = widget.expense.name;
      if (widget.expense.category != null) {
        _categoryName = widget.expense.category;
        _categoryOn = true;
      }
    }
    super.initState();
  }

  @override
  void dispose() {
    _expNameController.dispose();
    super.dispose();
  }

  Future<void> _onSave() async {
    if (_expNameController.text.isEmpty) {
      return;
    }
    setState(() {
      _isLoading = true;
    });
    await Provider.of<AllProvider>(context, listen: false).addOrEditExpNames(
      oldExpense: widget.expense,
      newExpense:
          Expense(name: _expNameController.text, category: _categoryName),
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
          child: SingleChildScrollView(
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
                          widget.expense == null
                              ? AppLocalizations.of(context)
                                  .translate('addNewExpenseName')
                              : AppLocalizations.of(context)
                                  .translate('editExpenseNames'),
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
                      controller: _expNameController,
                      decoration: InputDecoration(
                          labelText: AppLocalizations.of(context)
                              .translate('expenseName')),
                      textInputAction: TextInputAction.next,
                    ),
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                          AppLocalizations.of(context).translate('addCategory'),
                          style: boldTextStyle(size: 14)),
                      Switch(
                        value: _categoryOn,
                        onChanged: (value) {
                          if (value) {
                            _categoryName = categoryNames.first;
                          } else {
                            _categoryName = null;
                          }
                          setState(() {
                            _categoryOn = value;
                          });
                        },
                        activeTrackColor: Colors.orange.withOpacity(0.5),
                        activeColor: primaryColor,
                      ),
                    ],
                  ),
                  if (_categoryOn)
                    Container(
                      height: 60,
                      child: DropdownButtonFormField(
                        isDense: false,
                        itemHeight: 60,
                        decoration: InputDecoration(
                            contentPadding: EdgeInsets.fromLTRB(0, 5.5, 0, 0),
                            labelStyle: TextStyle(fontSize: 14),
                            labelText: 'Category'),
                        isExpanded: true,
                        items: categoryNames.map((String name) {
                          return DropdownMenuItem(
                              value: name,
                              child: Text(
                                name,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 14,
                                ),
                              ));
                        }).toList(),
                        onChanged: (newValue) {
                          // do other stuff with _category
                          setState(() {
                            _categoryName = newValue;
                          });
                        },
                        value: _categoryName,
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
                                  AppLocalizations.of(context)
                                      .translate('save'),
                                  style: TextStyle(fontSize: 14),
                                ))),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
