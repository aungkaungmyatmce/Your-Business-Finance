import '../../language_change/app_localizations.dart';
import '../../constants/colors.dart';
import '../../constants/decoration.dart';
import '../../constants/style.dart';
import '../../model/set_transaction.dart';
import '../../provider/allProvider.dart';
import '../../provider/date_and_tabIndex_provider.dart';
import '../../provider/transaction_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddSet extends StatefulWidget {
  final DateTime date;
  const AddSet({Key key, this.date}) : super(key: key);

  @override
  _AddSetState createState() => _AddSetState();
}

class _AddSetState extends State<AddSet> {
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
  List shopNames = [];
  String shopDropdownValue;
  String setDropDownValue;
  int setNum = 1;
  bool _isLoading = false;

  @override
  void initState() {
    Provider.of<DateAndTabIndex>(context, listen: false).setTabIndex(0);
    super.initState();
  }

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
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    shopNames = Provider.of<AllProvider>(context).allShop;
    shopDropdownValue = shopNames.isEmpty ? '' : shopNames.first;
    super.didChangeDependencies();
  }

  Future<void> _onSave() async {
    List<SetTransactionItem> setItems = [];
    for (int i = 0; i < setNum; i++) {
      if (_amountController[i].text.isNotEmpty &&
          _priceController[i].text.isNotEmpty) {
        setItems.add(SetTransactionItem(
          name: _nameController[i].text,
          num: int.parse(_amountController[i].text),
          price: int.parse(_priceController[i].text),
        ));
      }
    }
    setState(() {
      _isLoading = true;
    });
    if (setItems.isNotEmpty) {
      Provider.of<TransactionProvider>(context, listen: false).addSet(
          date: widget.date, setItems: setItems, shop: shopDropdownValue);
      await Provider.of<AllProvider>(context, listen: false)
          .addOrSubFromStockBySetTran(
              items: setItems, date: widget.date, isAdd: false, reAdd: false);
    }
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
                  shopDropDown(),
                  SizedBox(height: 20),
                  Container(
                    // height: (MediaQuery.of(context).size.height - 300),
                    child: Column(
                      children: [
                        AddSetWidget(
                          num: 1,
                          nameController: _nameController[0],
                          amountController: _amountController[0],
                          priceController: _priceController[0],
                        ),
                        if (setNum >= 2)
                          AddSetWidget(
                            num: 2,
                            nameController: _nameController[1],
                            amountController: _amountController[1],
                            priceController: _priceController[1],
                          ),
                        if (setNum >= 3)
                          AddSetWidget(
                            num: 3,
                            nameController: _nameController[2],
                            amountController: _amountController[2],
                            priceController: _priceController[2],
                          ),
                        if (setNum >= 4)
                          AddSetWidget(
                            num: 4,
                            nameController: _nameController[3],
                            amountController: _amountController[3],
                            priceController: _priceController[3],
                          ),
                        if (setNum >= 5)
                          AddSetWidget(
                            num: 5,
                            nameController: _nameController[4],
                            amountController: _amountController[4],
                            priceController: _priceController[4],
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
          onPressed: () {
            _onSave();
          },
          child: _isLoading
              ? SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(color: Colors.white),
                )
              : Text('Save'),
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

  Widget shopDropDown() {
    return Align(
      child: Container(
        //width: 82,
        height: 45,
        padding: EdgeInsets.only(left: 10, right: 5, top: 5, bottom: 5),
        decoration: BoxDecoration(
            border: Border.all(color: Colors.black12),
            borderRadius: BorderRadius.circular(10)),
        child: DropdownButton(
          value: shopDropdownValue,
          icon: Icon(
            Icons.keyboard_arrow_down,
            color: primaryColor,
          ),
          iconSize: 24,
          elevation: 16,
          underline: SizedBox(),
          style: primaryTextStyle(size: 16, color: Colors.black),
          onChanged: (newValue) {
            setState(() {
              shopDropdownValue = newValue;
            });
          },
          items: shopNames.map((value) {
            return DropdownMenuItem(
                value: value,
                child: Text(value,
                    style: primaryTextStyle(size: 16, color: Colors.black)));
          }).toList(),
        ),
      ),
    );
  }
}

class AddSetWidget extends StatefulWidget {
  const AddSetWidget({
    Key key,
    @required TextEditingController nameController,
    @required TextEditingController amountController,
    @required TextEditingController priceController,
    this.num,
  })  : _nameController = nameController,
        _amountController = amountController,
        _priceController = priceController,
        super(key: key);

  final _nameController;
  final _amountController;
  final _priceController;
  final int num;

  @override
  _AddSetWidgetState createState() => _AddSetWidgetState();
}

class _AddSetWidgetState extends State<AddSetWidget> {
  final _amountFocusNode = FocusNode();
  @override
  Widget build(BuildContext context) {
    List<Map> setNamesAndPrices =
        Provider.of<AllProvider>(context).setNamesAndPrices();
    List<String> setNames =
        setNamesAndPrices.map((set) => set['name'].toString()).toList();
    String _setName;
    return Container(
      margin: EdgeInsets.only(bottom: 5),
      padding: EdgeInsets.only(top: 10, bottom: 14, left: 7, right: 7),
      decoration: boxDecorationWithRoundedCorners(
        backgroundColor: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Text('${widget.num.toString()}.', style: boldTextStyle()),
              SizedBox(width: 8),
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
                      items: setNames.map((String name) {
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
                          _setName = newValue;
                          widget._nameController.text = _setName;
                          var set = setNamesAndPrices
                              .firstWhere((set) => set['name'] == _setName);
                          widget._priceController.text =
                              set['price'].toString();
                          FocusScope.of(context).requestFocus(_amountFocusNode);
                        });
                      },
                      value: _setName,
                    ),
                  )
                ],
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(AppLocalizations.of(context).translate('amount'),
                  style: boldTextStyle(size: 14)),
              Container(
                height: 45,
                width: 65,
                child: TextField(
                  focusNode: _amountFocusNode,
                  controller: widget._amountController,
                  keyboardType: TextInputType.number,
                  style: TextStyle(
                    fontSize: 14,
                  ),
                  decoration: InputDecoration(),
                ),
              ),
            ],
          ),
          //SizedBox(width: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(AppLocalizations.of(context).translate('price'),
                  style: boldTextStyle(size: 14)),
              Container(
                height: 45,
                width: 75,
                child: TextFormField(
                  controller: widget._priceController,
                  keyboardType: TextInputType.number,
                  style: TextStyle(
                    fontSize: 14,
                  ),
                  decoration: InputDecoration(),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
