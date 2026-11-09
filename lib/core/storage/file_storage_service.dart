
import 'dart:io';
import 'dart:math';

import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

class FileStorageService {
  FileStorageService._();

  static final FileStorageService instance =
      FileStorageService._();

  final Random _random = Random.secure();

  Future<Directory> get _rootDirectory async {
    final documents = await getApplicationDocumentsDirectory();

    final directory = Directory(
      path.join(documents.path, 'piping_engineering'),
    );

    if (!await directory.exists()) {
      await directory.create(recursive: true);
    }

    return directory;
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

  Future<String> saveAttachment(File sourceFile) async {
    if (!await sourceFile.exists()) {
      throw FileSystemException(
        'Source file does not exist.',
        sourceFile.path,
      );
    }

    final sourcePath = await sourceFile.resolveSymbolicLinks();
    final source = File(sourcePath);

    if (await FileSystemEntity.type(sourcePath) !=
        FileSystemEntityType.file) {
      throw FileSystemException(
        'Source is not a regular file.',
        sourcePath,
      );
    }

    final directory = await _attachmentsDirectory;
    final extension = path.extension(sourcePath).toLowerCase();

    final fileName =
        '${DateTime.now().microsecondsSinceEpoch}_'
        '${_random.nextInt(1000000)}$extension';

    final destination = File(
      path.join(directory.path, fileName),
    );

    final savedFile = await source.copy(destination.path);

    return savedFile.path;
  }

  Future<bool> deleteAttachment(String filePath) async {
    if (filePath.trim().isEmpty) {
      return false;
    }

    final directory = await _attachmentsDirectory;
    final absolutePath = path.normalize(
      path.absolute(filePath),
    );

    final absoluteDirectory = path.normalize(
      path.absolute(directory.path),
    );

    if (!path.isWithin(absoluteDirectory, absolutePath)) {
      return false;
    }

    final file = File(absolutePath);

    if (!await FileSystemEntity.type(
          absolutePath,
          followLinks: false,
        ).then((type) => type != FileSystemEntityType.notFound)) {
      return false;
    }

    final resolvedPath = await file.resolveSymbolicLinks();
    final resolvedDirectory =
        await directory.resolveSymbolicLinks();

    if (!path.isWithin(resolvedDirectory, resolvedPath)) {
      return false;
    }

    await file.delete();
    return true;
  }

  Future<bool> isManagedAttachment(String filePath) async {
    if (filePath.trim().isEmpty) {
      return false;
    }

    try {
      final directory = await _attachmentsDirectory;
      final file = File(filePath);

      if (!await file.exists()) {
        return false;
      }

      final resolvedFile = await file.resolveSymbolicLinks();
      final resolvedDirectory =
          await directory.resolveSymbolicLinks();

      return path.isWithin(resolvedDirectory, resolvedFile);
    } catch (_) {
      return false;
    }
  }

  Future<List<File>> getAllAttachments() async {
    final directory = await _attachmentsDirectory;
    final files = <File>[];

    await for (final entity in directory.list(
      recursive: false,
      followLinks: false,
    )) {
      if (entity is! File) {
        continue;
      }

      if (await isManagedAttachment(entity.path)) {
        files.add(entity);
      }
    }

    files.sort(
      (a, b) => a.path.compareTo(b.path),
    );

    return files;
  }

  Future<File> createBackupFile({
    required String fileName,
    required List<int> bytes,
  }) async {
    final safeName = path.basename(fileName);

    if (safeName != fileName ||
        safeName.trim().isEmpty ||
        !safeName.toLowerCase().endsWith('.zip')) {
      throw ArgumentError(
        'A valid ZIP backup file name is required.',
      );
    }

    final directory = await getBackupDirectory();

    final file = File(
      path.join(directory.path, safeName),
    );

    if (await file.exists()) {
      throw FileSystemException(
        'Backup file already exists.',
        file.path,
      );
    }

    return file.writeAsBytes(
      bytes,
      flush: true,
    );
  }

  Future<List<File>> getAllBackupFiles() async {
    final directory = await getBackupDirectory();
    final files = <File>[];

    await for (final entity in directory.list(
      recursive: false,
      followLinks: false,
    )) {
      if (entity is File &&
          path.extension(entity.path).toLowerCase() == '.zip') {
        files.add(entity);
      }
    }

    files.sort(
      (a, b) => b.path.compareTo(a.path),
    );

    return files;
  }

  Future<bool> deleteBackupFile(String filePath) async {
    if (filePath.trim().isEmpty) {
      return false;
    }

    final directory = await getBackupDirectory();

    final absolutePath = path.normalize(
      path.absolute(filePath),
    );

    final absoluteDirectory = path.normalize(
      path.absolute(directory.path),
    );

    if (!path.isWithin(absoluteDirectory, absolutePath)) {
      return false;
    }

    final file = File(absolutePath);

    if (!await file.exists()) {
      return false;
    }

    final resolvedFile = await file.resolveSymbolicLinks();
    final resolvedDirectory =
        await directory.resolveSymbolicLinks();

    if (!path.isWithin(resolvedDirectory, resolvedFile)) {
      return false;
    }

    await file.delete();
    return true;
  }
}
