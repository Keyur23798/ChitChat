import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:whatsapp/Utils/CustomColors.dart';

class FullScreenImgViewSC extends StatefulWidget {
  // const FullScreenImgViewSC({Key? key}) : super(key: key);
  String? url;
  FullScreenImgViewSC({this.url});

  @override
  State<FullScreenImgViewSC> createState() => _FullScreenImgViewSCState();
}

class _FullScreenImgViewSCState extends State<FullScreenImgViewSC> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: Colors.white, //change your color here
          ),
          title: Text(
            "",
            style: GoogleFonts.satisfy(
              textStyle: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  letterSpacing: 1.5,
                  decoration: TextDecoration.none,
                  fontWeight: FontWeight.bold),
            ),
          ),
          // backgroundColor: AppColors.mainColor,
          backgroundColor: Colors.black,
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
