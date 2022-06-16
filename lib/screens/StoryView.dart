import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'ProfileScreen.dart';

class StoryViewSC extends StatefulWidget {
  String? id;
  String? url;
  StoryViewSC({this.id,this.url});

  @override
  _StoryViewSCState createState() => _StoryViewSCState();
}

class _StoryViewSCState extends State<StoryViewSC> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final fb = FirebaseDatabase.instance;
  String userName = '';
  String imageUrl = '';

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
        .child('profilePic')
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
        backgroundColor: Colors.black,
        appBar: AppBar(
          elevation: 0,
          automaticallyImplyLeading: false,
          backgroundColor: Colors.white,
          flexibleSpace: SafeArea(
            child: Container(
              padding: EdgeInsets.all(5),
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back_rounded),
                    color: Colors.black,
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
                                color: Colors.black),
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
                          'Time',
                          style: TextStyle(color: Colors.black, fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                  Visibility(
                    visible: (widget.id == _auth.currentUser!.uid) ? true : false,
                    child: PopupMenuButton(
                      icon: Icon(Icons.more_vert_rounded,color: Colors.black,),
                      iconSize: 35,
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
