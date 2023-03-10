import 'package:ybf_sample_version_2/model/income.dart';

import '../../language_change/app_localizations.dart';
import '../../constants/decoration.dart';
import '../../constants/style.dart';
import '../../provider/allProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'in_name_edit_screen.dart';

class InNamesScreen extends StatefulWidget {
  const InNamesScreen({Key key}) : super(key: key);

  @override
  _InNamesScreenState createState() => _InNamesScreenState();
}

class _InNamesScreenState extends State<InNamesScreen> {
  bool _isLoading = false;

  Future<void> _showDialog(String inName) async {
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
                      .deleteInName(inName: inName);
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
    List<Income> inNameList = Provider.of<AllProvider>(context).allIncome;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            AppLocalizations.of(context).translate('incomeNames'),
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
                        itemCount: inNameList.length,
                        itemBuilder: (context, index) {
                          // return Container(
                          //   // width: MediaQuery.of(context).size.width,
                          //   height: 70,
                          //   margin: EdgeInsets.only(bottom: 5),
                          //   padding: EdgeInsets.symmetric(vertical: 5),
                          //   decoration: boxDecorationRoundedWithShadow(10),
                          //   child: ListTile(
                          //     title: Text(
                          //       '${index + 1}. ${inNameList[index].name}',
                          //       style: boldTextStyle(),
                          //     ),
                          //     subtitle: inNameList[index].category != null
                          //         ? Container(
                          //             height: 10,
                          //             child: Text(
                          //               '     ${inNameList[index].category}',
                          //               // softWrap: false,
                          //               overflow: TextOverflow.ellipsis,
                          //               style: secondaryTextStyle(),
                          //             ),
                          //           )
                          //         : Container(),
                          //     trailing: Container(
                          //       width: 100,
                          //       child: Row(
                          //         children: [
                          //           IconButton(
                          //               onPressed: () {
                          //                 Navigator.push(
                          //                     context,
                          //                     MaterialPageRoute(
                          //                       builder: (context) =>
                          //                           InNameEditScreen(
                          //                               income:
                          //                                   inNameList[index]),
                          //                     ));
                          //               },
                          //               icon: Icon(
                          //                 Icons.edit,
                          //                 color: Colors.green,
                          //               )),
                          //           IconButton(
                          //               onPressed: () async {
                          //                 _showDialog(inNameList[index].name);
                          //               },
                          //               icon: Icon(
                          //                 Icons.delete,
                          //                 color: Colors.red,
                          //               )),
                          //         ],
                          //       ),
                          //     ),
                          //   ),
                          // );
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
                                            '  ${index + 1}. ${inNameList[index].name}',
                                            softWrap: false,
                                            overflow: TextOverflow.ellipsis,
                                            style: boldTextStyle(),
                                          ),
                                        ),
                                        if (inNameList[index].category != null)
                                          Container(
                                            height: 25,
                                            child: Text(
                                              '        ${inNameList[index].category}',
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
                                                  InNameEditScreen(
                                                      income:
                                                          inNameList[index]),
                                            ));
                                      },
                                      icon: Icon(
                                        Icons.edit,
                                        color: Colors.green,
                                      )),
                                  IconButton(
                                      onPressed: () async {
                                        _showDialog(inNameList[index].name);
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
                                builder: (context) => InNameEditScreen(),
                              ));
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Text(
                            AppLocalizations.of(context)
                                .translate('addNewIncomeName'),
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
