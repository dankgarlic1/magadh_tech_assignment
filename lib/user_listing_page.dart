import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:magadh_tech_assignment/otp_page.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';

class UserListingPage extends StatefulWidget {
  @override
  _UserListingPageState createState() => _UserListingPageState();
}

class _UserListingPageState extends State<UserListingPage> {
  List<Map<String, dynamic>> users = [];

  Future<void> fetchUsers(String token) async {
    final apiUrl = 'https://flutter.magadh.co/api/v1/users';
    print("nigg");
    print(token);

    try {
      final headers = {
        'Authorization': 'Bearer $token',
      };

      final response = await http.get(Uri.parse(apiUrl), headers: headers);

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        setState(() {
          users = List<Map<String, dynamic>>.from(responseData['users']);
        });
      } else {
        print('Failed to fetch users: ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Exception occurred while fetching users: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    // You need to pass the token obtained after token verification to fetchUsers
    // For example, if you have stored the token in a variable called 'token'
    // you can pass it as follows:
    // final token = ... // Get the token from wherever it was stored
    fetchUsers('');
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Listing'),
      ),
      body: users.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: users.length,
        itemBuilder: (context, index) {
          final user = users[index];
          return ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(user['image']),
            ),
            title: Text(user['name']),
            subtitle: Text(user['email']),
            trailing: Icon(Icons.arrow_forward),
            onTap: () {
              // Handle user detail page navigation
            },
          );
        },
      ),
    );
  }
}
