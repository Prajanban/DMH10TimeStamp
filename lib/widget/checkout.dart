import 'package:date_format/date_format.dart';
import 'package:dhm10_tm/screen/myservice.dart';
import 'package:dhm10_tm/widget/history.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';

import 'package:slide_digital_clock/slide_digital_clock.dart';

class CheckOutpage extends StatefulWidget {
  const CheckOutpage({super.key});

  @override
  State<CheckOutpage> createState() => _CheckOutpageState();
}

class _CheckOutpageState extends State<CheckOutpage> {
  final String Day_Txt = formatDate(
      DateTime.now(), [yyyy, '-', mm, '-', dd, ' ', HH, ':', nn, ':', ss]);
  final String Day_post = formatDate(DateTime.now(), [yyyy, '-', mm, '-', dd]);
  final String Time_post = formatDate(DateTime.now(), [HH, ':', nn, ':', ss]);

  String Uid = '..';
  void initState() {
    // TODO: implement initState
    super.initState();

    Getname();
  }

  Future<void> Getname() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var status = prefs.getBool('isLoggedIn') ?? false;
    if (status == true) {
      setState(() {
        Uid = prefs.getString('Uid') ?? "";
      });
    }
  }

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

  Future<void> ChkOut() async {
    var url = Uri.parse('http://it.eng.ubu.ac.th/online/api/chkout_api.php');
    var myReq = {};
    myReq['user'] = Uid;
    myReq['Day_post'] = Day_post;
    myReq['Time_post'] = Time_post;
    myReq['Comment_post'] = '-';
    myReq['Chkout_type'] = 'OUT_';
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
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Image.asset('assets/images/p03vnft4.jpg'),
          SizedBox(
            height: 60,
          ),
          Text(
            "เวลาปัจจุบัน",
            style: TextStyle(fontSize: 30, color: Colors.deepOrangeAccent),
          ),
          SizedBox(
            height: 10,
          ),
          DigitalClock(
            // is24HourTimeFormat: true,
            digitAnimationStyle: Curves.easeOutExpo,
            areaDecoration: BoxDecoration(
              color: Colors.orange,
            ),
            hourMinuteDigitTextStyle: TextStyle(
              color: Colors.black,
              fontSize: 50,
            ),
          ),
          SizedBox(
            height: 5,
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
                    'ลงเวลากลับ',
                    style: TextStyle(fontSize: 20),
                  ),
                  onPressed: () {
                    update_time();
                    ChkOut();
                  },
                )),
          ),
        ],
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
