import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pinput/pin_put/pin_put.dart';
import 'package:whatsapp/Utils/CustomColors.dart';
import 'package:whatsapp/screens/ProfileInfo.dart';

class OTPScreen extends StatefulWidget {
  String? mobileNumber;

  OTPScreen({this.mobileNumber});

  @override
  _OTPScreenState createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  final TextEditingController _pinPutController = TextEditingController();
  final FocusNode _pinPutFocusNode = FocusNode();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  String _verificationId = '';

  void verifyPhoneNumber() async {
    //Callback for when the user has already previously signed in with this phone number on this device
    PhoneVerificationCompleted verificationCompleted =
        (PhoneAuthCredential phoneAuthCredential) async {
      await _auth.signInWithCredential(phoneAuthCredential);
      Fluttertoast.showToast(
          msg: "Phone number automatically verified and user signed in: ${_auth.currentUser!.uid}",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0
      );
    };

    //Listens for errors with verification, such as too many attempts
    PhoneVerificationFailed verificationFailed =
        (FirebaseAuthException authException) {
          Fluttertoast.showToast(
              msg: 'Phone number verification failed. Code: ${authException.code}. Message: ${authException.message}',
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0
          );
    };

    await _auth.verifyPhoneNumber(
      phoneNumber: '+91${widget.mobileNumber!.trim()}',
      timeout: const Duration(seconds: 60),
      verificationCompleted: verificationCompleted,
      verificationFailed: verificationFailed,
      codeSent: (String verificationId, int? resendToken) async {
        _verificationId = verificationId;

        // String smsCode = '****';
        // // Create a PhoneAuthCredential with the code
        // PhoneAuthCredential credential = PhoneAuthProvider.credential(verificationId: verificationId, smsCode: smsCode);
        // // Sign the user in (or link) with the credential
        // await _auth.signInWithCredential(credential);
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        // Fluttertoast.showToast(
        //     msg: "verification code: " + verificationId,
        //     toastLength: Toast.LENGTH_SHORT,
        //     gravity: ToastGravity.CENTER,
        //     timeInSecForIosWeb: 1,
        //     backgroundColor: Colors.red,
        //     textColor: Colors.white,
        //     fontSize: 16.0
        // );
        print(verificationId);
        _verificationId = verificationId;
      },
    );

  }

  void signInWithPhoneNumber() async {
    try {
      final AuthCredential credential = PhoneAuthProvider.credential(
        verificationId: _verificationId,
        smsCode: _pinPutController.text,
      );

      final User? user = (await _auth.signInWithCredential(credential)).user;
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  ProfileInfoSC(mobileNumber: widget.mobileNumber ?? '',)));
      Fluttertoast.showToast(
          msg: "Successfully signed in UID: ${user!.uid}",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0
      );
    } catch (e) {
      Fluttertoast.showToast(
          msg: "Invalid OTP" + e.toString(),
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0
      );
    }
  }

  BoxDecoration get _pinPutDecoration {
    return BoxDecoration(
      border: Border.all(color: AppColors.mainColor ),
      borderRadius: BorderRadius.circular(15.0),
    );
  }

  @override
  void initState() {
    verifyPhoneNumber();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.white,
        body: Builder(
          builder: (context) {
            return Container(
              padding: EdgeInsets.fromLTRB(20, 30, 20, 0),
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: 40,
                  ),
                  Image(
                    image: AssetImage("assets/logo.png"),
                    height: 75,
                    width: 75,
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  Text(
                    "Please enter verification code\nthat we have sent to you on\n+91${widget.mobileNumber}",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Center(
                    child: Container(
                      color: Colors.white,
                      padding:
                      const EdgeInsets.only(top: 40, left: 20, right: 20),
                      child: PinPut(
                        fieldsCount: 6,
                        onSubmit: (String pin) async {
                          // String smsCode = pin;
                          // // Create a PhoneAuthCredential with the code
                          // PhoneAuthCredential credential = PhoneAuthProvider.credential(verificationId: _verificationId, smsCode: smsCode);
                          // // Sign the user in (or link) with the credential
                          // await _auth.signInWithCredential(credential);
                          signInWithPhoneNumber();
                          // if(credential.smsCode == pin) {
                          //   Navigator.pushReplacement(
                          //       context,
                          //       MaterialPageRoute(
                          //           builder: (context) =>
                          //               LoginScreen2()));
                          // } else {
                          //   _pinPutController.clear();
                          //   Fluttertoast.showToast(
                          //       msg: "Invalid OTP",
                          //       toastLength: Toast.LENGTH_SHORT,
                          //       gravity: ToastGravity.BOTTOM,
                          //       timeInSecForIosWeb: 1,
                          //       backgroundColor: Colors.red.shade300,
                          //       textColor: Colors.white,
                          //       fontSize: 16.0
                          //   );
                          // }
                        },
                        focusNode: _pinPutFocusNode,
                        controller: _pinPutController,
                        submittedFieldDecoration: _pinPutDecoration.copyWith(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        selectedFieldDecoration: _pinPutDecoration,
                        followingFieldDecoration: _pinPutDecoration.copyWith(
                          borderRadius: BorderRadius.circular(15.0),
                          border: Border.all(
                            color: AppColors.mainColor,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(right: 20),
                    alignment: Alignment.centerRight,
                    child: FlatButton(
                      color:AppColors.mainColor,
                      height: 30,
                      child: (Text(
                        "Resend OTP",
                        style: TextStyle(fontSize: 14, color: Colors.white),
                      )),
                      onPressed: () {
                        _pinPutController.clear();
                        verifyPhoneNumber();
                      },
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Container(
                    margin: EdgeInsets.only(right: 15, left: 15),
                    width: double.infinity,
                    height: 40,
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),color: AppColors.mainColor,),

                    child: FlatButton(
                      onPressed: () {
                        signInWithPhoneNumber();
                      },
                      child: Text("Submit",  style: TextStyle(fontSize: 14, color: Colors.white),),

                    ),
                  )
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

