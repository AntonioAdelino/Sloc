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
    Timer(Duration(seconds: 3), () {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (_) => TelaPrincipal()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Color(0xff315a7d),
        padding: EdgeInsets.all(100),
        child: Center(
          child: Image.asset("imagens/logoBranco.png"),
        ),
      ),
    );
  }
}
