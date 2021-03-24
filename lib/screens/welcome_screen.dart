import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:naariAndroid/constants/constants.dart';
import 'package:naariAndroid/screens/sign_Screen.dart';

class welcome_Screen extends StatelessWidget {

  static String id = "welcome_screen";
  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushNamed(context, sign_Screen.id);
    });

    return Scaffold(
      body: Column(
        children: [
          Expanded(
            flex: 3,
            child: Stack(
              children: [
                Container(),

                Hero(
                  tag: "cont",
                  child: Container(
                    decoration: new BoxDecoration(

                      gradient:     LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Color(0xFFB1D8D8), Color(0xFF79B7B7)]),
                      borderRadius: BorderRadius.vertical(
                          bottom: Radius.elliptical(
                              MediaQuery.of(context).size.width, 330.0)),
                    ),
                  ),
                ),
              ],
            ),
          ),


          Expanded(
            child: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SpinKitChasingDots(
                    color: Color(0xFF004C4C),
                    size: 30.0,
                  ),
                  Hero(
                      tag: "Logo",

                      child: Image.asset("assets/images/NAARI.png",scale: 1.6,)
                  ),
                  // Hero(
                  //   tag: "Logo",
                  //
                  //   child: Material(
                  //     color: Colors.transparent,
                  //     child: Text(
                  //       "NAARI",
                  //       style: kheroLogoText.copyWith(fontSize: 40, color: Color(0xFF004C4C)),
                  //     ),
                  //   ),
                  // ),
                  logoRichText()
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
