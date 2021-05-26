import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_snake_navigationbar/flutter_snake_navigationbar.dart';
import 'package:naariAndroid/constants/constants.dart';
import 'package:naariAndroid/screens/padcounter.dart';
import 'package:naariAndroid/screens/welcome_screen.dart';

enum ThemeStyle {
  Dribbble,
  Light,
  NoElevation,
  AntDesign,
  BorderRadius,
  FloatingBar,
  NotificationBadge,
  WithTitle,
  BlurEffect
}

class home_Screen extends StatefulWidget {
  static String id = "home_Screen";
  @override
  _home_ScreenState createState() => _home_ScreenState();
}

class _home_ScreenState extends State<home_Screen> {
  int _selectedItemPosition = 2;
  FirebaseAuth _auth = FirebaseAuth.instance;

  User user;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _selectedItemPosition = 2;
    print("Getting user");
    gtUser();
  }

  void gtUser() {
    final us = _auth.currentUser;
    if (us != null) {
      user = us;
      print("User $user");
    } else
      print("User null");
  }

  @override
  Widget build(BuildContext context) {
    Size query = MediaQuery.of(context).size;
    return Scaffold(
      extendBody: true,
      body: ListView(
        shrinkWrap: true,
        children: [
          Container(
              margin: const EdgeInsets.only(bottom: 5),
              height: query.height * 0.35,
              decoration: infoContainer,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Material(
                      color: Colors.transparent,
                      child: Text(
                        "Paavya",
                        style: kheroLogoText.copyWith(
                            fontFamily: "Samarkan",
                            fontSize: 40,
                            color: Colors.white),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  CircleAvatar(
                    radius: 35,
                    backgroundColor: Colors.white,
                    child: CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.transparent,
                      child: Icon(
                        Icons.person,
                        size: 60,
                        color: Color(0xFF8C41EA),
                      ),
//                      backgroundImage: NetworkImage("https://i.pinimg.com/280x280_RS/40/e1/2a/40e12afed06fdeda86a4e0aba34137ad.jpg"),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Hi User Name",
                      style: TextStyle(color: Colors.white, fontSize: 26),
                    ),
                  ),
                  sizedbox,
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "HOME",
                      style: TextStyle(letterSpacing: 6, color: Colors.white),
                    ),
                  )
                ],
              )),
          Padding(
            padding: infoContainers,
            child: Align(
              alignment: Alignment.centerRight,
              child: Container(
                height: query.height * 0.2,
                width: query.width * 0.95,
                decoration: smallinfoContainer,
              ),
            ),
          ),
          Padding(
            padding: infoContainers,
            child: Align(
              alignment: Alignment.centerLeft,
              child: GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, counter_Screen.id);
                },
                child: Container(
                    height: query.height * 0.2,
                    width: query.width * 0.95,
                    decoration: smallinfoContainer.copyWith(
                        color: Color.fromRGBO(0, 76, 76, 100),
                        borderRadius: BorderRadius.only(
                            topRight: Radius.circular(100),
                            bottomRight: Radius.circular(100)))
//

                    ),
              ),
            ),
          ),
          Padding(
            padding: infoContainers,
            child: Align(
              alignment: Alignment.centerRight,
              child: Container(
                  height: query.height * 0.2,
                  width: query.width * 0.95,
                  decoration:
                      smallinfoContainer.copyWith(color: Color(0xFFF56A82))
//              BoxDecoration(
//                  color: Color(0xFFF56A82),
//                  borderRadius: BorderRadius.only(topLeft: Radius.circular(100),
//                      bottomLeft: Radius
//                          .circular(100))
//              ),

                  ),
            ),
          ),
        ],
      ),
      // bottomNavigationBar: Hero(
      //   tag: "Snakegosss",
      //   child: SnakeNavigationBar.color(
      //     backgroundColor: Color(0xFF006666),
      //     behaviour: snakeBarStyle,
      //     snakeShape: snakeShape,
      //     shape: bottomBarShape,
      //     padding: padding,
      //     snakeViewColor:Color(0xFFEFEFEF) ,
      //     selectedItemColor: Color(0xFF006666),
      //     unselectedItemColor: Colors.white,
      //     showUnselectedLabels: showUnselectedLabels,
      //     showSelectedLabels: showSelectedLabels,
      //     currentIndex: _selectedItemPosition,
      //     onTap: (index){
      //       setState(() => _selectedItemPosition = index);print(_selectedItemPosition);
      //       print(index);
      //       switch(index){
      //         case 0:
      //           Future.delayed(const Duration(milliseconds: 500), () {
      //             setState(() {
      //               Navigator.pushNamed(context, home_Screen.id);
      //             });
      //
      //           });
      //           break;
      //         case 1: Future.delayed(const Duration(milliseconds: 500), () {
      //           setState(() {
      //             Navigator.pushNamed(context, counter_Screen.id);
      //           });
      //
      //         });
      //         break;
      //         case 2: Future.delayed(const Duration(milliseconds: 500), () {
      //           setState(() {
      //             Navigator.pushNamed(context, home_Screen.id);
      //           });
      //
      //         });
      //         break;
      //
      //       }
      //     },
      //     items: items,
      //     selectedLabelStyle: const TextStyle(fontSize: 14),
      //     unselectedLabelStyle: const TextStyle(fontSize: 10),
      //   ),
      // ),
    );
  }
}
