import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:google_maps_flutter/google_maps_flutter.dart';

class UserListingPage extends StatefulWidget {
  @override
  _UserListingPageState createState() => _UserListingPageState();
}

class _UserListingPageState extends State<UserListingPage> {
  List<Map<String, dynamic>> users = [];

  Future<void> fetchUsers() async {
    final apiUrl = 'https://flutter.magadh.co/api/v1/users';

    try {
      final response = await http.get(Uri.parse(apiUrl));

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
    fetchUsers();
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
