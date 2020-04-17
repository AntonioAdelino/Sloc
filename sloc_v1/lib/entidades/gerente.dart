class Gerente {
  //atributos
  int _id;
  String _nome;
  String _cpf;
  String _email;
  String _senha;

  //construtores
  Gerente(this._nome, this._cpf, this._email, this._senha);

  Gerente.fromMap(Map map){
    this.id = map["id"];
    this.nome = map["nome"];
    this.cpf = map["cpf"];
    this.email = map["email"];
    this.senha = map["senha"];

  }

  //método para mapear os atributos
  Map toMap(){

    Map<String, dynamic> map= {
      "nome" : this.nome,
      "cpf" : this.cpf,
      "email" : this.email,
      "senha" : this.senha,
    };

    if(this.id != null){
      map["id"] = this.id;
    }

    return map;
  }
  //getters
  int get id{return this._id;}
  String get nome{return this._nome;}
  String get cpf{return this._cpf;}
  String get email{return this._email;}
  String get senha{return this._senha;}

  //setters
  set id(int id){this._id = id;}
  set nome(String nome){this._nome = nome;}
  set cpf(String cpf){this._cpf = cpf;}
  set email(String email){this._email = email;}
  set senha(String senha){this._senha = senha;}
}