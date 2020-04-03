import 'package:flutter/material.dart';
class TelaSecundaria extends StatefulWidget {
  @override
  _TelaSecundariaState createState() => _TelaSecundariaState();
}

class _TelaSecundariaState extends State<TelaSecundaria> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Sloc"),
        backgroundColor: Color(0xff315a7d),
      ),
      body: Container(
        padding: EdgeInsets.all(32),
        child: ListView(

          children: <Widget>[

          Text("Nome:",
          textAlign: TextAlign.left,
          style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black54
          ),
        ),

          Text("CPF:",
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black54
            ),
          ),

          Text("Email:",
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black54
            ),
          ),

          Text("Senha:",
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black54
            ),
          ),

          Text("Confirmar senha:",
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black54
            ),
          ),
          FlatButton(
            color: Colors.green,
            onPressed: null,
            child: Text("Salvar",
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black54
              ),
            ),

          ),
        ]
          ),
      ),
    );
  }
}
