import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';

class ErrorLogger {
  ErrorLogger._();

  static final ErrorLogger instance = ErrorLogger._();

  Future<void> saveError(
    String message, {
    String source = 'Unknown',
    String? stackTrace,
  }) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/piping_error_log.txt');

      final entry = '''
------------------------------
Date: ${DateTime.now()}
Source: $source
$message
${stackTrace ?? ''}
------------------------------

''';

      await file.writeAsString(
        entry,
        mode: FileMode.append,
        flush: true,
      );
    } catch (error) {
      debugPrint('ErrorLogger failed: $error');
    }
  }

  Future<String> readErrors() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/piping_error_log.txt');

      if (!await file.exists()) {
        return 'هنوز خطایی ثبت نشده است.';
      }

      return await file.readAsString();
    } catch (error) {
      return 'خطا در خواندن گزارش: $error';
    }
  }
}
