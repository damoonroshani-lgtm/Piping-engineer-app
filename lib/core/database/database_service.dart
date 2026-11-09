
import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart';

import 'package:piping_engineer/core/diagnostics/error_logger.dart';
import 'package:piping_engineer/features/notes/models/note_model.dart';

class DatabaseService {
  DatabaseService._();

  static final DatabaseService instance = DatabaseService._();

  static const int databaseVersion = 1;
  static const String databaseName = 'piping_engineering.db';

  Database? _database;

  /// اجرای عملیات همراه با ثبت خطا
  Future<T> _runWithLogging<T>(
    String operation,
    Future<T> Function() action,
  ) async {
    try {
      return await action();
    } catch (error, stackTrace) {
      await ErrorLogger.instance.saveError(
        error.toString(),
        source: 'DatabaseService',
        errorType: error.runtimeType.toString(),
        operation: operation,
        page: 'Database',
        stackTrace: stackTrace.toString(),
      );

      rethrow;
    }
  }

  Future<Database> get database async {
    return _runWithLogging(
      'Open database',
      () async {
        if (_database != null) {
          return _database!;
        }

        final databasePath = await getDatabasesPath();
        final fullPath = path.join(databasePath, databaseName);

        final openedDatabase = await openDatabase(
          fullPath,
          version: databaseVersion,
          onConfigure: (db) async {
            await db.execute('PRAGMA foreign_keys = ON');
          },
          onCreate: _createDatabase,
          onUpgrade: _upgradeDatabase,
        );

        _database = openedDatabase;
        return openedDatabase;
      },
    );
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

    await db.execute('''
      CREATE INDEX idx_attachments_note
      ON note_attachments (note_id)
    ''');
  }

  Future<void> _upgradeDatabase(
    Database db,
    int oldVersion,
    int newVersion,
  ) async {
    // Future database migrations will be added here.
    // Existing user data must be preserved.
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
  }) {
    return _runWithLogging(
      'Add note',
      () async {
        _validateMarker(markerX, markerY);

        final db = await database;
        final now = DateTime.now().toIso8601String();

        return db.insert('notes', {
          'title': title.trim(),
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
      },
    );
  }

  Future<int> addNoteModel(NoteModel note) {
    return _runWithLogging(
      'Add note model',
      () async {
        _validateMarker(note.markerX, note.markerY);

        final db = await database;
        final now = DateTime.now().toIso8601String();

        return db.insert('notes', {
          'title': note.title.trim(),
          'content': note.content,
          'source_type': note.sourceType,
          'source_id': note.sourceId,
          'source_title': note.sourceTitle,
          'anchor_id': note.anchorId,
          'marker_x': note.markerX,
          'marker_y': note.markerY,
          'created_at': note.createdAt.toIso8601String(),
          'updated_at': now,
        });
      },
    );
  }

  Future<int> updateNote({
    required int id,
    required String title,
    required String content,
  }) {
    return _runWithLogging(
      'Update note',
      () async {
        final db = await database;

        return db.update(
          'notes',
          {
            'title': title.trim(),
            'content': content,
            'updated_at': DateTime.now().toIso8601String(),
          },
          where: 'id = ?',
          whereArgs: [id],
        );
      },
    );
  }

  Future<int> updateNoteModel(NoteModel note) {
    return _runWithLogging(
      'Update note model',
      () async {
        if (note.id == null) {
          throw ArgumentError('Note ID is required for updating.');
        }

        _validateMarker(note.markerX, note.markerY);

        final db = await database;

        return db.update(
          'notes',
          {
            'title': note.title.trim(),
            'content': note.content,
            'source_type': note.sourceType,
            'source_id': note.sourceId,
            'source_title': note.sourceTitle,
            'anchor_id': note.anchorId,
            'marker_x': note.markerX,
            'marker_y': note.markerY,
            'updated_at': DateTime.now().toIso8601String(),
          },
          where: 'id = ?',
          whereArgs: [note.id],
        );
      },
    );
  }

  Future<NoteModel?> getNoteById(int id) {
    return _runWithLogging(
      'Get note by ID',
      () async {
        final db = await database;

        final results = await db.query(
          'notes',
          where: 'id = ?',
          whereArgs: [id],
          limit: 1,
        );

        if (results.isEmpty) {
          return null;
        }

        return NoteModel.fromMap(results.first);
      },
    );
  }

  Future<List<NoteModel>> getAllNoteModels() {
    return _runWithLogging(
      'Get all note models',
      () async {
        final db = await database;

        final results = await db.query(
          'notes',
          orderBy: 'updated_at DESC',
        );

        return results.map(NoteModel.fromMap).toList();
      },
    );
  }

  Future<List<Map<String, dynamic>>> getAllNotes() {
    return _runWithLogging(
      'Get all notes',
      () async {
        final db = await database;

        return db.query(
          'notes',
          orderBy: 'updated_at DESC',
        );
      },
    );
  }

  Future<List<Map<String, dynamic>>> searchNotes(
    String query,
  ) {
    return _runWithLogging(
      'Search notes',
      () async {
        final searchText = query.trim();

        if (searchText.isEmpty) {
          return getAllNotes();
        }

        final db = await database;
        final search = '%$searchText%';

        return db.query(
          'notes',
          where: 'title LIKE ? OR content LIKE ? OR source_title LIKE ?',
          whereArgs: [search, search, search],
          orderBy: 'updated_at DESC',
        );
      },
    );
  }

  Future<List<NoteModel>> searchNoteModels(String query) {
    return _runWithLogging(
      'Search note models',
      () async {
        final results = await searchNotes(query);

        return results.map(NoteModel.fromMap).toList();
      },
    );
  }

  Future<int> deleteNote(int id) {
    return _runWithLogging(
      'Delete note',
      () async {
        final db = await database;

        return db.transaction((transaction) async {
          return transaction.delete(
            'notes',
            where: 'id = ?',
            whereArgs: [id],
          );
        });
      },
    );
  }

  Future<int> addAttachment({
    required int noteId,
    required String filePath,
    String? fileName,
  }) {
    return _runWithLogging(
      'Add note attachment',
      () async {
        final db = await database;

        final note = await db.query(
          'notes',
          columns: ['id'],
          where: 'id = ?',
          whereArgs: [noteId],
          limit: 1,
        );

        if (note.isEmpty) {
          throw ArgumentError(
            'The requested note does not exist.',
          );
        }

        return db.insert('note_attachments', {
          'note_id': noteId,
          'file_path': filePath,
          'file_name': fileName,
          'created_at': DateTime.now().toIso8601String(),
        });
      },
    );
  }

  Future<List<Map<String, dynamic>>> getAttachments(
    int noteId,
  ) {
    return _runWithLogging(
      'Get note attachments',
      () async {
        final db = await database;

        return db.query(
          'note_attachments',
          where: 'note_id = ?',
          whereArgs: [noteId],
          orderBy: 'created_at ASC',
        );
      },
    );
  }

  Future<int> deleteAttachmentRecord(int attachmentId) {
    return _runWithLogging(
      'Delete attachment record',
      () async {
        final db = await database;

        return db.delete(
          'note_attachments',
          where: 'id = ?',
          whereArgs: [attachmentId],
        );
      },
    );
  }

  void _validateMarker(
    double? markerX,
    double? markerY,
  ) {
    if (markerX != null && (markerX < 0 || markerX > 1)) {
      throw ArgumentError(
        'markerX must be between 0 and 1.',
      );
    }

    if (markerY != null && (markerY < 0 || markerY > 1)) {
      throw ArgumentError(
        'markerY must be between 0 and 1.',
      );
    }

    if ((markerX == null) != (markerY == null)) {
      throw ArgumentError(
        'Both marker coordinates must be provided together.',
      );
    }
  }

  Future<void> close() {
    return _runWithLogging(
      'Close database',
      () async {
        final currentDatabase = _database;

        if (currentDatabase != null) {
          await currentDatabase.close();
          _database = null;
        }
      },
    );
  }
}
