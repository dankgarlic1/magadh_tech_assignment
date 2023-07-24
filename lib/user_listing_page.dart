import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:magadh_tech_assignment/create_user_page.dart';
import 'package:magadh_tech_assignment/user_detaill_page.dart';
import 'package:magadh_tech_assignment/map_view_page.dart';


class UserListingPage extends StatefulWidget {
  final String token; // Adding the 'token' parameter to the constructor

  UserListingPage({required this.token}); // Constructor that receives the token

  @override
  _UserListingPageState createState() => _UserListingPageState();
}

class _UserListingPageState extends State<UserListingPage> {
  List<Map<String, dynamic>> users = [];
  List<String> allTokens = []; // List to store all the extracted tokens
  static const String defaultImageUrl = 'https://i.pinimg.com/564x/bf/e5/fd/bfe5fd63c5124fbb3730c5b9e2d3bc01.jpg';

  Future<void> fetchUsers() async {
    final apiUrl = 'https://flutter.magadh.co/api/v1/users';

    try {
      final headers = {
        'Authorization': 'Bearer ${widget.token}', // Using the widget's token
      };

      final response = await http.get(Uri.parse(apiUrl), headers: headers);

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        print(responseData);
        setState(() {
          users = List<Map<String, dynamic>>.from(responseData['users']);
          allTokens = users.map((user) => user['token'].toString()).toList();
        });
      } else {
        print('Failed to fetch users: ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Exception occurred while fetching users: $e');
    }
  }

  void navigateToCreateUserPage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => CreateUserPage(
        token: widget.token, // Pass the token to CreateUserPage
        onUserAdded: addUserToList, // Pass the function to handle new user addition
      ),
      ),
    );
  }
  void addUserToList(Map<String, dynamic> newUser) {
    setState(() {
      users.add(newUser);
    });
  }

  void navigateToUserDetailPage(Map<String, dynamic> user) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => user_detail_page(userData: user),
      ),
    );
  }


  @override
  void initState() {
    super.initState();
    fetchUsers();
  }

  @override
  Widget build(BuildContext context) {
    // Define the custom primary color
    final customPrimaryColor = MaterialColor(0xFF4E4FEB, {
      50: Color(0xFFE8E9FC),
      100: Color(0xFFC6C8F9),
      200: Color(0xFFA2A6F6),
      300: Color(0xFF7D82F3),
      400: Color(0xFF6268F1),
      500: Color(0xFF4E4FEB),
      600: Color(0xFF4649E9),
      700: Color(0xFF3B3EE7),
      800: Color(0xFF3136E4),
      900: Color(0xFF1F25E1),
    });

    return MaterialApp(
      theme: ThemeData(
        primarySwatch: customPrimaryColor,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('User Listing'),
          actions: [
            FloatingActionButton(
              onPressed: () async {
                // Navigate to CreateUserPage and get the newly added user
                final newUser = await Navigator.push<Map<String, dynamic>>(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CreateUserPage(
                      onUserAdded: addUserToList,
                      token: widget.token,
                    ),
                  ),
                );
                if (newUser != null) {
                  addUserToList(newUser);
                }
              },
              tooltip: 'Add User',
              child: Icon(Icons.add),
              elevation: 0,
            ),
            IconButton(
              onPressed: () {
                print(users);
                // Navigate to the MapViewPage with all users' data
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MapViewPage(users: users),
                  ),
                );
              },
              icon: Icon(Icons.map),
            ),
          ],
        ),
        body: users.isEmpty
            ? Center(child: CircularProgressIndicator())
            : ListView.builder(
          itemCount: users.length,
          itemBuilder: (context, index) {
            final user = users[index];
            return Card(
              color: Colors.white, // Customize card color
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
                side: BorderSide(color: customPrimaryColor.shade400, width: 1.0),
              ),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(user['image'] ?? _UserListingPageState.defaultImageUrl),
                ),
                title: Text(
                  user['name'],
                  style: TextStyle(
                    color: customPrimaryColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 18.0,
                  ),
                ),
                subtitle: Text(
                  user['email'],
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                ),
                trailing: Icon(Icons.arrow_forward),
                onTap: () {
                  navigateToUserDetailPage(user);
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
