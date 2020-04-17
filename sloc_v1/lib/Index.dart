import 'package:flutter/material.dart';
import 'package:v1/TelaBuscarGerente.dart';
import 'package:v1/TelaCadastroGerente.dart';
import 'package:v1/TelaListarGerentes.dart';

class TelaPrincipal extends StatefulWidget {
  @override
  _TelaPrincipalState createState() => _TelaPrincipalState();
}

class _TelaPrincipalState extends State<TelaPrincipal> {
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Sloc"),
        backgroundColor: Color(0xff315a7d),
      ),

      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.all(0),
          children: <Widget>[
            DrawerHeader(
              child: Text('Sloc',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18
                ),
              ),
              decoration: BoxDecoration(
                color: Color(0xff315a7d),
              ),
            ),
            ListTile(
              title: Text('Cadastrar gerente',
                style: TextStyle(
                    fontSize: 16
                ),
              ),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => TelaCadastroGerente()
                    )
                );
              },
            ),
            ListTile(
              title: Text('Buscar gerente',
                style: TextStyle(
                    fontSize: 16
                ),
              ),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => TelaBuscarGetente()
                    )
                );
              },
            ),

            ListTile(
              title: Text('Listar gerentes',
                style: TextStyle(
                    fontSize: 16
                ),
              ),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => TelaListarGerentes()
                    )
                );
              },
            ),

          ],
        ),
      ),


      body: Container(
        padding: EdgeInsets.fromLTRB(80, 30,80, 80),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Image.asset("imagens/logoPreto.png",
              ),

              Padding(
                padding: EdgeInsets.all(50),
                child: FloatingActionButton(
                  child: Icon(
                      Icons.search,
                      color: Colors.white),
                  backgroundColor: Color(0xff315a7d),
                ),
              ),
            ]
        ),
      ),

    );
  }
}


