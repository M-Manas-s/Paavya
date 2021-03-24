import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

import 'package:flutter/material.dart';
import 'package:naariAndroid/constants/locationclass.dart';
class Tapp extends StatefulWidget {
  @override
  _TappState createState() => _TappState();
}

class _TappState extends State<Tapp> {
  void getLocation() async{

    Locations location=Locations();
    await location.getnowLocation();

    print(location.long);
    print(location.lat);

//    var googlePlace = GooglePlace("");
// //    var result = await googlePlace.search.getNearBySearch(
// //        Location(lat: location.lat, lng: location.long), 1500,
// //        type: "hospital");
// // print(result.results);

    var url="https://maps.googleapis.com/maps/api/place/nearbysearch/json";
    var parameters={
      "key":"AIzaSyASx3MaOL6MKoKecTx7fcBh6hItOydoz0k",
      "location": '${location.lat},${location.long}',
      "radius":"800",
      "keyword": "hotel"
    };
    var urls =
    Uri.https("https://maps.googleapis.com","/maps/api/place/nearbysearch/json",parameters);
    var response=await http.get(urls);
    var jsonResponse = convert.jsonDecode(response.body);
    print(jsonResponse['results'].map<String>((result)=> result['name'].toString()).toList());

  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getLocation();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor:Color(0xFFEFEFEF),
        body: Container(
          child: Center(child: RaisedButton(onPressed: ()=>getLocation(), child: Text("Get Location"), )),
        ));
  }
}

