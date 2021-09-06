import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

/*
Essa classe só é instanciada uma vez pois segue o
padrão Singleton
*/
class DbPrimario {
  static final DbPrimario _dbPrimario = DbPrimario._internal();
  Database _db;

  factory DbPrimario() {
    return _dbPrimario;
  }

  DbPrimario._internal() {}

  //criar tabelas
  _onCreate(Database db, int version) async {
    //tabela gerentes
    String sql =
        "CREATE TABLE gerentes (id INTEGER PRIMARY KEY AUTOINCREMENT," +
            " nome VARCHAR, cpf VARCHAR, email VARCHAR, senha VARCHAR);";
    await db.execute(sql);

    //tabela vendedores
    sql = "CREATE TABLE vendedores (id INTEGER PRIMARY KEY AUTOINCREMENT, nome VARCHAR," +
        " cpf VARCHAR, email VARCHAR, senha VARCHAR, gerente INTEGER);";
    //criação do banco estruturado segue o sql com a linha abaixo
    //+ " FOREIGN KEY (idGerente) REFERENCES gerentes (id) ON DELETE CASCADE);";
    await db.execute(sql);

    //tabela profissionais
    sql = "CREATE TABLE IF NOT EXISTS profissionais (id INTEGER PRIMARY KEY AUTOINCREMENT, idPlace VARCHAR," +
        " nome VARCHAR, endereco VARCHAR, contato VARCHAR, avaliacao VARCHAR, lat VARCHAR, long VARCHAR);";
    await db.execute(sql);

    //tabela visitas
    sql =
        "CREATE TABLE IF NOT EXISTS visitas (id INTEGER PRIMARY KEY AUTOINCREMENT, idVendedor INTEGER," +
            " idProfissional INTEGER, data VARCHAR, distanciaCheckin INTEGER, " +
            " FOREIGN KEY (idVendedor) REFERENCES vendedores (id)," +
            " FOREIGN KEY (idProfissional) REFERENCES profissionais (id)); ";
    await db.execute(sql);
  }

  _onConfigure(Database db) async {
    await db.execute('PRAGMA foreign_keys = ON');
  }

  //inicializar banco de dados
  inicializarDB() async {
    final caminho = await getDatabasesPath();
    final local = join(caminho, "bancoSloc.db");

    var db = await openDatabase(local,
        version: 1, onCreate: _onCreate, onConfigure: _onConfigure);
    return db;
  }

  //get db (banco)
  get db async {
    //se já existir retorna db, se não existir cria db
    if (_db != null) {
      return _db;
    } else {
      _db = await inicializarDB();
      return _db;
    }
  }
}
