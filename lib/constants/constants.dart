import 'package:contained_tab_bar_view/contained_tab_bar_view.dart';
import 'package:custom_navigation_bar/custom_navigation_bar.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/animation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_snake_navigationbar/flutter_snake_navigationbar.dart';
import 'package:intl/intl.dart';
import 'dart:math' as math;
import 'package:naariAndroid/constants/my_flutter_app_icons.dart';
import 'package:naariAndroid/screens/experiment.dart';
import 'package:naariAndroid/screens/settings.dart';

import 'Database.dart';


//CONSTANTS

const indicatorColor = AlwaysStoppedAnimation<Color>(Color(0xFF004C4C));
const headingStyle= TextStyle(letterSpacing: 7, color: Colors.white, fontSize: 20);
const signPadding = EdgeInsets.only(right: 17.0, left: 17.0, top: 8, bottom: 8);
const infoContainers = const EdgeInsets.only(top: 13.0, bottom: 13);
const curscol=Color(0xFF004C4C);
const smallinfoContainer = BoxDecoration(
    gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Color(0xFF004D4D), Color(0xFF008080)]),
    color: Color(0xFF004C4C),
    borderRadius: BorderRadius.only(
        topLeft: Radius.circular(100), bottomLeft: Radius.circular(100)));
const infoContainer = BoxDecoration(
    boxShadow: [
      BoxShadow(
        color: Colors.black,
        offset: Offset(0.0, 1.0), //(x,y)
        blurRadius: 6.0,
      ),
    ],
    borderRadius: BorderRadius.only(
        bottomRight: Radius.circular(60), bottomLeft: Radius.circular(60)),
    gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Color(0xFF008080), Color(0xFF004D4D)]));
const SizedBox sizedbox = SizedBox(
  height: 5,
);
final BorderRadius _borderRadius = const BorderRadius.only(
  topLeft: Radius.circular(25),
  topRight: Radius.circular(25),
);
const kTextStyle = InputDecoration(
  filled: true,
  fillColor: Color(0xFFB1D8D8),
  hintText: "Email/Mobile No.",
  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(15.0)),
  ),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Color(0xFF004C4C), width: 2.0),
    borderRadius: BorderRadius.all(Radius.circular(15.0)),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Color(0xFF004C4C), width: 2.0),
    borderRadius: BorderRadius.all(Radius.circular(15.0)),
  ),
);
const kTextStylee = InputDecoration(
  filled: true,
  fillColor: Color(0xFFEFEFEF),
  hintText: "Pads Used Per Day.",
  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(18.0)),
  ),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Color(0xFF004C4C), width: 2.0),
    borderRadius: BorderRadius.all(Radius.circular(18.0)),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Color(0xFF004C4C), width: 2.0),
    borderRadius: BorderRadius.all(Radius.circular(18.0)),
  ),
);
const kheroLogoText = TextStyle(
    color: Color(0xFFA03FE4),
    fontSize: 40,
    fontWeight: FontWeight.w700,
    decoration: TextDecoration.none,
    letterSpacing: 2);

//VALIDATOR FUNCTIONS
String fnameValidator(value) {
  if (value.isEmpty) {
    return "Please Enter Text";
  }
}

String usernameValidator(value) {
  if (value.isEmpty) {
    return "Please Enter Text";
  }
}

String numberValidator(value) {
  if (value.isEmpty) {
    return "Please Enter Number";
  } else if (value.length < 10 || value.length > 10) {
    print(value.length);
    return "Enter A Valid Mobile Number ";
  }
  return null;
}

String passwordValidator(value) {
  String pattern = r'^(?=.*?[A-Z])(?=.*?[0-9])';
  RegExp regex = new RegExp(pattern);
  if (value.isEmpty) {
    return 'Please Enter Text';
  } else if (value.length <= 6) {
    return 'Password Must Be Atleast 6 '
        'Characters Long';
  } else if (!regex.hasMatch(value)) {
    return "Password Must Have Atleast One "
        "Uppercase and Numeric";
  } else {
    return null;
  }
}

String emailChecker(value) {
  if (value.isEmpty) {
    return 'Please Enter Text';
  } else if (EmailValidator.validate(value) == false) {
    return "Please Mention A Valid Email";
  }

  return null;
}

//HACKCLUB LOGO
class logoRichText extends StatelessWidget {
  const logoRichText({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
          text: "Developed By",
          style: TextStyle(color: Colors.black, fontSize: 12),
          children: [
            TextSpan(
                text: "\n Hack Club",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold))
          ]),
    );
  }
}
//SIGNING BUTTON
class buttonWidget extends StatelessWidget {
  final String title;
  final Function onpressed;
  const buttonWidget({
    Key key,
    this.title,
    this.onpressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
        elevation: 2.5,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        minWidth: MediaQuery.of(context).size.width * 0.5,
        color: Color(0xFF1D3E6B),
        onPressed: onpressed,
        child: Text(
          title,
          style: TextStyle(color: Colors.white),
        ));
  }
}
//SETTINGS BLOCK

// RaisedButton(onPressed: on,
//
// child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
// children: [
// Text("$title",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 18),),
// Icon(Icons.navigate_next,color: Colors.white,)
// ],
// ),
// shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
// color: Color(0xFF008080),

class settingsButton extends StatefulWidget {
  final String title;
  final bool special;
  final Function on;
  double contH=0;
  bool sw=false;
  final List<funcAndChild> widgetList;

  settingsButton({Key key, @required this.title,this.widgetList, this.on, this.special=false}) : super(key: key);
  @override
  _settingsButtonState createState() => _settingsButtonState();
}

class _settingsButtonState extends State<settingsButton> {

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 25,right: 25),

      child: RaisedButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        color: Color(0xFF008080),
        onPressed: !widget.special ? () {}  : widget.on,
        child:Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AnimatedContainer(duration: Duration(milliseconds: 300),height: !widget.sw ? 0 : 10),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(widget.title, style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 18),),
                  !widget.special ? GestureDetector(
                    onTap: !widget.special ? () {
                      setState(() {
                        if ( widget.sw )
                          widget.contH =0;
                        else if ( widget.widgetList != null)
                          widget.contH = 30;
                        if (widget.widgetList!=null)
                          widget.sw = !widget.sw;
                      });
                    } : (){},
                  child: !widget.sw ? Icon(
                      Icons.navigate_next,
                      color: Colors.white,
                    ) :
                  Transform.rotate(
                    angle: 90 * math.pi/180,
                    child: Icon(
                      Icons.navigate_next,
                      color: Colors.white,
                    ),
                  ),
                  ) : Container()
                  ],
              ),
              widget.widgetList!=null? AnimatedContainer(
                margin: EdgeInsets.only(left: 10,bottom: widget.sw?10:0),
                duration: Duration(milliseconds: 300),
                child: Column(
                    children: widget.widgetList.map((e) =>
                      AnimatedContainer(
                          duration: Duration(milliseconds: 300),
                          height: widget.contH,
                          child: widget.sw?
                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                e.child,
                                e.opt==optionType.checkbox ?
                                GestureDetector(
                                    child : !e.cond() ? Icon(Icons.check_box, color: Colors.white,) :
                                    Icon(Icons.check_box_outline_blank_rounded, color: Colors.white),
                                    onTap: () {
                                      setState(() {
                                        e.fun();
                                      });
                                    }
                                ) :
                                Container(
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.all(Radius.circular(4))),
                                  padding: EdgeInsets.only(left:5,right:5),
                                  child: DropdownButton<String>(
                                    value: e.cond().toString(),
                                    icon: const Icon(Icons.arrow_drop_down, color: Colors.black,),
                                    iconSize: 24,
                                    elevation: 16,
                                    style: const TextStyle(color: Colors.black),
                                    underline: Container(
                                      height: 0,
                                      color: Colors.black,
                                    ),
                                    onChanged: (String newValue) {
                                      setState(() {
                                        e.fun(int.parse(newValue));
                                      });
                                    },
                                    items:e.itemList
                                        .map<DropdownMenuItem<String>>((String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(value),
                                      );
                                    }).toList(),
                                  ),
                                ),
                              ]
                          )
                              :Container()
                      ),
                    ).toList(),
                ),
                ) : Container(),
            ]
        ),
      ),
    );
  }
}

//DONT HAVE ACCOUNT?
class signUpRichText extends StatelessWidget {
  final String title;
  final String text;
  final Function onTap;
  const signUpRichText({
    Key key,
    @required this.title,
    @required this.onTap, this.text = "Don't Have An Account? ",
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
          text: text,
          style: TextStyle(color: Colors.black, fontSize: 13),
          children: [
            TextSpan(
                recognizer: TapGestureRecognizer()..onTap = onTap,
                text: title,
                style: TextStyle(decoration: TextDecoration.underline))
          ]),
    );
  }
}


//FLOATINGBAR1
Widget buildFloatingBar() {
  return
    CustomNavigationBar(
      iconSize: 30.0,
// selectedColor: Color(0xff0c18fb),
// strokeColor: Color(0x300c18fb),
      unSelectedColor: Colors.grey[600],
      backgroundColor: Color(0xFF006666),
      borderRadius: Radius.circular(20.0),

      items: [
        CustomNavigationBarItem(
          icon: Icon(
            Icons.favorite,
            color: Colors.white,
          ),
        ),
        CustomNavigationBarItem(
          icon: Icon(
            Icons.audiotrack,
            color: Colors.white,
          ),
        ),
        CustomNavigationBarItem(
          icon: Icon(
            Icons.beach_access,
            color: Colors.white,
          ),
        ),
      ],
// currentIndex: _currentIndex,
// onTap: (index) {
//   setState(() {
//     _currentIndex = index;
//   });
// },
      isFloating: true,
    );


}

//SNAKEBAR CONSTANTS
ShapeBorder bottomBarShape = const RoundedRectangleBorder(
  borderRadius: BorderRadius.all(Radius.circular(25)),
);
SnakeBarBehaviour snakeBarStyle = SnakeBarBehaviour.floating;
EdgeInsets padding = const EdgeInsets.all(12);
SnakeShape snakeShape = SnakeShape.circle;
bool showSelectedLabels = false;
bool showUnselectedLabels = false;
Color selectedColor = Colors.black;
List<BottomNavigationBarItem> items=[
  const BottomNavigationBarItem(
      icon: Icon(Icons.calendar_today), label: 'tickets'),
  const BottomNavigationBarItem(
      icon: Icon(MyFlutterApp.icons8_pad_90), label: 'calendar'),
  const BottomNavigationBarItem(
      icon: Icon(Icons.home_filled), label: 'calendar'),
  const BottomNavigationBarItem(
      icon: Icon(Icons.music_note), label: 'calendar'),
  const BottomNavigationBarItem(
      icon: Icon(Icons.settings), label: 'calendar'),
];

//SNAKEBAR
Widget snakebar(Function ontap, int pos){

  return  SnakeNavigationBar.color(
    backgroundColor: Color(0xFF027e7e),
    behaviour: snakeBarStyle,
    snakeShape: snakeShape,
    shape: bottomBarShape,
    padding: padding,
    snakeViewColor:Color(0xFFEFEFEF) ,
    selectedItemColor: Color(0xFF006666),
    unselectedItemColor: Colors.white,
    showUnselectedLabels: showUnselectedLabels,
    showSelectedLabels: showSelectedLabels,
    currentIndex: pos,
    onTap: ontap,
    items: items,
    selectedLabelStyle: const TextStyle(fontSize: 14),
    unselectedLabelStyle: const TextStyle(fontSize: 10),
  );
}





User user;

//UpdateTask
void updateTask(int updatedValue, String id) {

  Database.updateTask(id, {
    'counter': updatedValue,
    'perday' : 0
  });
}
void updateTask2(int updatedValue, String id) {

  Database.updateTask(id, {

    'perday' : updatedValue
  });
}


DateTime selectedDate = DateTime.now();
final DateFormat formatter = DateFormat('MM-dd-yyyy');

// something like 2013-04-20


