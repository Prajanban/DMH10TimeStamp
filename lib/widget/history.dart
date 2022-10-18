import 'dart:convert';
import 'dart:io';
import 'package:dhm10_tm/main.dart';
import 'package:dhm10_tm/model/timehis.dart';
import 'package:dhm10_tm/widget/checkin.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../screen/myservice.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  List<TimeHis> TimeList = [];
  @override
  String Uid = '..';
  void initState() {
    // TODO: implement initState
    super.initState();
    // print("refresh data");
    setState(() {
      // Getname();
      fetchData();
    });
  }

  Future<void> Getname() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var status = prefs.getBool('isLoggedIn') ?? false;
    // if (status == true) {
    //   setState(() {
    Uid = prefs.getString('Uid') ?? "";
    // });
    // }
  }

  Future fetchData() async {
    // Getname();
    var urldat =
        Uri.parse("http://it.eng.ubu.ac.th/online/api/timehis_api.php");
    var myReq = {};
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Uid = prefs.getString('Uid') ?? "";
    myReq['user'] = Uid;
    String jsonReq = jsonEncode(myReq);
    // print("User id = $Uid");
    final response = await http.post(urldat,
        body: jsonReq,
        headers: {HttpHeaders.contentTypeHeader: 'application/json'});
    if (response.statusCode == 200) {
      final jsonStr = jsonDecode(response.body);
      // print(jsonStr);
      setState(() {
        jsonStr.forEach((data) {
          final tmpDat = TimeHis.fromJson(data);
          TimeList.add(tmpDat);
          // print(tmpDat);
        });
      });
    } else if (response.statusCode == 400) {
      print("Fail Get data");
    } else {
      return const CircularProgressIndicator();
    }
  }

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
      backgroundColor: Colors.blue.shade50,
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'ประวัติการลงเวลา',
                  style: TextStyle(fontSize: 20),
                ),
              ],
            ),
            SizedBox(
              height: 5,
            ),
            Container(
                height: MediaQuery.of(context).size.height - 300,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListView.builder(
                    itemCount: TimeList.length,
                    itemBuilder: (context, index) => Card(
                      child: ListTile(
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              TimeList[index].Day_post,
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              'เข้า',
                              style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              TimeList[index].In_time,
                              style: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              'ออก',
                              style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              TimeList[index].Out_time,
                              style: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        subtitle: Text(
                          TimeList[index].Comment,
                          style: TextStyle(
                              fontSize: 14, overflow: TextOverflow.ellipsis),
                        ),
                      ),
                    ),
                  ),
                )),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return ServicePage();
          }));
          // ServicePage();
        },
        tooltip: 'กลับ',
        child: const Icon(Icons.home),
        splashColor: Colors.orange.shade50,
        hoverColor: Colors.orange,
      ),
    );
  }
}
