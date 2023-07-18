import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:magadh_tech_assignment/otp_page.dart';
class login_page extends StatefulWidget {
  const login_page({super.key});

  @override
  State<login_page> createState() => _login_pageState();
}

class _login_pageState extends State<login_page> {
  TextEditingController country_code= TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();

  Future<void> sendOTP() async {
    final apiUrl = 'https://flutter.magadh.co/api/v1/users/login-request'; //Server OTP API endpoint
    final phoneNumber =phoneNumberController.text;
    print(phoneNumber);

    try {
      final response = await http.post(Uri.parse(apiUrl), body: {
        'phone': phoneNumber,
      });

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        final otp = responseData['otp'] as String;
        final message = responseData['message'] as String;

        print(message); // Print the server message

        // OTP sent successfully, navigate to otp_page
        Navigator.pushNamed(context, 'otp_page', arguments: {
          'phoneNumber': phoneNumber,
          'otp': otp,
        });
      } else {
        final message = jsonDecode(response.body)['message'] as String;
        print('fail: $message');
        // Handle API error
        // Show a SnackBar or display an error message to the user
      }
    } catch (e) {
      print('exception');
      // Handle any exceptions that occur during the API request
    }
  }
  @override
  void initState() {
    // TODO: implement initState
    country_code.text='+91';
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: EdgeInsets.only(left: 25,right: 25),
        alignment: Alignment.center,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                  'Assets/login.png',
                height: 190,
                width: 190,
              ),
              SizedBox(height: 10,),

              Text(
                  'Account Login',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize:  22,
                ),
              ),
              SizedBox(height: 10,),
              Text(
                  'Lets register your phone first before getting started !',
              style: TextStyle(
                fontSize: 16,
              ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20,),

              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(
                    width: 1,
                    color: Colors.grey.shade400,
                  ),
                ),
                child: Row(
                  children: [
                    SizedBox(width: 10,),
                    SizedBox(
                      child: TextField(
                        controller: country_code,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                        ),
                      ),
                      width: 40,
                    ),
                    SizedBox(width: 5,),
                    Text(
                      '|',
                      style: TextStyle(
                          fontSize: 35,
                          color: Colors.grey
                      ),
                    ),
                    SizedBox(width: 10,),
                    Expanded(
                      child: TextField(
                        controller: phoneNumberController,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Phone Number',
                        ),

                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 20,),
              SizedBox(
                height: 50,
                width: double.infinity,
                child: ElevatedButton(
                    onPressed: (){
                      sendOTP();
                    },
                    child: Text("Send One Time Password"),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.deepPurple,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
