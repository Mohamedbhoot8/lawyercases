import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBHelper {
  static Database? _db;

  Future<Database?> get db async {
    if (_db == null) {
      _db = await intialDB();
      return _db;
    } else {
      return _db;
    }
  }

  intialDB() async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'lawyer_cases.db');
    Database mydb = await openDatabase(path,
        onCreate: _oncraete, version: 1, onUpgrade: _onUpgrade);
    return mydb;
  }

  _oncraete(Database db, int version) async {
    Batch batch = db.batch();
    batch.execute('''
      CREATE TABLE cases(
      "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT , 
      "name1" TEXT NOT NULL, 
      "name2" TEXT NOT NULL,
      "date" TEXT NOT NULL,
      "details" TEXT NOT NULL,
      "case_number" TEXT NOT NULL,
      "court_name" TEXT NOT NULL,
      "client_phone" TEXT NOT NULL
      )
      ''');
    batch.execute('''
      CREATE TABLE  lawyer (
      "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT , 
      "name" TEXT NOT NULL, 
      "email" TEXT NOT NULL,
      "phone" TEXT NOT NULL,
      "imagePath" TEXT NOT NULL
      )
      ''');
    batch.execute('''
      CREATE TABLE dontknow(
      "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT , 
      "name1" TEXT NOT NULL, 
      "name2" TEXT NOT NULL,
      "claim" TEXT NOT NULL,
      "ruling" TEXT NOT NULL,
      "confinement" TEXT NOT NULL,
      "details" TEXT NOT NULL
      )
      ''');

    await batch.commit();
    // ignore: avoid_print
    print(
        "========================== CREAT DATA BASE ===========================");
  }

  _onUpgrade(Database db, int oldVersion, int newVersion) async {
    // ignore: avoid_print
    print("=================== ONUPGRADE===============");

    /* await db.execute('''
    ALTER TABLE NOTES ADD COLUMN title TEXT
''');*/
  }

  Future<List<Map<String, dynamic>>> getCases(String sql) async {
    Database? mydb = await db;
    final response = await mydb!.rawQuery(sql);

    return List<Map<String, dynamic>>.from(
      response.map((e) => Map<String, dynamic>.from(e)),
    );
  }

  insertCase(String sql) async {
    Database? mydb = await db;
    int response = await mydb!.rawInsert(sql);
    return response;
  }

  updateCase(String sql) async {
    Database? mydb = await db;
    int response = await mydb!.rawUpdate(sql);
    return response;
  }

  deletCase(String sql) async {
    Database? mydb = await db;
    int response = await mydb!.rawDelete(sql);
    return response;
  }

  Future<int> deletecasee(String table, int id) async {
    Database? mydb = await db;
    return await mydb!.delete(
      table,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<List<Map<String, dynamic>>> getTodayCases(DateTime date) async {
    final dbClient = await db;
    final todayStr = DateFormat('yyyy-MM-dd').format(date);
    return await dbClient!.query(
      'cases',
      where: 'date = ?',
      whereArgs: [todayStr],
    );
  }

  Future<List<Map<String, dynamic>>> searchCases(String sql) async {
    Database? mydb = await db;
    List<Map<String, dynamic>> response = await mydb!.rawQuery(sql);
    return response;
  }

  // layer
  getlayer(String sql) async {
    Database? mydb = await db;
    List<Map> response = await mydb!.rawQuery(sql);
    return response;
  }

  insertlayer(String sql) async {
    Database? mydb = await db;
    int response = await mydb!.rawInsert(sql);
    return response;
  }

  updatelayer(String sql) async {
    Database? mydb = await db;
    int response = await mydb!.rawUpdate(sql);
    return response;
  }

  deletlayer(String sql) async {
    Database? mydb = await db;
    int response = await mydb!.rawDelete(sql);
    return response;
  }

  Future<Map<String, dynamic>?> getLawyer() async {
    final dbClient = await db;
    final result = await dbClient!.query('lawyer');
    if (result.isNotEmpty) {
      return result.first;
    } else {
      return null;
    }
  }   
  // dontknow 
   insertdontknow(String sql) async {
    Database? mydb = await db;
    int response = await mydb!.rawInsert(sql);
    return response;
  }

  deletdb() async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'lawyer_cases.db');
    if (_db != null) {
      await _db!.close();
      _db = null;
    }
    await deleteDatabase(path);
  }
}
