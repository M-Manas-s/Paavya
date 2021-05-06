import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:naariAndroid/class/notifications.dart';
import 'package:naariAndroid/constants/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'home_Screen_beta.dart';
import 'package:cloud_firestore/cloud_firestore.dart';



class SliverHome extends StatefulWidget {
  static String id = "Sliver";
  @override
  _SliverHomeState createState() => _SliverHomeState();
}

class _SliverHomeState extends State<SliverHome> {


  FirebaseAuth _auth = FirebaseAuth.instance;
  SharedPreferences prefs;

  Future<void> calculatePads() async {
    DateTime dt;
    int pads;
    int perday;
    var uid;

    FirebaseFirestore.instance
        .collection('Users').where("Email",
        isEqualTo: "${
            user.email
        }")
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
         String date = doc.data()['lastLogin'];
        if ( date!=null )
          dt = DateTime.parse(date);
        else
          dt = null;
         pads = doc['counter'];
         perday = doc.data()['perday'];
         uid = doc.id;
         if ( dt == null )
           updateLastLogin(DateTime.now(), uid);
         else if ( pads!=null && perday!=null )
         {
           if ( prefs.getBool('periodBegun') )
           {
             pads -= DateTime.now().difference(dt).inDays*perday;
             pads = pads<0?0:pads;
             print("New count : $pads");
             updateCount(pads, uid);
             if ( pads<5 )
               sendLowPadNotif();
           }
         }
         updateLastLogin(DateTime.now(), uid);
      });
    });
  }


  void getPrefs() async{
    prefs = await SharedPreferences.getInstance();
  }


  void gtUser() {
    final us = _auth.currentUser;

    if (us != null) {
      setState(() {
        user = us;
        print("User $user");
      });
      getPrefs();
      calculatePads();
    }
  }


  @override
  void initState() {
    super.initState();
    gtUser();
  }

  @override
  Widget build(BuildContext context) {
    Size query = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(

        body: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
                automaticallyImplyLeading: false,
                backgroundColor: Colors.transparent,
                pinned: false,
                expandedHeight: MediaQuery.of(context).size.height * 0.35,
                flexibleSpace: FlexibleSpaceBar(
                  background: Container(
                      margin: const EdgeInsets.only(bottom: 50),
                      height: query.height * 0.3,
                      decoration: infoContainer,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Hero(
                              tag: "Logo",

                              child: Image.asset("assets/images/NAARI1.png",scale: 1.5,)
                          ),
                          // Hero(
                          //   tag: "Logo",
                          //   child: Padding(
                          //     padding: const EdgeInsets.all(8.0),
                          //     child: Material(
                          //       color: Colors.transparent,
                          //       child: Text(
                          //         "Naari",
                          //         style: headingStyle.copyWith(fontSize: 40),
                          //         textAlign: TextAlign.center,
                          //       ),
                          //     ),
                          //   ),
                          // ),
                          FirebaseAuth.instance.currentUser.photoURL !=null ?
                          Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                  image: NetworkImage(FirebaseAuth.instance.currentUser.photoURL),
                                  fit: BoxFit.fill
                              ),
                            ),
                          )

                              :CircleAvatar(
                            radius: 35,
                            backgroundColor: Colors.white,
                            child: CircleAvatar(
                              radius: 30,
                              backgroundColor: Colors.transparent,
                              child: Icon(
                                Icons.person,
                                size: 60,
                                color: Color(0xFF004C4C),
                              ),
//                      backgroundImage: NetworkImage("https://i.pinimg.com/280x280_RS/40/e1/2a/40e12afed06fdeda86a4e0aba34137ad.jpg"),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "Hi ${user.displayName}",
                              style: TextStyle(
                                  color: Colors.white, fontSize: 26),
                            ),
                          ),
                          sizedbox,
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "HOME",
                              style: TextStyle(
                                  letterSpacing: 6, color: Colors.white),
                            ),
                          )
                        ],
                      )),
                )),
            SliverList(
                delegate: SliverChildListDelegate([

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
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context){
                            return navBar(pageid: 1,);
                          }));
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

                ]))
          ],
        ),
      ),
    );
  }
}





