import 'package:flutter/material.dart';
import 'package:magadh_tech_assignment/edit_user_profile.dart';

class user_detail_page extends StatefulWidget {
  final Map<String, dynamic>? userData;

  const user_detail_page({required this.userData});

  @override
  State<user_detail_page> createState() => _user_detail_pageState();
}

class _user_detail_pageState extends State<user_detail_page> {
  // Function to update the user profile
  Future<void> updateUserProfile(Map<String, dynamic> newProfile) async {
    print("fail from user_detaill_user");

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 80,
                backgroundImage: NetworkImage(widget.userData?['image'] ?? ''),
              ),
              SizedBox(height: 20),
              Text(
                widget.userData?['name'] ?? 'Name not available',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              Text(
                'Phone: ${widget.userData?['phone'] ?? 'Phone not available'}',
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
              SizedBox(height: 10),
              Text(
                'Email: ${widget.userData?['email'] ?? 'Email not available'}',
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
              SizedBox(height: 10,),
              ElevatedButton(
                onPressed: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditUserProfile(
                        userData: widget.userData,
                        updateUserProfile: updateUserProfile,
                      ),
                    ),
                  );
                },
                child: Text("Edit this Profile"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
