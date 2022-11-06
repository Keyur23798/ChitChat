import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:whatsapp/Utils/CustomColors.dart';
import 'package:whatsapp/screens/Security.dart';

import 'Splash.dart';

class AccountSC extends StatefulWidget {
  const AccountSC({Key? key}) : super(key: key);

  @override
  _AccountSCState createState() => _AccountSCState();
}

class _AccountSCState extends State<AccountSC> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white, //change your color here
        ),
        title: Text(
          'Account',
          style: TextStyle(
              color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
        ),
        backgroundColor: AppColors.mainColor,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              Card(
                elevation: 0,
                color: Colors.transparent,
                child: Row(
                  children: [
                    Icon(Icons.lock,size: 25,color: Colors.blueGrey.shade400,),
                    SizedBox(
                      width: 20,
                    ),
                    Expanded(
                      child: Text(
                        'Privacy',
                          style: GoogleFonts.lato(
                            textStyle: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                decoration: TextDecoration.none,
                                fontWeight: FontWeight.normal),
                          )
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>SecuritySC()));
                },
                child: Card(
                  elevation: 0,
                  color: Colors.transparent,
                  child: Row(
                    children: [
                      Icon(Icons.shield,size: 25,color: Colors.blueGrey.shade400,),
                      SizedBox(
                        width: 20,
                      ),
                      Expanded(
                        child: Text(
                            'Security',
                            style: GoogleFonts.lato(
                              textStyle: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  decoration: TextDecoration.none,
                                  fontWeight: FontWeight.normal),
                            )
                        ),
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Card(
                elevation: 0,
                color: Colors.transparent,
                child: Row(
                  children: [
                    Icon(Icons.send_to_mobile,size: 25,color: Colors.blueGrey.shade400,),
                    SizedBox(
                      width: 20,
                    ),
                    Expanded(
                      child: Text(
                          'Change Number',
                          style: GoogleFonts.lato(
                            textStyle: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                decoration: TextDecoration.none,
                                fontWeight: FontWeight.normal),
                          )
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              GestureDetector(
                onTap: (){
                  showDialog(
                      context: context,
                      barrierColor: Colors.black.withOpacity(0.65),
                      builder: (BuildContext context) {
                        return StatefulBuilder(
                          builder: (context, setState) {
                            return AlertDialog(
                              scrollable: false,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              backgroundColor: Colors.transparent,
                              elevation: 0,
                              content: Container(
                                height: 150,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: Colors.white,
                                ),
                                padding: EdgeInsets.all(20),
                                child: Column(
                                  children: [
                                    Text(
                                      'Are you sure you want to\nLogout ?',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 16,
                                        decoration: TextDecoration.none,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Container(
                                            width: 120,
                                            height: 40,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                              BorderRadius.circular(
                                                  15),
                                              color: Colors.black,
                                            ),
                                            child: FlatButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              child: Text(
                                                'CANCEL',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 13,
                                                    decoration:
                                                    TextDecoration
                                                        .none,
                                                    fontWeight:
                                                    FontWeight.bold),
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 20,
                                        ),
                                        Expanded(
                                          child: Container(
                                            width: 120,
                                            height: 40,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                              BorderRadius.circular(
                                                  15),
                                              color: AppColors.mainColor,
                                            ),
                                            child: FlatButton(
                                              onPressed: () async {
                                                /*await FirebaseAuth.instance.signOut();*/
                                                SharedPreferences prefs =
                                                await SharedPreferences
                                                    .getInstance();
                                                prefs.setBool(
                                                    "isLoggedIn",
                                                    false);
                                                prefs.clear();
                                                Navigator.pushReplacement(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder:
                                                            (context) =>
                                                            SplashScreen()));
                                              },
                                              child: Text(
                                                'OK',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 13,
                                                    decoration:
                                                    TextDecoration
                                                        .none,
                                                    fontWeight:
                                                    FontWeight.bold),
                                              ),
                                            ),
                                          ),
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      });
                },
                child: Card(
                  elevation: 0,
                  color: Colors.transparent,
                  child: Row(
                    children: [
                      Icon(Icons.logout,size: 25,color: Colors.blueGrey.shade400,),
                      SizedBox(
                        width: 20,
                      ),
                      Expanded(
                        child: Text(
                            'Logout',
                            style: GoogleFonts.lato(
                              textStyle: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  decoration: TextDecoration.none,
                                  fontWeight: FontWeight.normal),
                            )
                        ),
                      )
                    ],
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
