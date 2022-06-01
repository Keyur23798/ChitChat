import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:whatsapp/screens/ProfileInfo.dart';
import 'homeScreen.dart';
import 'loginScreen.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool? isLogin;

  @override
  void initState() {
    super.initState();
    checkIsLogin();
  }

  checkIsLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    isLogin = prefs.getBool('isLogin');
    print('isLoggedIn = $isLogin');

    new Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  (isLogin == true) ? HomeScreen() : LoginScreen()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
        color: Colors.white,
        child: Stack(
          children: [
            Align(
              alignment: Alignment.bottomCenter,
              child: Text('Developed By Keyur Kanzariya',
                  style: GoogleFonts.lato(
                    textStyle: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        decoration: TextDecoration.none,
                        fontWeight: FontWeight.bold),
                  )
              )
            ),
            Align(
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image(
                    image: AssetImage('assets/logo.png'),
                    height: 125,
                    width: 125,
                  ),
                  SizedBox(height: 10),
                  Text('ChitChat',
                    style: GoogleFonts.satisfy(
                      textStyle: TextStyle(
                          color: Colors.black,
                          fontSize: 23,
                          letterSpacing: 2.5,
                          decoration: TextDecoration.none,
                          fontWeight: FontWeight.bold),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
