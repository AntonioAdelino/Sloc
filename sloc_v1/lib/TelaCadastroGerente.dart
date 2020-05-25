import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:Sloc/dados/dbGerente.dart';
import 'entidades/gerente.dart';

class TelaCadastroGerente extends StatefulWidget {
  @override
  _TelaCadastroGerenteState createState() => _TelaCadastroGerenteState();
}

class _TelaCadastroGerenteState extends State<TelaCadastroGerente> {
  //////////////////////////////////////////////////////////////////
  //                          ATRIBUTOS                           //
  //////////////////////////////////////////////////////////////////

  //Atributos DB
  var _dbGerente = DbGerente();

  //Atributos Form
  final _formKey = GlobalKey<FormState>();
  bool _validate = false;
  String nome, cpf, email, senha, confSenha;

  //Atributos Controladores
  TextEditingController _nomeController = TextEditingController();
  TextEditingController _cpfController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _senhaController = TextEditingController();
  TextEditingController _confSenhaController = TextEditingController();

  //////////////////////////////////////////////////////////////////
  //                         VALIDAÇÕES                           //
  //////////////////////////////////////////////////////////////////

  String _validarNome(String value) {
    String patttern = r'(^[a-zA-ZÀÁÇÈÉÊÌÍÎÑÒÓÔÕÙÚÛÝàáâãçèéêìíîðñòóôõùúûý\s]*$)';
    RegExp regExp = new RegExp(patttern);
    if (value.length <= 2) {
      return "Informe um nome válido";
    } else if (!regExp.hasMatch(value)) {
      return "Informe um nome válido";
    }
    return null;
  }

  String _validarCpf(String value) {
    if (value.length == 0) {
      return "Informe o CPF";
    } else if (value.length != 14) {
      return "O CPF está incompleto";
    }
    return null;
  }

  String _validarEmail(String value) {
    String pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@' +
            '((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))';
    RegExp regExp = new RegExp(pattern);
    if (value.length == 0) {
      return "Informe o Email";
    } else if (!regExp.hasMatch(value)) {
      return "Email inválido";
    } else {
      return null;
    }
  }

  String _validarSenha(String value) {
    if (value.length == 0) {
      return "Informe a senha";
    } else if (value != _confSenhaController.text) {
      return "Senhas não correspondem";
    } else {
      return null;
    }
  }

  String _validarConfSenha(String value) {
    if (value.length == 0) {
      return "Informe a senha";
    } else if (value != _senhaController.text) {
      return "Senhas não correspondem";
    } else {
      return null;
    }
  }

  //////////////////////////////////////////////////////////////////
  //                           ALERTAS                            //
  //////////////////////////////////////////////////////////////////

  _gerenteCadastradoComSucesso(Gerente gerente) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
              "Cadastro realizado!",
              textAlign: TextAlign.center,
            ),
            content: Text(gerente.nome + " foi cadastrado com sucesso"),
            actions: <Widget>[
              FlatButton(
                color: Colors.grey,
                textColor: Colors.white,
                //textColor: Colors.grey,
                onPressed: () => Navigator.pop(context),
                child: Text("Ok"),
              ),
            ],
          );
        });
  }

  //////////////////////////////////////////////////////////////////
  //                         MÉTODOS                              //
  //////////////////////////////////////////////////////////////////

  _cadastrarGerente() async {
    String nome = _nomeController.text;
    String cpf = _cpfController.text;
    String email = _emailController.text;
    String senha = _senhaController.text;
    String confSenha = _confSenhaController.text;

    Gerente gerente = Gerente(nome, cpf, email, senha);
    int resultado = await _dbGerente.cadastrarGerente(gerente);
    gerente.id = resultado;

    if (resultado != null) {
      _gerenteCadastradoComSucesso(gerente);
    }
  }

  _enviarFormulario() {
    if (_formKey.currentState.validate()) {
      // Sem erros na validação
      _cadastrarGerente();
      _formKey.currentState.reset();
    } else {
      // erro de validação
      setState(() {
        _validate = true;
      });
    }
  }

  //////////////////////////////////////////////////////////////////
  //                           CORPO                              //
  //////////////////////////////////////////////////////////////////
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text("Cadastrar Gerente"),
          backgroundColor: Color(0xff315a7d),
        ),
        body: Container(
          //padding: EdgeInsets.fromLTRB(5, 10, 5, 10),
          child: Form(
            key: _formKey,
            autovalidate: _validate,
            child: ListView(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                  child: TextFormField(
                    autofocus: true,
                    controller: _nomeController,
                    keyboardType: TextInputType.text,
                    textCapitalization: TextCapitalization.words,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.person),
                      labelText: "Nome",
                    ),
                    validator: _validarNome,
                    onSaved: (String val) {
                      nome = val;
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                  child: TextFormField(
                    controller: _cpfController,
                    inputFormatters: [
                      WhitelistingTextInputFormatter.digitsOnly,
                      CpfInputFormatter(),
                    ],
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.assignment_ind),
                      labelText: "CPF",
                    ),
                    validator: _validarCpf,
                    onSaved: (String val) {
                      cpf = val;
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                  child: TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.email),
                      labelText: "Email",
                    ),
                    validator: _validarEmail,
                    onSaved: (String val) {
                      email = val;
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                  child: TextFormField(
                    controller: _senhaController,
                    keyboardType: TextInputType.text,
                    obscureText: true,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.lock_open),
                      labelText: "Senha",
                    ),
                    validator: _validarSenha,
                    onSaved: (String val) {
                      senha = val;
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(10, 0, 10, 20),
                  child: TextFormField(
                    controller: _confSenhaController,
                    keyboardType: TextInputType.text,
                    obscureText: true,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.lock_outline),
                      labelText: "Confirmar senha",
                    ),
                    validator: _validarConfSenha,
                    onSaved: (String val) {
                      confSenha = val;
                    },
                  ),
                ),
                Row(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.fromLTRB(155, 0, 0, 0),
                    ),
                    RaisedButton(
                      color: Colors.grey,
                      textColor: Colors.white,
                      child: Text("Cancelar"),
                      onPressed: () => Navigator.pop(context),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                    ),
                    RaisedButton(
                      color: Colors.green,
                      textColor: Colors.white,
                      child: Text("Salvar"),
                      onPressed: () {
                        _enviarFormulario();
                        //_cadastrarGerente();
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ));
  }
}
