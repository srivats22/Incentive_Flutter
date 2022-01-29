import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:incentive_flutter/common.dart';
import 'package:incentive_flutter/screens/forgot_pwd_success.dart';
import 'package:incentive_flutter/screens/navigation/navigation.dart';
import 'package:incentive_flutter/screens/register.dart';
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
    if(UniversalPlatform.isIOS){
      return SafeArea(
        child: Scaffold(
          body: isLoading ? Center(
            child: CupertinoActivityIndicator(),
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
                    Text("Incentive",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),),
                    SizedBox(height: 10,),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * .75,
                      child: CupertinoTextField(
                        controller: email,
                        placeholder: "Email",
                        keyboardType: TextInputType.emailAddress,
                        restorationId: 'Email',
                      ),
                    ),
                    SizedBox(height: 10,),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * .75,
                      child: CupertinoTextField(
                        controller: pwd,
                        placeholder: "Password",
                        restorationId: 'Password',
                        obscureText: isObscured,
                        suffix: isObscured ? IconButton(
                          onPressed: (){
                            if(isObscured){
                              setState(() {
                                isObscured = false;
                              });
                            }
                          },
                          icon: Icon(CupertinoIcons.eye_slash_fill),
                        ) : IconButton(
                          onPressed: (){
                            if(isObscured == false){
                              setState(() {
                                isObscured = true;
                              });
                            }
                          },
                          icon: Icon(CupertinoIcons.eye),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: CupertinoButton(
                        onPressed: (){
                          showDialog(
                              context: context,
                              builder: (context){
                                return AlertDialog(
                                  alignment: Alignment.center,
                                  scrollable: true,
                                  content: Column(
                                    children: [
                                      CupertinoTextField(
                                        controller: email,
                                        placeholder: "Email",
                                        keyboardType: TextInputType.emailAddress,
                                        restorationId: 'Email',
                                        autocorrect: false,
                                      ),
                                    ],
                                  ),
                                  actions: [
                                    CupertinoButton.filled(
                                      onPressed: (){
                                        fAuth.sendPasswordResetEmail(email: forgotPwdEmail!.text);
                                        Navigator.of(context).pushReplacement(
                                            new MaterialPageRoute(builder: (context) => ForgotPwdSuccess(
                                                forgotPwdEmail!.text
                                            ))
                                        );
                                      },
                                      child: Text("Submit"),
                                    ),
                                  ],
                                );
                              }
                          );
                        },
                        child: Text("Forgot Password"),
                      ),
                    ),
                    SizedBox(height: 10,),
                    Text(isErrorMsg ? errorMsg
                        : "", style: TextStyle(color: Colors.red,),
                    textAlign: TextAlign.center,),
                    SizedBox(height: 10,),
                    CupertinoButton.filled(
                      onPressed: (){
                        fAnalytics.logLogin();
                        setState(() {
                          isLoading = true;
                        });
                        loginFunction();
                      },
                      child: Text("Login"),
                    ),
                    Divider(
                      indent: 20,
                      endIndent: 20,
                    ),
                    CupertinoButton(
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
    // Android
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
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: TextButton(
                      onPressed: (){
                        showDialog(
                          context: context,
                          builder: (context){
                            return AlertDialog(
                              scrollable: true,
                              content: Column(
                                children: [
                                  TextFormField(
                                    controller: forgotPwdEmail,
                                    decoration: InputDecoration(
                                      labelText: 'Registered Email',
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
                                  ),
                                ],
                              ),
                              actions: [
                                ElevatedButton(
                                  onPressed: (){
                                    fAuth.sendPasswordResetEmail(email: forgotPwdEmail!.text);
                                    Navigator.of(context).pushReplacement(
                                      new MaterialPageRoute(builder: (context) => ForgotPwdSuccess(
                                        forgotPwdEmail!.text
                                      ))
                                    );
                                  },
                                  child: Text("Submit")
                                )
                              ],
                            );
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
