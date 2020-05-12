import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:v1/entidades/vendedor.dart';

/*
Essa classe só é instanciada uma vez pois segue o
padrão Singleton
*/

class DbVendedor{

  static final String nomeTabela = "vendedores";
  static final DbVendedor _dbVendedor = DbVendedor._internal();
  Database _db;

  factory DbVendedor(){
    return _dbVendedor;
  }

  DbVendedor._internal(){
  }

  //criar tabela vendedores
  _onCreate( Database db, int version) async {
    String sql = "CREATE TABLE vendedores (id INTEGER PRIMARY KEY AUTOINCREMENT, nome VARCHAR, cpf VARCHAR, email VARCHAR, senha VARCHAR, idGerente INTERGER, CONSTRAINT vendedores_gerentes_FK FOREIGN KEY (idGerente) REFERENCES gerentes (id));";
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
  Future<int> cadastrarVendedor(Vendedor vendedor) async{

    var bancoDados = await db;
    int id = await bancoDados.insert(nomeTabela, vendedor.toMap());
    return id;
  }

}