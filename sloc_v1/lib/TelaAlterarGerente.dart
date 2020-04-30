import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'entidades/gerente.dart';

class TelaAlterarGerente extends StatefulWidget {
  TelaAlterarGerente({this.gerente});
  var gerente;
  @override
  _TelaAlterarGerenteState createState() => _TelaAlterarGerenteState();
}

class _TelaAlterarGerenteState extends State<TelaAlterarGerente> {

  //Atributos
  TextEditingController _nomeController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _senhaController = TextEditingController();
  TextEditingController _confSenhaController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text("Alterar Gerente"),
          backgroundColor: Color(0xff315a7d),
        ),
        body: Container(
          //padding: EdgeInsets.fromLTRB(5, 10, 5, 10),
          child: ListView(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.fromLTRB(10,0,10,0),
                child: TextField(
                  controller: _nomeController,
                  keyboardType: TextInputType.text,
                  textCapitalization: TextCapitalization.words,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.person),
                    labelText: "Nome",
                  ),
                ),
              ),


              Padding(
                padding: EdgeInsets.fromLTRB(10,0,10,0),
                child: TextField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.email),
                    labelText: "Email",
                  ),
                ),
              ),

              Padding(
                padding: EdgeInsets.fromLTRB(10,0,10,0),
                child: TextField(
                  controller: _senhaController,
                  keyboardType: TextInputType.text,
                  obscureText: true,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.lock_open),
                    labelText: "Senha",
                  ),
                ),
              ),

              Padding(
                padding: EdgeInsets.fromLTRB(10,0,10,20),
                child: TextField(
                  controller: _confSenhaController,
                  keyboardType: TextInputType.text,
                  obscureText: true,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.lock_outline),
                    labelText: "Confirmar senha",
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
                    onPressed: (){
                      print(widget.gerente);
                     // _cadastrarGerente();
                    },
                  ),
                ],
              ),

            ],
          ),
        )
    );
  }
}
