import 'package:flutter/material.dart';
import 'package:magadh_tech_assignment/login_page.dart';
import 'package:magadh_tech_assignment/user_listing_page.dart';
import 'package:pinput/pinput.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class otp_page extends StatefulWidget {
  final String phoneNumber;
  final String correct_otp;
  final String token;

  otp_page({required this.phoneNumber, required this.correct_otp, required this.token});

  @override
  State<otp_page> createState() => _otp_pageState();
}

class _otp_pageState extends State<otp_page> {
  TextEditingController otpController = TextEditingController();
  String receivedOtp = ''; // Store the OTP received from the login page
  String enteredOtp = ''; // Store the OTP entered by the user
  String token = ''; // Store the token after successful OTP verification

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final args = ModalRoute.of(context)?.settings.arguments as String?;
    if (args != null) {
      receivedOtp = args; // Assign the argument to receivedOTP variable
    }
  }
  Future<void> verifyOTP() async {
    final apiUrl = 'https://flutter.magadh.co/api/v1/users/login-verify';

    final headers = {
      'Content-Type': 'application/json',
    };

    final body = json.encode({
      "phone": widget.phoneNumber, // Access phoneNumber from the widget
      "otp": enteredOtp,
    });

    final response = await http.post(Uri.parse(apiUrl), headers: headers, body: body);

    print(receivedOtp);
    print(widget.phoneNumber); // Access phoneNumber from the widget
    print(enteredOtp);
    print(widget.correct_otp);
    print(token);

    if (response.statusCode==200 && enteredOtp == widget.correct_otp) { // Use correct_otp from the widget
      // The request was successful
      final jsonResponse = json.decode(response.body);
      token = jsonResponse['token']; // Store the token from the response
      print(jsonResponse); // You can access data from the response using jsonResponse['key']
      // OTP verification successful, show an AlertDialog with the OTP
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('OTP Verification Successful'),
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Congratulations!, you are ready to go!'),
                // Add any other content you want to display in the dialog
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  // Close the dialog when the user taps the button
                  verifyToken(token);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => UserListingPage(
                        token:token ,
                      ),
                    ),
                  );
                },
                child: Text('Okay'),
              ),
            ],
          );
        },
      );
    } else {
      // OTP verification failed
      // Show a SnackBar or display an error message to the user
      print('OTP verification failed');
      print('API request failed: ${response.reasonPhrase}');
    }
  }

  Future<void> verifyToken(String token) async {
    final apiUrl = 'https://flutter.magadh.co/api/v1/users/verify-token';

    final headers = {
      'Authorization': 'Bearer $token',
    };

    final response = await http.get(Uri.parse(apiUrl), headers: headers);

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      print(jsonResponse['message']); // Should print "Token verified"
      print(jsonResponse['user']); // Should print user details
    } else {
      print('Token verification failed');
      print('API request failed: ${response.reasonPhrase}');
    }
  }



  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 56,
      height: 56,
      textStyle: TextStyle(fontSize: 20, color: Color.fromRGBO(30, 60, 87, 1), fontWeight: FontWeight.w600),
      decoration: BoxDecoration(
        border: Border.all(color: Color.fromRGBO(234, 239, 243, 1)),
        borderRadius: BorderRadius.circular(20),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyDecorationWith(
      border: Border.all(color: Color.fromRGBO(114, 178, 238, 1)),
      borderRadius: BorderRadius.circular(8),
    );

    final submittedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration?.copyWith(
        color: Color.fromRGBO(234, 239, 243, 1),
      ),
    );
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(onPressed: (){
          Navigator.pop(context);
        },
            icon: Icon(
              Icons.arrow_back_sharp,
              color: Colors.black87,
            ),
        ),
      ),
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
                'OTP Verification',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize:  22,
                ),
              ),
              SizedBox(height: 10,),
              Text(
                'Enter the OTP you recieved on the phone number you entered',
                style: TextStyle(
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20,),
              Pinput(
                length: 6,
                pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
                showCursor: true,
                onCompleted: (otp) {
                  setState(() {
                    enteredOtp = otp;
                  });
                },
              ),


              SizedBox(height: 20,),
              SizedBox(
                height: 50,
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: (){
                    // enteredOtp = enteredOtp.trim(); // Trim any leading/trailing whitespace from the entered OTP
                    // enteredOtp=otpController.text;
                    print('niffa');
                    print(enteredOtp);
                    verifyOTP();
                  },
                  child: Text("Verify OTP"),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.deepPurple,
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  TextButton(
                      onPressed: (){
                        Navigator.pushNamed(context,'login_page');
                      },
                      child: Text(
                          "Change your Phone Number ?",
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w400,
                      ),
                      ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );

  }
}
