import 'dart:convert';

import 'package:Sloc/entidades/gerente.dart';
import 'package:http/http.dart' as http;

class GerenteControlador {
  String url = "http://192.168.0.113:8080/gerentes";

  Future<List> listarTodos() async {
    //faz consulta web
    var resposta = await http.get(url);
    //captura o json da resposta http
    List resultado = json.decode(resposta.body);
    //retorna a lista de gerentes
    return transformarJsonEmGerentes(resultado);
  }

  List transformarJsonEmGerentes(List json) {
    List gerentes = [];
    //varre a lista json convertendo os objetos para Gerente
    for (int i = 0; i < json.length; i++) {
      Gerente g = new Gerente.fromMap(json[i]);
      gerentes.add(g);
    }
    return gerentes;
  }

  Future<List> buscarGerente(String nome) async {
    List<dynamic> gerentes = await listarTodos();
    List<Gerente> resultado = [];
    for (int i = 0; i < gerentes.length; i++) {
      if (gerentes[i].nome.contains(nome)) {
        resultado.add(gerentes[i]);
      }
    }

    return resultado;
  }

  Future adicionar(Gerente gerente) async {
    //converte gerente para json
    var g = json.encode(gerente.toMap());
    //faz consulta web
    var resposta = await http.post(url,
        headers: {"Content-Type": "application/json"}, body: g);

    return resposta.statusCode;
  }

  Future alterar(Gerente gerente) async {
    //converte gerente para json
    var g = json.encode(gerente.toMap());
    //faz consulta web
    var resposta = await http.put(url,
        headers: {"Content-Type": "application/json"}, body: g);

    return resposta.statusCode;
  }

  Future deletar(int idGerente) async {
    var g = json.encode(idGerente);
    //faz consulta web
    var client = http.Client();
    var resposta = await client.send(http.Request("DELETE", Uri.parse(url))
      ..headers["Content-Type"] = "application/json"
      ..body = g);
    return resposta;
  }
}
