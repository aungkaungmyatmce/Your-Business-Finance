import '../../language_change/app_localizations.dart';
import '../../constants/colors.dart';
import '../../constants/decoration.dart';
import '../../constants/style.dart';
import '../../model/stock_transaction.dart';
import '../../provider/allProvider.dart';
import '../../provider/date_and_tabIndex_provider.dart';
import '../../provider/transaction_provider.dart';
import 'tran_tag.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class AddStock extends StatefulWidget {
  final DateTime date;
  const AddStock({Key key, this.date}) : super(key: key);

  @override
  _AddStockState createState() => _AddStockState();
}

class _AddStockState extends State<AddStock> {
  final _formKey = GlobalKey<FormState>();
  List<TextEditingController> _nameController = [
    for (int i = 0; i < 5; i++) TextEditingController()
  ];
  List<TextEditingController> _amountController = [
    for (int i = 0; i < 5; i++) TextEditingController()
  ];
  List<TextEditingController> _priceController = [
    for (int i = 0; i < 5; i++) TextEditingController()
  ];
  List<TextEditingController> _unitController = [
    for (int i = 0; i < 5; i++) TextEditingController()
  ];
  List<TextEditingController> _stockUnitController = [
    for (int i = 0; i < 5; i++) TextEditingController()
  ];
  List<TextEditingController> _useUnitController = [
    for (int i = 0; i < 5; i++) TextEditingController()
  ];
  List<TextEditingController> _unitRatioController = [
    for (int i = 0; i < 5; i++) TextEditingController()
  ];
  List<TextEditingController> _totalController = [
    for (int i = 0; i < 5; i++) TextEditingController()
  ];

  String shopDropdownValue;
  String setDropDownValue;
  int setNum = 1;
  bool _isAdd = false;
  bool _isLoading = false;

  @override
  void dispose() {
    for (int i = 0; i < _nameController.length; i++) {
      _nameController[i].dispose();
    }
    for (int i = 0; i < _amountController.length; i++) {
      _amountController[i].dispose();
    }
    for (int i = 0; i < _priceController.length; i++) {
      _priceController[i].dispose();
    }
    for (int i = 0; i < _unitController.length; i++) {
      _unitController[i].dispose();
    }
    for (int i = 0; i < _stockUnitController.length; i++) {
      _stockUnitController[i].dispose();
    }
    for (int i = 0; i < _useUnitController.length; i++) {
      _useUnitController[i].dispose();
    }
    for (int i = 0; i < _unitRatioController.length; i++) {
      _unitRatioController[i].dispose();
    }
    for (int i = 0; i < _totalController.length; i++) {
      _totalController[i].dispose();
    }
    super.dispose();
  }

  Future<void> _onSave() async {
    List<StockTransactionItem> stockItems = [];
    for (int i = 0; i < setNum; i++) {
      if (_amountController[i].text.isNotEmpty) {
        stockItems.add(StockTransactionItem(
          name: _nameController[i].text,
          num: int.parse(_amountController[i].text),
          price: int.parse(_priceController[i].text) ?? 0,
          unit: _unitController[i].text,
          stockUnit: _stockUnitController[i].text,
          useUnit: _useUnitController[i].text,
          unitRatio: _unitRatioController[i].text,
          total: int.parse(_totalController[i].text) ?? 0,
        ));
      }
    }
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

    if (stockItems.isNotEmpty) {
      Provider.of<TransactionProvider>(context, listen: false).addStock(
          stockItems: stockItems,
          isAdd: _isAdd,
          date: widget.date,
          isReAdd: false);
      await Provider.of<AllProvider>(context, listen: false)
          .addToStockByStockTran(items: stockItems, isAdd: _isAdd);
    }

    if (!mounted) return;
    setState(() {
      _isLoading = false;
    });
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                //shrinkWrap: true,
                children: [
                  SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      TranTag(
                        title: AppLocalizations.of(context).translate('use'),
                        textColor: _isAdd ? Colors.grey : primaryColor,
                        backColor: _isAdd
                            ? Colors.grey.withOpacity(0.2)
                            : primaryColor.withOpacity(0.3),
                        onTap: () {
                          setState(() {
                            _isAdd = false;
                            for (int i = 0; i < setNum; i++) {
                              //_nameController[i].text = '';
                              //_amountController[i].text = '';
                              //  _unitController[i].text = '';
                            }
                          });
                        },
                      ),
                      TranTag(
                        title: AppLocalizations.of(context).translate('add'),
                        textColor: _isAdd ? primaryColor : Colors.grey,
                        backColor: _isAdd
                            ? primaryColor.withOpacity(0.4)
                            : Colors.grey.withOpacity(0.2),
                        onTap: () {
                          setState(() {
                            _isAdd = true;
                            for (int i = 0; i < setNum; i++) {
                              //_nameController[i].text = '';
                              // _amountController[i].text = '';
                              //_unitController[i].text = '';
                            }
                          });
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Container(
                    // height: (MediaQuery.of(context).size.height - 300),
                    child: Column(
                      children: [
                        AddStockWidget(
                          num: 1,
                          nameController: _nameController[0],
                          amountController: _amountController[0],
                          priceController: _priceController[0],
                          unitController: _unitController[0],
                          stockUnitController: _stockUnitController[0],
                          useUnitController: _useUnitController[0],
                          unitRatioController: _unitRatioController[0],
                          totalController: _totalController[0],
                          isAdd: _isAdd,
                        ),
                        if (setNum >= 2)
                          AddStockWidget(
                            num: 2,
                            nameController: _nameController[1],
                            amountController: _amountController[1],
                            priceController: _priceController[1],
                            unitController: _unitController[1],
                            stockUnitController: _stockUnitController[1],
                            useUnitController: _useUnitController[1],
                            unitRatioController: _unitRatioController[1],
                            totalController: _totalController[1],
                            isAdd: _isAdd,
                          ),
                        if (setNum >= 3)
                          AddStockWidget(
                            num: 3,
                            nameController: _nameController[2],
                            amountController: _amountController[2],
                            priceController: _priceController[2],
                            unitController: _unitController[2],
                            stockUnitController: _stockUnitController[2],
                            useUnitController: _useUnitController[2],
                            unitRatioController: _unitRatioController[2],
                            totalController: _totalController[2],
                            isAdd: _isAdd,
                          ),
                        if (setNum >= 4)
                          AddStockWidget(
                            num: 4,
                            nameController: _nameController[3],
                            amountController: _amountController[3],
                            priceController: _priceController[3],
                            unitController: _unitController[3],
                            stockUnitController: _stockUnitController[4],
                            useUnitController: _useUnitController[4],
                            unitRatioController: _unitRatioController[4],
                            totalController: _totalController[3],
                            isAdd: _isAdd,
                          ),
                        if (setNum >= 5)
                          AddStockWidget(
                            num: 5,
                            nameController: _nameController[4],
                            amountController: _amountController[4],
                            priceController: _priceController[4],
                            unitController: _unitController[4],
                            stockUnitController: _stockUnitController[4],
                            useUnitController: _useUnitController[4],
                            unitRatioController: _unitRatioController[4],
                            totalController: _totalController[4],
                            isAdd: _isAdd,
                          ),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      if (setNum != 5)
                        IconButton(
                            onPressed: () {
                              setState(() {
                                setNum += 1;
                              });
                            },
                            icon: Icon(
                              Icons.add,
                              color: primaryColor,
                            )),
                      if (setNum > 1)
                        IconButton(
                            onPressed: () {
                              for (int i = setNum - 1; i < 5; i++) {
                                _nameController[i].clear();
                                _amountController[i].clear();
                                _priceController[i].clear();
                                _unitController[i].clear();
                                _totalController[i].clear();
                              }
                              setState(() {
                                setNum -= 1;
                              });
                            },
                            icon: Icon(
                              Icons.remove,
                              color: primaryColor,
                            )),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        ElevatedButton(
          onPressed: _onSave,
          child: _isLoading
              ? SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(color: Colors.white),
                )
              : Text(AppLocalizations.of(context).translate('save')),
          style: ButtonStyle(
            backgroundColor:
                MaterialStateProperty.all(Theme.of(context).accentColor),
            elevation: MaterialStateProperty.all(0),
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
        ),
      ],
    );
  }
}

class AddStockWidget extends StatefulWidget {
  final int num;
  final TextEditingController nameController;
  final TextEditingController amountController;
  final TextEditingController priceController;
  final TextEditingController unitController;
  final TextEditingController stockUnitController;
  final TextEditingController useUnitController;
  final TextEditingController unitRatioController;
  final TextEditingController totalController;
  final bool isAdd;

  const AddStockWidget(
      {Key key,
      this.num,
      this.nameController,
      this.amountController,
      this.priceController,
      this.unitController,
      this.stockUnitController,
      this.useUnitController,
      this.unitRatioController,
      this.totalController,
      this.isAdd})
      : super(key: key);

  @override
  _AddStockWidgetState createState() => _AddStockWidgetState();
}

class _AddStockWidgetState extends State<AddStockWidget> {
  List<String> units = [];
  final _amountFocusNode = FocusNode();
  String _setName;
  Map nameAndUnits;
  bool _isAddConfirm;

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> stockNamesAndUnits =
        Provider.of<AllProvider>(context).stockNamesAndUnits();
    List<String> stockNames =
        stockNamesAndUnits.map((stock) => stock['name'].toString()).toList();
    // print(widget.nameController.text);

    if (widget.isAdd &&
        widget.nameController.text.isNotEmpty &&
        (_isAddConfirm != widget.isAdd)) {
      _isAddConfirm = widget.isAdd;
      nameAndUnits = stockNamesAndUnits
          .firstWhere((stock) => stock['name'] == widget.nameController.text);
      units.clear();
      units.add(nameAndUnits['stockUnit']);
      units.add(nameAndUnits['useUnit']);
      widget.unitController.text = units.first;
    } else {
      _isAddConfirm = widget.isAdd;
    }

    return Container(
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.only(bottom: 5),
      padding: EdgeInsets.only(top: 10, bottom: 14, left: 7, right: 7),
      decoration: boxDecorationWithRoundedCorners(
        backgroundColor: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('${widget.num.toString()}.', style: boldTextStyle()),
              SizedBox(width: 3),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(AppLocalizations.of(context).translate('name'),
                      style: boldTextStyle(size: 14)),
                  Container(
                    width: 160,
                    height: 50,
                    child: DropdownButtonFormField(
                      isExpanded: true,
                      items: stockNames.map((String name) {
                        return DropdownMenuItem(
                            value: name,
                            child: Text(
                              name,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 13.5,
                              ),
                            ));
                      }).toList(),
                      onChanged: (newValue) {
                        setState(() {
                          _setName = newValue;
                          widget.nameController.text = _setName;
                          nameAndUnits = stockNamesAndUnits
                              .firstWhere((stock) => stock['name'] == _setName);
                          units.clear();
                          units.add(nameAndUnits['stockUnit']);
                          units.add(nameAndUnits['useUnit']);
                          widget.stockUnitController.text =
                              nameAndUnits['stockUnit'];
                          widget.useUnitController.text =
                              nameAndUnits['useUnit'];
                          widget.unitRatioController.text =
                              nameAndUnits['unitRatio'].toString();
                          if (widget.isAdd) {
                            widget.unitController.text = units.first;
                          } else {
                            widget.unitController.text = units[1];
                          }
                          FocusScope.of(context).requestFocus(_amountFocusNode);
                        });
                      },
                      value: _setName,
                    ),
                  )
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(AppLocalizations.of(context).translate('amount'),
                      style: boldTextStyle(size: 14)),
                  Container(
                    height: 50,
                    width: 65,
                    child: TextField(
                      focusNode: _amountFocusNode,
                      controller: widget.amountController,
                      keyboardType: TextInputType.number,
                      style: TextStyle(
                        fontSize: 14,
                      ),
                      decoration: InputDecoration(),
                      onChanged: (value) {
                        if (value.trim().isNotEmpty) {
                          widget.priceController.text =
                              nameAndUnits['price'].toString();
                          int total = int.parse(value) * nameAndUnits['price'];
                          widget.totalController.text = total.toString();
                        } else {
                          widget.totalController.text = '';
                        }
                      },
                    ),
                  ),
                ],
              ),
              Container(
                width: 80,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(AppLocalizations.of(context).translate('unit'),
                            style: boldTextStyle(size: 14)),
                        SizedBox(width: 15),
                        InkWell(
                            onTap: () {
                              if (widget.unitController.text == units.first) {
                                widget.unitController.text = units[1];
                              } else {
                                widget.unitController.text = units[0];
                              }
                            },
                            child: FaIcon(
                              FontAwesomeIcons.exchangeAlt,
                              color: primaryColor,
                              size: 16,
                            ))
                      ],
                    ),
                    Container(
                        width: 160,
                        height: 50,
                        child: TextField(
                          enabled: false,
                          controller: widget.unitController,
                          style: TextStyle(
                            fontSize: 14,
                          ),
                          decoration: InputDecoration(
                            disabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(width: 0.5),
                            ),
                          ),
                        )),
                  ],
                ),
              ),
            ],
          ),
          if (widget.isAdd)
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 10, left: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(AppLocalizations.of(context).translate('price'),
                          style: boldTextStyle(size: 14)),
                      Container(
                        height: 30,
                        width: 65,
                        child: TextField(
                          controller: widget.priceController,
                          keyboardType: TextInputType.number,
                          style: TextStyle(
                            fontSize: 14,
                          ),
                          decoration: InputDecoration(),
                          onChanged: (value) {
                            if (widget.amountController.text.isNotEmpty &&
                                value.isNotEmpty) {
                              int total = int.parse(value) *
                                  int.parse(widget.amountController.text);
                              widget.totalController.text = total.toString();
                            } else {
                              widget.totalController.text = '';
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10, left: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(AppLocalizations.of(context).translate('total'),
                          style: boldTextStyle(size: 14)),
                      Container(
                        height: 30,
                        width: 65,
                        child: TextField(
                          controller: widget.totalController,
                          keyboardType: TextInputType.number,
                          style: TextStyle(
                            fontSize: 14,
                          ),
                          decoration: InputDecoration(),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
