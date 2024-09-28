import 'package:daily_planner/model/task.dart';
import 'package:daily_planner/model/user.dart';
import 'package:daily_planner/provider/taskprovider.dart';
import 'package:daily_planner/provider/userprovider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  static Database? _database;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, 'database_19.db');
    print("Đường dẫn database: $databasePath");
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
  CREATE TABLE IF NOT EXISTS "user" (
    "id" INTEGER PRIMARY KEY AUTOINCREMENT,
    "email" TEXT,
    "name" TEXT,
    "password" TEXT,
    "role" INTEGER
  );
  ''');

    await db.execute('''
  CREATE TABLE IF NOT EXISTS "task" (
    "id" INTEGER PRIMARY KEY AUTOINCREMENT,
    "user" INTEGER,
    "day" TEXT,
    "title" TEXT,
    "location" TEXT,
    "preside" TEXT,
    "status" TEXT,
    "startTime" TEXT,
    "endTime" TEXT,
    "note" TEXT,
    "approver" INTEGER
  );
  ''');

    await db.execute('''
  CREATE TABLE IF NOT EXISTS "notification" (
    "id" INTEGER PRIMARY KEY AUTOINCREMENT,
    "user" INTEGER,
    "content" TEXT,
    "dateCreate" TEXT
  );
  ''');
  }

  Future<int> getNextAvailableId(String tableName) async {
    final db = await database;
    List<int> existingIds = [];

    List<Map<String, dynamic>> idList =
        await db.rawQuery('SELECT id FROM $tableName ORDER BY id');
    idList.forEach((element) {
      existingIds.add(element['id']);
    });

    int nextId = 1;
    for (int i = 0; i < existingIds.length; i++) {
      if (existingIds[i] != nextId) {
        break;
      }
      nextId++;
    }

    return nextId;
  }

  Future<void> LoadUser() async {
    final db = await database;
    // Load JSON data and insert into the database
    List<User> user = await ReadDataUser().loadData();
    await ReadDataUser().insertUserToDB(db, user);

    // Verify data insertion
    List<Map<String, dynamic>> maps = await db.query('user');
    for (var map in maps) {
      print(map);
    }
  }

  Future<void> LoadTask() async {
    final db = await database;
    // Load JSON data and insert into the database
    List<Task> task = await ReadDataTask().loadData();
    await ReadDataTask().insertUserToDB(db, task);

    // Verify data insertion
    List<Map<String, dynamic>> maps = await db.query('task');
    for (var map in maps) {
      print(map);
    }
  }

  // --------------[USER]
  // Create
  Future<void> insertUser(User user) async {
    final db = await database;
    int nextId = await getNextAvailableId('user');
    user.id = nextId;

    await db.insert('user', user.toMap());
  }

  // Get User
  Future<List<User>> getAllUser() async {
    final db = await database;
    List<Map<String, dynamic>> results = await db.query('user');

    return results.map((map) => User.fromMap(map)).toList();
  }

  // Get user by role
  Future<List<User>> getAllUserByRole(int role) async {
    final db = await database;
    List<Map<String, dynamic>> results = await db.query(
      'user',
      where: 'role = ?',
      whereArgs: [role],
    );

    return results.map((map) => User.fromMap(map)).toList();
  }

  // Read user by ID
  Future<User?> getUserById(int id) async {
    final db = await database;
    List<Map<String, dynamic>> results =
        await db.query('user', where: 'id = ?', whereArgs: [id]);
    if (results.isNotEmpty) {
      return User.fromMap(results.first);
    }
    return null;
  }

  // Update
  Future<void> updateUser(User user) async {
    final db = await database;
    await db
        .update('user', user.toMap(), where: 'id = ?', whereArgs: [user.id]);
  }

  // Delete
  Future<void> deleteUser(int id) async {
    final db = await database;
    await db.delete('user', where: 'id = ?', whereArgs: [id]);
  }

  // --------------[TASK]
  // Create
  Future<void> insertTask(Task task) async {
    final db = await database;
    int nextId = await getNextAvailableId('task');
    task.id = nextId;

    await db.insert('task', task.toMap());
  }

  // Get ALL TASK For User
  Future<List<Task>> getTasksOfUser(int? userId) async {
    final db = await database;

    List<Map<String, dynamic>> results = await db.query(
      'task',
      where: 'user = ?',
      whereArgs: [userId],
    );

    if (results.isNotEmpty) {
      return results.map((task) => Task.fromMap(task)).toList();
    }

    return [];
  }

  // Read customer by ID
  Future<Task?> getTaskById(int id) async {
    final db = await database;
    List<Map<String, dynamic>> results =
        await db.query('task', where: 'id = ?', whereArgs: [id]);
    if (results.isNotEmpty) {
      return Task.fromMap(results.first);
    }
    return null;
  }

  // Update
  Future<void> updateTask(Task task) async {
    final db = await database;
    await db
        .update('task', task.toMap(), where: 'id = ?', whereArgs: [task.id]);
  }

  // Delete
  Future<void> deleteTask(int id) async {
    final db = await database;
    await db.delete('task', where: 'id = ?', whereArgs: [id]);
  }
}
