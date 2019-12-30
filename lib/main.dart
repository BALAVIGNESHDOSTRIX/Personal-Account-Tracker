import 'package:flutter/material.dart';
import 'root_splash.dart';

void main() {
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new MyHomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State createState() => new MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {

  @override
  void initState() {
    super.initState();
  }

   @override
  Widget build(BuildContext context){
    return Scaffold(
      body: new SplashScreen(),
    );
  }
}