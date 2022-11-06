import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:whatsapp/Utils/CustomColors.dart';

class ChatBgSC extends StatefulWidget {
  const ChatBgSC({Key? key}) : super(key: key);

  @override
  State<ChatBgSC> createState() => _ChatBgSCState();
}

class ChatBgColor {
  String? name;
  Color? color;

  ChatBgColor({
    this.name,
    this.color,
  });
}

class _ChatBgSCState extends State<ChatBgSC> {

  List<Color> arrColor = [
    Colors.redAccent,
    Colors.grey.shade300,
    Colors.greenAccent,
    Colors.blueGrey,
    Colors.orangeAccent,
    Colors.deepOrangeAccent,
    Colors.white,
    Colors.cyanAccent,
    Colors.deepPurpleAccent,
    Colors.tealAccent
  ];

  List<ChatBgColor> arrChatColor = [];

  @override
  void initState() {
    super.initState();
    for(int i = 0;i < arrColor.length;i++) {
      ChatBgColor col = ChatBgColor();
      col.name = '';
      col.color = arrColor[i];
      arrChatColor.add(col);
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
          "Chat Background",
          style: TextStyle(
              color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
        ),
        backgroundColor: AppColors.mainColor,
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        child: GridView.builder(
          itemCount: arrColor.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
          itemBuilder: (BuildContext context, int index) {
            return GestureDetector(
              onTap: () async {
                SharedPreferences prefs = await SharedPreferences.getInstance();

                if (arrColor[index] == Colors.redAccent) {
                  prefs.setString('chatBg', 'Red');
                  Fluttertoast.showToast(
                      msg: 'Chat Background change to Red',
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.red.shade300,
                      textColor: Colors.white,
                      fontSize: 16.0);
                } else if (arrColor[index] == Colors.grey.shade300) {
                  prefs.setString('chatBg', 'Grey');
                  Fluttertoast.showToast(
                      msg: 'Chat Background change to Grey',
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.red.shade300,
                      textColor: Colors.white,
                      fontSize: 16.0);
                } else if (arrColor[index] == Colors.greenAccent) {
                  prefs.setString('chatBg', 'Green');
                  Fluttertoast.showToast(
                      msg: 'Chat Background change to Green',
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.red.shade300,
                      textColor: Colors.white,
                      fontSize: 16.0);
                } else if (arrColor[index] == Colors.blueGrey) {
                  prefs.setString('chatBg', 'BlueGrey');
                  Fluttertoast.showToast(
                      msg: 'Chat Background change to BlueGrey',
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.red.shade300,
                      textColor: Colors.white,
                      fontSize: 16.0);
                } else if (arrColor[index] == Colors.orangeAccent) {
                  prefs.setString('chatBg', 'Orange');
                  Fluttertoast.showToast(
                      msg: 'Chat Background change to Orange',
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.red.shade300,
                      textColor: Colors.white,
                      fontSize: 16.0);
                } else if (arrColor[index] == Colors.deepOrangeAccent) {
                  prefs.setString('chatBg', 'DeepOrange');
                  Fluttertoast.showToast(
                      msg: 'Chat Background change to DeepOrange',
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.red.shade300,
                      textColor: Colors.white,
                      fontSize: 16.0);
                } else if (arrColor[index] == Colors.white) {
                  prefs.setString('chatBg', 'White');
                  Fluttertoast.showToast(
                      msg: 'Chat Background change to White',
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.red.shade300,
                      textColor: Colors.white,
                      fontSize: 16.0);
                } else if (arrColor[index] == Colors.cyanAccent) {
                  prefs.setString('chatBg', 'Cyan');
                  Fluttertoast.showToast(
                      msg: 'Chat Background change to Cyan',
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.red.shade300,
                      textColor: Colors.white,
                      fontSize: 16.0);
                } else if (arrColor[index] == Colors.deepPurpleAccent) {
                  prefs.setString('chatBg', 'DeepPurple');
                  Fluttertoast.showToast(
                      msg: 'Chat Background change to DeepPurple',
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.red.shade300,
                      textColor: Colors.white,
                      fontSize: 16.0);
                } else if (arrColor[index] == Colors.tealAccent) {
                  prefs.setString('chatBg', 'Teal');
                  Fluttertoast.showToast(
                      msg: 'Chat Background change to Teal',
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.red.shade300,
                      textColor: Colors.white,
                      fontSize: 16.0);
                }

                Navigator.pop(context);
              },
              child: Container(
                margin: EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: arrColor[index],
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
