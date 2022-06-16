import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:whatsapp/Utils/CustomColors.dart';
import 'package:whatsapp/screens/homeScreen.dart';

class ProfileInfoSC extends StatefulWidget {
  String? mobileNumber;

  ProfileInfoSC({this.mobileNumber});

  @override
  _ProfileInfoSCState createState() => _ProfileInfoSCState();
}

class _ProfileInfoSCState extends State<ProfileInfoSC> {
  TextEditingController nameControler = TextEditingController();
  TextEditingController aboutControler = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  DatabaseReference ref = FirebaseDatabase.instance.reference();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Profile Info',
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
        backgroundColor: AppColors.mainColor,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          alignment: Alignment.center,
          padding: EdgeInsets.only(top: 60, right: 30, left: 30),
          child: Column(
            children: [
              CircleAvatar(
                child: Icon(
                  Icons.camera_alt,
                  color: Colors.white,
                  size: 35,
                ),
                backgroundColor: AppColors.mainColor,
                radius: 60,
              ),
              SizedBox(
                height: 30,
              ),
              TextField(
                controller: nameControler,
                textInputAction: TextInputAction.next,
                onSubmitted: (_) => FocusScope.of(context).nextFocus(),
                decoration: InputDecoration(
                    hintText: "Type your name here",
                    hintStyle: TextStyle(
                      color: Colors.grey,
                      fontSize: 16,
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(Icons.emoji_emotions_outlined),
                      onPressed: () {},
                    )),
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                ),
              ),
              SizedBox(
                height: 30,
              ),
              TextField(
                controller: aboutControler,
                textInputAction: TextInputAction.done,
                maxLength: 150,
                maxLines: 2,
                decoration: InputDecoration(
                  hintText: "About your self",
                  hintStyle: TextStyle(
                    color: Colors.grey,
                    fontSize: 16,
                  ),
                ),
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Container(
                width: double.infinity,
                height: 40,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: AppColors.mainColor,
                ),
                child: FlatButton(
                  onPressed: () async{
                    if(nameControler.text.isEmpty) {
                      Fluttertoast.showToast(
                          msg: "Please enter your name",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.red.shade300,
                          textColor: Colors.white,
                          fontSize: 16.0
                      );
                    } else {
                      SharedPreferences prefs = await SharedPreferences.getInstance();
                      prefs.setString('uid', _auth.currentUser!.uid);
                      prefs.setString('userName', nameControler.text);
                      prefs.setString('mobileNo', widget.mobileNumber!);
                      prefs.setBool('isLogin', true);

                      String pushKey = ref.child('FriendList').child(_auth.currentUser!.uid).push().key;

                      ref.child('FriendList')
                          .child(_auth.currentUser!.uid)
                          .set({
                        'fullName': nameControler.text,
                        'about': aboutControler.text,
                        'mobileNo': widget.mobileNumber,
                        'userId': _auth.currentUser!.uid,
                        'photoUrl': '',
                        'hasStory': false,
                        'pendingMessage': '0',
                        'LastMessage': '',
                        'isVerifiedOtp': true,
                        'Online': 'Offline',
                        'DateTime': '',
                      });

                      Navigator.pushReplacement(context,
                          MaterialPageRoute(
                              builder: (context) => HomeScreen()));
                    }
                  },
                  child: Text(
                    "Next",
                    style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
