import 'dart:convert';
import 'package:intl/intl.dart';

iniciarVisitas(profissionais, latUsuario, longUsuario) {
  String data = gerarDataAtual();
  List profissionaisMapeados = gerarMaps(profissionais);

  var jsonDados = '{ "data" : "' +
      data +
      '", "latitudeInicial" : "' +
      latUsuario.toString() +
      '" , "longitudeInicial" : "' +
      longUsuario.toString() +
      '", "proofissionais" : ' +
      profissionaisMapeados.toString() +
      ' }';

  var parsedJson = json.decode(jsonDados);
  print("\nJSON: ");
  print(parsedJson);
}

gerarDataAtual() {
  DateTime dataAgora = new DateTime.now();
  String dataFormatada = DateFormat('dd/MM/yyyy kk:mm').format(dataAgora);
  return dataFormatada;
}

gerarMaps(profissionais) {
  List map = [];
  for (int i = 0; i < profissionais.length; i++) {
    Map profissionalMapeado = profissionais[i].toMap();
    var profissionalJson = json.encode(profissionalMapeado);
    map.add(profissionalJson);
  }
  return map;
}
