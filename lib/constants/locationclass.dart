import 'package:geolocator/geolocator.dart';

class Locations{
  double lat;
  double long;

  Future<void> getnowLocation() async{
    print("Inside current location");
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.low);
  print(position);
  lat=position.latitude;
  long= position.longitude;



  }
}