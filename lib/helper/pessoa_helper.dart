import 'package:neuronio/model/pessoa.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class PessoaHelper {
  static final PessoaHelper _pessoaHelper = PessoaHelper._internal();

  Database? _db;

  factory PessoaHelper() {
    return _pessoaHelper;
  }

  PessoaHelper._internal() {}

  get db async {
    if (_db != null) {
      return _db;
    } else {
      _db = await inicializarDB();
      return _db;
    }
  }

  _onCreate(Database db, int version) async {
    String sql =
        "CREATE TABLE pessoas(id INTEGER PRIMARY KEY AUTOINCREMENT, nome VARCHAR, data DATETIME)";
    db.execute(sql);
  }

  inicializarDB() async {
    final caminhoBancoDados = await getDatabasesPath();
    final localBancoDados = join(caminhoBancoDados, "pessoas.db");

    var db =
        await openDatabase(localBancoDados, version: 1, onCreate: _onCreate);
    return db;
  }

  recuperarPessoa() async {
    var bancoDados = await db;
    String sql = "SELECT * FROM pessoas ORDER BY DATA DESC";
    List anotacoes = await bancoDados.rawQuery(sql);
    return anotacoes;
  }

  Future<int> salvarPessoa(Pessoa pessoa) async {
    var bancoDados = await db;
    int result = await bancoDados.insert("pessoas", pessoa.toMap());

    return result;
  }

  Future<int> atualizarPessoa(Pessoa pessoa) async {
    var bancoDados = await db;
    return await bancoDados.update("pessoas", pessoa.toMap(),
        where: "id = ?", whereArgs: [pessoa.id]);
  }

  Future<int> removePessoa(int id) async {
    var bancoDados = await db;
    return await bancoDados.delete("pessoas", where: "id = ?", whereArgs: [id]);
  }
}