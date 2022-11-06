import 'dart:io';
import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pinput/pin_put/pin_put.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import 'package:whatsapp/Utils/CustomColors.dart';
import 'package:whatsapp/Utils/Util.dart';
import 'package:whatsapp/model/StoryModel.dart';
import 'package:whatsapp/model/userDetailsModel.dart';
import 'package:whatsapp/screens/ChatScreen.dart';
import 'package:whatsapp/screens/StoryView.dart';
import 'package:whatsapp/screens/selectContact.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final fb = FirebaseDatabase.instance;
  FirebaseStorage _storage = FirebaseStorage.instance;
  File? _image;
  final picker = ImagePicker();
  String imageName = '';
  String imagePath = '';
  String imageUrl = '';
  bool? hasStory;
  String storyUrl = '';
  String storyTime = '';
  final TextEditingController _pinPutController = TextEditingController();
  final FocusNode _pinPutFocusNode = FocusNode();
  String mobNumber = '';
  String userName = '';
  String uid = '';
  final ref = FirebaseDatabase.instance.reference();
  bool isShimmer = false;

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

    _fetchUserData();
  }

  _fetchUserData() async {
    final ref = fb.reference();

    ref
        .child('FriendList')
        .child(_auth.currentUser!.uid)
        .child('photoUrl')
        .onValue
        .listen((event) {
      var snapshot = event.snapshot;
      setState(() {
        imageUrl = snapshot.value;
      });
    });

    ref
        .child('FriendList')
        .child(_auth.currentUser!.uid)
        .child('hasStory')
        .onValue
        .listen((event) {
      var snapshot = event.snapshot;
      setState(() {
        hasStory = snapshot.value;
      });
    });

    ref
        .child('Story')
        .child(_auth.currentUser!.uid)
        .child('url')
        .onValue
        .listen((event) {
      var snapshot = event.snapshot;
      setState(() {
        storyUrl = snapshot.value;
      });
    });

    ref
        .child('Story')
        .child(_auth.currentUser!.uid)
        .child('time')
        .onValue
        .listen((event) {
      var snapshot = event.snapshot;
      setState(() {
        storyTime = snapshot.value;
      });
    });
  }

  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: new Wrap(
                children: <Widget>[
                  new ListTile(
                      leading: new Icon(Icons.photo_library),
                      title: new Text('Photo Library'),
                      onTap: () {
                        getImageFromGallery();
                        Navigator.of(context).pop();
                      }),
                  new ListTile(
                    leading: new Icon(Icons.photo_camera),
                    title: new Text('Camera'),
                    onTap: () {
                      getImageFromCamera();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  Future getImageFromGallery() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
        imageName = _image!.path.split('/').last;
        imagePath = pickedFile.path;
      });
      uploadImageToFirebase(context);
    } else {
      print('No image selected.');
    }
  }

  Future getImageFromCamera() async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
        imageName = _image!.path.split('/').last;
        imagePath = pickedFile.path;
      });
      uploadImageToFirebase(context);
    } else {
      print('No image selected.');
    }
  }

  Future uploadImageToFirebase(BuildContext context) async {
    final ref = fb.reference();
    //Create a reference to the location you want to upload to in firebase
    Reference reference =
        _storage.ref().child("Story/${_auth.currentUser!.uid}");

    //Upload the file to firebase
    final UploadTask uploadTask = reference.putFile(_image!);

    // Waits till the file is uploaded then stores the download url
    final TaskSnapshot downloadUrl = (await uploadTask);
    final String url = await downloadUrl.ref.getDownloadURL();
    setState(() {
      storyUrl = url;
    });

    //upload url to userdetails
    String id = ref.child('Story').child(_auth.currentUser!.uid).push().key;

    ref.child('Story').child(_auth.currentUser!.uid).child('url').set(url);
    ref.child('Story').child(_auth.currentUser!.uid).child('userId').set(uid);
    ref.child('Story').child(_auth.currentUser!.uid).child('time').set(DateTime.now().microsecondsSinceEpoch.toString());
    ref
        .child('Story')
        .child(_auth.currentUser!.uid)
        .child('name')
        .set(userName);
    ref
        .child('FriendList')
        .child(_auth.currentUser!.uid)
        .child('hasStory')
        .set(true);
    _fetchUserData();
  }

  BoxDecoration get _pinPutDecoration {
    return BoxDecoration(
      border: Border.all(color: AppColors.mainColor),
      borderRadius: BorderRadius.circular(15.0),
    );
  }

  _showPasswordView(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              height: 400,
              color: Colors.white,
              padding: const EdgeInsets.only(
                  top: 20, left: 20, right: 20, bottom: 40),
              child: Column(
                children: [
                  Icon(
                    Icons.lock,
                    color: Colors.black54,
                    size: 25,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text('Enter Your Security Password',
                      style: GoogleFonts.lato(
                        textStyle: TextStyle(
                            color: Colors.black54,
                            fontSize: 18,
                            decoration: TextDecoration.none,
                            fontWeight: FontWeight.bold),
                      )),
                  SizedBox(
                    height: 15,
                  ),
                  PinPut(
                    fieldsCount: 6,
                    onSubmit: (String pin) async {},
                    focusNode: _pinPutFocusNode,
                    controller: _pinPutController,
                    submittedFieldDecoration: _pinPutDecoration.copyWith(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    selectedFieldDecoration: _pinPutDecoration,
                    followingFieldDecoration: _pinPutDecoration.copyWith(
                      borderRadius: BorderRadius.circular(15.0),
                      border: Border.all(
                        color: AppColors.mainColor,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Container(
                    margin: EdgeInsets.only(right: 15, left: 15),
                    width: double.infinity,
                    height: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: AppColors.mainColor,
                    ),
                    child: FlatButton(
                      onPressed: () {
                        _checkPassword();
                      },
                      child: Text(
                        "Submit",
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
        });
  }

  _checkPassword() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? password = prefs.getString('password');

    if (_pinPutController.text == password) {
      Fluttertoast.showToast(
          msg: 'Now you can see hidden chat',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red.shade300,
          textColor: Colors.white,
          fontSize: 16.0);
    } else {
      Fluttertoast.showToast(
          msg: 'invalid Password',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red.shade300,
          textColor: Colors.white,
          fontSize: 16.0);
    }
    Navigator.pop(context);
    setState(() {
      _pinPutController.text = '';
    });
  }

  Widget buildShimmerItems() => ListView.separated(
      padding: const EdgeInsets.all(8),
      itemCount: 10,
      separatorBuilder: (BuildContext context, int index) => const Divider(),
      itemBuilder: (BuildContext context, int index) {
        return const ShimmerWidget();
      });

  @override
  Widget build(BuildContext context) {
    return AnimatedTheme(
      duration: const Duration(milliseconds: 300),
      data: Theme.of(context),
      child: Scaffold(
          backgroundColor: AppColors.mainColor,
          body: Container(
            padding: EdgeInsets.only(top: 30),
            child: Column(
              children: [
                Stack(
                  children: [
                    GestureDetector(
                      onLongPress: () async {
                        SharedPreferences prefs =
                            await SharedPreferences.getInstance();
                        String? password = prefs.getString('password');

                        if (password != null) {
                          _showPasswordView(context);
                        } else {
                          Fluttertoast.showToast(
                              msg:
                                  'Please set Password\nSettings > Account > Security',
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIosWeb: 3,
                              backgroundColor: Colors.red.shade300,
                              textColor: Colors.white,
                              fontSize: 16.0);
                        }
                      },
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 15, top: 5),
                          child: Text(
                            'ChitChat',
                            style: GoogleFonts.satisfy(
                              textStyle: TextStyle(
                                  color: Colors.white,
                                  fontSize: 25,
                                  letterSpacing: 2.5,
                                  decoration: TextDecoration.none,
                                  fontWeight: FontWeight.bold),
                            ),
                            textAlign: TextAlign.start,
                          ),
                        ),
                      ),
                    ),
                    // Padding(
                    //     padding: EdgeInsets.only(right: 40),
                    //     child: Align(
                    //       alignment: Alignment.centerRight,
                    //       child: IconButton(
                    //         icon: Icon(Icons.search),
                    //         color: Colors.white,
                    //         onPressed: () {
                    //           Navigator.push(
                    //               context,
                    //               MaterialPageRoute(
                    //                   builder: (context) => WallpaperSC()));
                    //         },
                    //       ),
                    //     ),
                    // ),
                    // Align(
                    //   alignment: Alignment.centerRight,
                    //   child: IconButton(
                    //     icon: Icon(Icons.wb_sunny_outlined),
                    //     color: Colors.white,
                    //     onPressed: () {
                    //       AdaptiveTheme.of(context).toggleThemeMode();
                    //     },
                    //   ),
                    // ),
                    Padding(
                      padding: EdgeInsets.only(right: 8.0),
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: IconButton(
                          icon: Icon(CupertinoIcons.ellipsis,size: 25,color: AppColors.white,),
                          color: Colors.white,
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SelectContactSC(
                                      from: 'chat',
                                    )));
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 5,
                ),
                Container(
                  height: 105,
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          if (hasStory == true) {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => StoryViewSC(
                                          id: _auth.currentUser!.uid,
                                          url: storyUrl,
                                          time: storyTime,
                                        ))).then((value) => _fetchUserData());
                          } else {
                            _showPicker(context);
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.only(top: 10, bottom: 10),
                          width: 90,
                          child: Column(
                            children: [
                              CircleAvatar(
                                radius: 27,
                                backgroundColor: Colors.white70,
                                child: CircleAvatar(
                                  child: ClipOval(
                                    child: (_image != null)
                                        ? Image.file(
                                            _image!,
                                            height: 50,
                                            width: 50,
                                            fit: BoxFit.cover,
                                          )
                                        : (hasStory == true)
                                            ? FancyShimmerImage(
                                                imageUrl: storyUrl,
                                                height: 50,
                                                width: 50,
                                                boxFit: BoxFit.cover,
                                              )
                                            : (imageUrl != '')
                                                ? FancyShimmerImage(
                                                    imageUrl: imageUrl,
                                                    height: 50,
                                                    width: 50,
                                                    boxFit: BoxFit.cover,
                                                  )
                                                : Image.asset(
                                                    'assets/user.png',
                                                    height: 50,
                                                    width: 50,
                                                    fit: BoxFit.cover,
                                                  ),
                                  ),
                                  backgroundColor: Colors.lightGreen.shade400,
                                  radius: 25,
                                ),
                              ),
                              SizedBox(
                                height: 3,
                              ),
                              Text(
                                'Your Story',
                                style: GoogleFonts.roboto(
                                  textStyle: TextStyle(
                                      color: Colors.white,
                                      fontSize: 13,
                                      decoration: TextDecoration.none,
                                      fontWeight: FontWeight.normal),
                                ),
                                maxLines: 2,
                                textAlign: TextAlign.center,
                              )
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        child: FirebaseAnimatedList(
                          query: ref.child('Story'),
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, snapshot, animation, index) {
                            final json =
                                snapshot.value as Map<dynamic, dynamic>;
                            var story = StoryModel.fromJson(json);
                            if (uid == story.userId) {
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
                                      .then((value) => _fetchUserData());
                                },
                                child: Container(
                                  width: 80,
                                  padding: EdgeInsets.all(10),
                                  child: Column(
                                    children: [
                                      CircleAvatar(
                                        radius: 27,
                                        backgroundColor: AppColors.mediumGreen,
                                        child: ClipOval(
                                            child: FancyShimmerImage(
                                          imageUrl: story.url!,
                                          height: 50,
                                          width: 50,
                                          boxFit: BoxFit.cover,
                                        )),
                                      ),
                                      SizedBox(
                                        height: 3,
                                      ),
                                      Text(
                                        story.name!,
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 12),
                                        textAlign: TextAlign.center,
                                        maxLines: 2,
                                      )
                                    ],
                                  ),
                                ),
                              );
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                        color: AdaptiveTheme.of(context).mode.isDark
                            ? AppColors.black
                            : AppColors.white,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(25.0),
                            topRight: Radius.circular(25.0))),
                    padding: EdgeInsets.only(top: 10),
                    child: FirebaseAnimatedList(
                      query: ref.child('FriendList').orderByChild('DateTime'),
                      itemBuilder: (context, snapshot, animation, index) {
                        final json = snapshot.value as Map<dynamic, dynamic>;
                        var user = UserModel.fromJson(json);

                        if (uid == user.userId) {
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
                                color: AdaptiveTheme.of(context).mode.isDark
                                    ? AppColors.black
                                    : AppColors.white,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    CircleAvatar(
                                      child: ClipOval(
                                          child: (user.photoUrl != '')
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
                                                    color: AdaptiveTheme.of(
                                                                context)
                                                            .mode
                                                            .isLight
                                                        ? AppColors.black
                                                        : AppColors.white,
                                                    fontSize: 17,
                                                    decoration:
                                                        TextDecoration.none,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              maxLines: 1,
                                            ),
                                            Visibility(
                                              visible: (user.lastMessage == '')
                                                  ? false
                                                  : true,
                                              child: Text(
                                                user.lastMessage!,
                                                style: GoogleFonts.roboto(
                                                  textStyle: TextStyle(
                                                      color: Colors
                                                          .blueGrey.shade400,
                                                      fontSize: 15,
                                                      decoration:
                                                          TextDecoration.none,
                                                      fontWeight:
                                                          FontWeight.normal),
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
                                    Container(
                                      child: Column(
                                        children: [
                                          Text(
                                            user.dateTime!,
                                            style: GoogleFonts.roboto(
                                              textStyle: TextStyle(
                                                  color: Colors.blueGrey,
                                                  fontSize: 14,
                                                  decoration:
                                                      TextDecoration.none,
                                                  fontWeight:
                                                      FontWeight.normal),
                                            ),
                                          ),
                                          Visibility(
                                            visible:
                                                (user.pendingMessage == '0')
                                                    ? false
                                                    : true,
                                            child: CircleAvatar(
                                              backgroundColor: AppColors.mediumGreen,
                                              child: Text(
                                                user.pendingMessage!,
                                                style: GoogleFonts.roboto(
                                                  textStyle: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 12,
                                                      decoration:
                                                          TextDecoration.none,
                                                      fontWeight:
                                                          FontWeight.normal),
                                                ),
                                              ),
                                              radius: 10,
                                            ),
                                          ),
                                        ],
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
          // floatingActionButton: _getFAB()
      ),
    );
  }

  Widget _getFAB() {
    return SpeedDial(
      animatedIcon: AnimatedIcons.add_event,
      foregroundColor: Colors.white,
      animatedIconTheme: IconThemeData(size: 22),
      backgroundColor: AppColors.mainColor,
      visible: true,
      curve: Curves.bounceIn,
      children: [
        // FAB 1
        SpeedDialChild(
            child: Icon(
              Icons.chat,
              color: Colors.white,
            ),
            backgroundColor: AppColors.mainColor,
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => SelectContactSC(
                            from: 'chat',
                          )));
            },
            label: 'New Chat',
            labelStyle: TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.white,
                fontSize: 16.0),
            labelBackgroundColor: AppColors.mainColor),
        // FAB 2
        SpeedDialChild(
            child: Icon(
              Icons.call,
              color: Colors.white,
            ),
            backgroundColor: AppColors.mainColor,
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => SelectContactSC(
                            from: 'call',
                          )));
            },
            label: 'Audio Call',
            labelStyle: TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.white,
                fontSize: 16.0),
            labelBackgroundColor: AppColors.mainColor),
        // FAB 3
        SpeedDialChild(
            child: Icon(
              Icons.video_call,
              color: Colors.white,
            ),
            backgroundColor: AppColors.mainColor,
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => SelectContactSC(
                            from: 'video call',
                          )));
            },
            label: 'Video Call',
            labelStyle: TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.white,
                fontSize: 16.0),
            labelBackgroundColor: AppColors.mainColor),
      ],
    );
  }
}
