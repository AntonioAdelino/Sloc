import 'dart:convert';

import 'package:Sloc/entidades/gerente.dart';
import 'package:Sloc/entidades/login.dart';
import 'package:Sloc/entidades/vendedor.dart';
import 'package:http/http.dart' as http;

class LoginControlador {
  Future<List> fazerLogin(String email, String senha) async {
    var login = Login(email, senha);
    var loginJson = json.encode(login.toMap());

    var gerenteRequest = await http.post(
        "http://192.168.0.113:8080/gerentes/login",
        headers: {"Content-Type": "application/json"},
        body: loginJson);

    var vendedorRequest = await http.post(
        "http://192.168.0.113:8080/vendedores/login",
        headers: {"Content-Type": "application/json"},
        body: loginJson);

    if (gerenteRequest.statusCode == 200) {
      Map gerenteMap = json.decode(gerenteRequest.body);
      return [new Gerente.fromMap(gerenteMap), 1];
    }

    if (vendedorRequest.statusCode == 200) {
      Map vendedorMap = json.decode(vendedorRequest.body);
      return [new Vendedor.fromMap(vendedorMap), 0];
    }
    return null;
  }
}
