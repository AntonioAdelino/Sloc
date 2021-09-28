import 'dart:convert';

import 'package:Sloc/entidades/profissional.dart';
import 'package:http/http.dart' as http;

class ProfissionalControlador {
  // machados 10.0.0.192
  // garanhuns 192.168.0.113
  String url = "http://192.168.0.113:8080/profissionais";

  Future<List> listarTodos() async {
    //faz consulta web
    var resposta = await http.get(url);
    //captura o json da resposta http
    List resultado = json.decode(resposta.body);
    //retorna a lista de profissionais
    return transformarJsonEmProfissionais(resultado);
  }

  List transformarJsonEmProfissionais(List json) {
    List profissionais = [];
    //varre a lista json convertendo os objetos para Profissionais
    for (int i = 0; i < json.length; i++) {
      Profissional p = new Profissional.fromMap(json[i]);
      profissionais.add(p);
    }
    return profissionais;
  }

  Future<List> buscarProfissionais(String nome) async {
    List<dynamic> profissionais = await listarTodos();
    List<Profissional> resultado = [];
    for (int i = 0; i < profissionais.length; i++) {
      if (profissionais[i].nome.contains(nome)) {
        resultado.add(profissionais[i]);
      }
    }

    return resultado;
  }

  Future adicionar(Profissional profissional) async {
    //converte profissional para json
    var p = json.encode(profissional.toMap());
    //faz consulta web
    var resposta = await http.post(url,
        headers: {"Content-Type": "application/json"}, body: p);

    return resposta.body;
  }
}
