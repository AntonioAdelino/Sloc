class Profissional {
  //atributos
  int _id;
  String _idPlace;
  String _nome;
  String _endereco;
  String _contato;
  String _avaliacao;
  String _latitude;
  String _longitude;

  //construtores
  Profissional(this._idPlace, this._nome, this._endereco, this._contato, this._avaliacao, this._latitude, this._longitude);

  Profissional.fromMap(Map map){
    this._id = map["id"];
    this._idPlace = map["idPlace"];
    this._nome = map["nome"];
    this._endereco = map["endereco"];
    this._contato = map["contato"];
    this._avaliacao = map["avaliacao"];
    this._latitude = map["latitude"];
    this._longitude = map["longitude"];
  }

  //método para mapear os atributos
  Map toMap(){

    Map<String, dynamic> map= {
      "idPlace"   : this._idPlace,
      "nome"      : this._nome,
      "endereco"  : this._endereco,
      "contato"   : this._contato,
      "avaliacao" : this._avaliacao,
      "latitude"       : this._latitude,
      "longitude"      : this._longitude,

    };
    if(this.id != null){
      map["id"] = this._id;
    }
    return map;
  }

  //getters
  int get id{return this._id;}
  String get idPlace{return this._idPlace;}
  String get nome{return this._nome;}
  String get endereco{return this._endereco;}
  String get contato{return this._contato;}
  String get avaliacao{return this._avaliacao;}
  String get latitude{return this._latitude;}
  String get longitude{return this._longitude;}

  //setters
  set id(int id){this._id = id;}
  set idPlace(String idPlace){this._idPlace = idPlace;}
  set nome(String nome){this._nome = nome;}
  set endereco(String endereco){this._endereco = endereco;}
  set contato(String contato){this._contato = contato;}
  set avaliacao(String avaliacao){this._avaliacao = avaliacao;}
  set latitude(String lat){this._latitude = lat;}
  set longitude(String long){this._longitude = long;}

}