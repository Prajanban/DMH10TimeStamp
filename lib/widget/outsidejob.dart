import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:date_format/date_format.dart';
import 'package:dhm10_tm/screen/myservice.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:geolocator/geolocator.dart';

class OutSide extends StatefulWidget {
  const OutSide({super.key});

  @override
  State<OutSide> createState() => _OutSideState();
}

class _OutSideState extends State<OutSide> {
  Position? userLocation;
  bool? serviceEnabled;
  LocationPermission? permission;
  final formkey = GlobalKey<FormState>();
  var text1 = TextEditingController();
  String? Uid;
  final String Day_Txt = formatDate(
      DateTime.now(), [yyyy, '-', mm, '-', dd, ' ', HH, ':', nn, ':', ss]);
  final String Day_post = formatDate(DateTime.now(), [yyyy, '-', mm, '-', dd]);
  final String Time_post = formatDate(DateTime.now(), [HH, ':', nn, ':', ss]);
  // ดึงข้อมูล GPS จากอุปกรณ์
  Future<Position?> _getLocation() async {
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled!) {
      return Future.error('Location services are disabled');
    }
// ตรวจสอบสิทธิ การเข้าถึง GPS
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
// ดึงตำแหน่งจากปัจจุบัน GPS
    userLocation = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.bestForNavigation);
    return userLocation;
  }

// จบการดึง GPS

  void update_time() {
    setState(() {
      final String Day_Txt = formatDate(
          DateTime.now(), [yyyy, '-', mm, '-', dd, ' ', HH, ':', nn, ':', ss]);
      final String Day_post =
          formatDate(DateTime.now(), [yyyy, '-', mm, '-', dd]);
      final String Time_post =
          formatDate(DateTime.now(), [HH, ':', nn, ':', ss]);
    });
  }

  Future<void> Gojob() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Uid = prefs.getString('Uid') ?? "";
    var url = Uri.parse('http://it.eng.ubu.ac.th/online/api/chkin_api.php');
    var myReq = {};
    myReq['user'] = Uid;
    myReq['Day_post'] = Day_post;
    myReq['Time_post'] = Time_post;
    myReq['Comment_post'] = "ไปราชการ: ${text1.text}";
    myReq['Chkin_type'] = 'Outside';
    myReq['Lat'] = userLocation!.latitude;
    myReq['Lng'] = userLocation!.longitude;
    String jsonReq = jsonEncode(myReq);
    var response = await http.post(url,
        body: jsonReq,
        headers: {HttpHeaders.contentTypeHeader: 'application/json'});
    var res = jsonDecode(response.body);
    if (response.statusCode == 200) {
      // print(res);
      if (res['status'] == true) {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text("Chkeck in Ststus"),
                content: Text("บันทึกรายการเรียบร้อย"),
                actions: <Widget>[
                  ElevatedButton(
                      onPressed: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return ServicePage();
                        }));
                      },
                      child: Text("Ok"))
                  // SizedBox(child: ,)
                ],
              );
            });
      } else {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text("Check in Status"),
                content: Text("ไม่สามารถบันทึกซ้ำได้"),
                actions: <Widget>[
                  ElevatedButton(
                      onPressed: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return ServicePage();
                        }));
                      },
                      child: Text("Ok"))
                  // SizedBox(child: ,)
                ],
              );
            });
      }
    } else {
      print("Error ok");
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      _getLocation();
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Form(
          key: formkey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Image.asset('assets/images/go7.jpg'),
              SizedBox(
                height: 60,
              ),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(30, 5, 30, 5),
                child: Container(
                  color: Colors.blue,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        'ระบุรายละเอียดการไปราชการ',
                        style: TextStyle(fontSize: 20),
                      ),
                      Container(
                        color: Colors.orange.shade50,
                        child: SizedBox(
                          height: 200,
                          child: TextField(
                            expands: true,
                            maxLines: null,
                            controller: text1,
                            keyboardType: TextInputType.text,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(30, 5, 30, 5),
                child: SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Colors.red,
                      ),
                      child: Text(
                        'บันทึกไปไปราชการ',
                        style: TextStyle(fontSize: 20),
                      ),
                      onPressed: () {
                        if (formkey.currentState!.validate()) {
                          update_time();
                          Gojob();
                        }
                      },
                    )),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return ServicePage();
          }));
        },
        tooltip: 'Home',
        child: const Icon(Icons.home),
      ),
    );
  }
}
