import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:v1/dados/dbGerente.dart';
import 'entidades/gerente.dart';

class TelaCadastroGerente extends StatefulWidget {
  @override
  _TelaCadastroGerenteState createState() => _TelaCadastroGerenteState();
}

class _TelaCadastroGerenteState extends State<TelaCadastroGerente> {

  //Atributos
  //Atributos DB
  var _dbGerente = DbGerente();

  //Atributos Controladores
  TextEditingController _nomeController = TextEditingController();
  TextEditingController _cpfController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _senhaController = TextEditingController();
  TextEditingController _confSenhaController = TextEditingController();

  //Alertas

  _erroCampoVazio(){
    showDialog(
        context: context,
        builder: (context){
          return AlertDialog(
            title: Text("Atenção!",
              textAlign: TextAlign.center,
            ),
            content: Text("Há campos vazios."),
            actions: <Widget>[
              FlatButton(
                color: Colors.grey,
                textColor: Colors.white,
                onPressed: () => Navigator.pop(context),
                child: Text("Ok"),
              ),
            ],
          );
        }
    );
  }

  _erroSenha(){
    showDialog(
        context: context,
      builder: (context){
          return AlertDialog(
            title: Text("Atenção!",
              textAlign: TextAlign.center,
            ),
            content: Text("As senhas não correspondem."),
            actions: <Widget>[
              FlatButton(
                color: Colors.grey,
                textColor: Colors.white,
                onPressed: () => Navigator.pop(context),
                child: Text("Ok"),
              ),
            ],
          );
      }
    );
  }

  _gerenteCadastradoComSucesso(Gerente gerente){
    showDialog(
        context: context,
        builder: (context){
          return AlertDialog(
            title: Text("Cadastro realizado!",
              textAlign: TextAlign.center,
            ),
            content: Text(gerente.nome +" foi cadastrado com sucesso"),
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
        }
    );
  }

  //Cadastrar Gerente
  _cadastrarGerente() async{
    String nome = _nomeController.text;
    String cpf = _cpfController.text;
    String email = _emailController.text;
    String senha = _senhaController.text;
    String confSenha = _confSenhaController.text;

    //verificar campos vazios
    if(nome.isEmpty || cpf.isEmpty || email.isEmpty || senha.isEmpty || confSenha.isEmpty){
      _erroCampoVazio();
    }else{
      //verificar se as senhas são iguais
      if( senha != confSenha){
        _erroSenha();
      }else{
        Gerente gerente = Gerente(nome, cpf, email, senha);
        int resultado = await _dbGerente.cadastrarGerente(gerente);
        gerente.id = resultado;
        if( resultado != null ){
          _gerenteCadastradoComSucesso(gerente);

        }
        print("o id é: " +resultado.toString());

      }
    }
  }

  //Corpo
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
                    _cadastrarGerente();
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
