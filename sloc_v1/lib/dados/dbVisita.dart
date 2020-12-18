import 'package:Sloc/entidades/visita.dart';
import 'dbPrimario.dart';

/*
Essa classe só é instanciada uma vez pois segue o
padrão Singleton
*/

class DbVisita {
  static final String nomeTabela = "visitas";
  static final DbVisita _dbVisita = DbVisita._internal();
  DbPrimario banco = DbPrimario();

  factory DbVisita() {
    return _dbVisita;
  }

  DbVisita._internal() {}

  //CRUD
  Future<int> cadastrarVisita(Visita visita) async {
    var bancoDados = await banco.db;
    int id = await bancoDados.insert(nomeTabela, visita.toMap());
    return id;
  }

  Future<int> alterarVisita(Visita visita) async {
    var bancoDados = await banco.db;
    return await bancoDados.update(nomeTabela, visita.toMap(),
        where: "id = ?", whereArgs: [visita.id]);
  }

  Future<int> removerVisita(int id) async {
    var bancoDados = await banco.db;
    return await bancoDados
        .delete(nomeTabela, where: "id = ?", whereArgs: [id]);
  }

  listarVisitas() async {
    var bancoDados = await banco.db;
    String sql = "SELECT * FROM $nomeTabela ORDER BY id DESC";
    List visitas = await bancoDados.rawQuery(sql);
    return visitas;
  }

  buscarVisita(String data) async {
    var bancoDados = await banco.db;
    String sql = "SELECT * FROM $nomeTabela WHERE data LIKE '%$data%'";
    List visitas = await bancoDados.rawQuery(sql);
    return visitas;
  }
}
