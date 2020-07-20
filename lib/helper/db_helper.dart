import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:io' as io;
import 'package:path/path.dart';
import 'package:sqlite_app/model/mynote_model.dart';

class DbHelper {
  static final DbHelper _instance = new DbHelper.internal();
  DbHelper.internal();
  factory DbHelper() {
    return _instance;
  }
  static Database _db;

  Future<Database> get db async {
    if (_db != null) return _db;
    _db = await setDb();
    return _db;
  }

  setDb() async {
    io.Directory directory = await getApplicationDocumentsDirectory();
    String path = join(directory.path, "SimpleNoteDb");
    var db = await openDatabase(path, version: 1, onCreate: _onCreate);
    return db;
  }

  void _onCreate(Database database, int version) async {
    await database.execute(
        "CREATE TABLE mynote(id INTEGER PRIMARY KEY, title TEXT, note TEXT, createDate TEXT, updateDate TEXT, sortDate TEXT)");
    print("database created");
  }

  Future<int> saveData(MyNote myNote) async {
    var dbClient = await db;
    int res = await dbClient.insert("mynote", myNote.toMap());
    print("data inserted");
    return res;
  }
  
  Future<bool> upadteData(MyNote note) async{
    var dbClient = await db;
    int res = await dbClient.update("mynote", note.toMap(), where: "id=?", whereArgs: <int>[note.id]);
    return res > 0 ? true : false;
  }

  Future<int> deleteData(MyNote myNote) async{
    var dbClient=await db;
    int res= await dbClient.rawDelete("DELETE FROM mynote WHERE id= ?", [myNote.id]);
    return res;
  }

  Future<List<MyNote>> getList() async {
    var dbClient = await db;
    List<Map> list = await dbClient.rawQuery("SELECT * FROM mynote ORDER BY sortDate DESC");
    List<MyNote> listData = new List();
    for (int i = 0; i < list.length; i++) {
      var note = new MyNote(list[i]['title'], list[i]['note'],
          list[i]['createDate'], list[i]['updateDate'], list[i]['sortDate']);
      note.setId(list[i]['id']);
      listData.add(note);
    }
    return listData;
  }

}
