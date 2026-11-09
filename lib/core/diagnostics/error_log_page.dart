import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:piping_engineer/core/diagnostics/error_logger.dart';

class ErrorLogPage extends StatefulWidget {
  const ErrorLogPage({super.key});

  @override
  State<ErrorLogPage> createState() => _ErrorLogPageState();
}

class _ErrorLogPageState extends State<ErrorLogPage> {
  late Future<String> _report;

  @override
  void initState() {
    super.initState();
    _report = ErrorLogger.instance.readErrors();
  }

  void _refreshReport() {
    setState(() {
      _report = ErrorLogger.instance.readErrors();
    });
  }

  Future<void> _copyReport(String report) async {
    await Clipboard.setData(ClipboardData(text: report));

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('گزارش خطا کپی شد.'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('گزارش خطاهای برنامه'),
        actions: [
          IconButton(
            onPressed: _refreshReport,
            icon: const Icon(Icons.refresh),
            tooltip: 'بروزرسانی',
          ),
        ],
      ),
      body: FutureBuilder<String>(
        future: _report,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text('خطا در دریافت گزارش: ${snapshot.error}'),
            );
          }

          final report = snapshot.data ?? '';

          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: SelectableText(
                      report.isEmpty
                          ? 'گزارشی ثبت نشده است.'
                          : report,
                      textDirection: TextDirection.ltr,
                      style: const TextStyle(
                        fontSize: 13,
                        height: 1.7,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: report.isEmpty
                        ? null
                        : () => _copyReport(report),
                    icon: const Icon(Icons.copy),
                    label: const Text('کپی گزارش خطا'),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
