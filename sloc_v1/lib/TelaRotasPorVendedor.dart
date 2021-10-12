import 'package:Sloc/entidades/vendedor.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'controladores/RotaControlador.dart';

class TelaDeRotasPorVendedor extends StatefulWidget {
  @override
  _TelaDeRotasPorVendedor createState() => _TelaDeRotasPorVendedor();
}

class _TelaDeRotasPorVendedor extends State<TelaDeRotasPorVendedor> {
  //////////////////////////////////////////////////////////////////
  //                          ATRIBUTOS                           //
  //////////////////////////////////////////////////////////////////

  //Atributos controladores

  //Atributos Form
  final _formKey = GlobalKey<FormState>();
  bool _controlador = true;
  String nome, email, senha, confSenha;

  //Atributos
  var _rotaControlador = RotaControlador();
  List _rotasBusca = [];

  //////////////////////////////////////////////////////////////////
  //                         MÉTODOS                              //
  //////////////////////////////////////////////////////////////////

  _buscarRotas(Vendedor vendedor) async {
    List rotas = await _rotaControlador.listarPorVendedor(vendedor.id);
    return setState(() {
      _rotasBusca.addAll(rotas.reversed);
    });
  }

  _quantidadeDeRotasFeitas(int vendedor) async {
    var a = await _rotaControlador.quantidadePorVendedor(vendedor);
    return a;
  }

  Future<List<Widget>> _pegarVisitas(int rotaId) async {
    var visitas = await _quantidadeDeRotasFeitas(rotaId);
    var tamanho = 1;
    tamanho = visitas.size;

    return List<Widget>.generate(
      tamanho,
      (i) => ListTile(
        title: Text('Título'),
        subtitle: Text("SUB"),
      ),
    );
  }

  List<Widget> _carregandoLista() {
    return List<Widget>.generate(
      1,
      (i) => ListTile(
        title: Text('Carregando...'),
      ),
    );
  }

  void _navegarParaTela(Object objeto, String rota) {
    Navigator.pushNamed(context, rota, arguments: {"objeto": objeto});
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
    Vendedor vendedor = objeto["objeto"];
    if (_controlador) {
      _buscarRotas(vendedor);
    };
    _controlador = false;

    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text("Rotas"),
          backgroundColor: Color(0xff1e2e3e),
        ),
        body: Column(children: <Widget>[
          Expanded(
            child: ListView.builder(
                shrinkWrap: true,
                itemCount: _rotasBusca.length,
                itemBuilder: (context, index) {
                  final rota = _rotasBusca[index];
                  return Card(
                    child: ListTile(
                      title: Text("Rota: " + rota[0].toString()),
                      subtitle: Text("Data/hora: " + rota[1]),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          GestureDetector(
                            onTap: () {
                              _navegarParaTela(rota[0], "/VisitasPorRotas");
                            },
                            child: Padding(
                              padding: EdgeInsets.only(right: 0),
                              child: Icon(
                                Icons.arrow_right_alt,
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
