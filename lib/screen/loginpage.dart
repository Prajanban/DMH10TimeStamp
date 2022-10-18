import 'dart:convert';
import 'dart:io';
import 'package:dhm10_tm/screen/myservice.dart';
import 'package:form_validator/form_validator.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  final formkey = GlobalKey<FormState>();
  var username = TextEditingController();
  var password = TextEditingController();
  // late List<auser> Auser;
  late String U_name;
  late String Depart;
  @override
  void initState() {
    super.initState();
    checkLogin();
  }

  void checkLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var status = prefs.getBool('isLoggedIn') ?? false;
    String U_name = prefs.getString('U_name') ?? "";
    String Depart = prefs.getString('Depart') ?? "";
    // print(status);
    if (status == true) {
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        // return MapPage();
        return ServicePage();
      }));
    }

    // runApp(MaterialApp(home: status == true ? LoginScreen() : roomList()));
  }

// Login Function
  Future<void> login() async {
    // var url = Uri.parse('http://it.eng.ubu.ac.th/online/api/myapi.php');
    var url = Uri.parse('http://it.eng.ubu.ac.th/online/api/chkuser_api.php');
    var myReq = {};
    myReq['user'] = username.text;
    myReq['password'] = password.text;
    String jsonReq = jsonEncode(myReq);
    var response = await http.post(url,
        body: jsonReq,
        headers: {HttpHeaders.contentTypeHeader: 'application/json'});
    var res = jsonDecode(response.body);
    if (response.statusCode == 200) {
      // print(res);
      if (res['status'] == true) {
        // print("Login Success");
        // Auser.add(value)
        U_name = res['U_name'];
        Depart = res['Depart'];
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setBool("isLoggedIn", true);
        prefs.setString("U_name", U_name);
        prefs.setString("Depart", Depart);
        prefs.setString('Uid', username.text);
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) {
          // return MapPage();
          return ServicePage();
        }));
      } else {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text("Login Failed"),
                content: Text("โปรดตรวจสอบ User Password"),
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
      }
    } else {
      print("Error ok");
    }
  }

// End Login
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Container(
          child: Form(
              key: formkey,
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(50, 20, 50, 20),
                        child: Image.asset("assets/images/MPH.png"),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "กรมสุขภาพจิต",
                        style: TextStyle(fontSize: 28),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "ศูนย์สุขภาพจิตที่ ๑๐",
                        style: TextStyle(fontSize: 28),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        controller: username,
                        validator: ValidationBuilder().maxLength(50).build(),
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'User ID :',
                          contentPadding: EdgeInsets.all(8.0),
                          icon: Icon(Icons.person),
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      TextFormField(
                        controller: password,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "กรุณาป้อน Password";
                          }
                        },
                        obscureText: true,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'PASSWORD :',
                          contentPadding: EdgeInsets.all(8.0),
                          icon: Icon(Icons.vpn_key),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: SizedBox(
                          width: 200,
                          child: ElevatedButton(
                            child: Text(
                              "Sign in",
                              style: TextStyle(fontSize: 20),
                            ),
                            onPressed: () {
                              if (formkey.currentState!.validate()) {
                                login();
                              }
                              // print("user = ${username} password =${password}");
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ))),
    );
  }
}
