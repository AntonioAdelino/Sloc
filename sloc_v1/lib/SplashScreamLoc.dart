import 'dart:async';
import 'package:flutter/material.dart';
import 'Index.dart';

class SplashScreemLoc extends StatefulWidget {
  @override
  _SplashScreemLocState createState() => _SplashScreemLocState();
}

class _SplashScreemLocState extends State<SplashScreemLoc> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    Timer(Duration(seconds: 1), () {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (_) => TelaPrincipal()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Color(0xff1e2e3e),
        padding: EdgeInsets.all(90),
        child: Center(
          child: Text(
            "Lembre-se de ativar a Loalização",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
        ),
      ),
    );
  }
}