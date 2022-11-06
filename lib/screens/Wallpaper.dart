import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pinput/pin_put/pin_put.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:whatsapp/Utils/CustomColors.dart';
import 'package:whatsapp/model/wallpaperModel.dart';
import 'package:whatsapp/screens/Admin.dart';
import 'package:whatsapp/screens/FullScreenImgView.dart';

class WallpaperSC extends StatefulWidget {
  const WallpaperSC({Key? key}) : super(key: key);

  @override
  State<WallpaperSC> createState() => _WallpaperSCState();
}

class _WallpaperSCState extends State<WallpaperSC> {
  final TextEditingController _pinPutController = TextEditingController();
  final FocusNode _pinPutFocusNode = FocusNode();
  final ref = FirebaseDatabase.instance.reference();

  BoxDecoration get _pinPutDecoration {
    return BoxDecoration(
      border: Border.all(color: AppColors.mainColor),
      borderRadius: BorderRadius.circular(15.0),
    );
  }

  _fetchWallpaper() {
    ref
        .child('FriendList')
        .child('url')
        .onValue.listen((event) {
      var snapshot = event.snapshot;
      setState(() {
        // imageUrl = snapshot.value;
      });
    });
  }

  _checkPassword() async {
    if (_pinPutController.text == '237238') {
      Navigator.pop(context);
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => AdminSC())).then((value) => _fetchWallpaper());
    } else {
      Fluttertoast.showToast(
          msg: 'Invalid Password',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red.shade300,
          textColor: Colors.white,
          fontSize: 16.0);
    }
    setState(() {
      _pinPutController.text = '';
    });
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
                  Icon(Icons.lock,color: Colors.black54,size: 25,),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white, //change your color here
        ),
        centerTitle: true,
        title: GestureDetector(
          onLongPress: () async {
            SharedPreferences prefs = await SharedPreferences.getInstance();
            String? password = prefs.getString('password');

            _showPasswordView(context);
          },
          child: Text(
            "4K HD Wallpaper",
            style: GoogleFonts.satisfy(
              textStyle: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  letterSpacing: 1.5,
                  decoration: TextDecoration.none,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ),
        backgroundColor: AppColors.mainColor,
      ),
      body: FirebaseAnimatedList(
        query: ref.child('Wallpaper'),
        padding: EdgeInsets.only(bottom: 80),
        itemBuilder: (context, snapshot, animation,index) {
          final json = snapshot.value as Map<dynamic, dynamic>;
          var wall = WallpaperModel.fromJson(json);

          return Padding(
            padding: EdgeInsets.only(left: 15,right: 15,top: 15),
            child: GestureDetector(
              onTap: () async {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => FullScreenImgViewSC(url: wall.url ?? "",)));
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: FancyShimmerImage(
                imageUrl: wall.url!,
                // height: 50,
                // width: 50,
                boxFit: BoxFit.cover,
              ),
              ),
            ),
          );
        },
      ),
    );
  }
}
