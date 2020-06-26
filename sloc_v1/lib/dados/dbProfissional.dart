import 'package:Sloc/dados/dbPrimario.dart';
import 'package:Sloc/entidades/profissional.dart';

/*
Essa classe só é instanciada uma vez pois segue o
padrão Singleton
*/

class DbProfissional {
  static final String nomeTabela = "profissionais";
  static final DbProfissional _DbProfissional = DbProfissional._internal();
  DbPrimario banco = DbPrimario();

  factory DbProfissional() {
    return _DbProfissional;
  }

  DbProfissional._internal() {}

  //CRUD
  Future<int> cadastrarProfissional(Profissional profissional) async {
    var bancoDados = await banco.db;
    int id = await bancoDados.insert(nomeTabela, profissional.toMap());
    return id;
  }

  Future<int> alterarProfissional(Profissional profissional) async {
    var bancoDados = await banco.db;
    return await bancoDados.update(nomeTabela, profissional.toMap(),
        where: "id = ?", whereArgs: [profissional.id]);
  }

  Future<int> removerProfissional(int id) async {
    var bancoDados = await banco.db;
    return await bancoDados
        .delete(nomeTabela, where: "id = ?", whereArgs: [id]);
  }

  listarProfissionais() async {
    var bancoDados = await banco.db;
    String sql = "SELECT * FROM $nomeTabela ORDER BY id DESC";
    List profissionais = await bancoDados.rawQuery(sql);
    return profissionais;
  }

  buscarProfissional(String profissionalIdPlace) async {
    var bancoDados = await banco.db;
    String sql = "SELECT * FROM $nomeTabela WHERE idPlace LIKE '%$profissionalIdPlace%'";
    List profissionais = await bancoDados.rawQuery(sql);
    print("\n\n" + profissionais.toString());
    return profissionais;
  }

}