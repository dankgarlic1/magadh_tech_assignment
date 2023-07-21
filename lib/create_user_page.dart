import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:magadh_tech_assignment/otp_page.dart';
import 'package:magadh_tech_assignment/user_listing_page.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';


class CreateUserPage extends StatefulWidget {
  final Function(Map<String, dynamic>) onUserAdded;
  final String token; // Add the 'token' parameter for authentication

  CreateUserPage({required this.onUserAdded, required this.token});
  @override
  _CreateUserPageState createState() => _CreateUserPageState();
}

class _CreateUserPageState extends State<CreateUserPage> {
  String name = '';
  String phone = '';
  String email = '';

  Future<void> addUser() async {
    final apiUrl = 'https://flutter.magadh.co/api/v1/users';

    final request = http.Request('POST', Uri.parse(apiUrl));
    request.headers['Content-Type'] = 'application/json';
    request.headers['Authorization'] = 'Bearer ${widget.token}'; // Add the Bearer token

    // Create the user data as a Map
    final userData = {
      'name': name,
      'email': email,
      'phone': phone,
      'location': {'latitude': 123.123, 'longitude': 123.123},
    };

    request.body = json.encode(userData);

    final response = await http.Client().send(request);
    print(name);
    print(email);
    print(phone);
    print(widget.token);

    if (response.statusCode == 200) {
      final responseData = await response.stream.bytesToString();
      final parsedResponse = json.decode(responseData);
      print(parsedResponse);
      widget.onUserAdded(parsedResponse['user']); // Notify the parent about the new user
      Navigator.pop(context); // Navigate back to the user listing page
    } else {
      print('Failed to add user: ${response.reasonPhrase}');
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create New User'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              decoration: InputDecoration(labelText: 'Name'),
              onChanged: (value) {
                setState(() {
                  name = value;
                });
              },
            ),
            SizedBox(height: 16),
            TextFormField(
              decoration: InputDecoration(labelText: 'Phone'),
              onChanged: (value) {
                setState(() {
                  phone = value;
                });
              },
            ),
            SizedBox(height: 16),
            TextFormField(
              decoration: InputDecoration(labelText: 'Email'),
              onChanged: (value) {
                setState(() {
                  email = value;
                });
              },
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: addUser, // Call the addUser function when the button is pressed
              child: Text('Add User'),
            ),
          ],
        ),
      ),
    );
  }
}