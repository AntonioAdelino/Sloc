import 'dart:convert';

import 'package:http/http.dart' as http;

class VisitaControlador {
  String url = "http://192.168.0.113:8080/visitas";

  salvarVisita(int distancia, int idRota, idProfissional) async {

    var requisicao = '{ "distanciaCheckin" : "' + distancia.toString() +
        '", "rota" : { "id": ' + idRota.toString() + '},'
        '"profissional" : { "id": ' + idProfissional.toString() +'} }';
    return await fazerRequisicaoHttp(requisicao);
  }

  Future<void> fazerRequisicaoHttp(String requisicao) async {
    var resposta = await http.post(url,
        headers: {"Content-Type": "application/json"}, body: requisicao);
    var body = json.decode(resposta.body);
    return body["id"];
  }

  listarPorRota(int rota) async {
    var r = json.encode(rota);
    //faz consulta web
    var client = http.Client();
    var resposta = await client.send(http.Request(
        "POST", Uri.parse(url+"/por-rota"))
      ..headers["Content-Type"] = "application/json"
      ..body = r);

    //captura o json da resposta http
    List resultado = json.decode(await resposta.stream.bytesToString());
    return transformarJsonEmLista(resultado);
  }

  transformarJsonEmLista(List resultado){
    List rotas = [];
    //varre a lista json convertendo os objetos
    for (int i = 0; i < resultado.length; i++) {
      var nomeProfissional = resultado[i]["profissional"]["nome"];
      var enderecoProfissional = resultado[i]["profissional"]["endereco"];
      var contatoProfissional = resultado[i]["profissional"]["contato"];
      var distanciaCheckin = resultado[i]["distanciaCheckin"];
      if(contatoProfissional == null || contatoProfissional == ""){
        contatoProfissional = "Não há registros!";
      }
      rotas.add([nomeProfissional, distanciaCheckin, enderecoProfissional, contatoProfissional]);
    }
    return rotas;
  }
}
