import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:naariAndroid/constants/Database.dart';
import 'package:naariAndroid/constants/constants.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../../main.dart';



class Main extends StatefulWidget {
  @override
  _MainState createState() => _MainState();
}

class _MainState extends State<Main> {

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  Future<void> notifs() async {
    flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');
    final InitializationSettings initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: (String payload) async {
          if (payload != null) {
            debugPrint('notification payload: $payload');
          }
          print(payload);
        });
  }

  Future<void> sendNotif() async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
    AndroidNotificationDetails(
        'Naari', 'Naari', 'Maari Android',
        importance: Importance.max,
        priority: Priority.high,
        showWhen: false);
    const NotificationDetails platformChannelSpecifics =
    NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
        0, 'Low Pad Count!', 'Less than 5 pads remaining!', platformChannelSpecifics,
        payload: 'item x');
  }

  @override
  void initState() {
    notifs();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor:Color(0xFFEFEFEF),
        body: Center(
          heightFactor: 3,
          child: _getTasks()
        ));
  }

  Widget _getTasks() {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('Users').where("Email", isEqualTo: "${user.email}").snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData) {
            var cont= snapshot.data.docs[0]["counter"];
            if ( cont<5 )
              {
                print("Alert");
                sendNotif();
              }
            return Container(
                child: Text(
                  "AVAILABLE\n$cont",
                  textAlign: TextAlign.center,
                  style: kheroLogoText.copyWith( fontSize: 50,color: Color(0xFF535050)),)
            );
          } else {
            return Container();
          }
        });
  }
}