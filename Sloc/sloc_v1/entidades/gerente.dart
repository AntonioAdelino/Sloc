class Gerente {
  //atributos
  String _cpf;
  String _nome;
  String _email;
  String _senha;

  //construtor
  Gerente(this._cpf, this._nome, this._email, this._senha);

  //getters
  String get cpf{return this._cpf;}
  String get nome{return this._nome;}
  String get email{return this._email;}
  String get senha{return this._senha;}

  //setters
  set cpf(String cpf){this._cpf = cpf;}
  set nome(String nome){this._nome = nome;}
  set email(String email){this._email = email;}
  set senha(String senha){this._senha = senha;}
}