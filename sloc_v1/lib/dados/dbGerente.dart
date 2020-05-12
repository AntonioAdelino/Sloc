import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:v1/entidades/gerente.dart';

/*
Essa classe só é instanciada uma vez pois segue o
padrão Singleton
*/
class DbGerente {

  static final String nomeTabela = "gerentes";
  static final DbGerente _dbGerente = DbGerente._internal();
  Database _db;

  factory DbGerente(){
    return _dbGerente;
  }

  DbGerente._internal(){
  }

  //criar tabela gerentes
  _onCreate( Database db, int version) async {
    String sql = "CREATE TABLE $nomeTabela (id INTEGER PRIMARY KEY AUTOINCREMENT,"+
        " nome VARCHAR, cpf VARCHAR, email VARCHAR, senha VARCHAR);";
    await db.execute(sql);

    sql = "CREATE TABLE vendedores (id INTEGER PRIMARY KEY AUTOINCREMENT, nome VARCHAR, cpf VARCHAR, email VARCHAR, senha VARCHAR, idGerente INTERGER, CONSTRAINT vendedores_gerentes_FK FOREIGN KEY (idGerente) REFERENCES gerentes (id));";
    await db.execute(sql);

  }

  //inicializar banco de dados
  inicializarDB() async{
    final caminho = await getDatabasesPath();
    final local = join( caminho, "bancoSloc.db");

    var db = await openDatabase(local, version: 1, onCreate: _onCreate );
    return db;
  }

  //get db (banco)
  get db async {
    //se já existir retorna db, se não existir cria db
    if( _db != null){
      return _db;
    }else{
      _db = await inicializarDB();
      return _db;
    }
  }

  //CRUD
  Future<int> cadastrarGerente(Gerente gerente) async{

    var bancoDados = await db;
    int id = await bancoDados.insert(nomeTabela, gerente.toMap());
    return id;
  }

  Future<int> alterarGerente(Gerente gerente) async{

    var bancoDados = await db;
    return await bancoDados.update(
      nomeTabela,
      gerente.toMap(),
      where: "id = ?",
      whereArgs: [gerente.id]

    );



  }

  Future<int> removerGerente( int id) async {

    var bancoDados = await db;
    return await bancoDados.delete(
      nomeTabela,
      where: "id = ?",
      whereArgs: [id]
    );
  }

  listarGetentes() async {

    var bancoDados = await db;
    String sql = "SELECT * FROM $nomeTabela ORDER BY id DESC";
    List gerentes = await bancoDados.rawQuery(sql);
    return gerentes;
  }

  buscarGerente(String gerenteNome) async {
    var bancoDados = await db;
    String sql = "SELECT * FROM $nomeTabela WHERE nome LIKE '%$gerenteNome%'";
    List gerentes = await bancoDados.rawQuery(sql);
    print("\n\n"+gerentes.toString());
    return gerentes;
  }

}
//json estrutura de dados padrão