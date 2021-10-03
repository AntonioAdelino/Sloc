import 'dart:convert';
import 'package:Sloc/entidades/vendedor.dart';
import 'package:http/http.dart' as http;

class VendedorControlador {
  // 10.0.0.192 machados
  // 192.168.0.113 garanhuns
  String url = "http://192.168.0.113:8080/vendedores";

  Future<List> listarTodos() async {
    //faz consulta web
    var resposta =
        await http.get(url);
    //captura o json da resposta http
    List resultado = json.decode(resposta.body);
    //retorna a lista de vendedores
    return transformarJsonEmVendedores(resultado);
  }

  Future<List> listarPorGerente(int gerente) async {
    var g = json.encode(gerente);
    //faz consulta web
    var client = http.Client();
    var resposta = await client.send(http.Request(
        "POST", Uri.parse(url+"/por-gerente"))
      ..headers["Content-Type"] = "application/json"
      ..body = g);

    //captura o json da resposta http
    List resultado = json.decode(await resposta.stream.bytesToString());
    return transformarJsonEmVendedores(resultado);
  }

  List transformarJsonEmVendedores(List json) {
    List vendedores = [];
    //varre a lista json convertendo os objetos para Gerente
    for (int i = 0; i < json.length; i++) {
      var v = criarVendedor(json[i]);
      vendedores.add(v);
    }
    return vendedores;
  }

  Vendedor criarVendedor(Map vendedorMap){
    var gerenteMap =
    json.decode(json.encode(vendedorMap)) as Map<String, dynamic>;
    //pega o id do gerente para dicionar ao objeto de vendedor
    var gerente = gerenteMap["gerente"]["id"];
    vendedorMap["gerente"] = gerente;
    Vendedor vendedor = new Vendedor.fromMap(vendedorMap);

    vendedor.gerente = gerente;
    return vendedor;
  }

  Future<List> buscarVendedor(String nome) async {
    List<dynamic> vendedores = await listarTodos();
    List<Vendedor> resultado = [];
    for (int i = 0; i < vendedores.length; i++) {
      if (vendedores[i].nome.contains(nome)) {
        resultado.add(vendedores[i]);
      }
    }

    return resultado;
  }

  Future adicionar(Vendedor vendedor) async {
    //converte vendedor para json
    var intermediario = vendedor.toMap();
    intermediario["gerente"] = {"id": vendedor.gerente};
    var v = json.encode(intermediario);
    //faz consulta web
    var resposta = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: v);

    return resposta.statusCode;
  }

  Future alterar(Vendedor vendedor) async {
    //converte vendedor para json
    var v = json.encode(vendedor.toMap());
    //faz consulta web
    var resposta = await http.put(
        url,
        headers: {"Content-Type": "application/json"},
        body: v);

    return resposta.statusCode;
  }

  Future deletar(int idVendedor) async {
    var v = json.encode(idVendedor);
    //faz consulta web
    var client = http.Client();
    var resposta = await client.send(http.Request(
        "DELETE", Uri.parse(url))
      ..headers["Content-Type"] = "application/json"
      ..body = v);

    return resposta;
  }
}
