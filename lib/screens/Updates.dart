import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:whatsapp/Utils/CustomColors.dart';
import 'package:whatsapp/model/StoryModel.dart';
import 'package:whatsapp/model/userDetailsModel.dart';

import 'ChatScreen.dart';
import 'StoryView.dart';

class UpdatesSC extends StatefulWidget {
  const UpdatesSC({Key? key}) : super(key: key);

  @override
  State<UpdatesSC> createState() => _UpdatesSCState();
}

class _UpdatesSCState extends State<UpdatesSC> {
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

  String readTimestamp(int timestamp) {
    var now = new DateTime.now();
    var format = new DateFormat('MMM d, HH:mm a');
    // var format = new DateFormat('HH:mm a');
    var date = new DateTime.fromMicrosecondsSinceEpoch(timestamp);
    var diff = date.difference(now);
    var time = '';

    if (diff.inSeconds <= 0 || diff.inSeconds > 0 && diff.inMinutes == 0 || diff.inMinutes > 0 && diff.inHours == 0 || diff.inHours > 0 && diff.inDays == 0) {
      time = format.format(date);
    } else {
      if (diff.inDays == 1) {
        time = diff.inDays.toString() + 'DAY AGO';
      } else {
        time = diff.inDays.toString() + 'DAYS AGO';
      }
    }

    return time;
  }

  _getUserDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      mobNumber = prefs.getString('mobileNo')!;
      userName = prefs.getString('userName')!;
      uid = prefs.getString('uid')!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white, //change your color here
        ),
        title: Text(
          'Updates',
          style: TextStyle(
              color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: AppColors.mainColor,
      ),
      body: Container(
        color: Colors.white,
        padding: EdgeInsets.only(top: 10),
        child: Expanded(
          child: Container(
            child: FirebaseAnimatedList(
              query: ref.child('Story').orderByChild('time'),
              itemBuilder: (context, snapshot, animation,index) {
                final json =
                snapshot.value as Map<dynamic, dynamic>;
                var story = StoryModel.fromJson(json);
                if (uid == story.userId){
                  return Container();
                } else {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => StoryViewSC(
                                id: story.userId,
                                url: story.url,
                                time: story.time,
                              )))
                          .then((value) => _getUserDetails());
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
                              backgroundColor: AppColors.mediumGreen,
                              radius: 27,
                              child: ClipOval(
                                  child: (story.url !=
                                      '')
                                      ? FancyShimmerImage(
                                    imageUrl: story.url!,
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
                            ),
                            Expanded(
                              child: Container(
                                child: Column(
                                  children: [
                                    Text(
                                      story.name!,
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
                                      visible: (story.time == '') ? false : true,
                                      child: Text(
                                        readTimestamp(int.parse(story.time!)),
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
      ),
    );
  }
}
