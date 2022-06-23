import 'dart:io';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:whatsapp/Utils/CustomColors.dart';

class ProfileScreen extends StatefulWidget {
  String? id;
  ProfileScreen({this.id});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController aboutController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final fb = FirebaseDatabase.instance;
  FirebaseStorage _storage = FirebaseStorage.instance;
  String mobileNo = '';
  String userMobNo = '';
  String imageUrl = '';
  File? _image;
  final picker = ImagePicker();

  _fetchUserData() async {
    final ref = fb.reference();

    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userMobNo = prefs.getString('mobileNo')!;
    });

    ref
        .child('FriendList')
        .child(widget.id!)
        .child('fullName')
        .onValue.listen((event) {
      var snapshot = event.snapshot;
      setState(() {
        nameController.text = snapshot.value;
      });
    });

    ref
        .child('FriendList')
        .child(widget.id!)
        .child('mobileNo')
        .onValue.listen((event) {
      var snapshot = event.snapshot;
      setState(() {
        mobileNo = snapshot.value;
      });
    });

    ref
        .child('FriendList')
        .child(widget.id!)
        .child('about')
        .onValue.listen((event) {
      var snapshot = event.snapshot;
      setState(() {
        aboutController.text = snapshot.value;
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
        });
        uploadImageToFirebase(context);
      } else {
        print('No image selected.');
      }
  }

  Future uploadImageToFirebase(BuildContext context) async {
    final ref = fb.reference();
    //Create a reference to the location you want to upload to in firebase
    Reference reference = _storage.ref().child("ProfilePic/${widget.id}");

    //Upload the file to firebase
    final UploadTask uploadTask = reference.putFile(_image!);

    // Waits till the file is uploaded then stores the download url
    final TaskSnapshot downloadUrl = (await uploadTask);
    final String url = await downloadUrl.ref.getDownloadURL();

    //upload url to userdetails
    ref.child('FriendList').child(_auth.currentUser!.uid).child('photoUrl').set(url);
  }

  _editProfile() {
    final ref = fb.reference();
    ref.child('FriendList').child(_auth.currentUser!.uid).child('fullName').set(nameController.text);
    ref.child('FriendList').child(_auth.currentUser!.uid).child('about').set(aboutController.text);
    Fluttertoast.showToast(
        msg: 'Saved',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red.shade300,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  @override
  void initState() {
    _fetchUserData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white, //change your color here
        ),
        title: Text(
          'Profile',
          style: TextStyle(
              color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
        ),
        backgroundColor: AppColors.mainColor,
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.only(top: 20, bottom: 40),
                alignment: Alignment.center,
                child: Stack(
                  children: [
                    CircleAvatar(
                      child: ClipOval(
                        child: (_image != null)
                            ? Image.file(
                          _image!,
                          height: 145,
                          width: 145,
                          fit: BoxFit.cover,
                        )
                            : (imageUrl != '') ?
                        FancyShimmerImage(
                          imageUrl: imageUrl,
                          height: 145,
                          width: 145,
                          boxFit: BoxFit.cover,
                        ) : Image.asset(
                          'assets/user.png',
                          height: 145,
                          width: 145,
                          fit: BoxFit.cover,
                        )
                      ),
                      backgroundColor: Colors.transparent,
                      radius: 75,
                    ),
                    Visibility(
                      visible: (userMobNo == mobileNo) ? true : false,
                      child: Positioned(
                        right: 10,
                        top: 110,
                        child: CircleAvatar(
                          child: IconButton(
                            icon: Icon(
                              Icons.camera_alt_rounded,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              _showPicker(context);
                            },
                          ),
                          backgroundColor: AppColors.mainColor,
                          radius: 20,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding:
                    EdgeInsets.only(left: 20, right: 20, top: 5, bottom: 5),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.person,
                      size: 25,
                      color: AppColors.mainColor,
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Text(
                            "Name",
                            style:
                                TextStyle(color: Colors.blueGrey, fontSize: 15),
                          ),
                          TextField(
                            controller: nameController,
                            textInputAction: TextInputAction.done,
                            readOnly : (userMobNo == mobileNo) ? false : true,
                            decoration: InputDecoration(
                              hintText:
                                  'Enter Name that visible to your contacts',
                              border: InputBorder.none,
                              hintStyle: TextStyle(
                                color: Colors.grey,
                                fontSize: 15,
                              ),
                            ),
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Visibility(
                      visible: (userMobNo == mobileNo) ? true : false,
                      child: Icon(
                        Icons.edit,
                        size: 20,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.only(left: 15, right: 15),
                child: Divider(
                  color: Colors.black12,
                  thickness: 1,
                ),
              ),
              Container(
                padding:
                    EdgeInsets.only(left: 20, right: 20, top: 5, bottom: 5),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.info_outline_rounded,
                      size: 25,
                      color: AppColors.mainColor,
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "About",
                            style:
                                TextStyle(color: Colors.blueGrey, fontSize: 15),
                          ),
                          TextField(
                            controller: aboutController,
                            textInputAction: TextInputAction.done,
                            readOnly : (userMobNo == mobileNo) ? false : true,
                            maxLength: 150,
                            decoration: InputDecoration(
                              hintText: 'Enter about yourself',
                              border: InputBorder.none,
                              hintStyle: TextStyle(
                                color: Colors.grey,
                                fontSize: 15,
                              ),
                            ),
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Visibility(
                      visible: (userMobNo == mobileNo) ? true : false,
                      child: Icon(
                        Icons.edit,
                        size: 20,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.only(left: 15, right: 15),
                child: Divider(
                  color: Colors.black12,
                  thickness: 1,
                ),
              ),
              Container(
                padding:
                    EdgeInsets.only(left: 20, right: 20, top: 5, bottom: 5),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.call,
                      size: 25,
                      color: AppColors.mainColor,
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "Phone",
                            style:
                                TextStyle(color: Colors.blueGrey, fontSize: 15),
                          ),
                          Text(
                            '+91 $mobileNo',
                            style: TextStyle(color: Colors.black, fontSize: 15),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 40,
              ),
              Visibility(
                visible: (widget.id == _auth.currentUser!.uid) ? true : false,
                child: Container(
                  margin: EdgeInsets.only(right: 15, left: 15),
                  width: double.infinity,
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: AppColors.mainColor,
                  ),
                  child: FlatButton(
                    onPressed: () {
                      _editProfile();
                    },
                    child: Text(
                      'Submit',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
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
