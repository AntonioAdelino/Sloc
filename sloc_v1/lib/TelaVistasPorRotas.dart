import 'package:Sloc/controladores/VendedorControlador.dart';
import 'package:Sloc/controladores/VisitaControlador.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'controladores/RotaControlador.dart';
import 'entidades/gerente.dart';

class TelaVisitasPorRota extends StatefulWidget {
  @override
  _TelaVisitasPorRota createState() => _TelaVisitasPorRota();
}

class _TelaVisitasPorRota extends State<TelaVisitasPorRota> {
  //////////////////////////////////////////////////////////////////
  //                          ATRIBUTOS                           //
  //////////////////////////////////////////////////////////////////

  //Atributos controladores


  //Atributos Form
  final _formKey = GlobalKey<FormState>();
  bool _controlador = true;
  String nome, email, senha, confSenha;

  //Atributos
  TextEditingController _buscaController = TextEditingController();
  var _visitaControlador = VisitaControlador();
  var _rotaControlador = RotaControlador();
  List _visitaBusca = [];


  //////////////////////////////////////////////////////////////////
  //                         MÉTODOS                              //
  //////////////////////////////////////////////////////////////////

  _buscarVisitasPorRota(int rotaId) async {
      List visitas =
      await _visitaControlador.listarPorRota(rotaId);
      return setState(() {
        _visitaBusca.addAll(visitas);
      });
  }

  _quantidadeDeRotasFeitas(int vendedor) async {
    return await _rotaControlador.quantidadePorVendedor(vendedor);
  }
  _quantidadeDeProfissionaisVisitados(int vendedor) async {
    return await _rotaControlador.profissionaisPorVendedor(vendedor);
  }

  _pegarDados(int vendedor) async{
    var rotas = await _quantidadeDeRotasFeitas(vendedor);
    var profissionais = await _quantidadeDeProfissionaisVisitados(vendedor);
    return [rotas, profissionais];
  }

  void _navegarParaTela(Object objeto, String rota) {
    Navigator.pushNamed(context, rota, arguments: {"objeto": objeto});
  }

  _mostrarDetalhesVisita(List visita) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(visita[0], textAlign: TextAlign.center),
            content: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text( "Endereço:",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 14.0,
                    ),
                  ),
                  Text( visita[2],
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 14.0,
                    ),
                  ),
                  Text( "Contato:",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 14.0,
                    ),
                  ),
                  Text( visita[3],
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 14.0,
                    ),
                  ),

                  Text( "\nCheckin feito a " +
                      visita[1].toString() + " metros do local.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 14.0,
                    ),
                  ),
                ],
              )
              ),
            );
        });
  }

  //Inicializando o State
  @override
  void initState() {
    super.initState();
  }

  //////////////////////////////////////////////////////////////////
  //                           CORPO                              //
  //////////////////////////////////////////////////////////////////

  @override
  Widget build(BuildContext context) {

    Map objeto = ModalRoute.of(context).settings.arguments;
    int rota = objeto["objeto"];
    if(_controlador){_buscarVisitasPorRota(rota);};
    _controlador = false;

    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text("Visitas"),
          backgroundColor: Color(0xff1e2e3e),
        ),
        body: Column(children: <Widget>[
          Expanded(
            child: ListView.builder(
                shrinkWrap: true,
                itemCount: _visitaBusca.length,
                itemBuilder: (context, index) {
                  final visita = _visitaBusca[index];
                  return Card(
                    child: ListTile(
                      title: Text(visita[0]),
                      subtitle: Text("Checkin feito a " +
                          visita[1].toString() + " metros do local."),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          GestureDetector(
                            onTap: () {
                              _mostrarDetalhesVisita(visita);
                            },
                            child: Padding(
                              padding: EdgeInsets.only(right: 0),
                              child: Icon(
                                Icons.info,
                                color: Color(0xff1e2e3e),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
          )
        ]));
  }
}
