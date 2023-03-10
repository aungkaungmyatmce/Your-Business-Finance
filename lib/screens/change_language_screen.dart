import '../../constants/decoration.dart';
import '../../constants/style.dart';
import '../../language_change/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../language_change/AppLanguage.dart';

class ChangeLanguageScreen extends StatefulWidget {
  const ChangeLanguageScreen({Key key}) : super(key: key);

  @override
  _ChangeLanguageScreenState createState() => _ChangeLanguageScreenState();
}

class _ChangeLanguageScreenState extends State<ChangeLanguageScreen> {
  @override
  Widget build(BuildContext context) {
    var appLanguage = Provider.of<AppLanguage>(context);
    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(Icons.arrow_back)),
        title: Text(
          AppLocalizations.of(context).translate('changeLanguage'),
          style: TextStyle(fontSize: 16),
        ),
      ),
      body: Container(
        height: 110,
        margin: EdgeInsets.symmetric(vertical: 4, horizontal: 3),
        padding: EdgeInsets.all(12.0),
        decoration: boxDecorationRoundedWithShadow(8),
        child: Column(
          children: [
            SizedBox(
              height: 35,
              child: ListTile(
                onTap: () {
                  appLanguage.changeLanguage(Locale("en"));
                },
                title: Text('English',
                    style: secondaryTextStyle(color: Colors.black87, size: 16)),
                trailing: appLanguage.appLocal == Locale('en')
                    ? Icon(Icons.done, color: Colors.green, size: 16)
                    : null,
                contentPadding:
                    EdgeInsets.symmetric(vertical: 0.0, horizontal: 10.0),
                visualDensity: VisualDensity(vertical: -3),
                dense: true,
              ),
            ),
            Divider(),
            SizedBox(
              height: 35,
              child: ListTile(
                onTap: () {
                  appLanguage.changeLanguage(Locale("my"));
                },
                title: Text('Myanmar',
                    style: secondaryTextStyle(color: Colors.black87, size: 16)),
                trailing: appLanguage.appLocal == Locale('my')
                    ? Icon(Icons.done, color: Colors.green, size: 16)
                    : null,
                contentPadding:
                    EdgeInsets.symmetric(vertical: 0.0, horizontal: 10.0),
                visualDensity: VisualDensity(vertical: -3),
                dense: true,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
