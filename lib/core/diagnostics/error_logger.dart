
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';

class ErrorLogger {
  ErrorLogger._();

  static final ErrorLogger instance = ErrorLogger._();

  static String? _currentPage;
  static String? _currentOperation;

  /// ثبت صفحه‌ای که کاربر در آن قرار دارد
  void setCurrentPage(String page) {
    _currentPage = page;
  }

  /// ثبت عملیاتی که برنامه در حال انجام آن است
  void setCurrentOperation(String operation) {
    _currentOperation = operation;
  }

  /// پاک کردن عملیات جاری
  void clearCurrentOperation() {
    _currentOperation = null;
  }

  /// ثبت خطا با جزئیات کامل‌تر
  Future<void> saveError(
    String message, {
    String source = 'Unknown',
    String? stackTrace,
    String? errorType,
    String? page,
    String? operation,
  }) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File(
        '${directory.path}/piping_error_log.txt',
      );

      final entry = '''
==================================================
Date: ${DateTime.now().toIso8601String()}
Source: $source
Error Type: ${errorType ?? 'Not specified'}
Page: ${page ?? _currentPage ?? 'Unknown'}
Operation: ${operation ?? _currentOperation ?? 'Unknown'}

Message:
$message

Stack Trace:
${stackTrace ?? 'Not available'}
==================================================

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

  /// خواندن گزارش خطاها
  Future<String> readErrors() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File(
        '${directory.path}/piping_error_log.txt',
      );

      if (!await file.exists()) {
        return 'هنوز خطایی ثبت نشده است.';
      }

      return await file.readAsString();
    } catch (error) {
      return 'خطا در خواندن گزارش: $error';
    }
  }

  /// پاک کردن گزارش‌ها
  Future<void> clearErrors() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File(
        '${directory.path}/piping_error_log.txt',
      );

      if (await file.exists()) {
        await file.writeAsString('');
      }
    } catch (error) {
      debugPrint('ErrorLogger clear failed: $error');
    }
  }
}
