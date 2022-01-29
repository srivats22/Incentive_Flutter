import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:incentive_flutter/common.dart';
import 'package:incentive_flutter/screens/navigation/navigation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:universal_platform/universal_platform.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  bool isLoading = false;
  bool isObscured = true;
  bool isBtnEnabled = false;
  bool isErrorMsg = false;
  String errorMsg = "";
  TextEditingController? name, email, pwd;
  final GlobalKey<FormState> registerKey = new GlobalKey<FormState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    name = new TextEditingController();
    email = new TextEditingController();
    pwd = new TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    if(UniversalPlatform.isIOS){
      return SafeArea(
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            iconTheme: IconThemeData(color: Colors.black),
            elevation: 0,
          ),
          body: isLoading ? Center(
            child: CupertinoActivityIndicator(),
          ) : Center(
            child: Form(
              key: registerKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              onChanged: (){
                if(registerKey.currentState!.validate()){
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
                        controller: name,
                        placeholder: "Name",
                        keyboardType: TextInputType.name,
                        autofillHints: [AutofillHints.name],
                      ),
                    ),
                    SizedBox(height: 10,),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * .75,
                      child: CupertinoTextField(
                        controller: email,
                        placeholder: "Email",
                        keyboardType: TextInputType.emailAddress,
                        autofillHints: [AutofillHints.email],
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
                        autofillHints: [AutofillHints.password],
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
                    SizedBox(height: 10,),
                    Text(isErrorMsg ? errorMsg
                        : "", style: TextStyle(color: Colors.red),),
                    SizedBox(height: 10,),
                    CupertinoButton.filled(
                      onPressed: (){
                        fAnalytics.logSignUp(signUpMethod: "Email & password");
                        setState(() {
                          isLoading = true;
                        });
                        registerFunction();
                      },
                      child: Text("Register"),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    }
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(),
        body: isLoading ? Center(
          child: CircularProgressIndicator(),
        ) : Center(
          child: Form(
            key: registerKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            onChanged: (){
              if(registerKey.currentState!.validate()){
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
                      controller: name,
                      decoration: InputDecoration(
                        labelText: 'Name',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      validator: (input){
                        if(input!.isEmpty){
                          return 'Name is required';
                        }
                        return null;
                      },
                      autofillHints: [AutofillHints.name],
                    ),
                  ),
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
                      onFieldSubmitted: (onSubmitted){
                        if(registerKey.currentState!.validate()){
                          fAnalytics.logSignUp(signUpMethod: "Email & password");
                          setState(() {
                            isLoading = true;
                          });
                          registerFunction();
                        }
                      },
                      obscureText: isObscured,
                      autofillHints: [AutofillHints.newPassword],
                    ),
                  ),
                  SizedBox(height: 10,),
                  Text(isErrorMsg ? errorMsg
                      : "", style: TextStyle(color: Colors.red),),
                  SizedBox(height: 10,),
                  ElevatedButton(
                    onPressed: isBtnEnabled ? (){
                      fAnalytics.logSignUp(signUpMethod: "Email & password");
                      setState(() {
                        isLoading = true;
                      });
                      registerFunction();
                    } : null,
                    child: Text("Register"),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void registerFunction() async{
    try{
      User? user = (await fAuth.createUserWithEmailAndPassword(
          email: email!.text, password: pwd!.text)).user;

      await user!.updateDisplayName(name!.text);
      SharedPreferences userName = await SharedPreferences.getInstance();
      if(user.displayName == null){
        userName.setString("username", "${name!.text}");
      }

      fStore.collection("users").doc(user.uid)
      .set({
        "name": name!.text,
        "email": email!.text,
        "uid": user.uid,
      });

      Navigator.of(context).popUntil((route) => route.isFirst);
      Navigator.of(context).pushReplacement(
          new MaterialPageRoute(builder: (context) => Navigation())
      );
    }
    on FirebaseAuthException catch(e){
      if(e.code == 'email-already-in-use'){
        setState(() {
          isLoading = false;
          isErrorMsg = true;
          errorMsg = "Email is already in use";
        });
      }
    }
  }
}
