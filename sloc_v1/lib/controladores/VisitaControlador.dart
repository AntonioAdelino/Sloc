import 'dart:convert';

import 'package:Sloc/controladores/ProfissionalControlador.dart';
import 'package:Sloc/entidades/gerente.dart';
import 'package:Sloc/entidades/profissional.dart';
import 'package:Sloc/entidades/rota.dart';
import 'package:Sloc/entidades/vendedor.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

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
}
