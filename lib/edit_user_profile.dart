import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class EditUserProfile extends StatefulWidget {
  final Map<String, dynamic>? userData;
  final Function(Map<String, dynamic>) updateUserProfile;

  const EditUserProfile({required this.userData, required this.updateUserProfile});

  @override
  State<EditUserProfile> createState() => _EditUserProfileState();
}

class _EditUserProfileState extends State<EditUserProfile> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _locationController = TextEditingController();
  File? _selectedImage;

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.userData?['name'] ?? '';
    _phoneController.text = widget.userData?['phone'] ?? '';
    _emailController.text = widget.userData?['email'] ?? '';
    _locationController.text = widget.userData?['location'] != null
        ? '${widget.userData?['location']['latitude']}, ${widget.userData?['location']['longitude']}'
        : '';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  Future<void> _selectImageFromGallery() async {
    final pickedImage = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        _selectedImage = File(pickedImage.path);
        print('Selected image path: ${_selectedImage?.path}');
      });
    }
  }

  Future<void> updateUserProfile(Map<String, dynamic> newProfile) async {
    final apiUrl = 'https://flutter.magadh.co/api/v1/users';
    // print("fail from edit_user");

    try {
      final headers = {
        'Authorization': 'Bearer ${widget.userData?['token']}', // Use the user's token
      };

      final request = http.MultipartRequest('PATCH', Uri.parse(apiUrl));
      request.headers.addAll(headers);
      request.fields.addAll({
        'location': jsonEncode({'location': newProfile['location']}),
      });

      if (_selectedImage != null) {
        print("image done");
        request.files.add(await http.MultipartFile.fromPath('image', _selectedImage!.path));
      }

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        final responseData = jsonDecode(await response.stream.bytesToString());
        print('User profile updated: $responseData');

        setState(() {
          widget.userData?['name'] = newProfile['name'];
          widget.userData?['phone'] = newProfile['phone'];
          widget.userData?['email'] = newProfile['email'];
          widget.userData?['location'] = newProfile['location'];
          widget.userData?['image'] = responseData['user']['image'];
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Profile updated successfully!')),
        );
      } else {
        print('Failed to update user profile: ${response.reasonPhrase}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update profile!')),
        );
      }
    } catch (e) {
      print('Exception occurred while updating user profile: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred!')),
      );
    }
  }

  Future<void> getImagePath() async {
    final apiUrl = 'https://flutter.magadh.co/${widget.userData?['image']}';

    try {
      final headers = {
        'Authorization': 'Bearer ${widget.userData?['token']}', // Use the user's token
      };

      final response = await http.get(Uri.parse(apiUrl), headers: headers);

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        print('Image path: $responseData');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Image path: ${responseData['user']['image']}')),
        );
      } else {
        print('Failed to get image path: ${response.reasonPhrase}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to get image path!')),
        );
      }
    } catch (e) {
      print('Exception occurred while getting image path: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit User Profile'),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 30),
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Name',
                contentPadding: EdgeInsets.only(left: 15),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a name';
                }
                return null;
              },
            ),
            SizedBox(height: 15),
            TextFormField(
              controller: _phoneController,
              decoration: InputDecoration(
                labelText: 'Phone',
                contentPadding: EdgeInsets.only(left: 15),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a phone number';
                }
                return null;
              },
            ),
            SizedBox(height: 15),
            TextFormField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                contentPadding: EdgeInsets.only(left: 15),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter an email address';
                }
                return null;
              },
            ),
            SizedBox(height: 15),
            TextFormField(
              controller: _locationController,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.only(left: 15),
                labelText: 'Location (Latitude, Longitude)',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter the location';
                }
                return null;
              },
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                _selectImageFromGallery();
              },
              child: Text('Select Profile Picture'),
            ),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState?.validate() ?? false) {
                  updateUserProfile({
                    'name': _nameController.text,
                    'phone': _phoneController.text,
                    'email': _emailController.text,
                    'location': {
                      'latitude': double.tryParse(_locationController.text.split(',')[0].trim()) ?? 0.0,
                      'longitude': double.tryParse(_locationController.text.split(',')[1].trim()) ?? 0.0,
                    },
                  });
                }
              },
              child: Text('Update Profile'),
            ),
          ],
        ),
      ),
    );
  }
}
