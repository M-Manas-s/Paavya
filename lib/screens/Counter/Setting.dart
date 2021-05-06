import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:naariAndroid/constants/constants.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';
import 'package:stepper_counter_swipe/stepper_counter_swipe.dart';
import '../../constants/constants.dart';
import '../../main.dart';

class setting extends StatefulWidget {
  @override
  _settingState createState() => _settingState();
}

class _settingState extends State<setting> {
  int stepvalue;
  int padperday=0;

  selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: selectedDate, // Refer step 1
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
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
      });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: Color(0xFFEFEFEF), body: _getTasks());
  }

  Widget _getTasks() {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('Users')
            .where("Email",
                isEqualTo: "${
                    user.email
                   }")
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {

          if (snapshot.hasData) {

            stepvalue = snapshot.data.docs[0]["perday"].toInt();

            return Padding(
              padding: const EdgeInsets.only(top:20,bottom:80),
              child: ListView(

                children: [
                  Padding(
                    padding: const EdgeInsets.all(11.0),
                    child: Center(
                        child: RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        text: "SET COUNT",
                        style: kheroLogoText.copyWith(
                          decoration: TextDecoration.underline,
                            fontSize: 35, color: Color(0xFF535050)),
                      ),
                    )),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.05,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(11.0),
                    child: SleekCircularSlider(
                      appearance: CircularSliderAppearance(
                          size: MediaQuery.of(context).size.height * 0.3,
                          infoProperties: InfoProperties(
                            modifier: (double value) {
                              final roundedValue =
                                  value.floor().toInt().toString();
                              return '$roundedValue';
                            },
                          ),
                          customWidths: CustomSliderWidths(
                              handlerSize: 25, progressBarWidth: 10),
                          customColors: CustomSliderColors(
                            dotColor: Color(0xFF006666),
                            trackColor: Colors.red,
                            progressBarColors: [
                              Color(0xFF008079),
                              Color(0xFF004D4B)
                            ],
                          )),
                      min: 0,
                      max: 30,
                      initialValue: snapshot.data.docs[0]["counter"].toDouble(),
                      onChange: (double value) {
                        final roundedValue = value.floor().toInt();
                        setState(() {
                          counter = roundedValue.toDouble().toInt();
                          print(counter);
                          updateCount(counter, snapshot.data.docs[0].id);
                        });
                      },
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(11.0),
                    child: Center(
                      child: Text(
                        'Pad Usage Per Day',
                        style: kheroLogoText.copyWith(
                            decoration: TextDecoration.underline,fontWeight: FontWeight.bold,
                            fontSize: 30, color: Color(0xFF535050)),
                      ),
                    ),
                  ),
                  Center(
                    child: Container(
                      padding: const EdgeInsets.all(8.0),
                      child: StepperSwipe(
                        withFastCount: true,
                        withPlusMinus: true,
                        iconsColor: Colors.red,
                        stepperValue: stepvalue,
                        initialValue: snapshot.data.docs[0]["perday"].toInt(),
                        speedTransitionLimitCount:
                            3, //Trigger count for fast counting
                        onChanged: (int value) {
                            setState(() {
                              stepvalue = value;

                              updatePerDayUsage(stepvalue, snapshot.data.docs[0].id);
                            });

                        },
                        firstIncrementDuration: Duration(
                            milliseconds: 100), //Unit time before fast counting
                        secondIncrementDuration: Duration(
                            milliseconds: 100), //Unit time during fast counting
                        direction: Axis.horizontal,
                        dragButtonColor: Color(0xFF008079),
                        maxValue: 30,
                        minValue: 0,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Text("*Slide the number to either side to increase or decrease the count",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 13, color: Color(0xFF535050)
                    ),),
                  ),
                  SizedBox(height:10),
                  Center(
                    child: Padding(
                        padding: const EdgeInsets.all(11.0),
                        child: RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                              text: "${formatter.format(selectedDate)}"
                                  .split(' ')[0],
                              style: kheroLogoText.copyWith(
                                  fontSize: 25, color: Color(0xFF535050)),
                              children: <TextSpan>[
                                TextSpan(
                                    text:
                                        "\n${DateFormat('EEEE').format(selectedDate)}",
                                    style: kheroLogoText.copyWith(
                                        fontSize: 20, color: Color(0xFF535050)))
                              ]),
                        )),
                  ),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(11.0),
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.6,
                        child: ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  Color(0xFFEFEFEF)),
                              shape:
                                  MaterialStateProperty.all<RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18.0),
                                side: BorderSide(color: Colors.red, width: 2),
                              ))),
                          onPressed: () => selectDate(context), // Refer step 3
                          child: Text(
                            'Set Purchase Date',
                            style: kheroLogoText.copyWith(
                                fontSize: 14, color: Color(0xFF535050)),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          } else {
            return Container(child: Text("Please connect to the Internet",
            style: kheroLogoText.copyWith(
              fontSize: 24, color: Color(0xFF535050)),
            ));
          }
        });
  }
}
