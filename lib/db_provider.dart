import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:tasklist/task_card_entity.dart';

class DBProvider {
  static late Database _database;

  Future<Database> get database async {
    _database = await initDB();
    return _database;
  }

  Future<Database> initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();

    String path = join(documentsDirectory.path, "taskcard_database.db");

    return await openDatabase(path, version: 1, onCreate: _createTable);
  }

  Future<void> _createTable(Database db, int version) async {
    return await db.execute(
      "CREATE TABLE task(id INTEGER PRIMARY KEY AUTOINCREMENT, taskName TEXT, limitDate TEXT, priority TEXT)",
    );
  }

  Future<void> insertTaskCard(TaskCardEntity task) async {
    try {
      final Database db = await database;
      await db.insert(
        'task',
        task.toMap(),
        conflictAlgorithm: ConflictAlgorithm.fail,
      );
    } catch (e) {
      print(e);
    }
  }

  Future<void> deleteTaskCard(TaskCardEntity task) async {
    try {
      final Database db = await database;
      await db.delete(
        'task',
        where: "id = ?",
        whereArgs: [task.id],
      );
    } catch (e) {
      print(e);
    }
  }

  Future<List<TaskCardEntity>> selectAll() async {
    final Database db = await database;
    final List<Map<String, dynamic>> res = await db.query('task');
    print(res);
    return List.generate(res.length, (i) {
      return TaskCardEntity(
        id: res[i]['id'],
        taskName: res[i]['taskName'],
        limitDate: res[i]['limitDate'],
        priority: res[i]['priority'],
      );
    });
  }
}
