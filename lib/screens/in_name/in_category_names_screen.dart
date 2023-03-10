import 'in_category_name_edit_screen.dart';
import '../../language_change/app_localizations.dart';
import '../../constants/decoration.dart';
import '../../services/ui_helper.dart';
import '../../constants/style.dart';
import '../../provider/allProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class InCategoryNamesScreen extends StatefulWidget {
  const InCategoryNamesScreen({Key key}) : super(key: key);

  @override
  _InCategoryNamesScreenState createState() => _InCategoryNamesScreenState();
}

class _InCategoryNamesScreenState extends State<InCategoryNamesScreen> {
  bool _isLoading = false;

  Future<void> _showDialog(String inCategoryName) async {
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
                      .deleteInCategoryName(inCategoryName: inCategoryName);
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
    List<String> inCategoryList =
        Provider.of<AllProvider>(context).inCategoryList;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            AppLocalizations.of(context).translate('incomeCategories'),
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
                        itemCount: inCategoryList.length,
                        itemBuilder: (context, index) {
                          return Container(
                              //height: 150,
                              margin: EdgeInsets.all(3),
                              padding: EdgeInsets.all(10),
                              decoration: boxDecorationRoundedWithShadow(10),
                              child: Row(
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '${index + 1}. ${inCategoryList[index]}',
                                        style: boldTextStyle(),
                                      ),
                                      if (index == 0)
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 5),
                                          child: Text(
                                            '      (Default)',
                                            style: secondaryTextStyle(size: 12),
                                          ),
                                        ),
                                    ],
                                  ),
                                  Spacer(),
                                  IconButton(
                                      onPressed: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  InCategoryNameEditScreen(
                                                      inCategoryName:
                                                          inCategoryList[
                                                              index]),
                                            ));
                                      },
                                      icon: Icon(
                                        Icons.edit,
                                        color: Colors.green,
                                      )),
                                  IconButton(
                                      onPressed: () async {
                                        if (inCategoryList.length <= 1) {
                                          UIHelper.showSuccessFlushbar(context,
                                              'At least one category name must have',
                                              icon: Icons.clear_rounded);
                                        } else {
                                          _showDialog(inCategoryList[index]);
                                        }
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
                                builder: (context) =>
                                    InCategoryNameEditScreen(),
                              ));
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Text(
                            AppLocalizations.of(context)
                                .translate('addNewIncomeCategory'),
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
