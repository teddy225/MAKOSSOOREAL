import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as p;

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() {
    return _instance;
  }

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = p.join(dbPath, 'fil_actualite.db');
    print("Création de la base de données et des tables");

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE fil_actualite(
            id INTEGER PRIMARY KEY,
            uid TEXT,
            type TEXT,
            title TEXT,
            description TEXT,
            url TEXT,
            is_feeded INTEGER,
            created_at TEXT,
            updated_at TEXT
          );
         
        ''');
      },
    );
  }

  // Insérer dans 'fil_actualite'
  Future<void> insertFilActualite(List<Map<String, dynamic>> data) async {
    final db = await database;
    await db.transaction((txn) async {
      for (var item in data) {
        await txn.insert(
          'fil_actualite',
          item,
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }
    });
  }

  // Récupérer les données de 'fil_actualite'
  Future<List<Map<String, dynamic>>> getFilActualite() async {
    final db = await database;
    return await db.query('fil_actualite');
  }
}
