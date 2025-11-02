import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DBHelper {
  static Database? _db;
  static const _dbName = 'database_zikirler.db';
  static const _dbVersion = 1;

  static Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDB();
    return _db!;
  }

  static Future<Database> _initDB() async {
    Directory docDir = await getApplicationDocumentsDirectory();
    String path = join(docDir.path, _dbName);

    // If an asset DB exists, copy it first (safe)
    final exists = await File(path).exists();
    if (!exists) {
      try {
        final data = await rootBundle.load('assets/$_dbName');
        final bytes = data.buffer.asUint8List();
        await File(path).writeAsBytes(bytes, flush: true);
      } catch (_) {
        // no prepackaged DB in assets — next openDatabase will create tables in onCreate
      }
    }

    return await openDatabase(path, version: _dbVersion, onCreate: _onCreate);
  }

  static Future<void> _onCreate(Database db, int version) async {
    // minimal safe tables if no DB exists; these match original structure names where possible
    await db.execute('''
      CREATE TABLE IF NOT EXISTS zikirler (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        baslik TEXT,
        icerik TEXT,
        foto TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS gunluk_hedefler (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        metin TEXT,
        hedef INTEGER,
        sayac INTEGER
      )
    ''');
  }

  // basic helpers
  static Future<List<Map<String, dynamic>>> queryAll(String table) async {
    final db = await database;
    return await db.query(table);
  }

  static Future<int> insert(String table, Map<String, dynamic> row) async {
    final db = await database;
    return await db.insert(table, row);
  }

  static Future<int> update(String table, Map<String, dynamic> row, int id) async {
    final db = await database;
    return await db.update(table, row, where: 'id = ?', whereArgs: [id]);
  }

  static Future<int> delete(String table, int id) async {
    final db = await database;
    return await db.delete(table, where: 'id = ?', whereArgs: [id]);
  }
}
