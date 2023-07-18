import 'package:flutter/material.dart';
import 'package:magadh_tech_assignment/login_page.dart';
import 'package:pinput/pinput.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class otp_page extends StatefulWidget {
  const otp_page({super.key});

  @override
  State<otp_page> createState() => _otp_pageState();
}

class _otp_pageState extends State<otp_page> {
  TextEditingController otpController = TextEditingController();
  String phoneNumber = '';
  String receivedOtp = ''; // Store the OTP received from the login page
  String enteredOtp = ''; // Store the OTP entered by the user

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final args = ModalRoute.of(context)?.settings.arguments as String?;
    if (args != null) {
      receivedOtp = args; // Assign the argument to receivedOTP variable
    }
  }


  Future<void> verifyOTP() async {
    final apiUrl = 'https://flutter.magadh.co/api/v1/users/verify-token';
    print(receivedOtp);
    print(enteredOtp);

    if (enteredOtp == receivedOtp) {
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
                Text('Your OTP: $enteredOtp'),
                // Add any other content you want to display in the dialog
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  // Close the dialog when the user taps the button
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    } else {
      // OTP verification failed
      // Show a SnackBar or display an error message to the user
      print('OTP verification failed');
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
                // onSubmitted: (otp) {
                //   setState(() {
                //     enteredOtp = otp; // Update the enteredOtp variable
                //     print('Entered OTP: $enteredOtp');
                //   });
                // },
              ),

              SizedBox(height: 20,),
              SizedBox(
                height: 50,
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: (){
                    enteredOtp=otpController.text;
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
