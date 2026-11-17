
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';

class StandardsPage extends StatefulWidget {
  const StandardsPage({super.key});

  @override
  State<StandardsPage> createState() => _StandardsPageState();
}

class _StandardsPageState extends State<StandardsPage> {
  List<Map<String, dynamic>> standards = [];
  bool isLoading = true;

  final List<String> categories = [
    'طراحی پایپینگ',
    'فلنج و اتصالات',
    'شیرآلات صنعتی',
    'متریال و لوله‌ها',
    'جوشکاری و بازرسی',
    'خوردگی و سرویس ترش',
    'سایر استانداردها',
  ];

  @override
  void initState() {
    super.initState();
    loadStandards();
  }

  Future<Directory> getLibraryDirectory() async {
    final appDir = await getApplicationDocumentsDirectory();
    final directory = Directory('${appDir.path}/standards_pdfs');

    if (!await directory.exists()) {
      await directory.create(recursive: true);
    }

    return directory;
  }

  Future<File> getDatabaseFile() async {
    final appDir = await getApplicationDocumentsDirectory();
    return File('${appDir.path}/standards_library.json');
  }

  Future<void> loadStandards() async {
    try {
      final file = await getDatabaseFile();

      if (await file.exists()) {
        final content = await file.readAsString();
        final data = jsonDecode(content) as List;

        standards = data
            .map((item) => Map<String, dynamic>.from(item))
            .where((item) => File(item['filePath']).existsSync())
            .toList();
      }
    } catch (_) {
      standards = [];
    }

    if (mounted) {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> saveStandards() async {
    final file = await getDatabaseFile();
    await file.writeAsString(jsonEncode(standards));
  }

  Future<void> addPdf() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
      );

      if (result == null || result.files.single.path == null) {
        return;
      }

      final sourceFile = File(result.files.single.path!);

      if (!await sourceFile.exists() || !mounted) return;

      final details = await showDialog<Map<String, String>>(
        context: context,
        useRootNavigator: true,
        builder: (_) => StandardDetailsDialog(
          categories: categories,
        ),
      );

      if (!mounted || details == null) return;

      final directory = await getLibraryDirectory();

      final fileName =
          '${DateTime.now().microsecondsSinceEpoch}_${p.basename(sourceFile.path)}';

      final destination = File('${directory.path}/$fileName');

      await sourceFile.copy(destination.path);

      standards.add({
        'title': details['title'],
        'code': details['code'],
        'category': details['category'],
        'filePath': destination.path,
        'dateAdded': DateTime.now().toIso8601String(),
      });

      await saveStandards();

      if (!mounted) return;

      setState(() {});

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('فایل استاندارد با موفقیت اضافه شد.'),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('خطا در افزودن فایل: $e')),
      );
    }
  }

  Future<void> deleteStandard(int index) async {
    final item = standards[index];

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('حذف استاندارد'),
        content: Text('آیا فایل ${item['code']} حذف شود؟'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(dialogContext).pop(false);
            },
            child: const Text('انصراف'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(dialogContext).pop(true);
            },
            child: const Text('حذف'),
          ),
        ],
      ),
    );

    if (confirmed != true || !mounted) return;

    try {
      final pdfFile = File(item['filePath']);

      if (await pdfFile.exists()) {
        await pdfFile.delete();
      }

      standards.removeAt(index);
      await saveStandards();

      if (mounted) {
        setState(() {});
      }
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('خطا در حذف فایل: $e')),
      );
    }
  }

  void openPdf(Map<String, dynamic> item) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => StandardPdfPage(
          title: item['code'] ?? 'استاندارد',
          filePath: item['filePath'],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('استانداردها و مراجع'),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: addPdf,
        icon: const Icon(Icons.add),
        label: const Text('افزودن PDF'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : standards.isEmpty
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.library_books_outlined,
                          size: 72,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'کتابخانه استانداردها خالی است',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'با انتخاب گزینه افزودن PDF، فایل استاندارد موردنظر خود را از گوشی وارد کنید.',
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                )
              : ListView(
                  padding: const EdgeInsets.fromLTRB(12, 12, 12, 90),
                  children: [
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            const Icon(Icons.menu_book, size: 32),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                'تعداد فایل‌های ذخیره‌شده: ${standards.length}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    ...List.generate(standards.length, (index) {
                      final item = standards[index];

                      return Card(
                        margin: const EdgeInsets.only(bottom: 10),
                        child: ListTile(
                          leading: const CircleAvatar(
                            child: Icon(Icons.picture_as_pdf),
                          ),
                          title: Text(
                            item['code'] ?? '',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Text(
                            '${item['title']}\n${item['category']}',
                          ),
                          isThreeLine: true,
                          onTap: () => openPdf(item),
                          trailing: PopupMenuButton<String>(
                            onSelected: (value) {
                              if (value == 'delete') {
                                deleteStandard(index);
                              }
                            },
                            itemBuilder: (context) => [
                              const PopupMenuItem(
                                value: 'delete',
                                child: Text('حذف فایل'),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
                  ],
                ),
    );
  }
}

class StandardDetailsDialog extends StatefulWidget {
  final List<String> categories;

  const StandardDetailsDialog({
    super.key,
    required this.categories,
  });

  @override
  State<StandardDetailsDialog> createState() =>
      _StandardDetailsDialogState();
}

class _StandardDetailsDialogState
    extends State<StandardDetailsDialog> {
  late final TextEditingController _titleController;
  late final TextEditingController _codeController;

  late String _selectedCategory;

  @override
  void initState() {
    super.initState();

    _titleController = TextEditingController();
    _codeController = TextEditingController();
    _selectedCategory = widget.categories.first;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _codeController.dispose();
    super.dispose();
  }

  void _save() {
    final title = _titleController.text.trim();
    final code = _codeController.text.trim();

    if (title.isEmpty || code.isEmpty) return;

    Navigator.of(context, rootNavigator: true).pop({
      'title': title,
      'code': code,
      'category': _selectedCategory,
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('مشخصات استاندارد'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'نام استاندارد',
                hintText: 'مثلاً استاندارد پایپینگ',
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _codeController,
              decoration: const InputDecoration(
                labelText: 'شماره استاندارد',
                hintText: 'مثلاً ASME B31.3',
              ),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: _selectedCategory,
              decoration: const InputDecoration(
                labelText: 'دسته‌بندی',
              ),
              isExpanded: true,
              items: widget.categories.map((category) {
                return DropdownMenuItem<String>(
                  value: category,
                  child: Text(category),
                );
              }).toList(),
              onChanged: (value) {
                if (value == null) return;

                setState(() {
                  _selectedCategory = value;
                });
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context, rootNavigator: true).pop();
          },
          child: const Text('انصراف'),
        ),
        ElevatedButton(
          onPressed: _save,
          child: const Text('ادامه'),
        ),
      ],
    );
  }
}

class StandardPdfPage extends StatelessWidget {
  final String title;
  final String filePath;

  const StandardPdfPage({
    super.key,
    required this.title,
    required this.filePath,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: PDFView(
        filePath: filePath,
        enableSwipe: true,
        swipeHorizontal: false,
        autoSpacing: true,
        pageFling: true,
      ),
    );
  }
}
