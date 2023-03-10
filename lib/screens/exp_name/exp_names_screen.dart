import 'package:ybf_sample_version_2/model/expense.dart';

import '../../language_change/app_localizations.dart';
import '../../constants/decoration.dart';
import '../../constants/style.dart';
import '../../provider/allProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'exp_name_edit_screen.dart';

class ExpNamesScreen extends StatefulWidget {
  const ExpNamesScreen({Key key}) : super(key: key);

  @override
  _ExpNamesScreenState createState() => _ExpNamesScreenState();
}

class _ExpNamesScreenState extends State<ExpNamesScreen> {
  bool _isLoading = false;

  Future<void> _showDialog(String expName) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            title: new Text("Confirm delete"),
            content: new Text("Are you sure ?"),
            actions: <Widget>[
              new TextButton(
                child: _isLoading
                    ? SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator())
                    : new Text("Yes"),
                onPressed: () async {
                  setState(() {
                    _isLoading = true;
                  });
                  await Provider.of<AllProvider>(context, listen: false)
                      .deleteExpName(expName: expName);
                  setState(() {
                    _isLoading = false;
                  });
                  Navigator.of(context).pop();
                },
              ),
              new TextButton(
                child: new Text("No"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Expense> expNameList = Provider.of<AllProvider>(context).allExpense;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            AppLocalizations.of(context).translate('expenseNames'),
            style: boldTextStyle(size: 16, color: Colors.white),
          ),
        ),
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                      child: ListView.separated(
                        separatorBuilder: (context, index) =>
                            SizedBox(height: 3),
                        itemCount: expNameList.length,
                        itemBuilder: (context, index) {
                          return Container(
                              height: 75,
                              width: MediaQuery.of(context).size.width - 20,
                              margin: EdgeInsets.all(3),
                              padding: EdgeInsets.all(10),
                              decoration: boxDecorationRoundedWithShadow(10),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          height: 30,
                                          child: Text(
                                            '  ${index + 1}. ${expNameList[index].name}',
                                            softWrap: false,
                                            overflow: TextOverflow.ellipsis,
                                            style: boldTextStyle(),
                                          ),
                                        ),
                                        if (expNameList[index].category != null)
                                          Container(
                                            height: 25,
                                            child: Text(
                                              '        ${expNameList[index].category}',
                                              style:
                                                  secondaryTextStyle(size: 13),
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                  IconButton(
                                      onPressed: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  ExpNameEditScreen(
                                                      expense:
                                                          expNameList[index]),
                                            ));
                                      },
                                      icon: Icon(
                                        Icons.edit,
                                        color: Colors.green,
                                      )),
                                  IconButton(
                                      onPressed: () async {
                                        _showDialog(expNameList[index].name);
                                      },
                                      icon: Icon(
                                        Icons.delete,
                                        color: Colors.red,
                                      )),
                                ],
                              ));
                        },
                      ),
                    ),
                    SizedBox(height: 60),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ExpNameEditScreen(),
                              ));
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Text(
                            AppLocalizations.of(context)
                                .translate('addNewExpenseName'),
                            style: primaryTextStyle(
                                size: 14, height: 1, color: Colors.white),
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          shape: new RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(10.0),
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
