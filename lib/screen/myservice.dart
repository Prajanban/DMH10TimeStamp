import 'dart:io';

import 'package:dhm10_tm/main.dart';
import 'package:dhm10_tm/widget/checkin.dart';
import 'package:dhm10_tm/widget/checkout.dart';
import 'package:dhm10_tm/widget/history.dart';
import 'package:dhm10_tm/widget/mymenu.dart';
import 'package:dhm10_tm/widget/outsidejob.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ServicePage extends StatefulWidget {
  const ServicePage({super.key});

  @override
  State<ServicePage> createState() => _ServicePageState();
}

class _ServicePageState extends State<ServicePage> {
  String U_name = "..";
  String Depart = "..";
  Widget currentWidget = myMenu(); //HistoryPage();

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
        U_name = prefs.getString('U_name') ?? "";
        Depart = prefs.getString('Depart') ?? "";
      });

      print("Data from $U_name : $Depart");
    }
  }

  void logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool("isLoggedIn", false);
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
      return MyApp();
    }));
  }

  Widget ShowHistory() {
    return ListTile(
      leading: const Icon(Icons.access_time_filled),
      title: const Text('ดูรายการลงเวลาย้อนหลัง'),
      onTap: () {
        setState(() {
          currentWidget = HistoryPage();
        });
        Navigator.of(context).pop();
      },
    );
  }

  Widget ShowLogout() {
    return ListTile(
      leading: Icon(
        Icons.logout,
        color: Colors.redAccent,
      ),
      title: Text('ออกจากระบบ'),
      onTap: () {
        logout();
      },
    );
  }

  Widget ShowTm() {
    return ListTile(
      leading: Icon(
        Icons.access_time,
        color: Colors.blue,
      ),
      title: Text('ลงเวลาเข้า'),
      onTap: () {
        setState(() {
          currentWidget = CheckInpage();
        });
        Navigator.of(context).pop();
      },
    );
  }

  Widget ShowGojob() {
    return ListTile(
      leading: Icon(
        Icons.air,
        color: Colors.deepPurple,
      ),
      title: Text('ไปราชการ'),
      onTap: () {
        setState(() {
          currentWidget = OutSide();
        });
        Navigator.of(context).pop();
      },
    );
  }

  Widget ShowExt() {
    return ListTile(
      leading: const Icon(
        Icons.exit_to_app,
        color: Colors.red,
      ),
      title: const Text('ออกจากโปรแกรม'),
      onTap: () {
        if (Platform.isAndroid) {
          SystemNavigator.pop();
        } else {
          exit(0);
        }
      },
    );
  }

  Widget ShowTmOut() {
    return ListTile(
      leading: const Icon(
        Icons.home,
        color: Colors.green,
      ),
      title: const Text('ลงเวลาออก'),
      onTap: () {
        setState(() {
          currentWidget = CheckOutpage();
        });
        Navigator.of(context).pop();
      },
    );
  }

  Widget ShowDepart() {
    return Text('$Depart');
  }

  Widget ShowLogin() {
    // Getname();
    return Text('$U_name',
        style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold));
  }

  Widget ShowAppName() {
    return Text(
      'ระบบลงเวลา ศูนย์สุขภาพจิตที่ 10',
      style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
    );
  }

  Widget ShowLogo() {
    return CircleAvatar(
      radius: 30,
      backgroundColor: Colors.transparent,
      child: ClipOval(
        child: Image.asset('assets/images/cat.png'),
      ),
    );
  }

  Widget ShowHead() {
    return DrawerHeader(
      decoration: BoxDecoration(color: Theme.of(context).primaryColor),
      child: Column(
        children: <Widget>[
          ShowLogo(),
          SizedBox(
            height: 5,
          ),
          // ShowAppName(),
          SizedBox(
            height: 5,
          ),
          ShowLogin(),
          SizedBox(
            height: 5,
          ),
          ShowDepart(),
        ],
      ),
    );
  }

  Widget ShowDrawer() {
    return Drawer(
      child: ListView(children: <Widget>[
        ShowHead(),
        ShowTm(),
        ShowTmOut(),
        ShowGojob(),
        ShowHistory(),
        Divider(),
        ShowLogout(),
        ShowExt(),
      ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ระบบลงเวลา ศูนย์สุขภาพจิตที่ 10'),
      ),
      body: currentWidget,
      drawer: ShowDrawer(),
    );
  }
}
