class Profissional {
  //atributos
  int _id;
  String _idPlace;
  String _nome;
  String _endereco;
  String _contato;
  String _avaliacao;
  String _lat;
  String _long;

  //construtores
  Profissional(this._idPlace, this._nome, this._endereco, this._contato, this._avaliacao, this._lat, this._long);

  Profissional.fromMap(Map map){
    this._id = map["id"];
    this._idPlace = map["idPlace"];
    this._nome = map["nome"];
    this._endereco = map["endereco"];
    this._contato = map["contato"];
    this._avaliacao = map["avaliacao"];
    this._lat = map["lat"];
    this._long = map["long"];
  }

  //método para mapear os atributos
  Map toMap(){

    Map<String, dynamic> map= {
      "idPlace"   : this._idPlace,
      "nome"      : this._nome,
      "endereco"  : this._endereco,
      "contato"   : this._contato,
      "avaliacao" : this._avaliacao,
      "lat"       : this._lat,
      "long"      : this._long,

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
  String get lat{return this._lat;}
  String get long{return this._long;}

  //setters
  set id(int id){this._id = id;}
  set idPlace(String idPlace){this._idPlace = idPlace;}
  set nome(String nome){this._nome = nome;}
  set endereco(String endereco){this._endereco = endereco;}
  set contato(String contato){this._contato = contato;}
  set avaliacao(String avaliacao){this._avaliacao = avaliacao;}
  set lat(String lat){this._lat = lat;}
  set long(String long){this._long = long;}

}