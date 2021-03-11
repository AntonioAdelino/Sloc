import 'package:Sloc/controladores/VendedorControlador.dart';
import 'package:brasil_fields/formatter/cpf_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:Sloc/dados/dbVendedor.dart';
import 'entidades/vendedor.dart';

class TelaCadastroVendedor extends StatefulWidget {
  @override
  _TelaCadastroVendedorState createState() => _TelaCadastroVendedorState();
}

class _TelaCadastroVendedorState extends State<TelaCadastroVendedor> {
  //////////////////////////////////////////////////////////////////
  //                          ATRIBUTOS                           //
  //////////////////////////////////////////////////////////////////

  //Atributos controlador
  VendedorControlador vendedorControlador = VendedorControlador();

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
  TextEditingController _idGerenteController = TextEditingController();

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

  _vendedorCadastradoComSucesso(Vendedor vendedor) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
              "Cadastro realizado!",
              textAlign: TextAlign.center,
            ),
            content: Text(vendedor.nome + " foi cadastrado com sucesso"),
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

  _cadastrarVendedor() async {
    String nome = _nomeController.text;
    String cpf = _cpfController.text;
    String email = _emailController.text;
    String senha = _senhaController.text;
    String confSenha = _confSenhaController.text;
    int idGerente = int.parse(_idGerenteController.text);

    Vendedor vendedor = Vendedor(nome, cpf, email, senha);
    vendedor.idGerente = idGerente;

    int resultado = await vendedorControlador.adicionar(vendedor);

    if ((199 < resultado && resultado < 300)) {
      _vendedorCadastradoComSucesso(vendedor);
    }
  }

  _enviarFormulario() {
    if (_formKey.currentState.validate()) {
      // Sem erros na validação
      _cadastrarVendedor();
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
          title: Text("Cadastrar Vendedor"),
          backgroundColor: Color(0xff1e2e3e),
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
                  padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
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
                Padding(
                  padding: EdgeInsets.fromLTRB(10, 0, 10, 20),
                  child: TextFormField(
                    controller: _idGerenteController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.lock_outline),
                      labelText: "Código do Gerente",
                    ),
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
