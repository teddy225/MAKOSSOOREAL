import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as p;
import 'dart:async';

class DatabaseHelper {
  static const _databaseName = 'app_database.db';
  static const _databaseVersion = 1;

  static Database? _database;

  // Singleton
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = p.join(dbPath, _databaseName);

    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE cache_meta (
        id INTEGER PRIMARY KEY,
        timestamp INTEGER
      )
    ''');

    await db.execute('''
      CREATE TABLE fil_actualite (
         id INTEGER PRIMARY KEY,
         uid TEXT,
         type TEXT,
         title TEXT,
         description TEXT,
         url TEXT,
         is_feeded INTEGER,
         created_at TEXT,
         updated_at TEXT,
         timestamp INTEGER
      )
    ''');
  }

  // Récupérer l'âge du cache
  Future<Duration> getCacheAge() async {
    final lastCacheTimestamp = await getLastCacheTimestamp();
    if (lastCacheTimestamp == 0) {
      return Duration(hours: 9999);
    }
    final now = DateTime.now().millisecondsSinceEpoch;
    final cacheAge = now - lastCacheTimestamp;
    return Duration(milliseconds: cacheAge);
  }

  // Récupérer le dernier timestamp du cache
  Future<int> getLastCacheTimestamp() async {
    final db = await database;
    try {
      final result =
          await db.rawQuery('SELECT timestamp FROM cache_meta LIMIT 1');
      if (result.isNotEmpty && result.first['timestamp'] != null) {
        return result.first['timestamp'] as int;
      } else {
        return 0;
      }
    } catch (e) {
      print('Erreur lors de la récupération du timestamp du cache: $e');
      return 0;
    }
  }

  // Mettre à jour le timestamp du cache
  Future<void> updateCacheTimestamp() async {
    final db = await database;
    try {
      final now = DateTime.now().millisecondsSinceEpoch;
      await db.rawInsert(
        'INSERT OR REPLACE INTO cache_meta (id, timestamp) VALUES (1, ?)',
        [now],
      );
    } catch (e) {
      print('Erreur lors de la mise à jour du timestamp du cache: $e');
    }
  }

  // Insérer des données dans la table `fil_actualite`
  Future<void> insertFilActualite(List<Map<String, dynamic>> posts) async {
    final db = await database;
    final batch = db.batch();
    final currentTimestamp = DateTime.now().millisecondsSinceEpoch;

    for (var post in posts) {
      post['timestamp'] = currentTimestamp;
      batch.insert(
        'fil_actualite',
        post,
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
    await batch.commit(noResult: true);
  }

  // Récupérer les données de la table `fil_actualite`
  Future<List<Map<String, dynamic>>> getFilActualite() async {
    final db = await database;
    return await db.query('fil_actualite');
  }
}
