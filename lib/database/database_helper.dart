import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('foods.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE foods (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        price TEXT NOT NULL,
        unit TEXT NOT NULL,
        image TEXT NOT NULL
      )
    ''');
  }

  Future<int> insertFood(Map<String, dynamic> food) async {
    final db = await instance.database;
    return await db.insert('foods', food);
  }

  Future<List<Map<String, dynamic>>> fetchFoods() async {
    final db = await instance.database;
    return await db.query('foods');
  }

  Future<int> updateFood(Map<String, dynamic> food) async {
    final db = await instance.database;
    return await db.update('foods', food, where: 'id = ?', whereArgs: [food['id']]);
  }

  Future<int> deleteFood(int id) async {
    final db = await instance.database;
    return await db.delete('foods', where: 'id = ?', whereArgs: [id]);
  }

  
}
