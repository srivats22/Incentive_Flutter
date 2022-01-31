import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

// firebase related
FirebaseAuth fAuth = FirebaseAuth.instance;
FirebaseFirestore fStore = FirebaseFirestore.instance;
FirebaseAnalytics fAnalytics = FirebaseAnalytics();
User? currUser = fAuth.currentUser;

final isWebMobile =
    kIsWeb && (defaultTargetPlatform == TargetPlatform.iOS || defaultTargetPlatform == TargetPlatform.android);

// links
String appUrl = "https://play.google.com/store/apps/details?id=com.srivats.todoincentive";
String privacyLink =
    "https://srivats22.notion.site/srivats22/Incentive-Privacy-Statement-83e236c5e5d84fccbf59cf124fbc7eaa";