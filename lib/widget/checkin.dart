import 'dart:ffi';
import 'package:dhm10_tm/widget/outsidejob.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'package:slide_digital_clock/slide_digital_clock.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:date_format/date_format.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';

import '../screen/myservice.dart';

class CheckInpage extends StatefulWidget {
  const CheckInpage({super.key});

  @override
  State<CheckInpage> createState() => _CheckInpageState();
}

class _CheckInpageState extends State<CheckInpage> {
  // @override

  // กำหนดตัวแปรสำหรับใช้งาน

  final String Day_Txt = formatDate(
      DateTime.now(), [yyyy, '-', mm, '-', dd, ' ', HH, ':', nn, ':', ss]);
  final String Day_post = formatDate(DateTime.now(), [yyyy, '-', mm, '-', dd]);
  final String Time_post = formatDate(DateTime.now(), [HH, ':', nn, ':', ss]);
  Position? userLocation;
  bool? serviceEnabled;
  LocationPermission? permission;
  double OffLat = 0.00;
  double OffLng = 0.00;
  double R_x = 0.00;
  // static const double _defaultLat = 15.20160; //Home
  // static const double _defaultLng = 104.86085; //Hone
  // static const double _defaultLat = 15.12030; // UBU
  // static const double _defaultLng = 104.90555; // UBU
  // static const double _defaultLat = OffLat; //Home
  // static const double _defaultLng = OffLng; //Hone

  // static const CameraPosition _defaultLocation =
  //     CameraPosition(target: LatLng(_defaultLat, _defaultLng), zoom: 15);
  double distance = 0;
  String? dis_txt = '"Waiting..';
  GoogleMapController? mapController;
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

  Future<void> Chkin(String Comment_post, Chkintype) async {
    var url = Uri.parse('http://it.eng.ubu.ac.th/online/api/chkin_api.php');
    var myReq = {};
    myReq['user'] = Uid;
    myReq['Day_post'] = Day_post;
    myReq['Time_post'] = Time_post;
    myReq['Comment_post'] = Comment_post;
    myReq['Chkin_type'] = Chkintype;
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

  void _onMapCreate(GoogleMapController controller) {
    mapController = controller;
    // Getname();
  }

//สร้าง Mark ในแผนที่สำหรับ ที่ตั้งสำนักงาน
  List<Marker> _marker = [];

  // final List<Marker> _list = const [
  //   Marker(
  //       markerId: MarkerId('defaultLocation'),
  //       position: LatLng(_defaultLat, _defaultLng),
  //       icon: BitmapDescriptor.defaultMarker,
  //       infoWindow: InfoWindow(title: 'UBU Office', snippet: '5 Star Rating'))
  // ];

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
  @override
  String Uid = '..';
  void initState() {
    // TODO: implement initState
    super.initState();
    Getname();
    // _marker.addAll(_list);
  }

  Future<void> Getname() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var status = prefs.getBool('isLoggedIn') ?? false;
    if (status == true) {
      setState(() {
        Uid = prefs.getString('Uid') ?? "";
        OffLat = prefs.getDouble('OffLat') ?? 0.00;
        OffLng = prefs.getDouble('OffLng') ?? 0.00;
        R_x = prefs.getDouble('OffRadian') ?? 0.00;
        // List<Marker> _marker = [];
        final List<Marker> _list = [
          Marker(
              markerId: MarkerId('defaultLocation'),
              position: LatLng(OffLat, OffLng),
              icon: BitmapDescriptor.defaultMarker,
              infoWindow:
                  InfoWindow(title: 'UBU Office', snippet: '5 Star Rating'))
        ];
        _marker.addAll(_list);
      });
    }
  }

  double calculateDistance(double lat1, double lng1, double lat2, double lng2) {
    double distance = 0;

    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) * (1 - c((lng2 - lng1) * p)) / 2;
    distance = 12742 * asin(sqrt(a));

    return distance;
  }

  String TimeMark() {
    var Status = "none";
    setState(() {
      distance = calculateDistance(
          OffLat, OffLng, userLocation!.latitude, userLocation!.longitude);
      // print('distance =$distance');
      dis_txt = distance.toStringAsFixed(3);
      var area = (R_x / 1000);
      if (distance > area) {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text("Location Alert"),
                content: Text(
                    "ไม่สามารถลงเวลาได้ เนื่องจากท่านอยู่นอกรัศมีที่ตั้งสำนักงานเกิน $area เมตร"),
                actions: <Widget>[
                  ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text("Ok"))
                  // SizedBox(child: ,)
                ],
              );
            });
      } else {
        update_time();
        // print(Day_Txt);
        Status = "Ok";
      }
    });
    return Status;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text('Distance =$dis_txt Km'),
            Text('Date $Day_Txt'),
            Container(
                color: Colors.blue,
                height: 250,
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    child: FutureBuilder(
                      future: _getLocation(),
                      builder: (BuildContext context, AsyncSnapshot snapshot) {
                        if (snapshot.hasData) {
                          distance = calculateDistance(OffLat, OffLng,
                              userLocation!.latitude, userLocation!.longitude);
                          dis_txt = distance.toStringAsFixed(3);
                          // print('distance =$distance');
                          return GoogleMap(
                            compassEnabled: false,
                            mapToolbarEnabled: true,
                            tiltGesturesEnabled: false,
                            myLocationEnabled: true,
                            mapType: MapType.normal,
                            onMapCreated: _onMapCreate,
                            initialCameraPosition: CameraPosition(
                                target: LatLng(userLocation!.latitude,
                                    userLocation!.longitude),
                                zoom: 15),
                            markers: Set<Marker>.of(_marker),
                          );
                        } else {
                          return Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[CircularProgressIndicator()],
                            ),
                          );
                        }
                      },
                    ),
                  ),
                )),
            SizedBox(
              height: 20,
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
                  height: 60,
                  child: ElevatedButton(
                    child: Text(
                      'ลงเวลาปฏิบัติงาน',
                      style: TextStyle(fontSize: 20),
                    ),
                    onPressed: () {
                      var Status = TimeMark();
                      if (Status == 'Ok') {
                        Chkin('ปฏิบัติงานสำนักงาน', 'IN_');
                      }
                    },
                  )),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              '*หากลืมลงเวลา โปรดติดต่อเจ้าหน้าที่',
              style: TextStyle(
                  color: Colors.red.shade400,
                  fontSize: 15,
                  fontWeight: FontWeight.bold),
            )
          ],
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
    ));
  }
}
