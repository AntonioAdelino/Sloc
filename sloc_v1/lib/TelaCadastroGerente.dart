import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
class TelaCadastroGerente extends StatefulWidget {
  @override
  _TelaCadastroGerenteState createState() => _TelaCadastroGerenteState();
}

class _TelaCadastroGerenteState extends State<TelaCadastroGerente> {

  TextEditingController _textEditingController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
        title: Text("Cadastrar Gerente"),
    backgroundColor: Color(0xff315a7d),
    ),
      body: Container(
        padding: EdgeInsets.fromLTRB(5, 10, 5, 10),
        child: ListView(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.fromLTRB(10,0,10,0),
              child: TextField(
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.person),
                  labelText: "Nome",
                ),
                onSubmitted: (String nome){
                  print(nome);//captura nome em uma variavel aqui
                },
                ),
              ),

            Padding(
              padding: EdgeInsets.fromLTRB(10,0,10,0),
              child: TextField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.assignment_ind),
                  labelText: "CPF",
                ),
                onSubmitted: (String cpf){
                  print(cpf);//captura nome em uma variavel aqui
                },
              ),
            ),

            Padding(
              padding: EdgeInsets.fromLTRB(10,0,10,0),
              child: TextField(
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.email),
                  labelText: "Email",
                ),
                onSubmitted: (String email){
                  print(email);//captura nome em uma variavel aqui
                },
              ),
            ),

            Padding(
              padding: EdgeInsets.fromLTRB(10,0,10,0),
              child: TextField(
                keyboardType: TextInputType.text,
                obscureText: true,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.lock_open),
                  labelText: "Senha",
                ),
                onSubmitted: (String senha){
                  print(senha);//captura nome em uma variavel aqui
                },
              ),
            ),

            Padding(
              padding: EdgeInsets.fromLTRB(10,0,10,20),
              child: TextField(
                keyboardType: TextInputType.text,
                obscureText: true,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.lock_outline),
                  labelText: "Confirmar senha",
                ),
                onSubmitted: (String confirmarSenha){
                  print(confirmarSenha);//captura nome em uma variavel aqui
                },
              ),
            ),

            Padding(
              padding: EdgeInsets.fromLTRB(220,0,0,0),
              child: RaisedButton(
                color: Colors.green,
                textColor: Colors.white,
                child: Text("Salvar"),
                onPressed: (){
                  //aqui instancia o objeto
                },
              ),
            ),
            ],
          ),
      )
    );
  }
}
