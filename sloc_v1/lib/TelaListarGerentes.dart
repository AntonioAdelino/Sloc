import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:v1/TelaAlterarGerente.dart';
import 'package:v1/dados/dbGerente.dart';
import 'package:v1/entidades/gerente.dart';


class TelaListarGerentes extends StatefulWidget {
  @override
  _TelaListarGerentesState createState() => _TelaListarGerentesState();
}

class _TelaListarGerentesState extends State<TelaListarGerentes> {
  //atributos
  var _dbGerente = DbGerente();
  List<Gerente> _listaDeGerentes = List<Gerente>();

  //text
  //Atributos Controladores
  TextEditingController _nomeController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _senhaController = TextEditingController();
  TextEditingController _confSenhaController = TextEditingController();

  //Aletas

  _alertaRemocao(int id) async{
    print("oiii");
    var a;
    showDialog(
        context: context,
        builder: (context){
          return AlertDialog(
            title: Text("Atenção!",
              textAlign: TextAlign.center,
            ),
            content: Text("Você tem certeza de que deseja remover esse cadastro?"),
            actions: <Widget>[

              FlatButton(
                color: Colors.grey,
                textColor: Colors.white,
                onPressed: (){
                  _dbGerente.removerGerente(id);
                  _listarGerentes();
                  Navigator.pop(context);

                },

                child: Text("Ok"),
              ),

              FlatButton(
                color: Colors.green,
                textColor: Colors.white,
                onPressed: () => Navigator.pop(context),
                child: Text("Cancelar"),
              ),
            ],
          );
        }
    );
  }

  _listarGerentes() async{

    List gerentes = await _dbGerente.listarGetentes();

    //criar as instancias vindas do banco
    List<Gerente> listaTemporaria = List<Gerente>();
    for( var item in gerentes){
      Gerente gerente = Gerente.fromMap(item);
      listaTemporaria.add(gerente);
    }

    setState(() {
      _listaDeGerentes = listaTemporaria;
    });

    listaTemporaria = null;

    //print("Lista de gerentes:\n"+gerentes.toString());

  }

  _removerGerente( int id) async{

    await _dbGerente.removerGerente(id);
    _listarGerentes();

  }

  exibirTelaAlteracao({Gerente gerente}){

    showDialog(
      context: context,
      builder: (context){
        return AlertDialog(
          title: Text("Alterar gerente",
            textAlign: TextAlign.center),
          content: Column(
            mainAxisSize: MainAxisSize.max,
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

            ],
          ),
        );
      }

    );
  }

  @override
  void initState() {
    super.initState();
    _listarGerentes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text("Gerentes cadastrados"),
          backgroundColor: Color(0xff315a7d),
        ),
        body: Column(
          children: <Widget>[

            Expanded(
              child: ListView.builder(
                  itemCount: _listaDeGerentes.length,
                  itemBuilder: (context, index) {

                    final gerente = _listaDeGerentes[index];
                    print(gerente.nome);

                    return Card(
                      child: ListTile(
                        title: Text( gerente.nome),
                        subtitle: Text ("CPF: "+gerente.cpf +"\nEmail: "+ gerente.email),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[

                            GestureDetector(
                              onTap: (){
                                _alertaRemocao(gerente.id);
                              },
                              child: Padding(
                                padding: EdgeInsets.only(right: 20),
                                child: Icon(
                                  Icons.remove_circle_outline,
                                  color: Color(0xff920101),
                                ),
                              ),
                            ),


                            GestureDetector(
                              onTap: (){
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => TelaAlterarGerente()
                                    )
                                );
                              },
                              child: Padding(
                                padding: EdgeInsets.only(right: 0),
                                child: Icon(
                                  Icons.edit,
                                  color: Color(0xff315a7d),
                                ),
                              ),
                            ),

                          ],
                        ),
                      ),
                    );
                  }
              ),
            )
          ],
        )
    );
  }
}
