import 'package:auto_size_text/auto_size_text.dart';
import 'package:contained_tab_bar_view/contained_tab_bar_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart'
    show CalendarCarousel;
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart';
import 'package:naariAndroid/constants/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class CalendarPage extends StatefulWidget {
  @override
  _CalendarPageState createState() => _CalendarPageState();
}

var _currentDate = new DateTime.now();
var Months = [
  'January',
  'February',
  'March',
  'April',
  'May',
  'June',
  'July',
  'August',
  'September',
  'October',
  'November',
  'December'
];

class _CalendarPageState extends State<CalendarPage> {
  DateTime d1 = DateTime.now();
  DateTime d2 = DateTime.now();
  int diff = 0;
  SharedPreferences prefs;

  @override
  void initState() {
    getDates();
    super.initState();
  }

  calcDiff() {
    setState(() {
      diff = d2.difference(d1).inDays;
      print("Diff: $diff");
    });
  }

  getDates() async {
    prefs = await SharedPreferences.getInstance();
    String ts = "", s1 = "", s2 = "";
    s1 = prefs.getString("d1") ?? "";
    s2 = prefs.getString("d2") ?? "";

    if (s1 == "") {
      d1 = DateTime.now();
      d2 = d1;
      return;
    }
    setState(() {
      d1 = DateTime.parse(s1);
      d2 = DateTime.parse(s2);
      diff = d2.difference(d1).inDays;
    });
    calcDiff();
  }

  selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      // Refer step 1
      firstDate: DateTime(2000),
      lastDate: DateTime(2025),
      helpText: 'Select Purchase Date',
      // Can be used as title

      cancelText: 'Cancel',
      confirmText: 'Set',
      builder: (BuildContext context, Widget child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: const Color(0xFF008079),
            accentColor: const Color(0xFF008079),
            colorScheme: ColorScheme.light(primary: const Color(0xFF008079)),
            buttonTheme: ButtonThemeData(textTheme: ButtonTextTheme.primary),
          ),
          child: child,
        );
      },
    );
    if (picked != null && picked != selectedDate) return picked;
  }

  @override
  Widget build(BuildContext context) {
    Size query = MediaQuery.of(context).size;
    return Scaffold(
      extendBody: true,
      appBar: PreferredSize(
        preferredSize: Size(double.infinity, 100),
        child: Container(
          margin: const EdgeInsets.only(bottom: 0),
          height: query.height,
          decoration: infoContainer,
          child: Center(
            child: Text("PERIOD TRACKER", style: headingStyle),
          ),
        ),
      ),
      body: ContainedTabBarView(
        tabs: [AutoSizeText('MAIN'), AutoSizeText('SETTING')],
        tabBarProperties: TabBarProperties(
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
          Container(
            decoration: BoxDecoration(
              color: Color(0xFF006666),
              borderRadius: BorderRadius.circular(40),
            ),
            padding: EdgeInsets.all(10),
            margin: EdgeInsets.only(left: 16.0, right: 16.0, bottom: 80.0),
            child: CalendarCarousel<Event>(
              onCalendarChanged: (var x) {
                this.setState(() {
                  this.setState(() => _currentDate = x);
                });
              },
              // onDayPressed: (DateTime date, List<Event> events) {
              //   this.setState(() => _currentDate = date);
              // },
              daysTextStyle: TextStyle(
                color: Colors.white,
              ),
              weekDayFormat: WeekdayFormat.short,
              weekdayTextStyle: TextStyle(color: Colors.white),
              nextMonthDayBorderColor: Colors.white12,
              prevMonthDayBorderColor: Colors.white12,
              headerTextStyle: TextStyle(color: Colors.white),
              headerText: Months[_currentDate.month - 1],
              iconColor: Colors.white,
              weekendTextStyle: TextStyle(
                color: Colors.white,
              ),
              thisMonthDayBorderColor: Colors.grey,
//      weekDays: null, /// for pass null when you do not want to render weekDays
//      headerText: Container( /// Example for rendering custom header
//        child: Text('Custom Header'),
//      ),
              customDayBuilder: (
                /// you can provide your own build function to make custom day containers
                bool isSelectable,
                int index,
                bool isSelectedDay,
                bool isToday,
                bool isPrevMonthDay,
                TextStyle textStyle,
                bool isNextMonthDay,
                bool isThisMonthDay,
                DateTime day,
              )  {


                /// If you return null, [CalendarCarousel] will build container for current [day] with default function.
                /// This way you can build custom containers for specific days only, leaving rest as default.

                // Example: every 15th of month, we have a flight, we can place an icon in the container like that:
                // if (day == d1 ||
                //     day == d2) {
                //   return Container(
                //     constraints: BoxConstraints.expand(),
                //     child: Center(child: Text("${day.day}")),
                //     decoration: BoxDecoration(
                //         color: Colors.orange, shape: BoxShape.circle),
                //   );
                // }
                DateTime next = d2.add(Duration(days: diff));
                if ( day.isAfter(next.subtract(Duration(days:3))) && day.isBefore(next.add(Duration(days:3))) )
                  return Container(
                    constraints: BoxConstraints.expand(),
                    child: Center(child: Text("${day.day}")),
                    decoration: BoxDecoration(
                        color: Color.fromRGBO(255-15*day.difference(next).inDays.abs(),30,30,1-0.05*day.difference(next).inDays.abs()), shape: BoxShape.circle),
                  );

                return null;
              },
              weekFormat: false,
              // markedDateCustomShapeBorder: ,
              todayButtonColor: null,
              todayBorderColor: Colors.white,
              // markedDatesMap: _markedDateMap,
              height: 420.0,
              // selectedDateTime: _currentDate,
              daysHaveCircularBorder: true,

              /// null for not rendering any border, true for circular border, false for rectangular border
            ),
          ),
          Container(
            padding: EdgeInsets.only(bottom: 40),
            color: Color(0xFFEFEFEF),
            child: Center(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.only(left:15, right:15),
                  child: Text("We will use this data to mark your next period on Calendar",
                      textAlign: TextAlign.center,
                      style: kheroLogoText.copyWith(
                          fontSize: 15, color: Color(0xFF535050))),
                ),
                SizedBox(height: 30,),
                Text("Last but one period was on",
                    style: kheroLogoText.copyWith(
                        fontSize: 15, color: Color(0xFF535050))),
                Text(" ${d1.day}-${d1.month}-${d1.year}",
                    style: kheroLogoText.copyWith(
                        fontSize: 25, color: Color(0xFF535050))),
                SizedBox(height: 15),
                ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Color(0xFFEFEFEF)),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                        side: BorderSide(color: Colors.red, width: 2),
                      ))),
                  onPressed: () async {
                    DateTime rec = await selectDate(context);
                    if (rec==null) return;
                    setState(() {
                      d1 = rec;
                      calcDiff();
                      prefs.setString(
                          "d1", DateFormat("yyyy-MM-dd").format(d1));
                    });
                  },
                  child: Text(
                    "Callibrate date",
                    style: kheroLogoText.copyWith(
                        fontSize: 20, color: Color(0xFF535050)),
                  ),
                ),
                SizedBox(height: 25),
                Text("Last period was on",
                    style: kheroLogoText.copyWith(
                        fontSize: 15, color: Color(0xFF535050))),
                Text("${d2.day}-${d2.month}-${d2.year}",
                    style: kheroLogoText.copyWith(
                        fontSize: 25, color: Color(0xFF535050))),
                SizedBox(height: 15),
                ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Color(0xFFEFEFEF)),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                        side: BorderSide(color: Colors.red, width: 2),
                      ))),
                  onPressed: () async {
                    DateTime rec = await selectDate(context);
                    if (rec==null) return;
                    setState(() {
                      d2 = rec;
                      calcDiff();
                      prefs.setString(
                          "d2", DateFormat("yyyy-MM-dd").format(d2));
                    });
                  },
                  child: Text(
                    "Callibrate date",
                    style: kheroLogoText.copyWith(
                        fontSize: 20, color: Color(0xFF535050)),
                  ),
                ),
                SizedBox(height: 50),
                GestureDetector(
                  onTap: () {
                    prefs.setBool("periodBegun", true);
                  },
                  child: Container(
                    padding: EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: Color(0xFF1E7777),
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    ),
                    child: Text(
                      "My Period Has Begun",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            )),
          ),
        ],
        onChange: (index) => print(index),
      ),
    );
  }
}
// return Scaffold(
//       appBar: AppBar(
//         title: Text('Calendar Page'),
//         centerTitle: true,
//       ),
//       body: ContainedTabBarView(
//         tabs: [Text('M A I N'), Text('S E T T I N G S')],
//         tabBarProperties: TabBarProperties(
//             innerPadding: const EdgeInsets.symmetric(
//               horizontal: 32.0,
//               vertical: 8.0,
//             ),
//             indicator: ContainerTabIndicator(
//               radius: BorderRadius.circular(16.0),
//               color: Colors.blue,
//               borderWidth: 2.0,
//               borderColor: Colors.black,
//             ),
//             labelColor: Colors.white,
//             unselectedLabelColor: Colors.grey[400]),
//         views: [
//           Container(
//             margin: EdgeInsets.symmetric(horizontal: 16.0),
//             child: CalendarCarousel<Event>(
//               onDayPressed: (DateTime date, List<Event> events) {
//                 this.setState(() => _currentDate = date);
//               },
//               weekendTextStyle: TextStyle(
//                 color: Colors.red,
//               ),
//               thisMonthDayBorderColor: Colors.grey,
// //      weekDays: null, /// for pass null when you do not want to render weekDays
// //      headerText: Container( /// Example for rendering custom header
// //        child: Text('Custom Header'),
// //      ),
//               customDayBuilder: (
//                 /// you can provide your own build function to make custom day containers
//                 bool isSelectable,
//                 int index,
//                 bool isSelectedDay,
//                 bool isToday,
//                 bool isPrevMonthDay,
//                 TextStyle textStyle,
//                 bool isNextMonthDay,
//                 bool isThisMonthDay,
//                 DateTime day,
//               ) {
//                 /// If you return null, [CalendarCarousel] will build container for current [day] with default function.
//                 /// This way you can build custom containers for specific days only, leaving rest as default.

//                 // Example: every 15th of month, we have a flight, we can place an icon in the container like that:
//                 if (day.day == _currentDate) {
//                   return Center(
//                     child: Icon(Icons.local_airport),
//                   );
//                 } else {
//                   return null;
//                 }
//               },
//               weekFormat: false,
//               // markedDatesMap: _markedDateMap,
//               height: 420.0,
//               // selectedDateTime: _currentDate,
//               daysHaveCircularBorder: true,

//               /// null for not rendering any border, true for circular border, false for rectangular border
//             ),
//           ),
//           Container(color: Colors.green),
//         ],
//         onChange: (index) => print(index),
//       ),
//     );
