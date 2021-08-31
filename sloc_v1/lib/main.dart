import 'package:Sloc/Login.dart';
import 'package:Sloc/SplashScreem.dart';
import 'package:flutter/material.dart';

import 'IndexGerente.dart';
import 'IndexVendedor.dart';
import 'TelaCadastroGerente.dart';
import 'TelaCadastroVendedor.dart';

void main() {
  runApp(MaterialApp(
      theme: ThemeData(
          primaryColor: Color(0xff1e2e3e),
          colorScheme:
              ColorScheme.fromSwatch().copyWith(secondary: Color(0xff25394e))),
      initialRoute: "/SpashScreen",
      routes: {
        "/SpashScreen": (context) => SplashScreem(),
        "/Login": (context) => Login(),
        "/IndexGerente": (context) => IndexGerente(),
        "/IndexVendedor": (context) => IndexVendedor(),
        "/CadastroGerente": (context) => TelaCadastroGerente(),
        "/CadastroVendedor": (context) => TelaCadastroVendedor(),
      }));
}
