import 'package:flutter/material.dart';
import 'package:v1/TelaBuscarGerente.dart';
import 'package:v1/TelaCadastroGerente.dart';
import 'package:v1/TelaCadastroVendedor.dart';

import 'TelaBuscarVendedor.dart';

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
              child: Text(
                'Menu',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18),
              ),
              decoration: BoxDecoration(
                color: Color(0xff315a7d),
              ),
            ),

            ExpansionTile(
              leading: Icon(Icons.people),
              title: Text(
                "Cadastrar",
                style: TextStyle(fontSize: 16),
              ),
              children: <Widget>[
                ListTile(
                  title: Text(
                    'Gerente',
                    style: TextStyle(fontSize: 15, color: Colors.black87),
                  ),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => TelaCadastroGerente()));
                  },
                ),
                ListTile(
                  title: Text(
                    'Vendedor',
                    style: TextStyle(fontSize: 15, color: Colors.black87),
                  ),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => TelaCadastroVendedor()));
                  },
                ),
              ],
            ),

            ExpansionTile(
              leading: Icon(Icons.search),
              title: Text(
                "Pesquisar",
                style: TextStyle(fontSize: 16),
              ),
              children: <Widget>[
                ListTile(
                  title: Text(
                    'Gerente',
                    style: TextStyle(fontSize: 15, color: Colors.black87),
                  ),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => TelaBuscarGetente()));
                  },
                ),
                ListTile(
                  title: Text(
                    'Vendedor',
                    style: TextStyle(fontSize: 15, color: Colors.black87),
                  ),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => TelaBuscarVendedor()));
                  },
                ),
              ],
            ),
////////////////////////////////////////
          ],
        ),
      ),
      body: Container(
        padding: EdgeInsets.fromLTRB(80, 30, 80, 80),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Image.asset(
                "imagens/logoPreto.png",
              ),

//              Padding(
//                padding: EdgeInsets.all(50),
//                child: FloatingActionButton(
//                  child: Icon(
//                      Icons.search,
//                      color: Colors.white),
//                  backgroundColor: Color(0xff315a7d),
//                ),
//              ),
            ]),
      ),
    );
  }
}
