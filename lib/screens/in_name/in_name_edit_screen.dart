import 'package:ybf_sample_version_2/model/income.dart';

import '../../language_change/app_localizations.dart';
import '../../constants/colors.dart';
import '../../constants/decoration.dart';
import '../../constants/style.dart';
import '../../provider/allProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class InNameEditScreen extends StatefulWidget {
  final Income income;
  const InNameEditScreen({Key key, this.income}) : super(key: key);

  @override
  _InNameEditScreenState createState() => _InNameEditScreenState();
}

class _InNameEditScreenState extends State<InNameEditScreen> {
  final _inNameController = TextEditingController();
  List<String> categoryNames = [];
  String _categoryName;
  bool _isLoading = false;
  bool _categoryOn = false;

  @override
  void initState() {
    List<String> list =
        Provider.of<AllProvider>(context, listen: false).inCategoryList;
    categoryNames = list;
    if (widget.income != null) {
      _inNameController.text = widget.income.name;
      if (widget.income.category != null) {
        _categoryName = widget.income.category;
        _categoryOn = true;
      }
    }
    super.initState();
  }

  @override
  void dispose() {
    _inNameController.dispose();
    super.dispose();
  }

  Future<void> _onSave() async {
    if (_inNameController.text.isEmpty) {
      return;
    }
    setState(() {
      _isLoading = true;
    });
    await Provider.of<AllProvider>(context, listen: false).addOrEditInNames(
      oldIncome: widget.income,
      newIncome: Income(name: _inNameController.text, category: _categoryName),
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
                          widget.income == null
                              ? AppLocalizations.of(context)
                                  .translate('addNewIncomeName')
                              : AppLocalizations.of(context)
                                  .translate('editIncomeNames'),
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
                      controller: _inNameController,
                      decoration: InputDecoration(
                          labelText: AppLocalizations.of(context)
                              .translate('incomeName')),
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
