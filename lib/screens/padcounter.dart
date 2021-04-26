import 'package:auto_size_text/auto_size_text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:naariAndroid/constants/constants.dart';
import 'package:contained_tab_bar_view/contained_tab_bar_view.dart';
import 'Counter/Main.dart';
import 'Counter/Setting.dart';
import 'Counter/Tapp.dart';

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



class counter_Screen extends StatefulWidget {
  static String id = "counter_Screen";
  static int pageid = 1;
  @override
  _counter_ScreenState createState() => _counter_ScreenState();
}

class _counter_ScreenState extends State<counter_Screen> {
  int _selectedItemPosition = 1;
  FirebaseAuth _auth = FirebaseAuth.instance;

  User user;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _selectedItemPosition = 1;
    gtUser();
  }

  void gtUser() {
    final us = _auth.currentUser;
    if (us != null) {
      user = us;
      print(user);
    }
  }

  @override
  Widget build(BuildContext context) {
    Size query = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () async => false,

      child: Scaffold(
        extendBody: true,
        appBar: PreferredSize(
          preferredSize: Size(double.infinity, 100),
          child: Container(
            margin: const EdgeInsets.only(bottom: 5),
            height: query.height,
            decoration: infoContainer,
            child: Center(
              child: Text("PAD COUNTER", style: headingStyle),
            ),
          ),
        ),
        body: ContainedTabBarView(
          initialIndex: 1,
          tabs: [AutoSizeText('STORES'), AutoSizeText('MAIN'), AutoSizeText('SETTING')],
          tabBarProperties:
          TabBarProperties(
              innerPadding: const EdgeInsets.symmetric(
                horizontal: 32.0,
                vertical: 8.0,
              ),
              indicator: ContainerTabIndicator(
                radius: BorderRadius.circular(16.0),
                color: Color(0xFFEFEFEF),
                borderWidth: 2.0,
                borderColor: Colors.transparent,
              ),
              labelColor: Color(0xFF1E7777),
              labelStyle: headingStyle.copyWith(
                  fontSize: 18, fontWeight: FontWeight.bold),
              unselectedLabelStyle: TextStyle(fontSize: 15),
              unselectedLabelColor: Color(0xFF8CC4C4)),
          views: [
            Tapp(),
            Main(),
            setting()
          ],
          onChange: (index) => print(index),
        ),


      ),
    );
  }
}



// class Tapp extends StatefulWidget {
//   @override
//   _TappState createState() => _TappState();
// }
//
// class _TappState extends State<Tapp> {
//   void getLocation() async{
//
//     Locations location=Locations();
//     await location.getnowLocation();
//
//     print(location.long);
//     print(location.lat);
//
// //    var googlePlace = GooglePlace("");
// // //    var result = await googlePlace.search.getNearBySearch(
// // //        Location(lat: location.lat, lng: location.long), 1500,
// // //        type: "hospital");
// // // print(result.results);
//     var dio=Dio();
//     var url="https://maps.googleapis.com/maps/api/place/nearbysearch/json";
//     var parameters={
//       "key":"AIzaSyASx3MaOL6MKoKecTx7fcBh6hItOydoz0k",
//       "location": '${location.lat},${location.long}',
//       "radius":"800",
//       "keyword": "hotel"
//     };
//
//     var response=await dio.get(url, queryParameters: parameters);
//
//     print(response.data['results'].map<String>((result)=> result['name'].toString()).toList());
//
//   }
//
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     getLocation();
//   }
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         backgroundColor:Color(0xFFEFEFEF),
//         body: Container(
//           child: Center(child: RaisedButton(onPressed: ()=>getLocation(), child: Text("Get Location"), )),
//         ));
//   }
// }
//


// class main extends StatefulWidget {
//   @override
//   _mainState createState() => _mainState();
// }
//
// class _mainState extends State<main> {
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         backgroundColor:Color(0xFFEFEFEF),
//         body: Center(
//           heightFactor: 3,
//           child: Container(
//               child: Text(
//
//                 "AVAILABLE\n${counter.toStringAsFixed(0)}",
//                 textAlign: TextAlign.center,
//                 style: kheroLogoText.copyWith( fontSize: 50,color: Color(0xFF535050)),)
//           ),
//         ));
//   }
// }


// class setting extends StatefulWidget {
//   @override
//   _settingState createState() => _settingState();
// }
//
// class _settingState extends State<setting> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         backgroundColor:Color(0xFFEFEFEF),
//         body: ListView(
//           children: [
//             Padding(
//               padding: const EdgeInsets.all(11.0),
//               child: Center(child: Text("SET COUNT",style: kheroLogoText.copyWith(fontSize: 50,color: Color(0xFF535050)),)),
//             ),
//             SizedBox(height: MediaQuery.of(context).size.height*0.1,),
//             Padding(
//               padding: const EdgeInsets.all(11.0),
//               child: SleekCircularSlider(
//
//                 appearance: CircularSliderAppearance(
//                     size: MediaQuery.of(context).size.height*0.3,
//
//                     infoProperties: InfoProperties(
//                         modifier:  (double value) {
//                           final roundedValue = value.ceil().toInt().toString();
//
//                           return '$roundedValue';
//                         }
//                     ),
//
//                     customWidths: CustomSliderWidths(
//                         handlerSize: 20,
//                         progressBarWidth: 10
//
//                     ),
//                     customColors: CustomSliderColors(
//                       dotColor: Color(0xFF006666),
//                       trackColor: Colors.red,
//                       progressBarColors: [Color(0xFF008079), Color(0xFF004D4B)]
//                       ,
//
//
//                     )
//                 ),
//                 min: 0,
//                 max: 50,
//                 initialValue: counter,
//                 onChange: (double value) {
//
//                   final roundedValue = value.ceil().toInt();
//                   setState(() {
//                     counter= roundedValue.toDouble();
//                   });
//
//                 },
//               ),
//             ),
//           ],
//         ));
//   }
// }
