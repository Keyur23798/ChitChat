import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:whatsapp/Utils/CustomColors.dart';
import 'package:whatsapp/model/userDetailsModel.dart';
import 'package:whatsapp/screens/ChatScreen.dart';
import 'package:qrscan/qrscan.dart' as scanner;
import 'ProfileScreen.dart';

class SelectContactSC extends StatefulWidget {
  String? from;

  SelectContactSC({this.from});

  @override
  _SelectContactSCState createState() => _SelectContactSCState();
}

class _SelectContactSCState extends State<SelectContactSC> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final fb = FirebaseDatabase.instance;
  List<UserDetails> userList = [];
  String mobNumber = '';

  Future<List<UserDetails>> fetchUsersList() async {
    final ref = fb.reference();

    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      mobNumber = prefs.getString('mobileNo')!;
    });

    await ref.child('FriendList').once().then((DataSnapshot data) {
      Map<dynamic, dynamic> values = data.value;
      userList.clear();
      values.forEach((key, values) {
        UserDetails userDetails = UserDetails();
        userDetails.userId = values['userId'];
        userDetails.fullName = values['fullName'];
        userDetails.about = values['about'];
        userDetails.Online = values['Online'];
        userDetails.hasStory = values['hasStory'];
        userDetails.mobileNo = values['mobileNo'];

        if (mobNumber == userDetails.mobileNo) {

        } else {
          userList.add(userDetails);
        }
      });
    });

    return userList;
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
                    backgroundColor: Colors.lightGreen,
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
                child: FutureBuilder(
                  future: fetchUsersList(),
                  builder: (context, snapshot) {
                    // WHILE THE CALL IS BEING MADE AKA LOADING
                    if (ConnectionState.active != null && !snapshot.hasData) {
                      return Center(child: CircularProgressIndicator());
                    }

                    return Container(
                      child: (userList.length > 0) ?
                      ListView.builder(
                        padding: EdgeInsets.only(top: 10),
                        itemCount: userList.length,
                        scrollDirection: Axis.vertical,
                        itemBuilder: (BuildContext context, int index) {
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ProfileScreen(id: userList[index].userId,)));
                            },
                            child: Container(
                              alignment: Alignment.centerLeft,
                              padding:
                                  EdgeInsets.only(left: 10, right: 10, bottom: 10),
                              child: Card(
                                elevation: 0,
                                color: Colors.transparent,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: [
                                    CircleAvatar(
                                      child: ClipOval(
                                          child: (userList[index].profilePic != '')
                                              ? FancyShimmerImage(
                                            imageUrl: userList[index].profilePic!,
                                            height: 50,
                                            width: 50,
                                            boxFit: BoxFit.cover,
                                          )
                                              : Image.asset(
                                            'assets/user.png',
                                            height: 50,
                                            width: 50,
                                            fit: BoxFit.cover,
                                          )
                                      ),
                                      backgroundColor: Colors.transparent,
                                      radius: 25,
                                    ),
                                    Expanded(
                                      child: Container(
                                        child: Column(
                                          children: [
                                            Text(
                                              userList[index].fullName!,
                                              maxLines: 1,
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 17),
                                            ),
                                            Text(
                                              userList[index].about!,
                                              style: TextStyle(color: Colors.blueGrey),
                                            )
                                          ],
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                        ),
                                        padding: EdgeInsets.only(left: 10, right: 10),
                                      ),
                                    ),
                                    IconButton(
                                        onPressed: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      ChatScreen(id: userList[index].userId,)));
                                        },
                                        icon: Icon(
                                          (widget.from == 'chat') ? Icons.message_rounded :
                                          (widget.from == 'video call') ? Icons.video_call : Icons.call,
                                          size: 30,
                                          color: AppColors.mainColor,
                                        ))
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ) :
                      Center(
                        child: Text(
                            'No User Found'
                        ),
                      ),
                    );
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
