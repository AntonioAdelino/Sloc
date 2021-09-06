import 'dart:convert';

import 'package:Sloc/dados/dbGerente.dart';
import 'package:Sloc/dados/dbVendedor.dart';
import 'package:Sloc/entidades/gerente.dart';
import 'package:Sloc/entidades/login.dart';
import 'package:Sloc/entidades/vendedor.dart';
import 'package:http/http.dart' as http;

class LoginControlador {
  Future<List> fazerLogin(String email, String senha) async {
    var login = Login(email, senha);
    var loginJson = json.encode(login.toMap());

    // garanhuns 192.168.0.113
    var gerenteRequest = await http.post(
        "http://10.0.0.192:8080/gerentes/login",
        headers: {"Content-Type": "application/json"},
        body: loginJson);

    var vendedorRequest = await http.post(
        "http://10.0.0.192:8080/vendedores/login",
        headers: {"Content-Type": "application/json"},
        body: loginJson);

    if (gerenteRequest.statusCode == 200) {
      Map gerenteMap = json.decode(gerenteRequest.body);
      Gerente gerente = new Gerente.fromMap(gerenteMap);
      DbGerente dbGerente = DbGerente();
      dbGerente.cadastrarGerente(gerente);
      return [gerente, 1];
    }

    if (vendedorRequest.statusCode == 200) {
      Map vendedorMap = json.decode(vendedorRequest.body);
      Vendedor vendedor = new Vendedor.fromMap(vendedorMap);
      //pega o Map do objeto gerente vindo da requisição
      var gerenteMap =
          json.decode(json.encode(vendedorMap)) as Map<String, dynamic>;
      //pega o id do gerente para dicionar ao objeto de vendedor
      var idGerente = gerenteMap["gerente"]["id"];

      vendedor.idGerente = idGerente;
      DbVendedor dbVendedor = DbVendedor();
      await dbVendedor.cadastrarVendedor(vendedor);
      return [vendedor, 0];
    }
    return null;
  }
}
