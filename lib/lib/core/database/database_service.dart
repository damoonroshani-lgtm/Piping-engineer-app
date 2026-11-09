
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseService {
  DatabaseService._();

  static final DatabaseService instance = DatabaseService._();

  static const int databaseVersion = 1;
  static const String databaseName = 'piping_engineering.db';

  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;

    final databasePath = await getDatabasesPath();
    final path = join(databasePath, databaseName);

    _database = await openDatabase(
      path,
      version: databaseVersion,
      onCreate: _createDatabase,
      onUpgrade: _upgradeDatabase,
    );

    return _database!;
  }

  Future<void> _createDatabase(
    Database db,
    int version,
  ) async {
    await db.execute('''
      CREATE TABLE notes (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        content TEXT NOT NULL,
        source_type TEXT,
        source_id TEXT,
        source_title TEXT,
        anchor_id TEXT,
        marker_x REAL,
        marker_y REAL,
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE note_attachments (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        note_id INTEGER NOT NULL,
        file_path TEXT NOT NULL,
        file_name TEXT,
        created_at TEXT NOT NULL,
        FOREIGN KEY (note_id)
          REFERENCES notes (id)
          ON DELETE CASCADE
      )
    ''');

    await db.execute('''
      CREATE INDEX idx_notes_updated
      ON notes (updated_at)
    ''');

    await db.execute('''
      CREATE INDEX idx_notes_source
      ON notes (source_type, source_id)
    ''');
  }

  Future<void> _upgradeDatabase(
    Database db,
    int oldVersion,
    int newVersion,
  ) async {
    // تغییرات ساختار پایگاه داده در نسخه‌های آینده
    // به‌صورت مرحله‌ای در این قسمت اضافه می‌شوند.
  }

  Future<int> addNote({
    required String title,
    required String content,
    String? sourceType,
    String? sourceId,
    String? sourceTitle,
    String? anchorId,
    double? markerX,
    double? markerY,
  }) async {
    final db = await database;
    final now = DateTime.now().toIso8601String();

    return db.insert('notes', {
      'title': title,
      'content': content,
      'source_type': sourceType,
      'source_id': sourceId,
      'source_title': sourceTitle,
      'anchor_id': anchorId,
      'marker_x': markerX,
      'marker_y': markerY,
      'created_at': now,
      'updated_at': now,
    });
  }

  Future<int> updateNote({
    required int id,
    required String title,
    required String content,
  }) async {
    final db = await database;

    return db.update(
      'notes',
      {
        'title': title,
        'content': content,
        'updated_at': DateTime.now().toIso8601String(),
      },
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<List<Map<String, dynamic>>> getAllNotes() async {
    final db = await database;

    return db.query(
      'notes',
      orderBy: 'updated_at DESC',
    );
  }

  Future<List<Map<String, dynamic>>> searchNotes(
    String query,
  ) async {
    final db = await database;
    final search = '%${query.trim()}%';

    return db.query(
      'notes',
      where: 'title LIKE ? OR content LIKE ?',
      whereArgs: [search, search],
      orderBy: 'updated_at DESC',
    );
  }

  Future<int> deleteNote(int id) async {
    final db = await database;

    return db.delete(
      'notes',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> close() async {
    if (_database != null) {
      await _database!.close();
      _database = null;
    }
  }
}
