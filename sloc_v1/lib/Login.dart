import 'package:Sloc/TelaCadastroGerente.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'controladores/LoginControlador.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  LoginControlador login = new LoginControlador();

  TextEditingController _emailController = TextEditingController();
  TextEditingController _senhaController = TextEditingController();

  void _navegarParaIndex(Object objeto, String rota) {
    Navigator.pushReplacementNamed(context, rota,
        arguments: {"objeto": objeto});
  }

  _erroLogin() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
              "ERRO!",
              textAlign: TextAlign.center,
            ),
            content: Text("Email ou senha incorretos.\nPor favor confira as informações e tente novamente."),
            actions: <Widget>[
              FlatButton(
                color: Colors.grey,
                textColor: Colors.white,
                onPressed: () => Navigator.pop(context),
                child: Text("Ok"),
              ),
            ],
          );
        });
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
                        _erroLogin();
                      } else if (resposta[1] == 1) {
                        _navegarParaIndex(resposta[0], "/IndexGerente");
                      } else if (resposta[1] == 0) {
                        _navegarParaIndex(resposta[0], "/IndexVendedor");
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
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (_) => TelaCadastroGerente()));
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
