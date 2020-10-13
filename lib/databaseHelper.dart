import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'cat.dart';

class DatabaseHelper {
  static final _databaseName = "cat.db";
  static final _databaseVersion = 1;

  static final catTable = 'cat';

  static final id = 'id';
  static final catName = 'catName';
  static final catLocation = 'catLocation';
  static final catRating = 'catRating';

  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database _database;
  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await _initDatabase();
    return _database;
  }

  _initDatabase() async {
    String path = join(await getDatabasesPath(), _databaseName);
    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);
  }

  // SQL code to create the database table
  Future _onCreate(Database db, int version) async {
    await db.execute('''
          CREATE TABLE $catTable (
            $id INTEGER PRIMARY KEY AUTOINCREMENT,
            $catName TEXT,
            $catLocation TEXT,
            $catRating TEXT
          )
          ''');
  }

  Future<int> insert(Cat cat) async {
    Database db = await instance.database;
    var res = await db.insert(catTable, cat.toMap());
    return res;
  }

  Future<List<Map<String, dynamic>>> queryAllRows() async {
    Database db = await instance.database;
    var res = await db.query(
      catTable,
    );
    return res;
  }

  Future<Cat> queryWithName(int id) async {
    Database db = await instance.database;
    List<Map> results = await db.query("cat",
        columns: ["id", "catName", "catLocation", "catRating"],
        where: 'id = ?',
        whereArgs: [id]);
    if (results.length > 0) {
      return new Cat.fromMap(results.first);
    }
    return null;
  }

  Future<void> clearTable() async {
    Database db = await instance.database;
    return await db.rawQuery("DELETE FROM $catTable");
  }
}
