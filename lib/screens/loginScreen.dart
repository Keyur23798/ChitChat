import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:whatsapp/Utils/CustomColors.dart';
import 'package:whatsapp/screens/otpScreen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController phoneNumber = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.fromLTRB(20, 50, 20, 0),
        color: Colors.white,
        child: Column(
          children: [
            Image(
              image: AssetImage('assets/logo.png'),
              alignment: Alignment.center,
              height: 75,
              width: 75,
              fit: BoxFit.fill,
            ),
            SizedBox(
              height: 50,
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Mobile Number",
                style: TextStyle(color: Colors.black, fontSize: 20),
              ),
            ),
            TextField(
              autofocus: true,
              controller: phoneNumber,
              style: TextStyle(fontSize: 17, color: Colors.black),
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: "Enter Phone number",
                prefixText: '+91 ',
              ),
              maxLength: 10,
            ),
            SizedBox(
              height: 50,
            ),
            Container(
              margin: EdgeInsets.only(right: 15, left: 15),
              width: double.infinity,
              height: 40,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: AppColors.mainColor,
              ),
              child: FlatButton(
                onPressed: () {
                  if (phoneNumber.text.isEmpty ||
                      phoneNumber.text.length < 10) {
                    Fluttertoast.showToast(
                        msg: "Please enter valid phonenumber",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.red.shade300,
                        textColor: Colors.white,
                        fontSize: 16.0);
                  } else {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => OTPScreen(
                                  mobileNumber: phoneNumber.text,
                                )));
                  }
                },
                child: Text(
                  "Submit",
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
