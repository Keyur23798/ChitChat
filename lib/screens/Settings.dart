import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:whatsapp/Utils/CustomColors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:whatsapp/screens/Account.dart';
import 'package:whatsapp/screens/ProfileInfo.dart';
import 'package:whatsapp/screens/SocialAccount.dart';
import 'package:whatsapp/screens/Splash.dart';
import 'ProfileScreen.dart';
import 'package:qrscan/qrscan.dart' as scanner;

class SettingScreen extends StatefulWidget {
  @override
  _SettingScreenState createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final fb = FirebaseDatabase.instance;
  String userName = '';
  String about = '';
  String imageUrl = '';

  _fetchUserData() {
    final ref = fb.reference();

    ref.child('FriendList').child(_auth.currentUser!.uid).child('fullName').onValue.listen((event) {
      var snapshot = event.snapshot;
      setState(() {
        userName = snapshot.value;
      });
    });


    ref.child('FriendList').child(_auth.currentUser!.uid).child('about').onValue.listen((event) {
      var snapshot = event.snapshot;
      setState(() {
        about = snapshot.value;
      });
    });

    ref.child('FriendList').child(_auth.currentUser!.uid).child('profilePic').onValue.listen((event) {
      var snapshot = event.snapshot;
      setState(() {
        imageUrl = snapshot.value;
      });
    });
  }

  @override
  void initState() {
    _fetchUserData();
    super.initState();
  }

  Future _scanPhoto(BuildContext context) async {
    String? barcode = await scanner.scan();
    print("qrcode_value " + barcode.toString());
  }

  Future<void> requestPermission() async {
    var status = await Permission.camera.status;
    if (status.isDenied) {
      Map<Permission, PermissionStatus> status = await [
        Permission.camera,
        Permission.storage,
      ].request();
      var status_camera = await Permission.camera.status;
      if (status_camera.isGranted) {
        _scanPhoto(context);
      } else {
        Navigator.pop(context);
      }
    } else {
      _scanPhoto(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white, //change your color here
        ),
        title: Text(
          "Settings",
          style: TextStyle(
              color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
        ),
        backgroundColor: AppColors.mainColor,
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ProfileScreen(id: _auth.currentUser!.uid,)));
                },
                child: Container(
                  padding:
                      EdgeInsets.only(left: 15, right: 15, top: 15, bottom: 10),
                  child: Row(
                    children: [
                      CircleAvatar(
                        child: ClipOval(
                            child: (imageUrl != '')
                                ? FancyShimmerImage(
                              imageUrl: imageUrl,
                              height: 60,
                              width: 60,
                              boxFit: BoxFit.cover,
                            )
                                : Image.asset(
                              'assets/user.png',
                              height: 60,
                              width: 60,
                              fit: BoxFit.cover,
                            )
                        ),
                        backgroundColor: Colors.transparent,
                        radius: 30,
                      ),
                      Expanded(
                        child: Container(
                          child: Column(
                            children: [
                              Text(
                                userName,
                                maxLines: 1,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 17),
                              ),
                              Text(
                                about,
                                maxLines: 2,
                                overflow: TextOverflow.fade,
                                // softWrap: false,
                                style: TextStyle(color: Colors.blueGrey),
                              )
                            ],
                            crossAxisAlignment: CrossAxisAlignment.start,
                          ),
                          padding: EdgeInsets.only(left: 15, right: 10),
                        ),
                      ),
                      IconButton(
                          onPressed: () {
                            requestPermission();
                          },
                          icon: Icon(
                            Icons.qr_code_scanner,
                            size: 30,
                            color: AppColors.mainColor,
                          )
                      )
                    ],
                  ),
                ),
              ),
              Divider(
                color: Colors.black12,
                thickness: 1,
              ),
              Container(
                padding:
                    EdgeInsets.only(left: 25, right: 25, top: 10, bottom: 10),
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>AccountSC()));
                      },
                      child: Card(
                        elevation: 0,
                        color: Colors.transparent,
                        child: Row(
                          children: [
                            Icon(
                              Icons.vpn_key_rounded,
                              color: AppColors.mainColor,
                              size: 30,
                            ),
                            Expanded(
                              child: Container(
                                padding: EdgeInsets.only(left: 25, right: 50),
                                child: Column(
                                  children: [
                                    Text(
                                      'Account',
                                      maxLines: 1,
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w400,
                                          fontSize: 17),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      "Edit Profile",
                                      style: TextStyle(color: Colors.blueGrey),
                                    )
                                  ],
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    GestureDetector(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>SocialAccountSC()));
                      },
                      child: Card(
                        elevation: 0,
                        color: Colors.transparent,
                        child: Row(
                          children: [
                            Icon(
                              Icons.account_box,
                              color: AppColors.mainColor,
                              size: 30,
                            ),
                            Expanded(
                              child: Container(
                                padding: EdgeInsets.only(left: 25, right: 50),
                                child: Column(
                                  children: [
                                    Text(
                                      'Add Social Account',
                                      maxLines: 1,
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w400,
                                          fontSize: 17),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      "Instagram, Facebook, Linkedin...",
                                      style: TextStyle(color: Colors.blueGrey),
                                    )
                                  ],
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Card(
                      elevation: 0,
                      color: Colors.transparent,
                      child: Row(
                        children: [
                          Icon(
                            Icons.notifications,
                            color: AppColors.mainColor,
                            size: 30,
                          ),
                          Expanded(
                            child: GestureDetector(
                              onTap: (){
                                // Navigator.push(
                                //     context,
                                //     MaterialPageRoute(
                                //         builder:
                                //             (context) =>
                                //             ProfileInfoSC()));
                              },
                              child: Container(
                                padding: EdgeInsets.only(left: 25, right: 50),
                                child: Column(
                                  children: [
                                    Text(
                                      'Notification',
                                      maxLines: 1,
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w400,
                                          fontSize: 17),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      "Message & call tones",
                                      style: TextStyle(color: Colors.blueGrey),
                                    )
                                  ],
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Card(
                      elevation: 0,
                      color: Colors.transparent,
                      child: Row(
                        children: [
                          Icon(
                            Icons.delete_forever_rounded,
                            color: AppColors.mainColor,
                            size: 30,
                          ),
                          Expanded(
                            child: GestureDetector(
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
                              child: Container(
                                padding: EdgeInsets.only(left: 25, right: 50),
                                child: Column(
                                  children: [
                                    Text(
                                      'Delete Account',
                                      maxLines: 1,
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w400,
                                          fontSize: 17),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      "Account delete forever",
                                      style: TextStyle(color: Colors.blueGrey),
                                    )
                                  ],
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Card(
                      elevation: 0,
                      color: Colors.transparent,
                      child: Row(
                        children: [
                          Icon(
                            Icons.help_rounded,
                            color: AppColors.mainColor,
                            size: 30,
                          ),
                          Expanded(
                            child: Container(
                              padding: EdgeInsets.only(left: 25, right: 50),
                              child: Column(
                                children: [
                                  Text(
                                    'Help',
                                    maxLines: 1,
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w400,
                                        fontSize: 17),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    "Contact Us",
                                    style: TextStyle(color: Colors.blueGrey),
                                  )
                                ],
                                crossAxisAlignment: CrossAxisAlignment.start,
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              Divider(
                color: Colors.black12,
                thickness: 1,
              ),
              Container(
                padding:
                    EdgeInsets.only(left: 25, right: 25, top: 10, bottom: 10),
                child: Row(
                  children: [
                    Icon(
                      Icons.group,
                      color: AppColors.mainColor,
                      size: 30,
                    ),
                    SizedBox(
                      width: 25,
                    ),
                    Text(
                      'Invite Friends',
                      style: TextStyle(color: Colors.black, fontSize: 18),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 35,
              ),
              Center(
                child: Column(
                  children: [
                    Text(
                      'Develop By',
                      style: TextStyle(
                        color: Colors.blueGrey,
                        fontSize: 15,
                        fontWeight: FontWeight.w500
                      ),
                    ),
                    Text(
                      'Keyur Kanzariya',
                      style: TextStyle(
                          color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.w500
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
