import '../../language_change/app_localizations.dart';
import '../../constants/colors.dart';
import '../../constants/decoration.dart';
import '../../constants/style.dart';
import '../../model/set_model.dart';
import '../../provider/allProvider.dart';
import 'set_edit_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SetOverviewScreen extends StatefulWidget {
  const SetOverviewScreen({Key key}) : super(key: key);

  @override
  _SetOverviewScreenState createState() => _SetOverviewScreenState();
}

class _SetOverviewScreenState extends State<SetOverviewScreen> {
  bool _isLoading = false;

  Future<void> _showDialog(String setName) async {
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
                      .deleteSet(setName: setName);
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
    List<ProductSet> setList = Provider.of<AllProvider>(context).allSets;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            AppLocalizations.of(context).translate('products'),
            style: boldTextStyle(size: 16, color: Colors.white),
          ),
        ),
        body: Container(
          //margin: EdgeInsets.only(top: 90),
          decoration: boxDecorationWithRoundedCorners(
              borderRadius: BorderRadius.only(topRight: Radius.circular(50))),
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
                        itemCount: setList.length,
                        itemBuilder: (context, index) {
                          return Container(
                            margin: EdgeInsets.symmetric(
                                vertical: 3, horizontal: 2),
                            decoration: boxDecorationRoundedWithShadow(2),
                            child: ListTile(
                              leading: SizedBox(
                                width: 120,
                                child: Text(setList[index].name,
                                    // overflow: TextOverflow.visible,
                                    style: boldTextStyle(
                                        color: primaryColor,
                                        size: 15,
                                        height: 1.5)),
                              ),
                              title: Text(
                                'Price: ${setList[index].price}',
                                style: boldTextStyle(size: 14),
                              ),
                              subtitle: Text(
                                'Stock Items: ${setList[index].items.length}',
                                style: TextStyle(fontSize: 13),
                              ),
                              trailing: SizedBox(
                                width: 60,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  SetEditScreen(
                                                      setItem: setList[index]),
                                            ));
                                      },
                                      child: Icon(
                                        Icons.edit,
                                        color: Colors.green,
                                      ),
                                    ),
                                    Spacer(),
                                    InkWell(
                                      onTap: () async {
                                        await _showDialog(setList[index].name);
                                      },
                                      child: Icon(
                                        Icons.delete,
                                        color: Colors.red,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          );
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
                                  builder: (context) => SetEditScreen()));
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Text(
                            AppLocalizations.of(context)
                                .translate('addNewProduct'),
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
