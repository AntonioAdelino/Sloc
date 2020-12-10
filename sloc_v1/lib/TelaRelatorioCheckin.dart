import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

telaCheckin(context, distancia) {
  if (distancia > 100) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
              "Atenção!",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xff1e2e3e),
              ),
            ),
            content: Text(
              "Você está a mais de 100 metros deste lugar. Tem certeza que deseja realizar o Checkin?",
              style: TextStyle(
                color: Color(0xff1e2e3e),
              ),
            ),
            actions: <Widget>[
              FlatButton(
                color: Colors.grey,
                textColor: Colors.white,
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text("Continuar"),
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
  } else {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
              "Você chegou ao destino!",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xff1e2e3e),
              ),
            ),
            content: Text(
              "Você já pode fazer o Checkin, deseja realizar agora?",
              style: TextStyle(
                color: Color(0xff1e2e3e),
              ),
            ),
            actions: <Widget>[
              FlatButton(
                color: Colors.grey,
                textColor: Colors.white,
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text("Cancelar"),
              ),
              FlatButton(
                color: Colors.green,
                textColor: Colors.white,
                onPressed: () => Navigator.pop(context),
                child: Text("Continuar"),
              ),
            ],
          );
        });
  }
}
