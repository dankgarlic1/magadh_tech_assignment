import 'package:flutter/material.dart';
import 'package:magadh_tech_assignment/login_page.dart';
import 'package:magadh_tech_assignment/map_view_page.dart';
import 'package:magadh_tech_assignment/otp_page.dart';
import 'package:magadh_tech_assignment/user_listing_page.dart';
import 'package:magadh_tech_assignment/create_user_page.dart';

void main() {
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
      }, ),
    },
  ),
  );
}
