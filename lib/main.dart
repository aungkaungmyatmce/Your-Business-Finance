import 'screens/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'language_change/AppLanguage.dart';
import 'language_change/app_localizations.dart';
import 'provider/allProvider.dart';
import 'provider/date_and_tabIndex_provider.dart';
import 'provider/transaction_provider.dart';
import 'screens/main/overall_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'constants/colors.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  AppLanguage appLanguage = AppLanguage();
  await appLanguage.fetchLocale();
  runApp(MyApp(
    appLanguage: appLanguage,
  ));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  final AppLanguage appLanguage;

  MyApp({this.appLanguage});
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: primaryColor,
      statusBarBrightness: Brightness.dark,
    ));
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (context) => TransactionProvider(),
          ),
          ChangeNotifierProvider(
            create: (context) => AllProvider(),
          ),
          ChangeNotifierProvider(
            create: (context) => DateAndTabIndex(),
          ),
          ChangeNotifierProvider(
            create: (context) => appLanguage,
          ),
        ],
        child: Consumer<AppLanguage>(builder: (context, model, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Your Business Finance',
            theme: ThemeData(
              // This is the theme of your application.
              //
              // Try running your application with "flutter run". You'll see the
              // application has a blue toolbar. Then, without quitting the app, try
              // changing the primarySwatch below to Colors.green and then invoke
              // "hot reload" (press "r" in the console where you ran "flutter run",
              // or simply save your changes to "hot reload" in a Flutter IDE).
              // Notice that the counter didn't reset back to zero; the application
              // is not restarted.
              //fontFamily: 'Pyidaungsu',
              primaryColor: primaryColor,
              primarySwatch: canvasColor,
              elevatedButtonTheme: ElevatedButtonThemeData(
                  style: ElevatedButton.styleFrom(
                      primary: primaryColor,
                      textStyle:
                          TextStyle(fontSize: 16.0, color: Colors.white))),
            ),
            locale: model.appLocal,
            supportedLocales: [
              Locale('en', 'US'),
              Locale('my', 'MY'),
              Locale('ar', ''),
            ],
            localizationsDelegates: [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
            ],
            home: OverallScreen(),
            // home: StreamBuilder(
            //     stream: FirebaseAuth.instance.authStateChanges(),
            //     builder: (ctx, userSnapshot) {
            //       if (userSnapshot.connectionState ==
            //           ConnectionState.waiting) {}
            //       if (userSnapshot.hasData) {
            //         return OverallScreen();
            //       }
            //       return LoginScreen();
            //     }),
          );
        }));
  }
}
