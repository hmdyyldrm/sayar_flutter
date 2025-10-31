import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static const _databaseName = 'database_zikirler.db';
  static const _databaseVersion = 1;
  static const table = 'zikirler';

  static const columnId = 'id';
  static const columnBaslik = 'baslik';
  static const columnZikir = 'zikir';
  static const columnFoto = 'foto';
  static const columnHedef = 'hedef';
  static const columnSayac = 'sayac';
  static const columnBugunSayac = 'bugun_sayac';
  static const columnToplam = 'toplam';
  static const columnBaslangicTarih = 'baslangic_tarih';
  static const columnGuncellemeTarih = 'guncelleme_tarih';
  static const columnGecmis = 'gecmis';
  static const columnBildirimSaati = 'bildirim_saati';

  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;
  Future<Database> get database async => _database ??= await _initDatabase();

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, _databaseName);
    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
    );
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $table (
        $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
        $columnBaslik TEXT,
        $columnZikir TEXT,
        $columnFoto TEXT,
        $columnHedef INTEGER,
        $columnSayac INTEGER,
        $columnBugunSayac INTEGER,
        $columnToplam INTEGER,
        $columnBaslangicTarih TEXT,
        $columnGuncellemeTarih TEXT,
        $columnGecmis TEXT,
        $columnBildirimSaati TEXT
      )
    ''');
  }

  Future<int> insert(Map<String, dynamic> row) async {
    final db = await database;
    return await db.insert(table, row);
  }

  Future<List<Map<String, dynamic>>> queryAll() async {
    final db = await database;
    return await db.query(table);
  }

  Future<int> update(Map<String, dynamic> row) async {
    final db = await database;
    final id = row[columnId];
    return await db.update(
      table,
      row,
      where: '$columnId = ?',
      whereArgs: [id],
    );
  }

  Future<int> delete(int id) async {
    final db = await database;
    return await db.delete(
      table,
      where: '$columnId = ?',
      whereArgs: [id],
    );
  }
}
