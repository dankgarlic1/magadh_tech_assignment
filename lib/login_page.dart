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
  TextEditingController country_code = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  String phoneNumber = '';

  Future<void> sendOTP() async {
    var headers = {
      'Content-Type': 'application/json'
    };
    var request = http.Request('POST', Uri.parse('https://flutter.magadh.co/api/v1/users/login-request'));
    request.body = json.encode({
      "phone": phoneNumber,
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      final response_data=await response.stream.bytesToString();
      print(response_data);
      final jsonResponse = jsonDecode(response_data);
      final otp = jsonResponse['otp'] as int;
      print(otp);
      final otp_str='$otp';

      // Now you have the OTP value in the 'otp' variable, you can use it as needed
      print('Generated OTP: $otp');
     // Extract 'otp' value as an integer


      Navigator.pushNamed(context,'otp_page',arguments: otp_str);
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('OTP Generation Successfull'),
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Text('Generated OTP: $otp'),
                SizedBox(height: 10),
                Text('OTP: '),
                Text('$otp'),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context); // Close the dialog
                },
                child: Text('Okay'),
              ),
            ],
          );
        },
      );


    }
    else {
      print(response.reasonPhrase);
    }

  }

  @override
  void initState() {
    // TODO: implement initState
    country_code.text = '+91';
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: EdgeInsets.only(left: 25, right: 25),
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
                        onChanged: (value) {
                          // Remove any non-digit characters from the entered text
                          phoneNumber = value.replaceAll(RegExp(r'[^\d]'), '');
                        },
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
                  onPressed: sendOTP,
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
