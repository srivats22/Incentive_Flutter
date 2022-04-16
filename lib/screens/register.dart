import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:incentive_flutter/common.dart';
import 'package:incentive_flutter/screens/navigation/navigation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:universal_platform/universal_platform.dart';

import '../widgets/custom_input.dart';

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
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(),
        body: isLoading ? Center(
          child: UniversalPlatform.isIOS ? CupertinoActivityIndicator() :
          CircularProgressIndicator(),
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
                    child: CustomInput(
                        name!, "Name", "", "", false,
                        TextInputType.name, false, false,
                    ),
                  ),
                  SizedBox(height: 10,),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * .75,
                    child: CustomInput(
                        email!, "Email", "", "", false,
                        TextInputType.emailAddress, false, false,
                    ),
                  ),
                  SizedBox(height: 10,),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * .75,
                    child: CustomInput(
                        pwd!, "Password", "", "", true,
                        TextInputType.text, true, false,
                    ),
                  ),
                  SizedBox(height: 10,),
                  Text(isErrorMsg ? errorMsg
                      : "", style: TextStyle(color: Colors.red),),
                  SizedBox(height: 10,),
                  btn(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget btn(){
    if(UniversalPlatform.isIOS){
      return CupertinoButton(
        onPressed: (){
          fAnalytics.logSignUp(signUpMethod: "Email & password");
          setState(() {
            isLoading = true;
          });
          registerFunction();
        },
        child: Text("Register"),
        color: Color.fromRGBO(0, 128, 128, 1),
      );
    }
    return ElevatedButton(
      onPressed: isBtnEnabled ? (){
        fAnalytics.logSignUp(signUpMethod: "Email & password");
        setState(() {
          isLoading = true;
        });
        registerFunction();
      } : null,
      child: Text("Register"),
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
