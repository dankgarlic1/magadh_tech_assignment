import 'package:flutter/material.dart';
import 'package:magadh_tech_assignment/login_page.dart';
import 'package:magadh_tech_assignment/map_view_page.dart';
import 'package:magadh_tech_assignment/otp_page.dart';
import 'package:magadh_tech_assignment/user_listing_page.dart';

void main() {
  runApp( MaterialApp(
    debugShowCheckedModeBanner: false,
    initialRoute:'map_view_page',
    routes: {
      'login_page':(context) => login_page(),
      'otp_page':(context) => otp_page(),
      'user_listing_page': (context) => UserListingPage(),
      'map_view_page': (context) => MapViewPage(users: [],),
    },
  ),
  );
}
