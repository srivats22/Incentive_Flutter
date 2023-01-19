import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

var lightTheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.light,
  textTheme: TextTheme(
    headline1: GoogleFonts.montserrat(
        fontSize: 97, fontWeight: FontWeight.w300, letterSpacing: -1.5,
        color: Colors.black),
    headline2: GoogleFonts.montserrat(
        fontSize: 61, fontWeight: FontWeight.w300, letterSpacing: -0.5,
        color: Colors.black),
    headline3:
    GoogleFonts.montserrat(fontSize: 48, fontWeight: FontWeight.w400,
        color: Colors.black),
    headline4: GoogleFonts.montserrat(
        fontSize: 34, fontWeight: FontWeight.w400, letterSpacing: 0.25,
        color: Colors.black),
    headline5:
    GoogleFonts.montserrat(fontSize: 24, fontWeight: FontWeight.w400,
        color: Colors.black),
    headline6: GoogleFonts.montserrat(
        fontSize: 20, fontWeight: FontWeight.w500, letterSpacing: 0.15,
        color: Colors.black),
    subtitle1: GoogleFonts.montserrat(
        fontSize: 16, fontWeight: FontWeight.w400, letterSpacing: 0.15,
        color: Colors.black),
    subtitle2: GoogleFonts.montserrat(
        fontSize: 14, fontWeight: FontWeight.w500, letterSpacing: 0.1,
        color: Colors.black),
    bodyText1: GoogleFonts.montserrat(
        fontSize: 16, fontWeight: FontWeight.w400, letterSpacing: 0.5,
        color: Colors.black),
    bodyText2: GoogleFonts.montserrat(
        fontSize: 14, fontWeight: FontWeight.w400, letterSpacing: 0.25,
        color: Colors.black),
    button: GoogleFonts.montserrat(
        fontSize: 14, fontWeight: FontWeight.w500, letterSpacing: 1.25,
        color: Colors.black),
    caption: GoogleFonts.montserrat(
        fontSize: 12, fontWeight: FontWeight.w400, letterSpacing: 0.4,
        color: Colors.black),
    overline: GoogleFonts.montserrat(
        fontSize: 10, fontWeight: FontWeight.w400, letterSpacing: 1.5,
        color: Colors.black),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
        primary: Color.fromRGBO(0, 128, 128, 1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
        onPrimary: Colors.white,
        elevation: 8.0),
  ),
  outlinedButtonTheme: OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      primary: Color.fromRGBO(0, 128, 128, 1),
      side: BorderSide(
        color: Color.fromRGBO(0, 128, 128, 1),
        width: 2,
      ),
    ),
  ),
  inputDecorationTheme: InputDecorationTheme(
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(20),
      borderSide: BorderSide(
        width: 2,
      ),
    ),
    focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: BorderSide(
          color: Color.fromRGBO(120, 176, 177, 1),
          width: 2,
        )),
  ),
  appBarTheme: AppBarTheme(
    elevation: 0,
    color: Colors.white,
    iconTheme: IconThemeData(color: Colors.black),
    titleTextStyle: GoogleFonts.montserrat(
        fontSize: 20, fontWeight: FontWeight.w500, letterSpacing: 0.15,
        color: Colors.black),
  ),
  dividerTheme: DividerThemeData(
    color: Colors.black,
  ),
  navigationRailTheme: NavigationRailThemeData(
    selectedLabelTextStyle: TextStyle(color: Colors.black),
    selectedIconTheme: IconThemeData(color: Colors.black),
  ),
  iconTheme: IconThemeData(color: Colors.black),
);

var darkTheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.dark,

  textTheme: TextTheme(
    headline1: GoogleFonts.montserrat(
        fontSize: 97, fontWeight: FontWeight.w300, letterSpacing: -1.5,
        color: Colors.white),
    headline2: GoogleFonts.montserrat(
        fontSize: 61, fontWeight: FontWeight.w300, letterSpacing: -0.5,
        color: Colors.white),
    headline3:
    GoogleFonts.montserrat(fontSize: 48, fontWeight: FontWeight.w400,
        color: Colors.white),
    headline4: GoogleFonts.montserrat(
        fontSize: 34, fontWeight: FontWeight.w400, letterSpacing: 0.25,
        color: Colors.white),
    headline5:
    GoogleFonts.montserrat(fontSize: 24, fontWeight: FontWeight.w400,
        color: Colors.white),
    headline6: GoogleFonts.montserrat(
        fontSize: 20, fontWeight: FontWeight.w500, letterSpacing: 0.15,
        color: Colors.white),
    subtitle1: GoogleFonts.montserrat(
        fontSize: 16, fontWeight: FontWeight.w400, letterSpacing: 0.15,
        color: Colors.white),
    subtitle2: GoogleFonts.montserrat(
        fontSize: 14, fontWeight: FontWeight.w500, letterSpacing: 0.1,
        color: Colors.white),
    bodyText1: GoogleFonts.montserrat(
        fontSize: 16, fontWeight: FontWeight.w400, letterSpacing: 0.5,
        color: Colors.white),
    bodyText2: GoogleFonts.montserrat(
        fontSize: 14, fontWeight: FontWeight.w400, letterSpacing: 0.25,
        color: Colors.white),
    button: GoogleFonts.montserrat(
        fontSize: 14, fontWeight: FontWeight.w500, letterSpacing: 1.25,
        color: Colors.white),
    caption: GoogleFonts.montserrat(
        fontSize: 12, fontWeight: FontWeight.w400, letterSpacing: 0.4,
        color: Colors.white),
    overline: GoogleFonts.montserrat(
        fontSize: 10, fontWeight: FontWeight.w400, letterSpacing: 1.5,
        color: Colors.white),
  ),
  appBarTheme: AppBarTheme(
    elevation: 0,
    iconTheme: IconThemeData(color: Colors.white),
    titleTextStyle: GoogleFonts.montserrat(
      fontSize: 20, fontWeight: FontWeight.w500, letterSpacing: 0.15,
      color: Colors.white),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
        primary: Color.fromRGBO(0, 128, 128, 1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
        onPrimary: Colors.white,
        elevation: 8.0),
  ),
  outlinedButtonTheme: OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      primary: Color.fromRGBO(0, 128, 128, 1),
      side: BorderSide(
        color: Color.fromRGBO(0, 128, 128, 1),
        width: 2,
      ),
    ),
  ),
  inputDecorationTheme: InputDecorationTheme(
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(20),
      borderSide: BorderSide(
        width: 2,
      ),
    ),
    focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: BorderSide(
          color: Color.fromRGBO(120, 176, 177, 1),
          width: 2,
        )),
  ),
  dividerTheme: DividerThemeData(
    color: Colors.white,
  ),
  navigationRailTheme: NavigationRailThemeData(
    selectedLabelTextStyle: TextStyle(color: Colors.white),
    selectedIconTheme: IconThemeData(color: Colors.white),
  ),
  iconTheme: IconThemeData(color: Colors.white),
);