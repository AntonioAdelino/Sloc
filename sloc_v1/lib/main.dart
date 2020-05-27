import 'package:Sloc/SplashScreem.dart';
import 'package:flutter/material.dart';
import 'package:Sloc/Index.dart';
import 'package:Sloc/Login.dart';

void main() {
  runApp(MaterialApp(
    home: SplashScreem(),
    theme: ThemeData(
        primaryColor: Color(0xff315a7d), accentColor: Color(0xff3d719c)),
  ));
}
