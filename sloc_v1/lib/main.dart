import 'package:Sloc/SplashScreem.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    home: SplashScreem(),
    theme: ThemeData(
        primaryColor: Color(0xff1e2e3e), colorScheme: ColorScheme.fromSwatch().copyWith(secondary: Color(0xff25394e))),
  ));
}
