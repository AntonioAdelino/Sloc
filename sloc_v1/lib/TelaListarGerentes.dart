import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
