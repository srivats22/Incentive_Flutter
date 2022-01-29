import 'package:flutter/material.dart';
import 'package:incentive_flutter/screens/login/login.dart';
import 'package:url_launcher/link.dart';

class ForgotPwdSuccess extends StatelessWidget {
  final String userEmail;
  ForgotPwdSuccess(this.userEmail);
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text("An email with instructions has been sent to: $userEmail"),
              Text("Open email client"),
              ButtonBar(
                alignment: MainAxisAlignment.center,
                children: [
                  Link(
                    uri: Uri.parse("mail.google.com"),
                    builder: (context, onLinkClicked){
                      return TextButton(
                        onPressed: onLinkClicked,
                        child: Text("Gmail"),
                      );
                    }
                  ),
                  Link(
                    uri: Uri.parse("outlook.com"),
                    builder: (context, onLinkClicked){
                      return TextButton(
                        onPressed: onLinkClicked,
                        child: Text("Outlook"),
                      );
                    },
                  )
                ],
              ),
              Divider(
                indent: 20,
                endIndent: 20,
              ),
              ElevatedButton(
                onPressed: (){
                  Navigator.of(context)
                      .pushReplacement(new MaterialPageRoute(
                      builder: (context) => Login()
                  ));
                },
                child: Text("Back to login"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
