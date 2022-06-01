import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:whatsapp/Utils/CustomColors.dart';
import 'package:whatsapp/screens/Security.dart';

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
              Card(
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
            ],
          ),
        ),
      ),
    );
  }
}
