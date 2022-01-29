import 'package:flutter/material.dart';
import 'package:incentive_flutter/screens/login/login_form.dart';
import 'package:incentive_flutter/screens/login/web_login.dart';
import 'package:universal_platform/universal_platform.dart';

import '../../common.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    if(UniversalPlatform.isAndroid ||
    UniversalPlatform.isIOS || isWebMobile){
      return LoginForm();
    }
    return WebLogin();
  }
}
