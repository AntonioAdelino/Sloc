import 'package:Sloc/controladores/VendedorControlador.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'controladores/RotaControlador.dart';
import 'entidades/gerente.dart';

class TelaDeRelatorioDeVendedores extends StatefulWidget {
  @override
  _TelaDeRelatorioDeVendedores createState() => _TelaDeRelatorioDeVendedores();
}

class _TelaDeRelatorioDeVendedores extends State<TelaDeRelatorioDeVendedores> {
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
  var _vendedorControlador = VendedorControlador();
  var _rotaControlador = RotaControlador();
  List _vendedorBusca = [];


  //////////////////////////////////////////////////////////////////
  //                         MÉTODOS                              //
  //////////////////////////////////////////////////////////////////

  _buscarVendedores(Gerente gerente) async {
      List vendedores =
      await _vendedorControlador.listarPorGerente(gerente.id);
      return setState(() {
        _vendedorBusca.addAll(vendedores);
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

  _exibirInformacoes(int vendedor) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Informações", textAlign: TextAlign.center),
            content: Container(
              child: FutureBuilder(
                future: _pegarDados(vendedor),
                builder: (context, dados) {
                  if (dados.hasData) {
                    return Text(
                      "Rotas realizadas: " +
                          dados.data[0] +
                          "\nProfissionais visitados: " +
                          dados.data[1],
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 14.0,
                      ),
                    );
                  } else {
                    return Text(
                      "Carregando...",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 14.0,
                      ),
                    );
                  }
                },
              ),
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
    Gerente gerente = objeto["objeto"];
    if(_controlador){_buscarVendedores(gerente);};
    _controlador = false;

    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text("Vendedores"),
          backgroundColor: Color(0xff1e2e3e),
        ),
        body: Column(children: <Widget>[
          Expanded(
            child: ListView.builder(
                shrinkWrap: true,
                itemCount: _vendedorBusca.length,
                itemBuilder: (context, index) {
                  final vendedor = _vendedorBusca[index];
                  return Card(
                    child: ListTile(
                      title: Text(vendedor.nome),
                      subtitle: Text("CPF: " +
                          vendedor.cpf +
                          "\nEmail: " +
                          vendedor.email),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          GestureDetector(
                            onTap: () {
                              _exibirInformacoes(vendedor.id);
                            },
                            child: Padding(
                              padding: EdgeInsets.only(right: 0),
                              child: Icon(
                                Icons.info,
                                color: Color(0xff315a7d),
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
