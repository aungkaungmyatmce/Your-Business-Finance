import 'package:ybf_sample_version_2/constants/colors.dart';
import 'package:ybf_sample_version_2/model/income.dart';
import 'package:ybf_sample_version_2/screens/in_name/in_name_edit_screen.dart';

import '../../constants/decoration.dart';
import '../../language_change/app_localizations.dart';
import '../../provider/allProvider.dart';
import '../../provider/transaction_provider.dart';
import '../../provider/date_and_tabIndex_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddIncome extends StatefulWidget {
  final DateTime date;
  const AddIncome({Key key, this.date}) : super(key: key);

  @override
  _AddIncomeState createState() => _AddIncomeState();
}

class _AddIncomeState extends State<AddIncome> {
  final _form = GlobalKey<FormState>();
  final _incomeNameController = TextEditingController();
  final _incomeAmountController = TextEditingController();
  final _incomeNoteController = TextEditingController();
  final _incomeCategoryController = TextEditingController();
  final _amountFocusNode = FocusNode();
  final _noteFocusNode = FocusNode();
  bool _isLoading = false;
  List<String> sugNames = [];
  List<String> categoryNames = [];
  List<Income> incomeList = [];
  String _categoryName;

  @override
  void dispose() {
    _incomeNameController.dispose();
    _incomeAmountController.dispose();
    _incomeNoteController.dispose();
    _incomeCategoryController.dispose();
    _amountFocusNode.dispose();
    _noteFocusNode.dispose();
    super.dispose();
  }

  Future<void> _onSave() async {
    final _isValid = _form.currentState.validate();
    if (!_isValid) {
      return;
    }
    _form.currentState.save();
    setState(() {
      _isLoading = true;
    });
    Future.delayed(Duration(seconds: 3), () {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
      });
      Navigator.pop(context);
    });

    await Provider.of<TransactionProvider>(context, listen: false)
        .addIncomeAndExpense(
            name: _incomeNameController.text,
            amount: int.parse(_incomeAmountController.text),
            inCategory: _incomeCategoryController.text,
            note: _incomeNoteController.text.trim().isEmpty
                ? null
                : _incomeNoteController.text.trim(),
            date: widget.date,
            inOrEx: 'in');

    if (!mounted) return;
    setState(() {
      _isLoading = false;
    });
    Navigator.pop(context);
  }

  void addSugNames() {
    //sugNames = Provider.of<TransactionProvider>(context).inSugNames();
    incomeList = Provider.of<AllProvider>(context).allIncome;
    incomeList.forEach((income) {
      if (!sugNames.contains(income.name)) {
        sugNames.add(income.name);
      }
    });
  }

  @override
  void initState() {
    List<String> list =
        Provider.of<AllProvider>(context, listen: false).inCategoryList;
    categoryNames = list;
    _categoryName = categoryNames.first;
    _incomeCategoryController.text = list.first;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    addSugNames();
    return Form(
      key: _form,
      child: ListView(
        children: [
          Container(
            margin: EdgeInsets.only(bottom: 5),
            //padding: EdgeInsets.only(top: 10, bottom: 14, left: 7, right: 7),
            decoration: boxDecorationWithRoundedCorners(
              backgroundColor: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                Stack(
                  children: [
                    SizedBox(
                      height: 60,
                      child: TextFormField(
                        controller: _incomeNameController,
                        decoration: InputDecoration(
                            labelStyle: TextStyle(fontSize: 14),
                            labelText:
                                AppLocalizations.of(context).translate('name')),
                        textInputAction: TextInputAction.next,
                      ),
                    ),
                    Positioned(
                        right: 10,
                        top: 4,
                        child: PopupMenuButton<String>(
                          //enabled: true,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(15.0),
                            ),
                          ),
                          icon: Icon(
                            Icons.expand_more,
                          ),
                          itemBuilder: (context) {
                            List<PopupMenuItem<String>> itemList = [];
                            itemList = sugNames
                                .map((text) => PopupMenuItem<String>(
                                      child: Text(text),
                                      value: text,
                                    ))
                                .toList();
                            itemList.add(PopupMenuItem<String>(
                              child: Text('Add New +',
                                  style: TextStyle(color: primaryColor)),
                              value: '+',
                            ));
                            return itemList;
                          },
                          onSelected: (String text) {
                            if (text == '+') {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => InNameEditScreen(),
                                  ));
                              return;
                            }
                            Income inc = incomeList
                                .firstWhere((inc) => inc.name == text);
                            if (categoryNames.contains(inc.category)) {
                              _categoryName = inc.category;
                            } else {
                              _categoryName = categoryNames.first;
                            }

                            _incomeNameController.text = text;
                            FocusScope.of(context)
                                .requestFocus(_amountFocusNode);
                          },
                        ))
                  ],
                ),
                SizedBox(height: 10),
                SizedBox(
                  height: 60,
                  child: TextFormField(
                    focusNode: _amountFocusNode,
                    controller: _incomeAmountController,
                    decoration: InputDecoration(
                        labelStyle: TextStyle(fontSize: 14),
                        labelText:
                            AppLocalizations.of(context).translate('amount')),
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.next,
                  ),
                ),
                SizedBox(height: 10),
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
                        _incomeCategoryController.text = _categoryName;
                        FocusScope.of(context).requestFocus(_noteFocusNode);
                      });
                    },
                    value: _categoryName,
                  ),
                ),
                SizedBox(height: 10),
                SizedBox(
                  height: 60,
                  child: TextFormField(
                    controller: _incomeNoteController,
                    focusNode: _noteFocusNode,
                    decoration: InputDecoration(
                        labelStyle: TextStyle(fontSize: 14),
                        labelText:
                            AppLocalizations.of(context).translate('note')),
                    textInputAction: TextInputAction.next,
                  ),
                ),
                SizedBox(height: 10),
              ],
            ),
          ),
          SizedBox(height: 10),
          ElevatedButton(
              onPressed: _onSave,
              child: _isLoading
                  ? SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(color: Colors.white),
                    )
                  : Text(AppLocalizations.of(context).translate('save')))
        ],
      ),
    );
  }
}
