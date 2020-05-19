import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:v1/dados/dbVendedor.dart';
import 'package:v1/entidades/vendedor.dart';

class TelaBuscarVendedor extends StatefulWidget {
  @override
  _TelaCuscarVendedorState createState() => _TelaCuscarVendedorState();
}

class _TelaCuscarVendedorState extends State<TelaBuscarVendedor> {
  //////////////////////////////////////////////////////////////////
  //                          ATRIBUTOS                           //
  //////////////////////////////////////////////////////////////////

  //Atributos controladores
  TextEditingController _nomeController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _senhaController = TextEditingController();
  TextEditingController _confSenhaController = TextEditingController();

  //Atributos Form
  final _formKey = GlobalKey<FormState>();
  bool _validate = false;
  String nome, email, senha, confSenha;

  //Atributos
  TextEditingController _buscaController = TextEditingController();
  var _dbVendedor = DbVendedor();
  List<Vendedor> _vendedorBusca = [];

  //////////////////////////////////////////////////////////////////
  //                         VALIDAÇÕES                           //
  //////////////////////////////////////////////////////////////////

  String _validarNome(String value) {
    String patttern = r'(^[a-zA-ZÀÁÇÈÉÊÌÍÎÑÒÓÔÕÙÚÛÝàáâãçèéêìíîðñòóôõùúûý\s]*$)';
    RegExp regExp = new RegExp(patttern);
    if (value.length <= 2) {
      return "Informe um nome válido";
    } else if (!regExp.hasMatch(value)) {
      return "Informe um nome válido";
    }
    return null;
  }

  String _validarCpf(String value) {
    if (value.length == 0) {
      return "Informe o CPF";
    } else if (value.length != 14) {
      return "O CPF está incompleto";
    }
    return null;
  }

  String _validarEmail(String value) {
    String pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@' +
            '((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))';
    RegExp regExp = new RegExp(pattern);
    if (value.length == 0) {
      return "Informe o Email";
    } else if (!regExp.hasMatch(value)) {
      return "Email inválido";
    } else {
      return null;
    }
  }

  String _validarSenha(String value) {
    if (value.length == 0) {
      return "Informe a senha";
    } else if (value != _confSenhaController.text) {
      return "Senhas não correspondem";
    } else {
      return null;
    }
  }

  String _validarConfSenha(String value) {
    if (value.length == 0) {
      return "Informe a senha";
    } else if (value != _senhaController.text) {
      return "Senhas não correspondem";
    } else {
      return null;
    }
  }

  //////////////////////////////////////////////////////////////////
  //                           ALERTAS                            //
  //////////////////////////////////////////////////////////////////

  _erroCampoVazio() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
              "Atenção!",
              textAlign: TextAlign.center,
            ),
            content: Text("O campo de busca não foi preenchido."),
            actions: <Widget>[
              FlatButton(
                color: Colors.grey,
                textColor: Colors.white,
                onPressed: () => Navigator.pop(context),
                child: Text("Ok"),
              ),
            ],
          );
        });
  }

  _alertaRemocao(int id, String nome) async {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
              "Atenção!",
              textAlign: TextAlign.center,
            ),
            content:
                Text("Você tem certeza de que deseja remover esse cadastro?"),
            actions: <Widget>[
              FlatButton(
                color: Colors.grey,
                textColor: Colors.white,
                onPressed: () {
                  _dbVendedor.removerVendedor(id);
                  setState(() {
                    _vendedorBusca.clear();
                    _buscarVendedor(nome);
                  });
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
        });
  }

  _naoEncontrado() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
              "Não encontrado!",
              textAlign: TextAlign.center,
            ),
            content: Text("O usuário não foi encontrado na base de dados."),
            actions: <Widget>[
              FlatButton(
                color: Colors.grey,
                textColor: Colors.white,
                onPressed: () => Navigator.pop(context),
                child: Text("Ok"),
              ),
            ],
          );
        });
  }

  //////////////////////////////////////////////////////////////////
  //                         MÉTODOS                              //
  //////////////////////////////////////////////////////////////////

  _buscarVendedor(String vendedorNome) async {
    //_gerenteBusca = null;
    List gerentes = await _dbVendedor.buscarVendedor(vendedorNome);

    //criar as instancias vindas do banco
    List<Vendedor> listaTemporaria = List<Vendedor>();
    for (var item in gerentes) {
      Vendedor vendedor = Vendedor.fromMap(item);
      listaTemporaria.add(vendedor);
    }
    if (listaTemporaria.isEmpty) {
      _naoEncontrado();
    }
    //modificando o State
    setState(() {
      _vendedorBusca.addAll(listaTemporaria);
    });
  }

  _alterarGerente(int id, String cpf, int idGerente) async {
    String nome = _nomeController.text;
    String email = _emailController.text;
    String senha = _senhaController.text;

    Vendedor vendedor = Vendedor(nome, cpf, email, senha);
    vendedor.id = id;
    vendedor.idGerente = idGerente;
    int resultado = await _dbVendedor.alterarVendedor(vendedor);
    vendedor.id = resultado;
  }

  _exibirTelaAlteracao({Vendedor vendedor}) {
    //setando dados nos campos
    _nomeController = TextEditingController(text: vendedor.nome);
    _emailController = TextEditingController(text: vendedor.email);
    _senhaController = TextEditingController(text: vendedor.senha);
    _confSenhaController = TextEditingController(text: vendedor.senha);

    print(vendedor.nome);
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Alterar vendedor", textAlign: TextAlign.center),
            content: Form(
              key: _formKey,
              autovalidate: _validate,
              child: ListView(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                    child: TextFormField(
                      controller: _nomeController,
                      keyboardType: TextInputType.text,
                      textCapitalization: TextCapitalization.words,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.person),
                        labelText: "Nome",
                      ),
                      validator: _validarNome,
                      onSaved: (String val) {
                        nome = val;
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                    child: TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.email),
                        labelText: "Email",
                      ),
                      validator: _validarEmail,
                      onSaved: (String val) {
                        email = val;
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                    child: TextFormField(
                      controller: _senhaController,
                      keyboardType: TextInputType.text,
                      obscureText: true,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.lock_open),
                        labelText: "Senha",
                      ),
                      validator: _validarSenha,
                      onSaved: (String val) {
                        senha = val;
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(10, 0, 10, 20),
                    child: TextFormField(
                      controller: _confSenhaController,
                      keyboardType: TextInputType.text,
                      obscureText: true,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.lock_outline),
                        labelText: "Confirmar senha",
                      ),
                      validator: _validarConfSenha,
                      onSaved: (String val) {
                        confSenha = val;
                      },
                    ),
                  ),
                  Row(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
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
                        onPressed: () {
                          _enviarFormulario(vendedor.id, vendedor.cpf,
                              _buscaController.text, vendedor.idGetente);
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        });
  }

  _enviarFormulario(int id, String cpf, String nome, int idGerente) {
    if (_formKey.currentState.validate()) {
      // Sem erros na validação

      _alterarGerente(id, cpf, idGerente);
      setState(() {
        _vendedorBusca.clear();
        _buscarVendedor(_buscaController.text);
        Navigator.pop(context);
      });
    } else {
      // erro de validação
      setState(() {
        _validate = true;
      });
    }
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
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text("Pesquisar Vendedor"),
          backgroundColor: Color(0xff315a7d),
        ),
        body: Column(children: <Widget>[
          Padding(
            padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
            child: TextField(
              autofocus: true,
              controller: _buscaController,
              keyboardType: TextInputType.text,
              textCapitalization: TextCapitalization.words,
              decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.search),
                  labelText: "Pesquisar",
                  hintText: "Digite o nome"),
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
                onPressed: () {
                  String nome = _buscaController.text;
                  //verificar se a busca é vazia
                  if (nome == '') {
                    _erroCampoVazio();
                  } else {
                    _vendedorBusca.clear();
                    _buscarVendedor(nome);
                  }
                },
              ),
            ],
          ),
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
                              _alertaRemocao(
                                  vendedor.id, _buscaController.text);
                              print(_buscaController.text);
                              _vendedorBusca.clear();
                              _buscarVendedor(_buscaController.text);
                            },
                            child: Padding(
                              padding: EdgeInsets.only(right: 20),
                              child: Icon(
                                Icons.cancel,
                                color: Color(0xff920101),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              _exibirTelaAlteracao(vendedor: vendedor);
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
                }),
          )
        ]));
  }
}
