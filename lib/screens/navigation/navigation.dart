import 'package:flutter/material.dart';
import 'package:universal_platform/universal_platform.dart';
import 'web_navigation.dart';
import 'mobile_navigation.dart';

class Navigation extends StatefulWidget {
  @override
  _NavigationState createState() => _NavigationState();
}

class _NavigationState extends State<Navigation> {
  @override
  Widget build(BuildContext context) {
    if(UniversalPlatform.isAndroid ||
        MediaQuery.of(context).size.width < 600){
      return MobileNav();
    }
    return WebNavigation();
  }
}
