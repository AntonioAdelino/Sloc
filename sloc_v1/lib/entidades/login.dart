class Login {
  //atributos
  String _email;
  String _senha;

  //construtores
  Login(this._email, this._senha);

  Login.fromMap(Map map){
    this._email = map["email"];
    this._senha = map["senha"];
  }

  //método para mapear os atributos
  Map toMap(){

    Map<String, dynamic> map= {
      "email" : this._email,
      "senha" : this._senha,
    };
    return map;
  }
}