import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:v1/TelaAlterarGerente.dart';
import 'package:v1/dados/dbGerente.dart';
import 'package:v1/entidades/gerente.dart';

class TelaBuscarGetente extends StatefulWidget {
  @override
  _TelaBuscarGetenteState createState() => _TelaBuscarGetenteState();
}

class _TelaBuscarGetenteState extends State<TelaBuscarGetente> {

  //atributos controladores
  TextEditingController _nomeController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _senhaController = TextEditingController();
  TextEditingController _confSenhaController = TextEditingController();

  //atributos
  TextEditingController _buscaController = TextEditingController();
  var _dbGerente = DbGerente();
  List<Gerente> _gerenteBusca = [];

  //metodos
  _buscarGerente(String gerenteNome) async{

    //_gerenteBusca = null;
    List gerentes = await _dbGerente.buscarGerente(gerenteNome);

    //criar as instancias vindas do banco
    List<Gerente> listaTemporaria = List<Gerente>();
    for( var item in gerentes){
      Gerente gerente = Gerente.fromMap(item);
      listaTemporaria.add(gerente);
    }
    //modificando o State
    setState(() {
      _gerenteBusca.addAll(listaTemporaria);
    });
  }

  _alterarGerente(int id, String cpf) async{
    String nome = _nomeController.text;
    String email = _emailController.text;
    String senha = _senhaController.text;
    String confSenha = _confSenhaController.text;

    //verificar campos vazios
    if(nome.isEmpty || email.isEmpty || senha.isEmpty || confSenha.isEmpty){
      _erroCampoVazio();
    }else{
      //verificar se as senhas são iguais
      if( senha != confSenha){
        //_erroSenha();
      }else{
        Gerente gerente = Gerente(nome, cpf, email, senha);
        gerente.id = id;
        int resultado = await _dbGerente.alterarGerente(gerente);
        gerente.id = resultado;
        if( resultado != null ){
          //_gerenteCadastradoComSucesso(gerente);
        }
      }
    }
  }

  //Alertas
  _erroCampoVazio(){
    showDialog(
        context: context,
        builder: (context){
          return AlertDialog(
            title: Text("Atenção!",
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
        }
    );
  }

  _alertaRemocao(int id, String nome) async{
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
                  setState(() {
                    _gerenteBusca.clear();
                    _buscarGerente(nome);
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
        }
    );
  }
  //inicializando o State
  @override
  void initState() {
    super.initState();
  }




  _exibirTelaAlteracao({Gerente gerente}){
    //setando dados nos campos
    _nomeController = TextEditingController(text: gerente.nome);
    _emailController = TextEditingController(text: gerente.email);
    _senhaController = TextEditingController(text: gerente.senha);
    _confSenhaController = TextEditingController(text: gerente.senha);

    print(gerente.nome);
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
                  child: TextFormField(
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
                  child: TextFormField(
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
                  child: TextFormField(
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
                  child: TextFormField(
                    controller: _confSenhaController,
                    keyboardType: TextInputType.text,
                    obscureText: true,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.lock_outline),
                      labelText: "Confirmar senha",
                    ),
                  ),
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
                    _alterarGerente(gerente.id, gerente.cpf);
                    setState(() {
                      _gerenteBusca.clear();
                      _buscarGerente(_buscaController.text);
                      Navigator.pop(context);

                    });
                  },
                ),

              ],
            ),
          );
        }

    );
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
                    //verificar se a busca é vazia
                    if(nome == ''){
                      _erroCampoVazio();
                    }else{
                      _gerenteBusca.clear();
                      _buscarGerente(nome);
                    }
                  },
                ),
              ],
            ),

            Expanded(
              child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: _gerenteBusca.length,
                  itemBuilder: (context, index) {
                    final gerente = _gerenteBusca[index];
                    return Card(
                      child: ListTile(
                        title: Text( gerente.nome),
                        subtitle: Text ("CPF: "+gerente.cpf +"\nEmail: "+ gerente.email),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[

                            GestureDetector(
                              onTap: (){
                                _alertaRemocao(gerente.id, _buscaController.text);
                                print(_buscaController.text);
                                _gerenteBusca.clear();
                                _buscarGerente(_buscaController.text);
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
                              onTap: (){

                                _exibirTelaAlteracao(gerente: gerente);
//                                Navigator.push(
//                                    context,
//                                    MaterialPageRoute(
//                                      builder: (context) => exibirTelaAlteracao()
//                                      //builder: (context) => TelaAlterarGerente()
//                                    )
//                                );
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
          ]
        )
    );
  }
}
