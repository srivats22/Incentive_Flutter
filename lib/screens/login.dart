import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:incentive_flutter/common.dart';
import 'package:incentive_flutter/screens/navigation/navigation.dart';
import 'package:web_browser_detect/web_browser_detect.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool isLoading = false;
  bool isObscured = true;
  bool isBtnEnabled = false;
  bool isErrorMsg = false;
  String errorMsg = "";
  TextEditingController? email, pwd;
  final GlobalKey<FormState> loginKey = new GlobalKey<FormState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    email = new TextEditingController();
    pwd = new TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: isLoading ? Center(
          child: CircularProgressIndicator(),
        ) : Center(
          child: Form(
            key: loginKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            onChanged: (){
              if(loginKey.currentState!.validate()){
                setState(() {
                  isBtnEnabled = true;
                });
              }
              else{
                isBtnEnabled = false;
              }
            },
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Text("Incentive", style: TextStyle(fontWeight: FontWeight.bold),),
                  SizedBox(height: 10,),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * .75,
                    child: TextFormField(
                      controller: email,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      validator: (input){
                        if(input!.isEmpty){
                          return 'Email is required';
                        }
                        return null;
                      },
                      autofillHints: [AutofillHints.email],
                    ),
                  ),
                  SizedBox(height: 10,),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * .75,
                    child: TextFormField(
                      controller: pwd,
                      decoration: InputDecoration(
                          labelText: 'Password',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          suffixIcon: isObscured ? IconButton(
                            onPressed: (){
                              if(isObscured){
                                setState(() {
                                  isObscured = false;
                                });
                              }
                            },
                            icon: Icon(Icons.visibility),
                          ) : IconButton(
                            onPressed: (){
                              if(isObscured == false){
                                setState(() {
                                  isObscured = true;
                                });
                              }
                            },
                            icon: Icon(Icons.visibility_off),
                          )
                      ),
                      validator: (input){
                        if(input!.isEmpty){
                          return 'Password is required';
                        }
                        return null;
                      },
                      onFieldSubmitted: (input){
                        if(loginKey.currentState!.validate()){
                          fAnalytics.logLogin();
                          setState(() {
                            isLoading = true;
                          });
                          loginFunction();
                        }
                      },
                      obscureText: isObscured,
                      autofillHints: [AutofillHints.password],
                    ),
                  ),
                  SizedBox(height: 10,),
                  Text(isErrorMsg ? errorMsg
                      : "", style: TextStyle(color: Colors.red),),
                  SizedBox(height: 10,),
                  ElevatedButton(
                    onPressed: isBtnEnabled ? (){
                      fAnalytics.logLogin();
                      setState(() {
                        isLoading = true;
                      });
                      loginFunction();
                    } : null,
                    child: Text("Login"),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void loginFunction() async{
    if(loginKey.currentState!.validate()){
      loginKey.currentState!.save();
      try{
        await fAuth.signInWithEmailAndPassword(
            email: email!.text, password: pwd!.text);
        Navigator.of(context).popUntil((route) => route.isFirst);
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
}
