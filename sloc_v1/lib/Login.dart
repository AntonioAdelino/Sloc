import 'package:Sloc/TelaCadastroGerente.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'Index.dart';
import 'controladores/LoginControlador.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {

  LoginControlador login = new LoginControlador();

  TextEditingController _emailController = TextEditingController();
  TextEditingController _senhaController = TextEditingController();


  String _validarEmail(String value) {
    String pattern = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@'+
        '((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))';
    RegExp regExp = new RegExp(pattern);
    if (value.length == 0) {
      return "Informe o Email";
    } else if(!regExp.hasMatch(value)){
      return "Email inválido";
    }else {
      return null;
    }
  }

  String _validarSenha(String value) {
    if (value.length == 0) {
      return "Informe a senha";
    }else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(color: Color(0xff1e2e3e)),
        padding: EdgeInsets.all(16),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(bottom: 32),
                  child: Image.asset(
                    "imagens/logoBranco.png",
                    width: 180,
                    height: 180,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 8),
                  child: TextField(
                    controller: _emailController,
                    autofocus: true,
                    keyboardType: TextInputType.emailAddress,
                    style: TextStyle(fontSize: 16),
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                      hintText: "Email",
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(0),
                      ),
                    ),
                  ),
                ),
                TextField(
                  controller: _senhaController,
                  obscureText: true,
                  keyboardType: TextInputType.text,
                  style: TextStyle(fontSize: 16),
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                    hintText: "Senha",
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(0),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 10, bottom: 5),
                  child: RaisedButton(
                    child: Text(
                      "Entrar",
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                    color: Colors.green,
                    padding: EdgeInsets.fromLTRB(40, 10, 40, 10),
                    onPressed: () async {
                      List resposta = await login.fazerLogin(
                          _emailController.text, _senhaController.text);
                      if (resposta == null) {
                        print("USER NÃO CADASTRADO!");
                      } else if (resposta[1] == 1) {
                        print("É GERENTE!");
                        Navigator.pushReplacement(context,
                            MaterialPageRoute(builder: (_) => TelaPrincipal()));
                      } else if (resposta[1] == 0) {
                        print("É VENDEDOR!");
                        Navigator.pushReplacement(context,
                            MaterialPageRoute(builder: (_) => TelaPrincipal()));
                      }
                    },
                  ),
                ),
                Center(
                  child: GestureDetector(
                    child: Text("Olá gestor, não tem conta? Cadastre-se!",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        )),
                    onTap: () {
                      TelaCadastroGerente();
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
