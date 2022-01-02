import 'package:naariAndroid/class/notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';

void calculateAverageAndResetNotif() async{
  double average;
  SharedPreferences prefs = await SharedPreferences.getInstance();
  int age = prefs.get("Age");
  double bmi = prefs.get('BMI');

  // TODO : Implement model and calc average

  prefs.setDouble("CycleLength", average);
  resetNotifs();
}