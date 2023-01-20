import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_dynamic_theme/easy_dynamic_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:share_plus/share_plus.dart';
import 'package:universal_platform/universal_platform.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../common.dart';
import 'package:incentive_flutter/screens/login/login.dart';

class Account extends StatefulWidget {
  const Account({Key? key}) : super(key: key);

  @override
  _AccountState createState() => _AccountState();
}

class _AccountState extends State<Account> {
  String? name;
  String? appName;
  User? user;
  String? versionNum;

  initialization() async{
    user = FirebaseAuth.instance.currentUser;
    setState(() {
      name = user!.displayName;
    });
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      versionNum = packageInfo.version;
      appName = packageInfo.appName;
    });
  }

  @override
  void initState() {
    super.initState();
    initialization();
  }

  @override
  Widget build(BuildContext context) {
    bool isDarkModeOn = Theme.of(context).brightness == Brightness.dark;
    return SafeArea(
      child: Scaffold(
        appBar: UniversalPlatform.isAndroid || isWebMobile
            || UniversalPlatform.isIOS?
        AppBar(
          elevation: 0,
          title: const Text('Account',),
        ) : null,
        body: ListView(
          shrinkWrap: true,
          padding: EdgeInsets.all(10),
          children: [
            SelectableText("$name", style: TextStyle(
                fontSize: 20
            ),),
            SelectableText("${user!.email}",
              style: TextStyle(fontSize: 18),),
            Divider(
              indent: 20,
              endIndent: 20,
            ),
            Visibility(
              visible: !UniversalPlatform.isIOS,
              child: ListTile(
                leading: isDarkModeOn ? Icon(Icons.dark_mode) : Icon(Icons.light_mode),
                title: Text("Change Theme"),
                subtitle: Text(isDarkModeOn ? "Theme: Dark Mode" :
                "Theme: Light Mode"),
                trailing: Switch(
                  value: isDarkModeOn,
                  onChanged: (value){
                    setState(() {
                      isDarkModeOn = value;
                      EasyDynamicTheme.of(context).changeTheme();
                    });
                  },
                ),
              ),
            ),
            Visibility(
              visible: UniversalPlatform.isIOS,
              child: ListTile(
                leading: isDarkModeOn ? Icon(CupertinoIcons.moon_fill) :
                Icon(CupertinoIcons.sun_max_fill),
                title: Text("Change Theme"),
                subtitle: Text(isDarkModeOn ? "Theme: Dark Mode" :
                "Theme: Light Mode"),
                trailing: CupertinoSwitch(
                  value: isDarkModeOn,
                  onChanged: (value){
                    setState(() {
                      isDarkModeOn = value;
                      EasyDynamicTheme.of(context).changeTheme();
                    });
                  },
                ),
              ),
            ),
            Divider(
              indent: 20,
              endIndent: 20,
            ),
            SizedBox(height: 5,),
            Text("App Related", style: TextStyle(fontWeight: FontWeight.bold,
                color: Colors.teal)),
            ListTile(
              onTap: (){
                launchUrl(Uri.parse("$privacyLink"));
              },
              leading: Icon(Icons.privacy_tip),
              title: Text("Privacy"),
            ),
            ListTile(
              onTap: (){
                showAboutDialog(
                  applicationName: "Incentive",
                  applicationVersion: "$versionNum",
                  context: context,
                  applicationIcon: Image.asset(
                      "assets/mipmap-hdpi/ic_launcher.png"
                  ),
                  children: [
                    Text(
                        '''
                        Incentive is a new To-Do app. Where for each app you can write a reward you wish to enjoy after completing that task.
                        '''
                    )
                  ],
                );
              },
              leading: Icon(Icons.info),
              title: Text("About App"),
            ),
            Divider(
              indent: 20,
              endIndent: 20,
            ),
            Text("General", style: TextStyle(fontWeight: FontWeight.bold,
                color: Colors.teal)),
            Visibility(
              visible: UniversalPlatform.isIOS || UniversalPlatform.isAndroid,
              child: ListTile(
                onTap: (){
                  if(UniversalPlatform.isIOS){
                    launchUrl(Uri.parse("$iosUrl"));
                  }
                  if(UniversalPlatform.isAndroid){
                    launchUrl(Uri.parse("$androidUrl"));
                  }
                },
                leading: UniversalPlatform.isIOS ?
                Icon(CupertinoIcons.star_fill) : Icon(Icons.star),
                title: Text("Rate App"),
              ),
            ),
            ListTile(
              onTap: (){
                if(UniversalPlatform.isIOS){
                  showCupertinoModalPopup(
                    context: context,
                    builder: (context) => CupertinoActionSheet(
                      title: Text("What link do you want to share?"),
                      actions: [
                        CupertinoActionSheetAction(
                          child: const Text('Android Link'),
                          onPressed: () {
                            Navigator.pop(context);
                            Share.share("${androidUrl}");
                          },
                        ),
                        CupertinoActionSheetAction(
                          child: const Text('iOS Link'),
                          onPressed: () {
                            Navigator.pop(context);
                            Share.share("${iosUrl}");
                          },
                        ),
                        CupertinoActionSheetAction(
                          child: const Text('Web Link'),
                          onPressed: () {
                            Navigator.pop(context);
                            Share.share("${website}");
                          },
                        ),
                      ],
                    ),
                  );
                }
                else{
                  showModalBottomSheet(
                      context: context,
                      builder: (context){
                        return Container(
                          height: MediaQuery.of(context).size.height * .30,
                          child: ListView(
                            children: [
                              ListTile(
                                onTap: (){
                                  Navigator.of(context).pop();
                                  Share.share("$androidUrl");
                                },
                                title: Text("Android Link"),
                              ),
                              ListTile(
                                onTap: (){
                                  Navigator.of(context).pop();
                                  Share.share("$iosUrl");
                                },
                                title: Text("iOS Link"),
                              ),
                              ListTile(
                                onTap: (){
                                  Navigator.of(context).pop();
                                  Share.share("$website");
                                },
                                title: Text("Web Link"),
                              ),
                            ],
                          ),
                        );
                      }
                  );
                }
              },
              leading: Icon(Icons.share),
              title: Text("Share"),
            ),
            ListTile(
              onTap: (){
                launchUrl(Uri.parse("mailto:srivats.venkataraman@gmail.com"));
              },
              leading: Icon(Icons.email),
              title: Text("Contact Developer"),
            ),
            Divider(
              indent: 20,
              endIndent: 20,
            ),
            Text("Account", style: TextStyle(fontWeight: FontWeight.bold,
                color: Colors.teal)),
            btn(),
            Divider(
              indent: 20,
              endIndent: 20,
            ),
            Text("$versionNum"),
          ],
        )
      ),
    );
  }

  Widget btn(){
    if(UniversalPlatform.isIOS){
      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 5,),
          CupertinoButton(
            onPressed: (){
              fAnalytics.logEvent(name: "logout");
              FirebaseAuth.instance.signOut();
              Navigator.of(context).popUntil((route) => route.isFirst);
              Navigator.of(context).pushReplacement(
                  new MaterialPageRoute(builder: (context) => Login())
              );
            },
            child: Text("Logout"),
            color: Colors.teal,
          ),
          SizedBox(height: 5,),
          CupertinoButton(
            onPressed: (){
              showCupertinoDialog(
                context: context,
                builder: (context){
                  return CupertinoAlertDialog(
                    title: Text("Delete Account"),
                    content: Text("This action cannot be undone. You will have to recreate an account if you wish to use Incentive again"),
                    actions: [
                      CupertinoDialogAction(
                        onPressed: (){
                          fAnalytics.logEvent(name: "Cancelled account deletion");
                          Navigator.of(context).pop();
                        },
                        child: Text("Cancel"),
                      ),
                      CupertinoDialogAction(
                        onPressed: () async{
                          fAnalytics.logEvent(name: "Account deleted");
                          // deletes tasks
                          Future<QuerySnapshot> tasks = FirebaseFirestore.instance
                              .collection("users").doc(user!.uid).collection("tasks").get();
                          await tasks.then((value) => {
                            value.docs.forEach((element) {
                              FirebaseFirestore.instance
                                  .collection("users").doc(user!.uid).collection("tasks")
                                  .doc(element.id).delete();
                            })
                          });
                          // deletes collection
                          FirebaseFirestore.instance
                              .collection("users").doc(user!.uid).delete();
                          // deletes account
                          FirebaseAuth.instance.currentUser!.delete();
                          Navigator.of(context).popUntil((route) => route.isFirst);
                          Navigator.of(context).pushReplacement(
                              new MaterialPageRoute(builder: (context) => Login())
                          );
                        },
                        child: Text("DELETE ACCOUNT", style: TextStyle(color: Colors.red),),
                      ),
                    ],
                  );
                }
              );
            },
            color: Colors.red,
            child: Text("Delete Account"),
          ),
        ],
      );
    }
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ElevatedButton(
          onPressed: (){
            fAnalytics.logEvent(name: "logout");
            FirebaseAuth.instance.signOut();
            Navigator.of(context).popUntil((route) => route.isFirst);
            Navigator.of(context).pushReplacement(
                new MaterialPageRoute(builder: (context) => Login())
            );
          },
          child: Text("Logout"),
        ),
        SizedBox(height: 5,),
        ElevatedButton(
          onPressed: (){
            fAnalytics.logEvent(name: "Account deletion triggered");
            showDialog(
              context: context,
              builder: (context){
                return AlertDialog(
                  title: Text("Delete Account"),
                  content: Text("This action cannot be undone. You will have to recreate an account if you wish to use Incentive again"),
                  actions: [
                    TextButton(
                      onPressed: (){
                        fAnalytics.logEvent(name: "Cancelled account deletion");
                        Navigator.of(context).pop();
                      },
                      child: Text("Cancel"),
                    ),
                    ElevatedButton(
                      onPressed: () async{
                        fAnalytics.logEvent(name: "Account deleted");
                        // deletes tasks
                        Future<QuerySnapshot> tasks = FirebaseFirestore.instance
                            .collection("users").doc(user!.uid).collection("tasks").get();
                        Future<QuerySnapshot> plannedTasks = FirebaseFirestore.instance
                            .collection("users").doc(user!.uid).collection("planned").get();
                        await tasks.then((value) => {
                          value.docs.forEach((element) {
                            FirebaseFirestore.instance
                                .collection("users").doc(user!.uid).collection("tasks")
                                .doc(element.id).delete();
                          })
                        });
                        await plannedTasks.then((value) => {
                          value.docs.forEach((element) {
                            FirebaseFirestore.instance
                                .collection("users").doc(user!.uid).collection("planned")
                                .doc(element.id).delete();
                          })
                        });
                        // deletes collection
                        FirebaseFirestore.instance
                            .collection("users").doc(user!.uid).delete();
                        // deletes account
                        FirebaseAuth.instance.currentUser!.delete();
                        Navigator.of(context).popUntil((route) => route.isFirst);
                        Navigator.of(context).pushReplacement(
                            new MaterialPageRoute(builder: (context) => Login())
                        );
                      },
                      child: Text("DELETE"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red
                      ),
                    ),
                  ],
                );
              }
            );
          },
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white, backgroundColor: Colors.red,
          ),
          child: Text("Delete Account"),
        ),
      ],
    );
  }

  Widget deleteAccountConformation(){
    return Container(
      height: MediaQuery.of(context).size.height * .50,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width * .75,
            child: Text("This Action cannot be undone",
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.bold),),
          ),
          ButtonBar(
            alignment: MainAxisAlignment.center,
            children: [
              TextButton(
                onPressed: (){
                  fAnalytics.logEvent(name: "Cancelled account deletion");
                  Navigator.of(context).pop();
                },
                child: Text("Cancel"),
              ),
              SizedBox(height: 5,),
              ElevatedButton(
                onPressed: () async{
                  fAnalytics.logEvent(name: "Account deleted");
                  // deletes tasks
                  Future<QuerySnapshot> tasks = FirebaseFirestore.instance
                  .collection("users").doc(user!.uid).collection("tasks").get();
                  await tasks.then((value) => {
                    value.docs.forEach((element) {
                      FirebaseFirestore.instance
                          .collection("users").doc(user!.uid).collection("tasks")
                          .doc(element.id).delete();
                    })
                  });
                  // deletes collection
                  FirebaseFirestore.instance
                      .collection("users").doc(user!.uid).delete();
                  // deletes account
                  FirebaseAuth.instance.currentUser!.delete();
                  Navigator.of(context).popUntil((route) => route.isFirst);
                  Navigator.of(context).pushReplacement(
                    new MaterialPageRoute(builder: (context) => Login())
                  );
                },
                child: Text("Delete Account"),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white, backgroundColor: Colors.red,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
