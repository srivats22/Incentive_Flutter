import 'package:animations/animations.dart';
import 'package:easy_dynamic_theme/easy_dynamic_theme.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:incentive_flutter/firebase_options.dart';
import 'package:incentive_flutter/screens/login/login.dart';
import 'package:incentive_flutter/screens/navigation/navigation.dart';
import 'package:incentive_flutter/theme.dart';
import 'package:universal_platform/universal_platform.dart';
import 'package:url_strategy/url_strategy.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  setPathUrlStrategy();
  runApp(
    EasyDynamicThemeWidget(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {

  final sharedAxisTransition = const SharedAxisPageTransitionsBuilder(
    fillColor: Colors.white,
    transitionType: SharedAxisTransitionType.scaled,
  );

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    FirebaseAnalytics analytics = FirebaseAnalytics();
    bool isDarkModeOn = Theme.of(context).brightness == Brightness.dark;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Incentive',
      darkTheme: darkTheme,
      theme: isDarkModeOn ? darkTheme : lightTheme,
      themeMode: EasyDynamicTheme.of(context).themeMode,
      home: startingPage(),
      navigatorObservers: [
        FirebaseAnalyticsObserver(analytics: analytics)
      ],
    );
  }

  Widget startingPage(){
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot){
        // if(snapshot.connectionState == ConnectionState.waiting){
        //   return Center(
        //     child: CircularProgressIndicator(),
        //   );
        // }
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
