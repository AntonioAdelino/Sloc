import 'package:Sloc/entidades/profissional.dart';

class Visita {
  //atributos
  int _id;
  int _distanciaCheckin;
  int _rota;

  //construtores
  Visita(this._distanciaCheckin, this._rota);

  Visita.fromMap(Map map) {
    this._id = map["id"];
    this._distanciaCheckin = map["distanciaCheckin"];
    this._rota = map["rota"];
  }

  //método para mapear os atributos
  Map toMap() {
    Map<String, dynamic> map = {
      "distanciaCheckin": this._distanciaCheckin,
      "rota": this._rota,
    };

    if (this._id != null) {
      map["id"] = this._id;
    }
    return map;
  }

  int get rota => _rota;

  set rota(int value) {
    _rota = value;
  }

  int get distanciaCheckin => _distanciaCheckin;

  set distanciaCheckin(int value) {
    _distanciaCheckin = value;
  }

  int get id => _id;

  set id(int value) {
    _id = value;
  }
}
