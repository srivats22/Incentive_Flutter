import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:incentive_flutter/screens/account/account.dart';
import 'package:incentive_flutter/screens/current_task/currentTask.dart';
import 'package:incentive_flutter/screens/pending/pending.dart';
import 'package:incentive_flutter/screens/planned/planned.dart';

class MobileNav extends StatefulWidget {

  @override
  _MobileNavState createState() => _MobileNavState();
}

class _MobileNavState extends State<MobileNav> {
  User? user;
  int _selectedIndex = 0;

  void initialization(){
    user = FirebaseAuth.instance.currentUser;
  }

  final pages = [
    CurrentTask(),
    PendingTask(),
    Account(),
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initialization();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
            elevation: 0,
            title: const Text('Incentive', style: TextStyle(color: Colors.black),),
            actions: <Widget>[
              GestureDetector(
                onTap: (){
                  Navigator.of(context).push(new MaterialPageRoute(builder: (context) => Account()));
                },
                child: Padding(
                  padding: EdgeInsets.only(right: 20),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.teal
                        ),
                      ),
                      Text("${user!.displayName}".toString()[0])
                    ],
                  ),
                ),
              ),
            ]
        ),
        body: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(left: 5),
                child: Wrap(
                  alignment: WrapAlignment.start,
                  spacing: 5,
                  runSpacing: 5,
                  children: [
                    ChoiceChip(
                      onSelected: (bool value){
                        if(value){
                          setState(() {
                            _selectedIndex = 0;
                          });
                        }
                        else{
                          setState(() {
                            _selectedIndex = 0;
                          });
                        }
                      },
                      selectedColor: Color.fromRGBO(229, 252, 246, 1),
                      selected: _selectedIndex == 0,
                      label: Text("Tasks", style: GoogleFonts.montserrat(
                          color: Colors.black),),
                    ),
                    ChoiceChip(
                      onSelected: (bool value){
                        if(value){
                          setState(() {
                            _selectedIndex = 1;
                          });
                        }
                        else{
                          setState(() {
                            _selectedIndex = 0;
                          });
                        }
                      },
                      selectedColor: Color.fromRGBO(229, 252, 246, 1),
                      selected: _selectedIndex == 1,
                      label: Text("Pending", style: GoogleFonts.montserrat(
                          color: Colors.black)),
                    ),
                    ChoiceChip(
                      onSelected: (bool value){
                        if(value){
                          setState(() {
                            _selectedIndex = 2;
                          });
                        }
                        else{
                          setState(() {
                            _selectedIndex = 0;
                          });
                        }
                      },
                      selectedColor: Color.fromRGBO(229, 252, 246, 1),
                      selected: _selectedIndex == 2,
                      label: Text("Planned", style: GoogleFonts.montserrat(
                          color: Colors.black)),
                    ),
                  ],
                ),
              ),
              Visibility(
                visible: _selectedIndex == 0,
                child: Expanded(
                  child: CurrentTask(),
                ),
              ),
              Visibility(
                visible: _selectedIndex == 1,
                child: Expanded(
                  child: PendingTask(),
                ),
              ),
              Visibility(
                visible: _selectedIndex == 2,
                child: Expanded(
                  child: Center(
                    child: Planned(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
