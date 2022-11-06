import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:whatsapp/Utils/CustomColors.dart';
import 'ProfileScreen.dart';

class StoryViewSC extends StatefulWidget {
  String? id;
  String? url;
  String? time;
  StoryViewSC({this.id,this.url,this.time});

  @override
  _StoryViewSCState createState() => _StoryViewSCState();
}

class _StoryViewSCState extends State<StoryViewSC> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final fb = FirebaseDatabase.instance;
  String userName = '';
  String imageUrl = '';

  String displayTime(String microsecondsSinceEpoch){
    String ampm = "AM";
    int micro = int.parse(microsecondsSinceEpoch);
    var dateObj = DateTime.fromMicrosecondsSinceEpoch(micro);
    int hr = dateObj.hour;
    int min = dateObj.minute;
    if(hr > 12){
      hr = hr - 12;
      ampm = "PM";
    }
    else if(hr == 12){
      ampm = "PM";
    }
    else if(hr == 0){
      hr = 12;
      ampm = "AM";
    }
    return "$hr:$min $ampm";
  }

  String readTimestamp(int timestamp) {
    var now = new DateTime.now();
    var format = new DateFormat('MMM d, HH:mm a');
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

  _fetchUserData() {
    final ref = fb.reference();

    ref
        .child('FriendList')
        .child(widget.id!)
        .child('fullName')
        .onValue.listen((event) {
      var snapshot = event.snapshot;
      setState(() {
        userName = snapshot.value;
      });
    });

    ref
        .child('FriendList')
        .child(widget.id!)
        .child('photoUrl')
        .onValue.listen((event) {
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

    // new Future.delayed(const Duration(seconds: 5), () {
    //   Navigator.pop(context);
    // });
  }

  deleteStory() async{
    final ref = fb.reference();

    ref.child('Story').child(_auth.currentUser!.uid).child('url').set('');
    ref.child('FriendList').child(_auth.currentUser!.uid).child('hasStory').set(false);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.black,
        appBar: AppBar(
          elevation: 0,
          automaticallyImplyLeading: false,
          backgroundColor: AppColors.mainColor,
          flexibleSpace: SafeArea(
            child: Container(
              padding: EdgeInsets.all(5),
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back_rounded),
                    color: AppColors.white,
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ProfileScreen(id: widget.id,)));
                    },
                    child: CircleAvatar(
                      child: ClipOval(
                          child: (imageUrl != '')
                              ? FancyShimmerImage(
                            imageUrl: imageUrl,
                            height: 35,
                            width: 35,
                            boxFit: BoxFit.cover,
                          )
                              : Image.asset(
                            'assets/user.png',
                            height: 35,
                            width: 35,
                            fit: BoxFit.cover,
                          )
                      ),
                      backgroundColor: Colors.transparent,
                      radius: 18,
                    ),
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        GestureDetector(
                          child: Text(
                            userName,
                            style: TextStyle(
                                decoration: TextDecoration.none,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: AppColors.white),
                            maxLines: 1,
                            softWrap: false,
                            overflow: TextOverflow.fade,
                            textAlign: TextAlign.start,
                          ),
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ProfileScreen(id: widget.id,)));
                          },
                        ),
                        SizedBox(
                          height: 2,
                        ),
                        Text(
                          // displayTime(widget.time ?? ''),
                          readTimestamp(int.parse(widget.time ?? '')),
                          style: TextStyle(color: AppColors.white, fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                  Visibility(
                    visible: (widget.id == _auth.currentUser!.uid) ? true : false,
                    child: PopupMenuButton(
                      icon: Icon(Icons.more_vert_rounded,color: AppColors.white,),
                      iconSize: 25,
                      itemBuilder: (_) => <PopupMenuItem<String>>[
                        new PopupMenuItem<String>(
                            child: const Text('Delete'), value: 'Delete'),
                      ],
                      onSelected: (value) async {
                        if(value == 'Delete') {
                          deleteStory();
                        }
                      },
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
        body: SafeArea(
          child: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            alignment: Alignment.center,
            child: FancyShimmerImage(
              imageUrl: widget.url!,
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              boxFit: BoxFit.fitWidth,
            )
          ),
        ),
      ),
    );
  }
}
