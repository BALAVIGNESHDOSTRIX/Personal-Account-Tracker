import 'dart:async';
import 'package:flutter/material.dart';
import 'root.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => new _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  startTime() async {
    var _duration = new Duration(seconds: 4);
    return new Timer(_duration, navigationPage);
  }

  void navigationPage() {
  Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context)=> new RootPage()));
  }

  @override
  void initState() {
    super.initState();
    startTime();
  }

   @override
  Widget build(BuildContext context) {
  return new Scaffold(
    appBar: new AppBar(
      title: new Text('Personal Account Tracker'),
      backgroundColor: Color.fromRGBO(107, 99, 255, 1),
    ),
    body: new Center(
      child: new Image.asset('assets/logo.png', width: 130.0, height: 130.0)
    ),
  );
  }
}