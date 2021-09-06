import 'package:Sloc/entidades/vendedor.dart';

import 'dbPrimario.dart';

/*
Essa classe só é instanciada uma vez pois segue o
padrão Singleton
*/

class DbVendedor {
  static final String nomeTabela = "vendedores";
  static final DbVendedor _dbVendedor = DbVendedor._internal();
  DbPrimario banco = DbPrimario();

  factory DbVendedor() {
    return _dbVendedor;
  }

  DbVendedor._internal() {}

  //CRUD
  Future<int> cadastrarVendedor(Vendedor vendedor) async {
    var bancoDados = await banco.db;
    int id = await bancoDados.insert(nomeTabela, vendedor.toMap());
    return id;
  }

  Future<int> alterarVendedor(Vendedor vendedor) async {
    var bancoDados = await banco.db;
    return await bancoDados.update(nomeTabela, vendedor.toMap(),
        where: "id = ?", whereArgs: [vendedor.id]);
  }

  Future<int> removerVendedor(int id) async {
    var bancoDados = await banco.db;
    return await bancoDados
        .delete(nomeTabela, where: "id = ?", whereArgs: [id]);
  }

  listarVendedores() async {
    var bancoDados = await banco.db;
    String sql = "SELECT * FROM $nomeTabela ORDER BY id DESC";
    List vendedores = await bancoDados.rawQuery(sql);
    return vendedores;
  }

  buscarVendedor(String vendedorNome) async {
    var bancoDados = await banco.db;
    String sql = "SELECT * FROM $nomeTabela WHERE nome LIKE '%$vendedorNome%'";
    List vendedores = await bancoDados.rawQuery(sql);
    return vendedores;
  }

  deletarVendedores() async {
    var bancoDados = await banco.db;
    String sql = "DROP TABLE $nomeTabela";
    await bancoDados.execute(sql);

    sql = "CREATE TABLE gerentes (id INTEGER PRIMARY KEY AUTOINCREMENT," +
        " nome VARCHAR, cpf VARCHAR, email VARCHAR, senha VARCHAR);";
    await bancoDados.rawQuery(sql);

    sql =
        "CREATE TABLE $nomeTabela (id INTEGER PRIMARY KEY AUTOINCREMENT, nome VARCHAR," +
            " cpf VARCHAR, email VARCHAR, senha VARCHAR, gerente INTEGER);";
    await bancoDados.rawQuery(sql);
  }
}
