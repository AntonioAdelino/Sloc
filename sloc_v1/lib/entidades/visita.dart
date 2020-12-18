import 'package:Sloc/entidades/profissional.dart';

class Visita {
  //atributos
  int _id;
  int _idVendedor;
  int _idProfissional;
  String _data;
  int _distanciaCheckin;

  //construtores
  Visita(this._idVendedor, this._idProfissional, this._data,
      this._distanciaCheckin);

  Visita.fromMap(Map map) {
    this._id = map["id"];
    this._idVendedor = map["idVendedor"];
    this._idProfissional = map["idProfissional"];
    this._data = map["data"];
    this._distanciaCheckin = map["distanciaCheckin"];
  }

  //método para mapear os atributos
  Map toMap() {
    Map<String, dynamic> map = {
      "idVendedor": this._idVendedor,
      "idProfissional": this._idProfissional,
      "data": this._data,
      "distanciaCheckin": this._distanciaCheckin,
    };

    if (this._id != null) {
      map["id"] = this._id;
    }
    return map;
  }

  //getters
  int get id {
    return this._id;
  }

  int get idVendedor {
    return this._idVendedor;
  }

  int get idProfissional {
    return this._idProfissional;
  }

  String get data {
    return this._data;
  }

  int get distanciaCheckin {
    return this._distanciaCheckin;
  }

  //setters
  set id(int id) {
    this._id = id;
  }

  set idVendedor(int nome) {
    this._idVendedor = idVendedor;
  }

  set idProfissional(int cpf) {
    this._idProfissional = idProfissional;
  }

  set data(String data) {
    this._data = data;
  }

  set distanciaCheckin(int distanciaCheckin) {
    this._distanciaCheckin = distanciaCheckin;
  }
}
