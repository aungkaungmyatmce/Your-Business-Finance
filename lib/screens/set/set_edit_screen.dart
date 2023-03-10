import '../../language_change/app_localizations.dart';
import '../../constants/colors.dart';
import '../../constants/decoration.dart';
import '../../constants/style.dart';
import '../../model/set_model.dart';
import '../../provider/allProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SetEditScreen extends StatefulWidget {
  final ProductSet setItem;
  const SetEditScreen({Key key, this.setItem}) : super(key: key);

  @override
  _SetEditScreenState createState() => _SetEditScreenState();
}

class _SetEditScreenState extends State<SetEditScreen> {
  @override
  void initState() {
    if (widget.setItem != null) {
      _setNameController.text = widget.setItem.name;
      _setPriceController.text = widget.setItem.price.toString();
      stockNum = widget.setItem.items.length;
      if (stockNum > 0) {
        _stockItemsOn = true;
      }
      for (int i = 0; i < widget.setItem.items.length; i++) {
        _stockItemNameController[i].text = widget.setItem.items[i].name;
        _stockItemAmountController[i].text =
            widget.setItem.items[i].useAmount.toString();
      }
    }
    super.initState();
  }

  final _form = GlobalKey<FormState>();
  var _setNameController = TextEditingController();
  var _setPriceController = TextEditingController();

  List<TextEditingController> _stockItemNameController = [
    for (int i = 0; i < 6; i++) TextEditingController()
  ];
  List<TextEditingController> _stockItemAmountController = [
    for (int i = 0; i < 6; i++) TextEditingController()
  ];

  int stockNum = 0;

  bool _isLoading = false;
  bool _stockItemsOn = false;

  @override
  void dispose() {
    for (int i = 0; i < _stockItemNameController.length; i++) {
      _stockItemNameController[i].dispose();
    }
    for (int i = 0; i < _stockItemAmountController.length; i++) {
      _stockItemAmountController[i].dispose();
    }
    super.dispose();
  }

  Future<void> _onSave() async {
    final isValid = _form.currentState.validate();
    if (!isValid) {
      return;
    }
    setState(() {
      _isLoading = true;
    });

    List<SetItem> setItemList = List.generate(
        stockNum,
        (index) => SetItem(
            name: _stockItemNameController[index].text,
            useAmount: int.parse(_stockItemAmountController[index].text)));

    ProductSet set = ProductSet(
        name: _setNameController.text,
        price: int.parse(_setPriceController.text),
        items: setItemList);

    if (widget.setItem != null) {
      await Provider.of<AllProvider>(context, listen: false)
          .addOrEditSet(setItem: set, isEdit: true);
    } else {
      await Provider.of<AllProvider>(context, listen: false)
          .addOrEditSet(setItem: set, isEdit: false);
    }
    setState(() {
      _isLoading = true;
    });
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SafeArea(
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
                      widget.setItem != null
                          ? AppLocalizations.of(context)
                              .translate('editProduct')
                          : AppLocalizations.of(context)
                              .translate('addNewProduct'),
                      style: boldTextStyle(size: 16),
                    )
                  ],
                ),
                Divider(thickness: 1),
                Form(
                  key: _form,
                  child: Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: ListView(
                        children: [
                          Container(
                            margin: EdgeInsets.symmetric(vertical: 5),
                            height: 60,
                            child: TextFormField(
                              enabled: widget.setItem != null ? false : true,
                              controller: _setNameController,
                              decoration: InputDecoration(
                                  labelText: AppLocalizations.of(context)
                                      .translate('productName')),
                              textInputAction: TextInputAction.next,
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Please enter a name';
                                }
                                return null;
                              },
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.symmetric(vertical: 5),
                            height: 60,
                            child: TextFormField(
                              controller: _setPriceController,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                labelText: AppLocalizations.of(context)
                                    .translate('price'),
                              ),
                              textInputAction: TextInputAction.next,
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Please enter price';
                                }
                                return null;
                              },
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                  AppLocalizations.of(context)
                                      .translate('addStockItems'),
                                  style: boldTextStyle(size: 14)),
                              Switch(
                                value: _stockItemsOn,
                                onChanged: (value) {
                                  setState(() {
                                    _stockItemsOn = value;
                                    if (_stockItemsOn) {
                                      if (widget.setItem != null) {
                                        stockNum =
                                            widget.setItem.items.length == 0
                                                ? 1
                                                : widget.setItem.items.length;
                                      } else {
                                        stockNum = 1;
                                      }
                                    } else {
                                      stockNum = 0;
                                    }
                                  });
                                },
                                activeTrackColor:
                                    Colors.orange.withOpacity(0.5),
                                activeColor: primaryColor,
                              ),
                            ],
                          ),
                          SizedBox(height: 10),
                          Container(
                            // height: (MediaQuery.of(context).size.height - 300),
                            child: Column(
                              children: [
                                if (stockNum >= 1)
                                  AddStockWidget(
                                    num: 1,
                                    nameController: _stockItemNameController[0],
                                    amountController:
                                        _stockItemAmountController[0],
                                  ),
                                if (stockNum >= 2)
                                  AddStockWidget(
                                    num: 2,
                                    nameController: _stockItemNameController[1],
                                    amountController:
                                        _stockItemAmountController[1],
                                  ),
                                if (stockNum >= 3)
                                  AddStockWidget(
                                    num: 3,
                                    nameController: _stockItemNameController[2],
                                    amountController:
                                        _stockItemAmountController[2],
                                  ),
                                if (stockNum >= 4)
                                  AddStockWidget(
                                    num: 4,
                                    nameController: _stockItemNameController[3],
                                    amountController:
                                        _stockItemAmountController[3],
                                  ),
                                if (stockNum >= 5)
                                  AddStockWidget(
                                    num: 5,
                                    nameController: _stockItemNameController[4],
                                    amountController:
                                        _stockItemAmountController[4],
                                  ),
                                if (stockNum >= 6)
                                  AddStockWidget(
                                    num: 6,
                                    nameController: _stockItemNameController[5],
                                    amountController:
                                        _stockItemAmountController[5],
                                  ),
                              ],
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              if (stockNum != 6 && _stockItemsOn)
                                IconButton(
                                    onPressed: () {
                                      setState(() {
                                        stockNum += 1;
                                      });
                                    },
                                    icon: Icon(
                                      Icons.add,
                                      color: primaryColor,
                                    )),
                              if (stockNum > 1 && _stockItemsOn)
                                IconButton(
                                    onPressed: () {
                                      for (int i = stockNum - 1; i < 6; i++) {
                                        _stockItemNameController[i].clear();
                                        _stockItemAmountController[i].clear();
                                      }
                                      setState(() {
                                        stockNum -= 1;
                                      });
                                    },
                                    icon: Icon(
                                      Icons.remove,
                                      color: primaryColor,
                                    )),
                            ],
                          ),
                          ElevatedButton(
                              onPressed: () async {
                                _onSave();
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
                                      style: TextStyle(fontSize: 14)))
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      )),
    );
  }
}

class AddStockWidget extends StatefulWidget {
  final int num;
  final TextEditingController nameController;
  final TextEditingController amountController;

  final bool isAdd;

  const AddStockWidget(
      {Key key,
      this.num,
      this.nameController,
      this.amountController,
      this.isAdd})
      : super(key: key);

  @override
  _AddStockWidgetState createState() => _AddStockWidgetState();
}

class _AddStockWidgetState extends State<AddStockWidget> {
  List<String> units = [];
  final _amountFocusNode = FocusNode();
  final unitController = TextEditingController();
  String _setName;

  @override
  void didChangeDependencies() {
    if (widget.nameController.text.isNotEmpty) {
      List<Map<String, dynamic>> stockNamesAndUnits =
          Provider.of<AllProvider>(context, listen: false).stockNamesAndUnits();
      _setName = widget.nameController.text;
      Map nameAndUnits =
          stockNamesAndUnits.firstWhere((stock) => stock['name'] == _setName);
      units.clear();
      units.add(nameAndUnits['stockUnit']);
      units.add(nameAndUnits['useUnit']);
      unitController.text = units[1];
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> stockNamesAndUnits =
        Provider.of<AllProvider>(context).stockNamesAndUnits();
    List<String> stockNames =
        stockNamesAndUnits.map((stock) => stock['name'].toString()).toList();

    return Container(
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.only(bottom: 5),
      padding: EdgeInsets.only(top: 10, bottom: 14, left: 10, right: 10),
      decoration: boxDecorationWithRoundedCorners(
        backgroundColor: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('${widget.num.toString()}. ', style: boldTextStyle()),
          //SizedBox(width: 3),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(AppLocalizations.of(context).translate('name'),
                  style: boldTextStyle(height: 1.3, size: 14)),
              Container(
                width: 160,
                height: 50,
                child: DropdownButtonFormField(
                  items: stockNames.map((String name) {
                    return DropdownMenuItem(
                        value: name,
                        child: Text(
                          name,
                          style: TextStyle(
                            fontSize: 13.5,
                          ),
                        ));
                  }).toList(),
                  onChanged: (newValue) {
                    setState(() {
                      _setName = newValue;
                      widget.nameController.text = _setName;
                      Map nameAndUnits = stockNamesAndUnits
                          .firstWhere((stock) => stock['name'] == _setName);
                      units.clear();
                      units.add(nameAndUnits['stockUnit']);
                      units.add(nameAndUnits['useUnit']);
                      unitController.text = units[1];
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
              Text(AppLocalizations.of(context).translate('usedAmount'),
                  style: boldTextStyle(height: 1.3, size: 14)),
              Row(
                children: [
                  Container(
                    height: 45,
                    width: 65,
                    child: TextField(
                      focusNode: _amountFocusNode,
                      controller: widget.amountController,
                      keyboardType: TextInputType.number,
                      style: TextStyle(
                        fontSize: 14,
                      ),
                      decoration: InputDecoration(),
                    ),
                  ),
                  Container(
                      width: 45,
                      height: 45,
                      child: TextField(
                        enabled: false,
                        controller: unitController,
                        style: TextStyle(fontSize: 14, height: 1.4),
                        decoration: InputDecoration(
                          disabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(width: 0.5),
                          ),
                        ),
                      )),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
