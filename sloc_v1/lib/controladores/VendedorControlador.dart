import 'dart:convert';
import 'package:Sloc/entidades/vendedor.dart';
import 'package:http/http.dart' as http;

class VendedorControlador {
  Future<List> listarTodos() async {
    //faz consulta web
    var resposta =
        await http.get("https://servidorsloc.herokuapp.com/vendedores");
    //captura o json da resposta http
    List resultado = json.decode(resposta.body);
    //retorna a lista de vendedores
    return transformarJsonEmVendedores(resultado);
  }

  List transformarJsonEmVendedores(List json) {
    List vendedores = [];
    //varre a lista json convertendo os objetos para Gerente
    for (int i = 0; i < json.length; i++) {
      Vendedor v = new Vendedor.fromMap(json[i]);
      vendedores.add(v);
    }
    return vendedores;
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
    intermediario["gerente"] = {"id": vendedor.idGetente};
    var v = json.encode(intermediario);
    //faz consulta web
    var resposta = await http.post(
        "https://servidorsloc.herokuapp.com/vendedores",
        headers: {"Content-Type": "application/json"},
        body: v);

    return resposta.statusCode;
  }

  Future alterar(Vendedor vendedor) async {
    //converte vendedor para json
    var v = json.encode(vendedor.toMap());
    //faz consulta web
    var resposta = await http.put(
        "https://servidorsloc.herokuapp.com/vendedores",
        headers: {"Content-Type": "application/json"},
        body: v);

    return resposta.statusCode;
  }

  Future deletar(int idVendedor) async {
    var v = json.encode(idVendedor);
    //faz consulta web
    var client = http.Client();
    var resposta = await client.send(http.Request(
        "DELETE", Uri.parse("https://servidorsloc.herokuapp.com/vendedores"))
      ..headers["Content-Type"] = "application/json"
      ..body = v);

    return resposta;
  }
}
