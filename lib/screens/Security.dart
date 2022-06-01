import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pinput/pin_put/pin_put.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:whatsapp/Utils/CustomColors.dart';

class SecuritySC extends StatefulWidget {
  const SecuritySC({Key? key}) : super(key: key);

  @override
  _SecuritySCState createState() => _SecuritySCState();
}

class _SecuritySCState extends State<SecuritySC> {
  final TextEditingController _pinPutController = TextEditingController();
  final FocusNode _pinPutFocusNode = FocusNode();
  String? oldPassword;

  BoxDecoration get _pinPutDecoration {
    return BoxDecoration(
      border: Border.all(color: AppColors.mainColor),
      borderRadius: BorderRadius.circular(15.0),
    );
  }

  _getPassword() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      oldPassword = prefs.getString('password');
    });
  }

  _setPassword() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('password', _pinPutController.text);

    Fluttertoast.showToast(
        msg: 'Password Set Successfully',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red.shade300,
        textColor: Colors.white,
        fontSize: 16.0);

    _pinPutController.text = '';
  }

  _changePassword() async {
    if(_pinPutController.text == oldPassword) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('password', _pinPutController.text);

      Fluttertoast.showToast(
          msg: 'Password Change Successfully',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red.shade300,
          textColor: Colors.white,
          fontSize: 16.0);
    } else {
      Fluttertoast.showToast(
          msg: 'Password does not match with old password',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red.shade300,
          textColor: Colors.white,
          fontSize: 16.0);
    }
    _pinPutController.text = '';
  }

  @override
  void initState() {
    super.initState();
    _getPassword();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white, //change your color here
        ),
        title: Text(
          'Security',
          style: TextStyle(
              color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
        ),
        backgroundColor: AppColors.mainColor,
      ),
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              Icon(Icons.lock,color: Colors.black54,size: 25,),
              SizedBox(
                height: 10,
              ),
              Text(
                (oldPassword != null) ? 'Change Your Security Password' : 'Set Your Security Password',
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
                    if(oldPassword != null) {
                      _changePassword();
                    } else {
                      _setPassword();
                    }
                  },
                  child: Text(
                    'Submit',
                    style: TextStyle(fontSize: 16, color: Colors.white),
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
