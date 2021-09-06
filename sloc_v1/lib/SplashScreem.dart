import 'dart:async';

import 'package:Sloc/dados/dbVendedor.dart';
import 'package:flutter/material.dart';

import 'dados/dbGerente.dart';
import 'entidades/gerente.dart';
import 'entidades/vendedor.dart';

class SplashScreem extends StatefulWidget {
  @override
  _SplashScreemState createState() => _SplashScreemState();
}

class _SplashScreemState extends State<SplashScreem> {
  Future<List> _checagemDeLogin() async {
    DbGerente dbGerente = DbGerente();
    List gerentes = await dbGerente.listarGetentes();

    DbVendedor dbVendedor = DbVendedor();
    List vendedores = await dbVendedor.listarVendedores();
    if (!gerentes.isEmpty) {
      return [gerentes[0], 1];
    }
    if (!vendedores.isEmpty) {
      var a = [vendedores[0], 0];
      var b ='a';
      return [vendedores[0], 0];
    }
    if (gerentes.isEmpty && vendedores.isEmpty) {
      return null;
    }
  }

  void _navegarPara(String rota, {Object objeto /*Parâmetro opcional*/
      }) {
    if (objeto == null) {
      Navigator.pushReplacementNamed(context, rota);
    } else {
      Navigator.pushReplacementNamed(context, rota,
          arguments: {"objeto": objeto});
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    Timer(Duration(seconds: 2), () async {
        List resposta = await _checagemDeLogin();
        if (resposta == null) {
          _navegarPara("/Login");
        } else if (resposta[1] == 1) {
          var gerenteBanco = resposta[0];
          var id = gerenteBanco['id'] as int;
          var nome = gerenteBanco['nome'] as String;
          var cpf = gerenteBanco['cpf'] as String;
          var email = gerenteBanco['email'] as String;
          var senha = gerenteBanco['senha'] as String;

          Gerente gerente = new Gerente(nome, cpf, email, senha);
          gerente.id = id;

          _navegarPara("/IndexGerente", objeto: gerente);
        } else if (resposta[1] == 0) {
          var vendedorBanco = resposta[0];
          var id = vendedorBanco['id'] as int;
          var nome = vendedorBanco['nome'] as String;
          var cpf = vendedorBanco['cpf'] as String;
          var email = vendedorBanco['email'] as String;
          var senha = vendedorBanco['senha'] as String;
          var idGerente = vendedorBanco['idGerente'] as int;

          Vendedor vendedor = new Vendedor(nome, cpf, email, senha);
          vendedor.id = id;
          vendedor.idGerente = idGerente;

          _navegarPara("/IndexVendedor", objeto: resposta[0]);
        }
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Color(0xff1e2e3e),
        padding: EdgeInsets.all(90),
        child: Center(
          child: Text(
            "Lembre-se de ativar a localização",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }
}
