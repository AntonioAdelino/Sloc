import 'dart:convert';

import 'package:Sloc/controladores/ProfissionalControlador.dart';
import 'package:Sloc/entidades/gerente.dart';
import 'package:Sloc/entidades/profissional.dart';
import 'package:Sloc/entidades/vendedor.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class RotaControlador {
  String url = "http://192.168.0.113:8080/rotas";

  void salvarRotaGerente(Gerente gerente, List profissionais) async {
    String data = gerarDataAtual();
    List profissionaisMapeados = await gerarMaps(profissionais);
    var requisicao = '{ "data" : "' +
        data +
        '", "gerente" : { "id": ' +
        gerente.id.toString() +
        '}, "vendedor" : null,' +
        ' "profissionais" : ' +
        profissionaisMapeados.toString() +
        ' }';
    await fazerRequisicaoHttp(requisicao);
  }

  salvarRotaVendedor(Vendedor vendedor, List profissionais) async {
    String data = gerarDataAtual();
    List profissionaisMapeados = await gerarMaps(profissionais);
    var requisicao = '{ "data" : "' +
        data +
        '", "gerente" : { "id": ' +
        vendedor.gerente.toString() +
        '}, "vendedor" : { "id": ' +
        vendedor.id.toString() +
        '}, "profissionais" : ' +
        profissionaisMapeados.toString() +
        ' }';
    return await fazerRequisicaoHttp(requisicao);
  }

  Future<void> fazerRequisicaoHttp(String requisicao) async {
    var resposta = await http.post(url,
        headers: {"Content-Type": "application/json"}, body: requisicao);
    var body = json.decode(resposta.body);
    return body["id"];
  }

  gerarDataAtual() {
    DateTime dataAgora = new DateTime.now();
    String dataFormatada = DateFormat('dd/MM/yyyy kk:mm').format(dataAgora);
    return dataFormatada;
  }

  Future<List> gerarMaps(profissionais) async {
    List map = [];
    for (int i = 0; i < profissionais.length; i++) {
      var id = '{ "id" : ' + profissionais[i].id.toString() + ' }';
      map.add(id);
    }
    return map;
  }

  Future<String> salvarProfissional(Profissional profissional) async {
    ProfissionalControlador pc = new ProfissionalControlador();
    return await pc.adicionar(profissional);
  }

  quantidadePorVendedor(int vendedor) async {
    var v = json.encode(vendedor);
    //faz consulta web
    var client = http.Client();
    var resposta = await client.send(http.Request(
        "POST", Uri.parse(url+"/quantidade-por-vendedor"))
      ..headers["Content-Type"] = "application/json"
      ..body = v);

    //captura o json da resposta http
    return await resposta.stream.bytesToString();
  }

  profissionaisPorVendedor(int vendedor) async {
    var v = json.encode(vendedor);
    //faz consulta web
    var client = http.Client();
    var resposta = await client.send(http.Request(
        "POST", Uri.parse(url+"/quantidade-profissionais-por-vendedor"))
      ..headers["Content-Type"] = "application/json"
      ..body = v);

    //captura o json da resposta http
    return await resposta.stream.bytesToString();
  }

  listarPorVendedor(int vendedor) async {
    var v = json.encode(vendedor);
    //faz consulta web
    var client = http.Client();
    var resposta = await client.send(http.Request(
        "POST", Uri.parse(url+"/por-vendedor"))
      ..headers["Content-Type"] = "application/json"
      ..body = v);

    //captura o json da resposta http
    List resultado = json.decode(await resposta.stream.bytesToString());
    return transformarJsonEmLista(resultado);
  }

  transformarJsonEmLista(List json){
    List rotas = [];
    //varre a lista json convertendo os objetos
    for (int i = 0; i < json.length; i++) {
      var id = json[i]["id"];
      var data = json[i]["data"];
      rotas.add([id, data]);
    }
    return rotas;
  }
}
