import 'dart:async';
import 'package:flutter/material.dart';
import 'Index.dart';

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
          child: Image.asset("imagens/logoBranco.png"),
        ),
      ),
    );
  }
}
