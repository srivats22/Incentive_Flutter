import 'package:dynamic_color/dynamic_color.dart';
import 'package:easy_dynamic_theme/easy_dynamic_theme.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:incentive_flutter/common.dart';
import 'package:incentive_flutter/noti/noti_helper.dart';
import 'package:incentive_flutter/screens/login/login.dart';
import 'package:incentive_flutter/screens/navigation/navigation.dart';
import 'package:incentive_flutter/theme.dart';
import 'package:url_strategy/url_strategy.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await NotiHelper().init();
  setPathUrlStrategy();
  runApp(
    EasyDynamicThemeWidget(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    bool isDarkModeOn = Theme.of(context).brightness == Brightness.dark;
    return DynamicColorBuilder(
      builder: (ColorScheme? dayColorScheme, ColorScheme? nightColorScheme){
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Incentive',
          darkTheme: AppTheme.nightTheme(nightColorScheme),
          theme: isDarkModeOn ? AppTheme.nightTheme(nightColorScheme) :
          AppTheme.lightTheme(dayColorScheme),
          themeMode: EasyDynamicTheme.of(context).themeMode,
          home: startingPage(),
          navigatorObservers: [
            FirebaseAnalyticsObserver(analytics: fAnalytics)
          ],
        );
      },
    );
  }

  Widget startingPage(){
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot){
        if(snapshot.hasData){
          if (snapshot.data!.providerData.length == 1) {
            // logged in using email and password
            return Navigation();
          } else {
            // don't remove this
            return Navigation();
          }
        }
        else{
          return Login();
        }
      },
    );
  }
}
