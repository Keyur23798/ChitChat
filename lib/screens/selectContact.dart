import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:whatsapp/Utils/CustomColors.dart';
import 'package:whatsapp/model/userDetailsModel.dart';
import 'package:whatsapp/screens/ChatScreen.dart';
// import 'package:qrscan/qrscan.dart' as scanner;

class SelectContactSC extends StatefulWidget {
  String? from;

  SelectContactSC({this.from});

  @override
  _SelectContactSCState createState() => _SelectContactSCState();
}

class _SelectContactSCState extends State<SelectContactSC> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String mobNumber = '';
  String userName = '';
  String uid = '';
  final ref = FirebaseDatabase.instance.reference();

  @override
  void initState() {
    super.initState();

    _getUserDetails();
  }

  _getUserDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      mobNumber = prefs.getString('mobileNo')!;
      userName = prefs.getString('userName')!;
      uid = prefs.getString('uid')!;
    });
  }

  Future _scanPhoto(BuildContext context) async {
    // String? barcode = await scanner.scan();
    // print("qrcode_value " + barcode.toString());
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
          "Select Contact",
          style: TextStyle(
              color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            color: Colors.white,
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.refresh_rounded),
            color: Colors.white,
            onPressed: () {},
          ),
        ],
        backgroundColor: AppColors.mainColor,
      ),
      body: Container(
        color: Colors.white,
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.only(left: 10, top: 10, right: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CircleAvatar(
                    child: Icon(
                      Icons.person_add,
                      color: Colors.white,
                    ),
                    backgroundColor: AppColors.mediumGreen,
                    radius: 25,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: Text(
                      'New Contact',
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 17),
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
                      ))
                ],
              ),
            ),
            Divider(
              color: Colors.black12,
              thickness: 1,
            ),
            Expanded(
              child: Container(
                child: FirebaseAnimatedList(
                  query: ref.child('FriendList'),
                  itemBuilder: (context, snapshot, animation,index) {
                    final json = snapshot.value as Map<dynamic, dynamic>;
                    var user = UserModel.fromJson(json);
                    if (uid == user.userId){
                      return Container();
                    } else {
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ChatScreen(
                                    oppId: user.userId,
                                  )));
                        },
                        child: Container(
                          alignment: Alignment.centerLeft,
                          padding: EdgeInsets.only(
                              left: 10, right: 10, bottom: 10),
                          child: Card(
                            elevation: 0,
                            child: Row(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceAround,
                              children: [
                                CircleAvatar(
                                  child: ClipOval(
                                      child: (user.photoUrl !=
                                          '')
                                          ? FancyShimmerImage(
                                        imageUrl: user.photoUrl!,
                                        height: 50,
                                        width: 50,
                                        boxFit: BoxFit.cover,
                                      )
                                          : Image.asset(
                                        'assets/user.png',
                                        height: 50,
                                        width: 50,
                                        fit: BoxFit.cover,
                                      )),
                                  backgroundColor: Colors.transparent,
                                  radius: 25,
                                ),
                                Expanded(
                                  child: Container(
                                    child: Column(
                                      children: [
                                        Text(
                                          user.fullName!,
                                          style: GoogleFonts.roboto(
                                            textStyle: TextStyle(
                                                color: Colors.black,
                                                fontSize: 17,
                                                decoration: TextDecoration.none,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          maxLines: 1,
                                        ),
                                        Visibility(
                                          visible: (user.about == '') ? false : true,
                                          child: Text(
                                            user.about!,
                                            style: GoogleFonts.roboto(
                                              textStyle: TextStyle(
                                                  color: Colors.blueGrey.shade400,
                                                  fontSize: 15,
                                                  decoration: TextDecoration.none,
                                                  fontWeight: FontWeight.normal),
                                            ),
                                            maxLines: 1,
                                          ),
                                        ),
                                      ],
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                    ),
                                    padding: EdgeInsets.only(
                                        left: 10, right: 10),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
