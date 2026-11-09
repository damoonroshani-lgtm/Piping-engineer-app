
import 'dart:io';

import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

class FileStorageService {
  FileStorageService._();

  static final FileStorageService instance =
      FileStorageService._();

  Future<Directory> get _rootDirectory async {
    final directory = await getApplicationDocumentsDirectory();

    final storageDirectory = Directory(
      path.join(directory.path, 'piping_engineering'),
    );

    if (!await storageDirectory.exists()) {
      await storageDirectory.create(recursive: true);
    }

    return storageDirectory;
  }

  Future<Directory> get _attachmentsDirectory async {
    final root = await _rootDirectory;

    final directory = Directory(
      path.join(root.path, 'attachments'),
    );

    if (!await directory.exists()) {
      await directory.create(recursive: true);
    }

    return directory;
  }

  Future<String> saveAttachment(File sourceFile) async {
    if (!await sourceFile.exists()) {
      throw Exception('Source file does not exist.');
    }

    final directory = await _attachmentsDirectory;

    final extension = path.extension(sourceFile.path);

    final fileName =
        '${DateTime.now().microsecondsSinceEpoch}$extension';

    final destination = path.join(directory.path, fileName);

    final savedFile = await sourceFile.copy(destination);

    return savedFile.path;
  }

  Future<bool> deleteAttachment(String filePath) async {
    final file = File(filePath);

    if (await file.exists()) {
      await file.delete();
      return true;
    }

    return false;
  }

  Future<List<File>> getAllAttachments() async {
    final directory = await _attachmentsDirectory;

    return directory
        .list()
        .where((entity) => entity is File)
        .cast<File>()
        .toList();
  }

  Future<Directory> getBackupDirectory() async {
    final root = await _rootDirectory;

    final directory = Directory(
      path.join(root.path, 'backups'),
    );

    if (!await directory.exists()) {
      await directory.create(recursive: true);
    }

    return directory;
  }
}
