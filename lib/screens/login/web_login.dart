import 'package:flutter/material.dart';
import 'package:incentive_flutter/screens/login/login_form.dart';
import 'package:url_launcher/link.dart';

class WebLogin extends StatefulWidget {
  const WebLogin({Key? key}) : super(key: key);

  @override
  _WebLoginState createState() => _WebLoginState();
}

class _WebLoginState extends State<WebLogin> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Row(
          children: [
            Expanded(
              child: Column(
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height * .75,
                    child: Image.asset("assets/homess_google-pixel4-clearlywhite-portrait.png"),
                  ),
                  Link(
                    uri: Uri.parse(""),
                    target: LinkTarget.blank,
                    builder: (context, onLinkPressed){
                      return MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: GestureDetector(
                          onTap: onLinkPressed,
                          child: Image.asset(
                            "assets/google-play-badge.png",
                            width: 200,
                          ),
                        ),
                      );
                    },
                  )
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(left: 10, right: 10),
                child: LoginForm(),
              ),
            )
          ],
        ),
      ),
    );
  }
}
