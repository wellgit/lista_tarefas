import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:lista_tarefas/entity/task.dart';

class TaskRepository {
  static final TaskRepository _instance = TaskRepository.internal();

  factory TaskRepository() => _instance;

  TaskRepository.internal();

  Database? _db = null;

  Future<Database?> get db async {
    if (_db != null) {
      return _db;
    } else {
      _db = await initDb();
      return _db;
    }
  }

  Future<Database> initDb() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, "todo_list.db");

    return openDatabase(path, version: 1,
        onCreate: (Database db, int newerVersion) async {
      await db.execute("CREATE TABLE task("
          "id INTEGER PRIMARY KEY  NOT NULL, "
          "title TEXT, "
          "isDone INTEGER)");
    });
  }

  Future<int?> getCount() async {
    Database? database = await db;
    return Sqflite.firstIntValue(
        await database!.rawQuery("SELECT COUNT(*) FROM task"));
  }

  Future close() async {
    Database? database = await db;
    database?.close();
  }

  Future<Task> save(Task task) async {
    Database? database = await db;
    task.id = await database!.insert(
      'task',
      task.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return task;
  }

  Future<Task?> getById(int id) async {
    Database? database = await db;
    List<Map> maps = await database!.query('task',
        columns: ['id', 'title', 'isDone'], where: 'id = ?', whereArgs: [id]);

    if (maps.isNotEmpty) {
      return Task.fromMap(maps.first as Map<String, dynamic>);
    } else {
      return null;
    }
  }

  Future<int> delete(int id) async {
    Database? database = await db;
    return await database!.delete('task', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> deleteAll() async {
    Database? database = await db;
    return await database!.rawDelete("DELETE * from task");
  }

  Future<int> update(Task task) async {
    Database? database = await db;
    return await database!
        .update('task', task.toMap(), where: 'id = ?', whereArgs: [task.id]);
  }

  Future<List<Task>> getAll() async {
    Database? database = await db;
    List listMap = await database!.rawQuery("SELECT * FROM task");
    List<Task> stuffList = listMap.map((x) => Task.fromMap(x)).toList();
    return stuffList;
  }
}
