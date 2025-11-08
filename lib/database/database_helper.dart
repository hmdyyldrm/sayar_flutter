import 'dart:io';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static const _databaseName = "database_zikirler.db";
  static const _databaseVersion = 1;

  // Column name constants (used across the app)
  static const columnId = 'id';
  static const columnBaslik = 'baslik';
  static const columnZikir = 'zikir';
  static const columnIcerik = 'icerik';
  static const columnFoto = 'foto';
  static const columnHedef = 'hedef';
  static const columnSayac = 'sayac';
  static const columnBugunSayac = 'bugun_sayac';
  static const columnToplam = 'toplam';
  static const columnBaslangicTarih = 'baslangic_tarih';
  static const columnGuncellemeTarih = 'guncelleme_tarih';
  static const columnGecmis = 'gecmis';
  static const columnBildirimSaati = 'bildirim_saati';

  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();
  static Database? _database;

  DatabaseHelper._privateConstructor();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbDir = await getDatabasesPath();
    final newPath = join(dbDir, _databaseName);

    await _tryMigrateOldDatabase(newPath);

    return await openDatabase(
      newPath,
      version: _databaseVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE zikirler (
        id INTEGER PRIMARY KEY,
        baslik TEXT,
        zikir TEXT,
        foto TEXT,
        hedef TEXT,
        sayac TEXT,
        bugun_sayac TEXT,
        toplam TEXT,
        baslangic_tarih TEXT,
        guncelleme_tarih TEXT,
        gecmis TEXT,
        bildirim_saati TEXT
      )
    ''');
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    final cols = (await db.rawQuery("PRAGMA table_info(zikirler)"))
        .map((e) => e["name"])
        .toList();
    final extras = {
      "gecmis": "TEXT",
      "bildirim_saati": "TEXT",
    };
    for (final entry in extras.entries) {
      if (!cols.contains(entry.key)) {
        await db.execute("ALTER TABLE zikirler ADD COLUMN ${entry.key} ${entry.value}");
      }
    }
  }

  /// 🔥 Yeni: eski DB'yi arar ve taşır
  Future<void> _tryMigrateOldDatabase(String newPath) async {
    try {
      final possiblePaths = [
        "/data/data/com.sayar.rana.sayar/databases/$_databaseName",
        "/data/user/0/com.sayar.rana.sayar/databases/$_databaseName",
        "/storage/emulated/0/Android/data/com.sayar.rana.sayar/databases/$_databaseName",
      ];

      for (final path in possiblePaths) {
        final file = File(path);
        if (await file.exists()) {
          print("🟢 Eski DB bulundu: $path");
          await File(newPath).parent.create(recursive: true);
          await file.copy(newPath);
          print("✅ Eski DB başarıyla taşındı → $newPath");
          return;
        }
      }
      print("⚪ Eski DB bulunamadı, yeni oluşturulacak.");
    } catch (e) {
      print("⚠️ Migration hatası: $e");
    }
  }

  /// Public wrapper so callers (e.g. main.dart) can request a migration.
  /// Calls the internal _tryMigrateOldDatabase with the computed new DB path.
  Future<void> migrateOldDatabase() async {
    final dbDir = await getDatabasesPath();
    final newPath = join(dbDir, _databaseName);
    await _tryMigrateOldDatabase(newPath);
  }

  /// 🔍 Dinamik tablo adı bulucu (geri uyumlu)
  Future<String> _findTable(Database db) async {
    final tables = await db.rawQuery(
        "SELECT name FROM sqlite_master WHERE type='table' ORDER BY name");
    final names = tables.map((e) => e['name']).toList();
    if (names.contains("zikirler")) return "zikirler";
    if (names.contains("zikir")) return "zikir";
    if (names.contains("tbl_zikir")) return "tbl_zikir";
    return "zikirler";
  }

  Future<List<Map<String, dynamic>>> getAllZikirler() async {
    final db = await instance.database;
    final table = await _findTable(db);
    final rows = await db.query(table);
    // Normalize old column names to keep UI code compatible ('zikir' -> 'icerik')
    return rows.map((r) {
      final m = Map<String, dynamic>.from(r);
      if (m.containsKey('zikir') && !m.containsKey('icerik')) {
        m['icerik'] = m['zikir'];
      }
      return m;
    }).toList();
  }

  Future<Map<String, dynamic>?> getZikirById(int id) async {
    final db = await instance.database;
    final table = await _findTable(db);
    final result = await db.query(table, where: "id = ?", whereArgs: [id]);
    if (result.isEmpty) return null;
    final m = Map<String, dynamic>.from(result.first);
    if (m.containsKey('zikir') && !m.containsKey('icerik')) m['icerik'] = m['zikir'];
    return m;
  }

  Future<int> updateZikir(int id, Map<String, dynamic> row) async {
    final db = await instance.database;
    final table = await _findTable(db);
    // Normalize keys: map 'icerik' → 'zikir' and strip unknown columns
    final colsInfo = await db.rawQuery("PRAGMA table_info($table)");
    final cols = colsInfo.map((e) => e['name'] as String).toSet();
    final Map<String, dynamic> filtered = {};
    final input = Map<String, dynamic>.from(row);
    if (input.containsKey('icerik') && !input.containsKey('zikir')) {
      input['zikir'] = input['icerik'];
      input.remove('icerik');
    }
    for (final k in input.keys) {
      if (cols.contains(k)) filtered[k] = input[k];
    }
    return await db.update(table, filtered, where: "id = ?", whereArgs: [id]);
  }

  Future<int> insertZikir(Map<String, dynamic> row) async {
    final db = await instance.database;
    final table = await _findTable(db);
    // Normalize similarly to update: map 'icerik' → 'zikir' and remove unknown cols
    final colsInfo = await db.rawQuery("PRAGMA table_info($table)");
    final cols = colsInfo.map((e) => e['name'] as String).toSet();
    final input = Map<String, dynamic>.from(row);
    if (input.containsKey('icerik') && !input.containsKey('zikir')) {
      input['zikir'] = input['icerik'];
      input.remove('icerik');
    }
    final Map<String, dynamic> filtered = {};
    for (final k in input.keys) {
      if (cols.contains(k)) filtered[k] = input[k];
    }
    return await db.insert(table, filtered);
  }

  Future<int> deleteZikir(int id) async {
    final db = await instance.database;
    final table = await _findTable(db);
    return await db.delete(table, where: "id = ?", whereArgs: [id]);
  }
}
