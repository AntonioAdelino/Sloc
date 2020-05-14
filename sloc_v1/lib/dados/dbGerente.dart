import 'package:v1/dados/dbPrimario.dart';
import 'package:v1/entidades/gerente.dart';

/*
Essa classe só é instanciada uma vez pois segue o
padrão Singleton
*/
class DbGerente {
  static final String nomeTabela = "gerentes";
  static final DbGerente _dbGerente = DbGerente._internal();
  DbPrimario banco = DbPrimario();

  factory DbGerente() {
    return _dbGerente;
  }

  DbGerente._internal() {}

  //CRUD
  Future<int> cadastrarGerente(Gerente gerente) async {
    var bancoDados = await banco.db;
    int id = await bancoDados.insert(nomeTabela, gerente.toMap());
    return id;
  }

  Future<int> alterarGerente(Gerente gerente) async {
    var bancoDados = await banco.db;
    return await bancoDados.update(nomeTabela, gerente.toMap(),
        where: "id = ?", whereArgs: [gerente.id]);
  }

  Future<int> removerGerente(int id) async {
    var bancoDados = await banco.db;
    return await bancoDados
        .delete(nomeTabela, where: "id = ?", whereArgs: [id]);
  }

  listarGetentes() async {
    var bancoDados = await banco.db;
    String sql = "SELECT * FROM $nomeTabela ORDER BY id DESC";
    List gerentes = await bancoDados.rawQuery(sql);
    return gerentes;
  }

  buscarGerente(String gerenteNome) async {
    var bancoDados = await banco.db;
    String sql = "SELECT * FROM $nomeTabela WHERE nome LIKE '%$gerenteNome%'";
    List gerentes = await bancoDados.rawQuery(sql);
    print("\n\n" + gerentes.toString());
    return gerentes;
  }
}
