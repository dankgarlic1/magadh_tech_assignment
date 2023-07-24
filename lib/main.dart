import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:magadh_tech_assignment/firebase_api/firebase_api.dart';
import 'package:magadh_tech_assignment/login_page.dart';
import 'package:magadh_tech_assignment/map_view_page.dart';
import 'package:magadh_tech_assignment/otp_page.dart';
import 'package:magadh_tech_assignment/user_listing_page.dart';
import 'package:magadh_tech_assignment/create_user_page.dart';


import 'package:firebase_messaging/firebase_messaging.dart';


void main()  {
  // WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp();
  // await FirebaseApi().initNotifications();
  runApp( MaterialApp(
    debugShowCheckedModeBanner: false,
    initialRoute:'login_page',
    routes: {
      'login_page':(context) => login_page(),
      'otp_page':(context) => otp_page(correct_otp: '',phoneNumber: '',token: '',),
      'user_listing_page': (context) => UserListingPage(token: ''),
      'map_view_page': (context) => MapViewPage(users: [],),
      'create_user_page':(context) => CreateUserPage(
        token: '',
        onUserAdded: (newUser) {
        // Handle the addition of new users here in the UserListingPage
        Navigator.pop(context); // Pop the CreateUserPage from the stack
      },
      ),
    },
  ),
  );
}
