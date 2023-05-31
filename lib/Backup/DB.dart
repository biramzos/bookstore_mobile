import 'dart:io';
import 'package:Bookstore/Backup/Data.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DB{

  static final DB _instance = DB.internal();

  factory DB() => _instance;
  static Database? _db;

  Future<Database> get db async {
    if (_db != null) {
      return _db!;
    } else {
      _db = await initDB();
      return _db!;
    }
  }

  DB.internal();

  static initDB() async{
      Directory documentDirectory = await getApplicationDocumentsDirectory();
      String path = join(documentDirectory.path, "backup.db");
      var ourDb = await openDatabase(path, version: 1, onCreate: onCreate);
      return ourDb;
  }

  static void onCreate(Database db, int version) async =>
      await db.execute("CREATE TABLE USER ("
          "id INTEGER PRIMARY KEY,"
          "username TEXT,"
          "token TEXT"
          ")");

  static createUser (Data user) async {
    final db = await DB().db;
    var res = await db.insert("USER", user.toJson());
    return res;
  }

  static readUser (int id) async {
    final db = await DB().db;
    var res = await db.query("USER", where: "id = ?", whereArgs: [id]);
    return res.isNotEmpty ? (Data.fromJson(res.first)) : (null);
  }

  static updateUser (Data user) async {
    final db = await DB().db;
    var res = await db.update("USER", user.toJson(),
        where: "id = ?", whereArgs: [user.id]);
    return res;
  }

  static deleteUser (int id) async {
    final db = await DB().db;
    await db.delete("USER", where: "id = ?", whereArgs: [id]);
  }

  static deleteAllUser () async {
    final db = await DB().db;
    await db.rawQuery("delete from USER");
  }

  static queryRowCount() async {
    final db = await DB().db;
    final result = await db.rawQuery('SELECT COUNT(*) FROM USER');
    return Sqflite.firstIntValue(result);
  }

  static readAll() async {
    final db = await DB().db;
    final results = await db.query('USER');
    return results;
  }
}