import 'package:Sloc/Login.dart';
import 'package:Sloc/SplashScreem.dart';
import 'package:Sloc/TelaBuscarVendedor.dart';
import 'package:Sloc/TelaRotasPorVendedor.dart';
import 'package:Sloc/TelaVistasPorRotas.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'IndexGerente.dart';
import 'IndexVendedor.dart';
import 'TelaCadastroGerente.dart';
import 'TelaCadastroVendedor.dart';
import 'TelaRelatorioDeVendedores.dart';

void main() {
  runApp(MaterialApp(
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate
      ],
      supportedLocales: [const Locale('pt', 'BR')],
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
        "/BuscarVendedor": (context) => TelaBuscarVendedor(),
        "/TelaDeRelatorioDeVendedores": (context) => TelaDeRelatorioDeVendedores(),
        "/RotasPorVendedor": (context) => TelaDeRotasPorVendedor(),
        "/VisitasPorRotas": (context) => TelaVisitasPorRota(),
      }));
}
