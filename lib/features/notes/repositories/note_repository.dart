

import 'dart:io';

import 'package:piping_engineer/core/database/database_service.dart';
import 'package:piping_engineer/core/storage/file_storage_service.dart';
import 'package:piping_engineer/features/notes/models/note_model.dart';

class NoteRepository {
  NoteRepository._();

  static final NoteRepository instance = NoteRepository._();

  final DatabaseService _database = DatabaseService.instance;
  final FileStorageService _storage = FileStorageService.instance;

  Future<int> createNote(NoteModel note) async {
    return _database.addNoteModel(note);
  }

  Future<int> updateNote(NoteModel note) async {
    return _database.updateNoteModel(note);
  }

  Future<NoteModel?> getNoteById(int id) async {
    return _database.getNoteById(id);
  }

  Future<List<NoteModel>> getAllNotes() async {
    return _database.getAllNoteModels();
  }

  Future<List<NoteModel>> searchNotes(String query) async {
    return _database.searchNoteModels(query);
  }

  Future<int> addAttachment({
    required int noteId,
    required File sourceFile,
    String? fileName,
  }) async {
    final note = await _database.getNoteById(noteId);

    if (note == null) {
      throw ArgumentError('The requested note does not exist.');
    }

    final savedPath = await _storage.saveAttachment(sourceFile);

    try {
      return await _database.addAttachment(
        noteId: noteId,
        filePath: savedPath,
        fileName: fileName ?? sourceFile.uri.pathSegments.last,
      );
    } catch (_) {
      await _storage.deleteAttachment(savedPath);
      rethrow;
    }
  }

  Future<List<Map<String, dynamic>>> getAttachments(
    int noteId,
  ) async {
    return _database.getAttachments(noteId);
  }

  Future<bool> deleteAttachment({
    required int attachmentId,
    required int noteId,
  }) async {
    final attachments = await _database.getAttachments(noteId);

    final matchingAttachments = attachments.where(
      (item) => item['id'] == attachmentId,
    );

    if (matchingAttachments.isEmpty) {
      return false;
    }

    final attachment = matchingAttachments.first;
    final filePath = attachment['file_path'] as String;

    if (!await _storage.isManagedAttachment(filePath)) {
      return false;
    }

    final deletedFile = await _storage.deleteAttachment(filePath);

    if (!deletedFile) {
      return false;
    }

    final deletedRecord =
        await _database.deleteAttachmentRecord(attachmentId);

    return deletedRecord > 0;
  }

  Future<List<String>> deleteNote(int noteId) async {
    final attachments = await _database.getAttachments(noteId);

    final deletedRecords = await _database.deleteNote(noteId);

    if (deletedRecords == 0) {
      throw StateError('The requested note does not exist.');
    }

    final remainingFiles = <String>[];

    for (final attachment in attachments) {
      final filePath = attachment['file_path'] as String;

      try {
        if (await _storage.isManagedAttachment(filePath)) {
          final deleted = await _storage.deleteAttachment(filePath);

          if (!deleted) {
            remainingFiles.add(filePath);
          }
        }
      } catch (_) {
        remainingFiles.add(filePath);
      }
    }

    return remainingFiles;
  }
}
