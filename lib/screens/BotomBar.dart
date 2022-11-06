import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:whatsapp/Utils/CustomColors.dart';
import 'package:whatsapp/screens/ProfileScreen.dart';
import 'package:whatsapp/screens/Updates.dart';
import 'package:whatsapp/screens/Wallpaper.dart';
import 'package:whatsapp/screens/homeScreen.dart';
import 'Settings.dart';

class BottomBarSC extends StatefulWidget {

  @override
  _MainSCState createState() => _MainSCState();
}

class _MainSCState extends State<BottomBarSC> {
  int _currentIndex = 0;
  final List<Widget> _Screens = [
    HomeScreen(),
    UpdatesSC(),
    WallpaperSC(),
    SettingScreen(),
  ];

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _Screens[_currentIndex],
      floatingActionButton: Container(
        height: 60,
        margin: EdgeInsets.only(left: 20,right: 20,bottom: 10),
        child: ClipRRect(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.0),
            topRight: Radius.circular(20.0),
            bottomLeft: Radius.circular(20.0),
            bottomRight: Radius.circular(20.0),
          ),
          child: BottomNavigationBar(
            currentIndex: _currentIndex,
            onTap: onTabTapped,
            backgroundColor: AppColors.mainColor,
            selectedItemColor: AppColors.white,
            unselectedItemColor: Colors.grey,
            showUnselectedLabels: false,
            showSelectedLabels: false,
            type: BottomNavigationBarType.fixed,
            items: [
              new BottomNavigationBarItem(
                icon: SvgPicture.asset('assets/message.svg',height: 28,width: 28,color: (_currentIndex == 0) ? AppColors.mediumGreen : AppColors.white,),
                label: 'Chat',
              ),
              new BottomNavigationBarItem(
                icon: SvgPicture.asset('assets/whatsapp-status.svg',height: 28,width: 28,color: (_currentIndex == 1) ? AppColors.mediumGreen : AppColors.white,),
                label: 'Updates',
              ),
              new BottomNavigationBarItem(
                icon: SvgPicture.asset('assets/wallpaper.svg',height: 25,width: 25,color: (_currentIndex == 2) ? AppColors.mediumGreen : AppColors.white,),
                label: 'Wallpaper',
              ),
              new BottomNavigationBarItem(
                icon: SvgPicture.asset('assets/setting.svg',height: 25,width: 25,color: (_currentIndex == 3) ? AppColors.mediumGreen : AppColors.white,),
                label: 'Settings',
              ),
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      // bottomNavigationBar: Container(
      //   // decoration: BoxDecoration(
      //   //   color: AppColors.mainColor,
      //   //   borderRadius: BorderRadius.only(
      //   //       topRight: Radius.circular(35), topLeft: Radius.circular(35)),
      //   //   boxShadow: [
      //   //     BoxShadow(
      //   //       color: AppColors.mainColor,
      //   //       offset: Offset(4.0, 4.0), //(x,y)
      //   //       blurRadius: 6.0,
      //   //       spreadRadius: 4,
      //   //     ),
      //   //   ],
      //   // ),
      //   height: 70,
      //   margin: EdgeInsets.all(10),
      //   child: ClipRRect(
      //     borderRadius: BorderRadius.only(
      //       topLeft: Radius.circular(35.0),
      //       topRight: Radius.circular(35.0),
      //       bottomLeft: Radius.circular(35.0),
      //       bottomRight: Radius.circular(35.0),
      //     ),
      //     child: BottomNavigationBar(
      //       currentIndex: _currentIndex,
      //       onTap: onTabTapped,
      //       backgroundColor: Colors.white,
      //       selectedItemColor: AppColors.mainColor,
      //       unselectedItemColor: Colors.grey,
      //       showUnselectedLabels: false,
      //       showSelectedLabels: false,
      //       type: BottomNavigationBarType.fixed,
      //       items: [
      //         new BottomNavigationBarItem(
      //           icon: SvgPicture.asset('assets/message.svg',height: 30,width: 30,color: (_currentIndex == 0) ? AppColors.mainColor : Colors.grey,),
      //           label: 'Chat',
      //         ),
      //         new BottomNavigationBarItem(
      //           icon: SvgPicture.asset('assets/whatsapp-status.svg',height: 30,width: 30,color: (_currentIndex == 1) ? AppColors.mainColor : Colors.grey,),
      //           label: 'Status',
      //         ),
      //         new BottomNavigationBarItem(
      //           icon: SvgPicture.asset('assets/wallpaper.svg',height: 30,width: 30,color: (_currentIndex == 2) ? AppColors.mainColor : Colors.grey,),
      //           label: 'Wallpaper',
      //         ),
      //         new BottomNavigationBarItem(
      //           icon: SvgPicture.asset('assets/setting.svg',height: 30,width: 30,color: (_currentIndex == 3) ? AppColors.mainColor : Colors.grey,),
      //           label: 'Settings',
      //         ),
      //       ],
      //     ),
      //   ),
      // ),
    );
  }
}