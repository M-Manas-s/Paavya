import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:naariAndroid/constants/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

void resetNotifs(){
  cancelNotif();
  cycleBeginNotif();
}

Future<int> calculateFuturePads() async {
  int pads;
  int perday;

  await FirebaseFirestore.instance
      .collection('Users')
      .where("Email", isEqualTo: "${user.email}")
      .get()
      .then((QuerySnapshot querySnapshot) {
    querySnapshot.docs.forEach((doc) {
      pads = doc['counter'];
      perday = doc.data()['perday'];
    });
  });
  return (pads/perday).floor();
}

Future<void> cancelNotif() async {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');
  final InitializationSettings initializationSettings =
      InitializationSettings(android: initializationSettingsAndroid);
  await flutterLocalNotificationsPlugin.initialize(initializationSettings,
      onSelectNotification: (String payload) async {
    if (payload != null) {
      debugPrint('notification payload: $payload');
    }
    print(payload);
  });
  await flutterLocalNotificationsPlugin.cancelAll();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  if ( prefs.getBool("padReminder") ) sendFutureLowPadNotif();
}

Future<void> sendLowPadNotif() async {

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();
  const AndroidInitializationSettings initializationSettingsAndroid =
  AndroidInitializationSettings('@mipmap/ic_launcher');
  final InitializationSettings initializationSettings =
  InitializationSettings(android: initializationSettingsAndroid);
  await flutterLocalNotificationsPlugin.initialize(initializationSettings,
      onSelectNotification: (String payload) async {
        if (payload != null) {
          debugPrint('notification payload: $payload');
        }
        print(payload);
      });

  const AndroidNotificationDetails androidPlatformChannelSpecifics =
  AndroidNotificationDetails(
      'Naari', 'Naari', 'Naari Android',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: false);
  const NotificationDetails platformChannelSpecifics =
  NotificationDetails(android: androidPlatformChannelSpecifics);
  await flutterLocalNotificationsPlugin.show(
      0, 'Low Pad Count!', 'Less than 5 pads remaining!', platformChannelSpecifics,
      payload: 'item x');
}

Future<void> sendFutureLowPadNotif() async {
  int d = await calculateFuturePads();
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();
  const AndroidInitializationSettings initializationSettingsAndroid =
  AndroidInitializationSettings('@mipmap/ic_launcher');
  final InitializationSettings initializationSettings =
  InitializationSettings(android: initializationSettingsAndroid);
  await flutterLocalNotificationsPlugin.initialize(initializationSettings,
      onSelectNotification: (String payload) async {
        if (payload != null) {
          debugPrint('notification payload: $payload');
        }
        print(payload);
      });

  tz.initializeTimeZones();
  tz.setLocalLocation(tz.getLocation('Asia/Kolkata'));

  await flutterLocalNotificationsPlugin.zonedSchedule(
      0,
      'Low Pad Count!', 'Less than 5 pads remaining!',
      tz.TZDateTime.now(tz.local).add(Duration(days: d)),
      const NotificationDetails(
          android: AndroidNotificationDetails('your channel id',
              'your channel name', 'your channel description')),
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
      UILocalNotificationDateInterpretation.absoluteTime);
}

Future<void> cycleBeginNotif() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  DateTime d1 = DateTime.now();
  double cycleLen;

  String s1 = prefs.getString("d1") ?? "";
  cycleLen = prefs.getDouble("CycleLength");

  if (s1 == "") {
    d1 = DateTime.now();
    return;
  }
  d1 = DateTime.parse(s1);

  tz.initializeTimeZones();
  tz.setLocalLocation(tz.getLocation('Asia/Kolkata'));
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');
  final InitializationSettings initializationSettings =
      InitializationSettings(android: initializationSettingsAndroid);
  await flutterLocalNotificationsPlugin.initialize(initializationSettings,
      onSelectNotification: (String payload) async {
    if (payload != null) {
      debugPrint('notification payload: $payload');
    }
    print(payload);
  });

  await flutterLocalNotificationsPlugin.cancelAll();

  tz.TZDateTime scheduledDate =
      tz.TZDateTime(tz.local, d1.year, d1.month, d1.day, 8, 0);
  int beforeStart = prefs.getInt('periodRemDay');
  scheduledDate = scheduledDate.add(Duration(days: (cycleLen.round() - beforeStart - 2)));
 // print("Scheduled Date: ${scheduledDate.day}");

  await flutterLocalNotificationsPlugin.zonedSchedule(
      0,
      'Your cycle begins in ${(scheduledDate.add(Duration(days: beforeStart))).difference(tz.TZDateTime.now(tz.local)).inDays+1} days!',
      'Stock up some chocolates!',
      scheduledDate,
      const NotificationDetails(
          android: AndroidNotificationDetails('your channel id',
              'your channel name', 'your channel description')),
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
      UILocalNotificationDateInterpretation.absoluteTime);
}
