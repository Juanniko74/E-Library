import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'buku.dart';

class DbHelper {
  static final DbHelper _instance = DbHelper._internal();
  static Database? _database;

  factory DbHelper() {
    return _instance;
  }

  DbHelper._internal();

  Future<Database> get database async {
    _database ??= await _initDb();
    return _database!;
  }

  Future<Database> _initDb() async {
    String path = join(await getDatabasesPath(), 'buku.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE buku(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            judul TEXT,
            penerbit TEXT,
            tahun TEXT,
            kategori TEXT,
            sinopsis TEXT,
            pdfPath TEXT,
            isFavorite INTEGER DEFAULT 0
          )
        ''');
      },
    );
  }

  Future<int> insertBuku(Buku buku) async {
    final db = await database;
    return await db.insert('buku', buku.toMap());
  }

  Future<List<Buku>> getBukuList() async {
    final db = await database;
    var result = await db.query('buku');
    return result.map((data) => Buku.fromMap(data)).toList();
  }

  Future<List<Buku>> getFavoriteBooks() async {
    final db = await database;
    var result = await db.query(
      'buku',
      where: 'isFavorite = ?',
      whereArgs: [1],
    );
    return result.map((data) => Buku.fromMap(data)).toList();
  }

  Future<int> updateBuku(Buku buku) async {
    final db = await database;
    return await db.update(
      'buku',
      buku.toMap(),
      where: 'id = ?',
      whereArgs: [buku.id],
    );
  }

  Future<void> deleteBuku(int id) async {
    final db = await database;
    await db.delete(
      'buku',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<List<Buku>> searchBuku({
    String? judul,
    String? penerbit,
    String? kategori,
    String? tahun,
  }) async {
    final db = await database;
    String query = 'SELECT * FROM buku WHERE 1=1';
    List<dynamic> args = [];

    if (judul != null && judul.isNotEmpty) {
      query += ' AND judul LIKE ?';
      args.add('%$judul%');
    }
    if (penerbit != null && penerbit.isNotEmpty) {
      query += ' AND penerbit LIKE ?';
      args.add('%$penerbit%');
    }
    if (kategori != null && kategori.isNotEmpty) {
      query += ' AND kategori = ?';
      args.add(kategori);
    }
    if (tahun != null && tahun.isNotEmpty) {
      query += ' AND tahun = ?';
      args.add(tahun);
    }

    final List<Map<String, dynamic>> results = await db.rawQuery(query, args);
    return results.map((map) => Buku.fromMap(map)).toList();
  }

  Future<void> deleteDatabaseFile() async {
    final dbPath = join(await getDatabasesPath(), 'buku.db');
    await databaseFactory.deleteDatabase(dbPath);
  }
}
