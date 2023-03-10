import 'package:ybf_sample_version_2/constants/colors.dart';
import 'package:ybf_sample_version_2/model/expense.dart';
import 'package:ybf_sample_version_2/screens/exp_name/exp_name_edit_screen.dart';

import '../../constants/decoration.dart';
import '../../language_change/app_localizations.dart';
import '../../provider/allProvider.dart';
import '../../provider/date_and_tabIndex_provider.dart';
import '../../provider/transaction_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddExpense extends StatefulWidget {
  final DateTime date;
  const AddExpense({Key key, this.date}) : super(key: key);

  @override
  _AddExpenseState createState() => _AddExpenseState();
}

class _AddExpenseState extends State<AddExpense> {
  final _form = GlobalKey<FormState>();
  var _expenseNameController = TextEditingController();
  var _expenseAmountController = TextEditingController();
  var _expenseNoteController = TextEditingController();
  final _expenseCategoryController = TextEditingController();
  final _amountFocusNode = FocusNode();
  final _noteFocusNode = FocusNode();
  bool _isLoading = false;
  List<String> sugNames = [];
  List<String> categoryNames = [];
  List<Expense> expenseList = [];
  String _categoryName;

  @override
  void initState() {
    List<String> list =
        Provider.of<AllProvider>(context, listen: false).exCategoryList;
    categoryNames = list;
    _categoryName = categoryNames.first;
    _expenseCategoryController.text = _categoryName;
    super.initState();
  }

  void addSugNames() {
    //sugNames = Provider.of<TransactionProvider>(context).expSugNames();
    expenseList = Provider.of<AllProvider>(context).allExpense;
    expenseList.forEach((expense) {
      if (!sugNames.contains(expense.name)) {
        sugNames.add(expense.name);
      }
    });
  }

  @override
  void dispose() {
    _expenseNameController.dispose();
    _expenseAmountController.dispose();
    _expenseNoteController.dispose();
    _amountFocusNode.dispose();
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
            name: _expenseNameController.text,
            amount: int.parse(_expenseAmountController.text),
            exCategory: _expenseCategoryController.text,
            note: _expenseNoteController.text.trim().isEmpty
                ? null
                : _expenseNoteController.text.trim(),
            date: widget.date,
            inOrEx: 'ex');

    if (!mounted) return;
    setState(() {
      _isLoading = false;
    });
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    addSugNames();
    return Form(
      key: _form,
      child: Container(
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
                          controller: _expenseNameController,
                          decoration: InputDecoration(
                            labelStyle: TextStyle(fontSize: 14),
                            labelText:
                                AppLocalizations.of(context).translate('name'),
                          ),
                          textInputAction: TextInputAction.next,
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please fill this field';
                            }
                            return null;
                          },
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
                                      builder: (context) => ExpNameEditScreen(),
                                    ));
                                return;
                              }

                              Expense exp = expenseList.firstWhere(
                                  (exp) => exp.name == text,
                                  orElse: () => null);
                              if (categoryNames.contains(exp.category)) {
                                _categoryName = exp.category;
                              } else {
                                _categoryName = categoryNames.first;
                              }
                              _expenseNameController.text = text;
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
                      controller: _expenseAmountController,
                      decoration: InputDecoration(
                        labelStyle: TextStyle(fontSize: 14),
                        labelText:
                            AppLocalizations.of(context).translate('amount'),
                      ),
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please fill this field';
                        }
                        return null;
                      },
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
                          _expenseCategoryController.text = _categoryName;
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
                      controller: _expenseNoteController,
                      focusNode: _noteFocusNode,
                      decoration: InputDecoration(
                        labelStyle: TextStyle(fontSize: 14),
                        labelText:
                            AppLocalizations.of(context).translate('note'),
                      ),
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
      ),
    );
  }
}
