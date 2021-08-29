import 'dart:async';

import 'package:Sloc/Login.dart';
import 'package:flutter/material.dart';

class SplashScreem extends StatefulWidget {
  @override
  _SplashScreemState createState() => _SplashScreemState();
}

class _SplashScreemState extends State<SplashScreem> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    Timer(Duration(seconds: 2), () {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (_) => Login()));
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Color(0xff1e2e3e),
        padding: EdgeInsets.all(90),
        child: Center(
          child: Text(
            "Lembre-se de ativar a localização",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }
}
