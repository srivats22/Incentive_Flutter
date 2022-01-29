import 'package:animations/animations.dart';
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
import 'package:universal_platform/universal_platform.dart';
import 'package:url_strategy/url_strategy.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  setPathUrlStrategy();
  runApp(MyApp());
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
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Incentive',
      themeMode: ThemeMode.system,
      theme: _appData().copyWith(
        pageTransitionsTheme: PageTransitionsTheme(
          builders: {
            for (var type in TargetPlatform.values)
              type: sharedAxisTransition,
          },
        ),
      ),
      home: startingPage(),
      navigatorObservers: [
        FirebaseAnalyticsObserver(analytics: analytics)
      ],
    );
  }

  ThemeData _appData(){
    return ThemeData(
      primarySwatch: Colors.teal,
      textTheme: GoogleFonts.montserratTextTheme(),
      // appBarTheme: AppBarTheme(
      //   elevation: 0,
      //   backgroundColor: Colors.white,
      //   titleTextStyle: TextStyle(color: Colors.black),
      //   iconTheme: IconThemeData(color: Colors.black),
      // ),
      scaffoldBackgroundColor: Colors.white,
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
