class Rota {
  //atributos
  int _id;
  String _data;
  int _vendedor;
  List<int> _profissionais;

  //construtores
  Rota(this._data, this._vendedor, this._profissionais);

  Rota.fromMap(Map map) {
    this._id = map["id"];
    this._data = map["data"];
    this._vendedor = map["vendedor"];
    this._profissionais = map["profissionais"];
  }

  //método para mapear os atributos
  Map toMap() {
    Map<String, dynamic> map = {
      "data": this._data,
      "vendedor": this._vendedor,
      "profissionais": this._profissionais,
    };

    if (this._id != null) {
      map["id"] = this._id;
    }
    return map;
  }

  List<int> get profissionais => _profissionais;

  set profissionais(List<int> value) {
    _profissionais = value;
  }

  int get vendedor => _vendedor;

  set vendedor(int value) {
    _vendedor = value;
  }

  String get data => _data;

  set data(String value) {
    _data = value;
  }

  int get id => _id;

  set id(int value) {
    _id = value;
  }
}
