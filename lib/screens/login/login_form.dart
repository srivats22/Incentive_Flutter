import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:incentive_flutter/common.dart';
import 'package:incentive_flutter/screens/forgot_pwd_success.dart';
import 'package:incentive_flutter/screens/navigation/navigation.dart';
import 'package:incentive_flutter/screens/register.dart';
import 'package:incentive_flutter/widgets/custom_input.dart';
import 'package:universal_platform/universal_platform.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({Key? key}) : super(key: key);

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  bool isLoading = false;
  bool isObscured = true;
  bool isBtnEnabled = false;
  bool isErrorMsg = false;
  String errorMsg = "";
  TextEditingController? email, pwd, forgotPwdEmail;
  final GlobalKey<FormState> loginKey = new GlobalKey<FormState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    email = new TextEditingController();
    pwd = new TextEditingController();
    forgotPwdEmail = new TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    final errorSnackBar = SnackBar(
      content: Text("Fields are empty",
        style: Theme.of(context).textTheme.caption
            ?.copyWith(color: Colors.white, fontWeight: FontWeight.bold),),
      backgroundColor: Colors.red,
    );
    return SafeArea(
      child: Scaffold(
        body: isLoading ? Center(
          child: CircularProgressIndicator(),
        ) : Center(
          child: Form(
            key: loginKey,
            child: SingleChildScrollView(
              primary: true,
              child: Column(
                children: [
                  Text("Incentive", style: TextStyle(fontWeight: FontWeight.bold),),
                  SizedBox(height: 10,),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * .75,
                    child: CustomInput(email!, "Email", "", "", false,
                      TextInputType.emailAddress, false, false),
                  ),
                  SizedBox(height: 10,),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * .75,
                    child: CustomInput(pwd!, "Password", "", "", true,
                        TextInputType.text, isObscured, false),
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: TextButton(
                      onPressed: (){
                        showModalBottomSheet(
                            context: context,
                            builder: (context){
                              return _bottomSheet();
                            }
                        );
                      },
                      child: Text("Forgot Password"),
                    ),
                  ),
                  SizedBox(height: 10,),
                  Text(isErrorMsg ? errorMsg
                      : "", style: TextStyle(color: Colors.red),),
                  SizedBox(height: 10,),
                  Visibility(
                    visible: UniversalPlatform.isIOS,
                    child: CupertinoButton(
                      onPressed: (){
                        if(email!.text.isEmpty
                        || pwd!.text.isEmpty){
                          ScaffoldMessenger.of(context).showSnackBar(errorSnackBar);
                        }
                        else{
                          fAnalytics.logLogin();
                          setState(() {
                            isLoading = true;
                          });
                          loginFunction();
                        }
                      },
                      child: Text("Login"),
                      color: Colors.teal,
                    ),
                  ),
                  Visibility(
                    visible: !UniversalPlatform.isIOS,
                    child: ElevatedButton(
                      onPressed: (){
                        if(email!.text.isEmpty
                            || pwd!.text.isEmpty){
                          ScaffoldMessenger.of(context).showSnackBar(errorSnackBar);
                        }
                        else{
                          fAnalytics.logLogin();
                          setState(() {
                            isLoading = true;
                          });
                          loginFunction();
                        }
                      },
                      child: Text("Login"),
                    ),
                  ),
                  Divider(
                    indent: 20,
                    endIndent: 20,
                  ),
                  TextButton(
                    onPressed: (){
                      Navigator.of(context)
                          .push(new MaterialPageRoute(
                          builder: (context) => Register()));
                    },
                    child: Text("New? Register"),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _bottomSheet(){
    return Container(
      height: MediaQuery.of(context).size.height * .90,
      child: SingleChildScrollView(
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            Text("Forgot password?",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
            SizedBox(height: 10,),
            Text("Complete the form below to get a link to change your password",
            style: TextStyle(fontSize: 18),),
            SizedBox(height: 10,),
            CustomInput(forgotPwdEmail!, "Email", "", "", false,
                TextInputType.emailAddress, false, false),
            SizedBox(height: 10,),
            Visibility(
              visible: UniversalPlatform.isIOS,
              child: CupertinoButton.filled(
                  onPressed: (){
                    fAuth.sendPasswordResetEmail(email: forgotPwdEmail!.text)
                    .whenComplete(() => {
                      Navigator.of(context).pushReplacement(
                      new MaterialPageRoute(builder: (context) => ForgotPwdSuccess(
                      forgotPwdEmail!.text
                      ))
                      ),
                    });
                  },
                  child: Text("Submit")
              ),
            ),
            Visibility(
              visible: !UniversalPlatform.isIOS,
              child: ElevatedButton(
                  onPressed: (){
                    fAuth.sendPasswordResetEmail(email: forgotPwdEmail!.text);
                    Navigator.of(context).pushReplacement(
                        new MaterialPageRoute(builder: (context) => ForgotPwdSuccess(
                            forgotPwdEmail!.text
                        ))
                    );
                  },
                  child: Text("Submit")
              ),
            ),
          ],
        ),
      ),
    );
  }

  void loginFunction() async{
    try{
      await fAuth.signInWithEmailAndPassword(
          email: email!.text, password: pwd!.text);
      Navigator.of(context).popUntil((route) => route.isFirst);
      // Navigator.of(context).pushReplacementNamed("/home");
      Navigator.of(context).pushReplacement(
          new MaterialPageRoute(builder: (context) => Navigation()));
    }
    on FirebaseAuthException catch(e){
      if(e.code.contains("user-not-found")){
        fAnalytics.logEvent(name: "user-not-found");
        // fAnalytics.logEvent(name: "Account not found");
        setState(() {
          isLoading = false;
          isErrorMsg = true;
          isBtnEnabled = false;
          errorMsg = "It looks like you don't have an account";
        });
      }
      if(e.code.contains("wrong-password")){
        fAnalytics.logEvent(name: "wrong-password");
        setState(() {
          isLoading = false;
          isErrorMsg = true;
          isBtnEnabled = false;
          errorMsg = "Your password is incorrect. Try again or reset your password";
        });
        print("Your Password not correct");
      }
    }
  }
}
