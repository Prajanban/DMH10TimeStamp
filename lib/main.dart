import 'dart:convert';
import 'dart:ffi';

import 'package:dhm10_tm/screen/loginpage.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:splash_screen_view/SplashScreenView.dart';
import 'package:http/http.dart' as http;

void main() {
  GetLocaion();
  runApp(MyApp());
}

Future GetLocaion() async {
  var urldat =
      Uri.parse("http://it.eng.ubu.ac.th/online/api/getlocation_api.php");
  final response = await http.get(urldat);
  var res = jsonDecode(response.body);
  // print(res);
  if (response.statusCode == 200) {
    if (res['status'] == true) {
      var Lat = res['Lat'];
      var Lng = res['Lng'];
      var Radian = res['Radian'];
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setDouble("OffLat", double.parse(Lat));
      prefs.setDouble("OffLng", double.parse(Lng));
      prefs.setDouble("OffRadian", double.parse(Radian));
    }
  } else if (response.statusCode == 400) {
    // print("Fail Get data");
  } else {
    return const CircularProgressIndicator();
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Widget example1 = SplashScreenView(
      navigateRoute: MyHomePage(title: 'โปรแกรมลงเวลาปฏิบัติราชการ'),
      duration: 5000,
      imageSize: 130,
      imageSrc: "assets/images/clock1.png",
      text: "DMH-10 TIME STAMP ",
      textType: TextType.ColorizeAnimationText,
      textStyle: TextStyle(
        fontSize: 30.0,
      ),
      colors: [
        Colors.purple,
        Colors.blue,
        Colors.yellow,
        Colors.red,
      ],
      backgroundColor: Colors.white,
    );

    return MaterialApp(
      theme: ThemeData(primarySwatch: Colors.deepOrange),
      title: 'DMH-10 Time Stamp',
      home: example1,
    );
  }
}
// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter Demo',
//       theme: ThemeData(
//         primarySwatch: Colors.deepOrange,
//       ),
//       // home: const MyHomePage(title: 'โปรแกรมลงเวลาปฏิบัติราชการ'),
//       home: const splashScreen(),
//     );
//   }
// }
