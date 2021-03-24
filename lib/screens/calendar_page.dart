import 'package:contained_tab_bar_view/contained_tab_bar_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart'
    show CalendarCarousel;
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart';
import 'package:naariAndroid/constants/constants.dart';

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
        tabs: [Text('MAIN'), Text('SETTING')],
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
            height: 10,
            decoration: BoxDecoration(
              color: Color(0xFF006666),
              borderRadius: BorderRadius.circular(40),
            ),
            padding: EdgeInsets.all(10),
            margin: EdgeInsets.symmetric(horizontal: 16.0),
            child: CalendarCarousel<Event>(
              onDayPressed: (DateTime date, List<Event> events) {
                this.setState(() => _currentDate = date);
              },
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
              ) {
                /// If you return null, [CalendarCarousel] will build container for current [day] with default function.
                /// This way you can build custom containers for specific days only, leaving rest as default.

                // Example: every 15th of month, we have a flight, we can place an icon in the container like that:
                if (day.day == _currentDate) {
                  return Center(
                    child: Icon(Icons.local_airport),
                  );
                } else {
                  return null;
                }
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
            color: Color(0xFFEFEFEF),
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
