import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:v1/dados/dbGerente.dart';
import 'package:v1/entidades/gerente.dart';

class TelaBuscarGetente extends StatefulWidget {
  @override
  _TelaBuscarGetenteState createState() => _TelaBuscarGetenteState();
}

class _TelaBuscarGetenteState extends State<TelaBuscarGetente> {

  //atributos
  TextEditingController _buscaController = TextEditingController();

  var _dbGerente = DbGerente();
  List<Gerente> _gerenteBusca = List<Gerente>();

  _buscarGerente(String gerenteNome) async{

    //_gerenteBusca = null;
    List gerentes = await _dbGerente.buscarGerente(gerenteNome);

    //criar as instancias vindas do banco
    List<Gerente> listaTemporaria = List<Gerente>();
    for( var item in gerentes){
      Gerente gerente = Gerente.fromMap(item);
      listaTemporaria.add(gerente);
    }

    setState(() {
      _gerenteBusca = listaTemporaria;
    });

    listaTemporaria = null;

    //print("Lista de gerentes:\n"+gerentes.toString());


  }

  @override
  void initState() {
    super.initState();
    //_listarGerentes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text("Buscar Gerentes"),
          backgroundColor: Color(0xff315a7d),
        ),
        body: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.fromLTRB(10,10,10,10),
              child: TextField(
                controller: _buscaController,
                keyboardType: TextInputType.text,
                textCapitalization: TextCapitalization.words,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.search),
                  labelText: "Buscar",
                ),
              ),
            ),

            Row(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.fromLTRB(260, 0, 0, 0),
                ),

                RaisedButton(
                  color: Colors.green,
                  textColor: Colors.white,
                  child: Text("Buscar"),
                  onPressed: (){
                    String nome = _buscaController.text;
                    _buscarGerente(nome);
                    //bloco card
                    Expanded(
                      child: ListView.builder(
                          itemCount: _gerenteBusca.length,
                          itemBuilder: (context, index) {

                            final gerente = _gerenteBusca[index];

                            return Card(
                              child: ListTile(
                                title: Text( gerente.nome),
                                subtitle: Text ("CPF: "+gerente.cpf +"\nEmail: "+ gerente.email),

                              ),
                            );
                          }
                      ),
                    );

                  },
                ),
              ],
            ),
          ]
        )
    );
  }
}
