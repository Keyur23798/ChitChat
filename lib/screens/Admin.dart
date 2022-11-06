import 'dart:io';
import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';

class AdminSC extends StatefulWidget {
  const AdminSC({Key? key}) : super(key: key);

  @override
  State<AdminSC> createState() => _AdminSCState();
}

class _AdminSCState extends State<AdminSC> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final fb = FirebaseDatabase.instance;
  FirebaseStorage _storage = FirebaseStorage.instance;
  String imageUrl = '';
  File? _image;
  final picker = ImagePicker();

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
    var r = Random();
    int len = 8;
    String genStr = String.fromCharCodes(List.generate(len, (index) => r.nextInt(33) + 89));

    final ref = fb.reference();
    //Create a reference to the location you want to upload to in firebase
    Reference reference = _storage.ref().child("Wallpaper/$genStr");

    //Upload the file to firebase
    final UploadTask uploadTask = reference.putFile(_image!);

    // Waits till the file is uploaded then stores the download url
    final TaskSnapshot downloadUrl = (await uploadTask);
    final String url = await downloadUrl.ref.getDownloadURL();

    //upload url to userdetails
    ref.child('Wallpaper').child(genStr).child('url').set(url);

    Fluttertoast.showToast(
        msg: 'Image Uploaded',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red.shade300,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: GestureDetector(
        onTap: (){
          _showPicker(context);
        },
          child: Icon(
        Icons.add_a_photo_rounded,
        size: 50,
      )),
    );
  }
}
