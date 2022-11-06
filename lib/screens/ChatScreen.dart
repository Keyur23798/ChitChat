import 'dart:async';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:whatsapp/Utils/CustomColors.dart';
import 'package:whatsapp/model/chatMessageModel.dart';
import 'package:whatsapp/screens/chatBackground.dart';
import 'ProfileScreen.dart';

class ChatScreen extends StatefulWidget {
  String? oppId;
  ChatScreen({this.oppId});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  TextEditingController chatController = TextEditingController();
  ScrollController _scrollController = new ScrollController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String userName = '';
  String imageUrl = '';
  String online = '';
  bool sendBtn = false;
  Color? chatBgColor;
  final ref = FirebaseDatabase.instance.reference();

  List<ChatMessage> messages = [
    ChatMessage(messageContent: "Hello, Will", messageType: "receiver",time: "1667719192273837",status: "Seen"),
    ChatMessage(messageContent: "How have you been?", messageType: "receiver",time: "1667719192273837",status: "Seen"),
    ChatMessage(
        messageContent: "Hey Kriss, I am doing fine dude. wbu?",
        messageType: "sender",time: "1667719192273837",status: "Seen"),
    ChatMessage(messageContent: "ehhhh, doing OK.", messageType: "receiver",time: "1667719192273837",status: "Seen"),
    ChatMessage(
        messageContent: "Is there any thing wrong?", messageType: "sender",time: "1667719192273837",status: "Seen"),
    ChatMessage(messageContent: "Hello, Will", messageType: "receiver",time: "1667719192273837",status: "Seen"),
    ChatMessage(messageContent: "How have you been?", messageType: "receiver",time: "1667719192273837",status: "Seen"),
    ChatMessage(
        messageContent: "Hey Kriss, I am doing fine dude. wbu?",
        messageType: "sender",time: "1667719192273837",status: "Seen"),
    ChatMessage(messageContent: "ehhhh, doing OK.", messageType: "receiver",time: "1667719192273837",status: "Seen"),
    ChatMessage(
        messageContent: "Is there any thing wrong?", messageType: "sender",time: "1667719192273837",status: "Seen"),
    ChatMessage(messageContent: "Hello, Will", messageType: "receiver",time: "1667719192273837",status: "Seen"),
    ChatMessage(messageContent: "How have you been?", messageType: "receiver",time: "1667719192273837",status: "Seen"),
    ChatMessage(
        messageContent: "Hey Kriss, I am doing fine dude. wbu?",
        messageType: "sender",time: "1667719192273837",status: "Seen"),
    ChatMessage(messageContent: "ehhhh, doing OK.", messageType: "receiver",time: "1667719192273837",status: "Seen"),
    ChatMessage(
        messageContent: "Is there any thing wrong?", messageType: "sender",time: "1667719192273837",status: "Seen"),
  ];

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

  _getChatBg() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String chatBg = prefs.getString('chatBg') ?? 'Grey';

    setState(() {
      if (chatBg == 'Red') {
        chatBgColor = Colors.redAccent;
      } else if (chatBg == 'Grey') {
        chatBgColor = Colors.grey.shade300;
      } else if (chatBg == 'Green') {
        chatBgColor = Colors.greenAccent;
      } else if (chatBg == 'BlueGrey') {
        chatBgColor = Colors.blueGrey;
      } else if (chatBg == 'Orange') {
        chatBgColor = Colors.orangeAccent;
      } else if (chatBg == 'DeepOrange') {
        chatBgColor = Colors.deepOrangeAccent;
      } else if (chatBg == 'White') {
        chatBgColor = Colors.white;
      } else if (chatBg == 'Cyan') {
        chatBgColor = Colors.cyanAccent;
      } else if (chatBg == 'DeepPurple') {
        chatBgColor = Colors.deepPurpleAccent;
      } else if (chatBg == 'Teal') {
        chatBgColor = Colors.tealAccent;
      }
    });
  }

  _fetchUserData() {
    ref
        .child('FriendList')
        .child(widget.oppId!)
        .child('fullName')
        .onValue.listen((event) {
      var snapshot = event.snapshot;
      setState(() {
        userName = snapshot.value;
      });
    });

    ref
        .child('FriendList')
        .child(widget.oppId!)
        .child('Online')
        .onValue.listen((event) {
         var snapshot = event.snapshot;
         setState(() {
           online = snapshot.value;
         });
    });

    ref
        .child('FriendList')
        .child(widget.oppId!)
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
    _getChatBg();
    _fetchUserData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Timer(Duration(milliseconds: 500), () => _scrollController.jumpTo(_scrollController.position.maxScrollExtent));

    return Scaffold(
      backgroundColor: chatBgColor,
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
                  color: Colors.white,
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ProfileScreen(id: widget.oppId,)));
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
                              color: Colors.white),
                          maxLines: 1,
                          softWrap: false,
                          overflow: TextOverflow.fade,
                          textAlign: TextAlign.start,
                        ),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ProfileScreen(id: widget.oppId,)));
                        },
                      ),
                      SizedBox(
                        height: 2,
                      ),
                      Visibility(
                        visible: (online == 'Offline') ? false : true,
                        child: Text(
                          online,
                          style: TextStyle(color:Colors.white, fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.videocam_rounded),
                  color: Colors.white,
                  onPressed: () {
                    Fluttertoast.showToast(
                        msg: "Coming Soon!",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.red.shade300,
                        textColor: Colors.white,
                        fontSize: 16.0);
                  },
                ),
                IconButton(
                  icon: Icon(Icons.call),
                  color: Colors.white,
                  onPressed: () {
                    Fluttertoast.showToast(
                        msg: "Coming Soon!",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.red.shade300,
                        textColor: Colors.white,
                        fontSize: 16.0);
                  },
                ),
                IconButton(
                  icon: Icon(Icons.more_vert_rounded),
                  color: Colors.white,
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ChatBgSC())).then((value) => _getChatBg());
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      body: Stack(
        children: [
          Container(
            padding: EdgeInsets.only(bottom: 70),
            child: ListView.builder(
              itemCount: messages.length,
              controller: _scrollController,
              shrinkWrap: true,
              padding: EdgeInsets.only(top: 8, bottom: 8),
              physics: AlwaysScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return Container(
                  padding:
                      EdgeInsets.only(left: 12, right: 12, top: 5, bottom: 5),
                  child: Align(
                    alignment: (messages[index].messageType == "receiver"
                        ? Alignment.topLeft
                        : Alignment.topRight),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: messages[index].messageType == "receiver" ?
                        BorderRadius.only(
                          topLeft: Radius.circular(2),
                          topRight: Radius.circular(18),
                          bottomLeft: Radius.circular(18),
                          bottomRight: Radius.circular(18),
                        ) :
                        BorderRadius.only(
                          topLeft: Radius.circular(18),
                          topRight: Radius.circular(18),
                          bottomLeft: Radius.circular(18),
                          bottomRight: Radius.circular(2),
                        ),
                        color: (messages[index].messageType == "receiver"
                            ? AppColors.lightYellow
                            : AppColors.lightBlue),
                      ),
                      padding: EdgeInsets.only(left: 10,right: 10,top: 10,bottom: 6),
                      width: MediaQuery.of(context).size.width*0.7,
                      child: Column(
                        crossAxisAlignment: messages[index].messageType == "receiver" ?
                        CrossAxisAlignment.start : CrossAxisAlignment.end,
                        children: [
                          Text(
                            messages[index].messageContent,
                            style: TextStyle(fontSize: 15),
                          ),
                          Align(
                            alignment: Alignment.bottomRight,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  displayTime(messages[index].time),
                                  style: TextStyle(fontSize: 10),
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                SvgPicture.asset(
                                  'assets/double-check.svg',
                                  height: 15,
                                  width: 15,
                                  color: messages[index].status == "Seen" ? AppColors.mainColor : Colors.grey,
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              // height: 60,
              padding: EdgeInsets.all(8),
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                        controller: chatController,
                        cursorColor: AppColors.mainColor,
                        keyboardType: TextInputType.multiline,
                        minLines: 1,
                        maxLines: 4,
                        style: TextStyle(color: Colors.black, fontSize: 18),
                        decoration: InputDecoration(
                          hintText: "Message...",
                          filled: true,
                          fillColor: Colors.white,
                          hintStyle:
                              TextStyle(color: Colors.blueGrey, fontSize: 18),
                          prefixIcon: IconButton(
                            icon: Icon(
                              Icons.emoji_emotions_outlined,
                              color: Colors.blueGrey,
                            ),
                            onPressed: () {},
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                              Icons.camera_alt_rounded,
                              color: Colors.blueGrey,
                            ),
                            onPressed: () {},
                          ),
                          border: new OutlineInputBorder(
                            borderRadius: const BorderRadius.all(
                              const Radius.circular(30),
                            ),
                            borderSide: BorderSide(
                              width: 0,
                              style: BorderStyle.none,
                            ),
                          ),
                        ),
                        onChanged: (val) {
                          setState(() {
                            if (val.length > 0) {
                              sendBtn = true;
                            } else {
                              sendBtn = false;
                            }
                          });
                        },
                        validator: (val) {
                          if (val!.isEmpty) {
                            return 'Please Enter text';
                          }
                        }),
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  FloatingActionButton(
                    child: SvgPicture.asset(
                      'assets/send.svg',
                      height: 30,
                      width: 30,
                      color: Colors.white,
                    ),
                    backgroundColor:
                        (sendBtn == true) ? AppColors.mainColor : Colors.blueGrey[300],
                    elevation: 0,
                    onPressed: () {
                      if (chatController.text.trim().length > 0) {
                        setState(() {
                          messages.add(ChatMessage(
                              messageContent: chatController.text,
                              messageType: 'sender',
                              time: DateTime.now().microsecondsSinceEpoch.toString(),
                              status: "Sent"));
                          chatController.clear();
                          sendBtn = false;
                        });

                        // String push_key = ref
                        //     .child("ChatList")
                        //     .child(widget.oppId!)
                        //     .push()
                        //     .key
                        //     .toString();
                        // ref
                        //     .child("ChatList")
                        //     .child(widget.getChatId)
                        //     .child(push_key)
                        //     .set({
                        //   'Date': currentTime.toString(),
                        //   'Message': messageCtrl.text.toString(),
                        //   'SenderId': widget.userId,
                        //   'ReceiverId': widget.oppo_userId,
                        //   'Chatids':
                        //   widget.userId + "_" + widget.oppo_userId,
                        //   'SeenUnseen': online_offline_oppo_user,
                        //   'PushKey': push_key,
                        //   'ImageUrl': ""
                        // });

                        _scrollController.animateTo(
                          _scrollController.position.maxScrollExtent+70,
                          curve: Curves.easeOut,
                          duration: const Duration(milliseconds: 300),
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
