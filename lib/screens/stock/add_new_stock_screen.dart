import '../../language_change/app_localizations.dart';
import '../../constants/colors.dart';
import '../../constants/decoration.dart';
import '../../constants/style.dart';
import '../../model/stock.dart';
import '../../provider/allProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddNewStockScreen extends StatefulWidget {
  const AddNewStockScreen({Key key, this.stock}) : super(key: key);
  final Stock stock;
  @override
  _AddNewStockScreenState createState() => _AddNewStockScreenState();
}

class _AddNewStockScreenState extends State<AddNewStockScreen> {
  final _form = GlobalKey<FormState>();
  var _stockNameController = TextEditingController();
  var _stockCurAmountController = TextEditingController();
  var _stockLimAmountController = TextEditingController();
  var _stockPriceController = TextEditingController();
  var _unitStockNameController = TextEditingController();
  var _unitUseNameController = TextEditingController();
  var _unitStockAmountController = TextEditingController(text: '1');
  var _unitUseAmountController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _stockNameController.dispose();
    _stockCurAmountController.dispose();
    _stockLimAmountController.dispose();
    _stockPriceController.dispose();
    _unitStockNameController.dispose();
    _unitUseNameController.dispose();
    _unitStockAmountController.dispose();
    _unitUseAmountController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    if (widget.stock != null) {
      _stockNameController.text = widget.stock.name;
      var curAmt =
          (widget.stock.curAmount / widget.stock.stockRatio).toStringAsFixed(2);
      _stockCurAmountController.text = curAmt.substring(0, curAmt.indexOf('.'));
      _stockLimAmountController.text =
          (widget.stock.limitAmount / widget.stock.stockRatio)
              .toStringAsFixed(0);
      _unitStockNameController.text = widget.stock.unitForStock;
      _unitUseNameController.text = widget.stock.unitForUse;
      _unitUseAmountController.text = widget.stock.stockRatio.toString();
      _stockPriceController.text = widget.stock.price.toString();
    }
    super.initState();
  }

  Future<void> _saveForm() async {
    int _curAmt = 0;
    int _limAmt = 0;
    final isValid = _form.currentState.validate();
    if (!isValid) {
      return;
    }
    setState(() {
      _isLoading = true;
    });
    if (_unitStockNameController.text.trim() ==
        _unitUseNameController.text.trim()) {
      _unitUseAmountController.text = '1';
    }
    _curAmt = int.parse(_stockCurAmountController.text) *
        int.parse(_unitUseAmountController.text);
    _limAmt = int.parse(_stockLimAmountController.text) *
        int.parse(_unitUseAmountController.text);

    await Provider.of<AllProvider>(context, listen: false).addNewStock(Stock(
      name: _stockNameController.text,
      curAmount: widget.stock == null ? _curAmt : widget.stock.curAmount,
      limitAmount: _limAmt,
      stockRatio: int.parse(_unitUseAmountController.text),
      unitForStock: _unitStockNameController.text,
      unitForUse: _unitUseNameController.text,
      price: int.parse(_stockPriceController.text),
    ));
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
        decoration: boxDecorationWithRoundedCorners(
            borderRadius: BorderRadius.only(topRight: Radius.circular(32))),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              Row(
                children: [
                  IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(
                        Icons.arrow_back_ios_outlined,
                        size: 18,
                      )),
                  Text(
                    AppLocalizations.of(context).translate('addNewStock'),
                    style: boldTextStyle(size: 16),
                  )
                ],
              ),
              Form(
                key: _form,
                child: Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: ListView(
                      children: [
                        SizedBox(
                          height: 60,
                          child: TextFormField(
                            controller: _stockNameController,
                            decoration: InputDecoration(
                                labelText: AppLocalizations.of(context)
                                    .translate('stockName')),
                            textInputAction: TextInputAction.next,
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Please enter a name';
                              }
                              return null;
                            },
                          ),
                        ),

                        SizedBox(height: 10),
                        SizedBox(
                          height: 60,
                          child: TextFormField(
                            controller: _unitStockNameController,
                            decoration: InputDecoration(
                                labelText: AppLocalizations.of(context)
                                    .translate('unitForStock')),
                            textInputAction: TextInputAction.next,
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Please enter a Unit for Stock';
                              }
                              return null;
                            },
                          ),
                        ),
                        SizedBox(height: 10),
                        SizedBox(
                          height: 60,
                          child: TextFormField(
                            controller: _unitUseNameController,
                            decoration: InputDecoration(
                                labelText: AppLocalizations.of(context)
                                    .translate('unitForUse')),
                            textInputAction: TextInputAction.next,
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Please enter a Unit for Use';
                              }
                              return null;
                            },
                            onChanged: (value) {
                              setState(() {});
                            },
                          ),
                        ),
                        SizedBox(height: 10),
                        if (_unitStockNameController.text.isNotEmpty &&
                            _unitUseNameController.text.isNotEmpty &&
                            _unitStockNameController.text.trim() !=
                                _unitUseNameController.text.trim())
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                height: 35,
                                width: 45,
                                child: TextFormField(
                                  controller: _unitStockAmountController,
                                  decoration: smallTextInputDecoration(),
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      return 'Please enter amount';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              SizedBox(width: 5),
                              Text(
                                _unitStockNameController.text,
                                style: boldTextStyle(
                                    color: primaryColor, size: 18),
                              ),
                              SizedBox(width: 5),
                              Text(
                                '=  ',
                                style: boldTextStyle(
                                    color: Colors.black, size: 18),
                              ),
                              Container(
                                height: 35,
                                width: 45,
                                // padding: EdgeInsets.symmetric(horizontal: 5),
                                child: TextFormField(
                                  controller: _unitUseAmountController,
                                  decoration: smallTextInputDecoration(),
                                  validator: (value) {
                                    if (value.isEmpty &&
                                        _unitStockNameController
                                            .text.isNotEmpty &&
                                        _unitUseNameController
                                            .text.isNotEmpty &&
                                        _unitStockNameController.text.trim() !=
                                            _unitUseNameController.text
                                                .trim()) {
                                      return 'Please enter amount';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              SizedBox(width: 5),
                              Text(
                                _unitUseNameController.text,
                                style: boldTextStyle(
                                    color: primaryColor, size: 18),
                              ),
                            ],
                          ),
                        // SizedBox(height: 10),

                        SizedBox(
                          height: 60,
                          child: TextFormField(
                            enabled: widget.stock != null ? false : true,
                            controller: _stockCurAmountController,
                            decoration: InputDecoration(
                                labelText:
                                    '${AppLocalizations.of(context).translate('currentAmount')} ( ${_unitStockNameController.text})'),
                            textInputAction: TextInputAction.next,
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Please enter a Amount';
                              }
                              return null;
                            },
                          ),
                        ),
                        SizedBox(height: 10),
                        SizedBox(
                          height: 60,
                          child: TextFormField(
                            controller: _stockLimAmountController,
                            decoration: InputDecoration(
                                labelText:
                                    '${AppLocalizations.of(context).translate('limitAmount')} ( ${_unitStockNameController.text})'),
                            textInputAction: TextInputAction.next,
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Please enter a Amount';
                              }
                              return null;
                            },
                          ),
                        ),
                        SizedBox(height: 10),
                        SizedBox(
                          height: 60,
                          child: TextFormField(
                            controller: _stockPriceController,
                            decoration: InputDecoration(
                                labelText: AppLocalizations.of(context)
                                    .translate('price')),
                            textInputAction: TextInputAction.next,
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Please enter a Amount';
                              }
                              return null;
                            },
                          ),
                        ),
                        SizedBox(height: 10),
                        ElevatedButton(
                            onPressed: () async {
                              _saveForm();
                            },
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
                                  ))
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    ));
  }
}
