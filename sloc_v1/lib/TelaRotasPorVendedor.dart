import 'package:Sloc/entidades/vendedor.dart';
import 'package:date_field/date_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'controladores/RotaControlador.dart';

class TelaDeRotasPorVendedor extends StatefulWidget {
  @override
  _TelaDeRotasPorVendedor createState() => _TelaDeRotasPorVendedor();
}

class _TelaDeRotasPorVendedor extends State<TelaDeRotasPorVendedor> {
  //////////////////////////////////////////////////////////////////
  //                          ATRIBUTOS                           //
  //////////////////////////////////////////////////////////////////
  bool _controlador = true;
  var _rotaControlador = RotaControlador();
  List _todasAsRotas = [];
  List _rotasBusca = [];
  DateTime _dataInicial = DateTime.now().subtract(Duration(days: 30));
  DateTime _dataFinal = DateTime.now();

  //////////////////////////////////////////////////////////////////
  //                         MÉTODOS                              //
  //////////////////////////////////////////////////////////////////

  _buscarRotas(Vendedor vendedor) async {
    List rotas = await _rotaControlador.listarPorVendedor(vendedor.id);
    return setState(() {
      _todasAsRotas.addAll(rotas.reversed);
    });
  }

  void _navegarParaTela(Object objeto, String rota) {
    Navigator.pushNamed(context, rota, arguments: {"objeto": objeto});
  }

  _selecionarEntreDatas() {
    List rotas = [];
    for (var item in _todasAsRotas) {
      var data = DateFormat('dd/MM/yyyy HH:mm').parse(item[1]);
      if (data.isAfter(_dataInicial) && data.isBefore(_dataFinal)) {
        rotas.add(item);
      }
    }
    _rotasBusca.clear();
    _rotasBusca.addAll(rotas);
  }

  _listarTodasAsRotas() {
    _rotasBusca.clear();
    _rotasBusca.addAll(_todasAsRotas);
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
    Map objeto = ModalRoute
        .of(context)
        .settings
        .arguments;
    Vendedor vendedor = objeto["objeto"];
    if (_controlador) {
      _buscarRotas(vendedor);
    }
    ;
    _controlador = false;
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text("Rotas"),
          backgroundColor: Color(0xff1e2e3e),
        ),
        body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                  padding: EdgeInsets.fromLTRB(20, 20, 20, 5),
                  child: Text("Escolha um período",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      color: Color(0xff1e2e3e),
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0,
                    ),
                  )
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(20, 10, 20, 5),
                child: DateTimeField(
                    lastDate: _dataFinal,
                    mode: DateTimeFieldPickerMode.date,
                    onDateSelected: (DateTime data) {
                      setState(() {
                        _dataInicial = data;
                      });
                    },
                    decoration: InputDecoration(
                      label: Text('Data inicial'),
                      border: OutlineInputBorder(),
                      suffixIcon:
                      Icon(Icons.event_note, color: Color(0xff1e2e3e)),
                    ),
                    dateFormat: DateFormat("dd/MM/yyyy"),
                    selectedDate: _dataInicial),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(20, 10, 20, 5),
                child: DateTimeField(
                    firstDate: _dataInicial,
                    lastDate: DateTime.now(),
                    mode: DateTimeFieldPickerMode.date,
                    onDateSelected: (DateTime data) {
                      setState(() {
                        _dataFinal = data;
                      });
                    },
                    decoration: InputDecoration(
                      label: Text('Data final'),
                      border: OutlineInputBorder(),
                      suffixIcon:
                      Icon(Icons.event_note, color: Color(0xff1e2e3e)),
                    ),
                    dateFormat: DateFormat("dd/MM/yyyy"),
                    selectedDate: _dataFinal),
              ),
              Row(mainAxisAlignment: MainAxisAlignment.end, children: <Widget>[
                Padding(padding: EdgeInsets.fromLTRB(0, 0, 10, 10),
                  child: RaisedButton(
                      color: Colors.grey,
                      textColor: Colors.white,
                      child: Text("Ver todas"),
                      onPressed: () {
                        setState(() {
                          _listarTodasAsRotas();
                        });
                      }
                  ),
                ),

                Padding(
                  padding: EdgeInsets.fromLTRB(0, 0, 20, 10),
                  child: RaisedButton(
                    color: Colors.green,
                    textColor: Colors.white,
                    child: Text("Buscar"),
                    onPressed: () {
                      setState(() {
                        _selecionarEntreDatas();
                      });
                    },
                  ),
                )
              ]),
              Padding(
                  padding: EdgeInsets.fromLTRB(20, 0, 20, 10),
                  child: Text("Rotas",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      color: Color(0xff1e2e3e),
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0,
                    ),
                  )
              ),
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
