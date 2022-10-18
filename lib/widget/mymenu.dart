import 'dart:io';

import 'package:dhm10_tm/main.dart';
import 'package:dhm10_tm/widget/checkin.dart';
import 'package:dhm10_tm/widget/checkout.dart';
import 'package:dhm10_tm/widget/history.dart';
import 'package:dhm10_tm/widget/offday.dart';
import 'package:dhm10_tm/widget/outsidejob.dart';
import 'package:dhm10_tm/widget/wfh.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class myMenu extends StatefulWidget {
  const myMenu({super.key});

  @override
  State<myMenu> createState() => _myMenuState();
}

class _myMenuState extends State<myMenu> {
  void logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool("isLoggedIn", false);
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
      return MyApp();
    }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(),
      backgroundColor: Colors.blue.shade50,
      body: ListView(
        children: [
          SizedBox(
            height: 50.0,
          ),
          Padding(
            padding: EdgeInsets.only(left: 40),
            child: Row(
              children: [
                Text(
                  "Menu",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 25,
                      color: Colors.black),
                ),
                SizedBox(
                  width: 5.0,
                ),
                Text(
                  'ระบบลงเวลา',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Colors.grey.shade700),
                ),
                SizedBox(
                  width: 5.0,
                ),
                SizedBox(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      if (Platform.isAndroid) {
                        SystemNavigator.pop();
                      } else {
                        exit(0);
                      }
                    },
                    icon: Icon(Icons.logout),
                    label: Text('Exit'),
                    style: ElevatedButton.styleFrom(primary: Colors.pink),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 50,
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                SizedBox(
                  height: 150,
                  width: 150,
                  child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(primary: Colors.orange),
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => CheckInpage()));
                      },
                      icon: Icon(
                        Icons.lock_clock,
                        size: 60,
                      ),
                      label: Text("ลงเวลาปฏิบัติงานปกติ")),
                ),
                SizedBox(
                  height: 150,
                  width: 150,
                  child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(primary: Colors.blue),
                      onPressed: () {
                        Navigator.of(context).push(
                            MaterialPageRoute(builder: (context) => myWfh()));
                      },
                      icon: Icon(
                        Icons.timer,
                        size: 60,
                      ),
                      label: Text("ลงเวลาปฏิบัติงาน WFH")),
                )
              ],
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                SizedBox(
                  height: 150,
                  width: 150,
                  child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(primary: Colors.green),
                      onPressed: () {
                        Navigator.of(context).push(
                            MaterialPageRoute(builder: (context) => OutSide()));
                      },
                      icon: Icon(
                        Icons.add_location,
                        size: 60,
                      ),
                      label: Text("เดินทางไปราชการ")),
                ),
                SizedBox(
                  height: 150,
                  width: 150,
                  child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(primary: Colors.red),
                      onPressed: () {
                        Navigator.of(context).push(
                            MaterialPageRoute(builder: (context) => OffDay()));
                      },
                      icon: Icon(
                        Icons.home,
                        size: 60,
                      ),
                      label: Text("บันทึกการลา")),
                )
              ],
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                SizedBox(
                  height: 150,
                  width: 150,
                  child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(primary: Colors.purple),
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => CheckOutpage()));
                      },
                      icon: Icon(
                        Icons.home_filled,
                        size: 60,
                      ),
                      label: Text("ลงเวลากลับ")),
                ),
                SizedBox(
                  height: 150,
                  width: 150,
                  child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(primary: Colors.indigo),
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => HistoryPage()));
                      },
                      icon: Icon(
                        Icons.history,
                        size: 60,
                      ),
                      label: Text("ข้อมูลการลงเวลา")),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
