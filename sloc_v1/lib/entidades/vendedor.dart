class Vendedor {
  //atributos
  int _id;
  String _nome;
  String _cpf;
  String _email;
  String _senha;
  int _idGerente;

  //construtores
  Vendedor(this._nome, this._cpf, this._email, this._senha);

  Vendedor.fromMap(Map map){
    this._id = map["id"];
    this._nome = map["nome"];
    this._cpf = map["cpf"];
    this._email = map["email"];
    this._senha = map["senha"];
    this._idGerente = map["idGerente"];
  }

  //método para mapear os atributos
  Map toMap(){

    Map<String, dynamic> map= {

      "nome"      : this._nome,
      "cpf"       : this._cpf,
      "email"     : this._email,
      "senha"     : this._senha,
      "gerente"   : this._idGerente,

    };

    if(this._id != null){
      map["id"] = this._id;
    }
    return map;
  }

  //getters
  int get id{return this._id;}
  String get nome{return this._nome;}
  String get cpf{return this._cpf;}
  String get email{return this._email;}
  String get senha{return this._senha;}
  int get idGetente{return this._idGerente;}

  //setters
  set id(int id){this._id = id;}
  set nome(String nome){this._nome = nome;}
  set cpf(String cpf){this._cpf = cpf;}
  set email(String email){this._email = email;}
  set senha(String senha){this._senha = senha;}
  set idGerente(int idGerente){this._idGerente = idGerente;}

}