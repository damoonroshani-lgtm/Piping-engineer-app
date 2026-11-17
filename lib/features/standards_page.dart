
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:pdfrx/pdfrx.dart';

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

class StandardPdfPage extends StatefulWidget {
  final String title;
  final String filePath;

  const StandardPdfPage({
    super.key,
    required this.title,
    required this.filePath,
  });

  @override
  State<StandardPdfPage> createState() => _StandardPdfPageState();
}

class _StandardPdfPageState extends State<StandardPdfPage> {
  final PdfViewerController _pdfController = PdfViewerController();

  late final TextEditingController _searchController;
  late final PdfTextSearcher _textSearcher;

  bool _hasSearched = false;

  @override
  void initState() {
    super.initState();

    _searchController = TextEditingController();

    _textSearcher = PdfTextSearcher(_pdfController)
      ..addListener(_onSearchUpdate);
  }

  void _onSearchUpdate() {
    if (mounted) {
      setState(() {});
    }
  }

  String _normalizeSearchText(String value) {
    return value
        .replaceAll('ي', 'ی')
        .replaceAll('ك', 'ک')
        .replaceAll('ۀ', 'ه')
        .trim();
  }

  void _searchPdf() {
    final query = _normalizeSearchText(_searchController.text);

    if (query.isEmpty) return;

    FocusScope.of(context).unfocus();

    setState(() {
      _hasSearched = true;
    });

    _textSearcher.resetTextSearch();

    _textSearcher.startTextSearch(
      query,
      caseInsensitive: true,
    );
  }

  Future<void> _openSearchResult(int index) async {
    await _textSearcher.goToMatchOfIndex(index);

    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    _searchController.dispose();

    _textSearcher.removeListener(_onSearchUpdate);
    _textSearcher.dispose();

    super.dispose();
  }

  Widget _buildSearchPanel() {
    final matches = _textSearcher.matches;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(10, 10, 10, 6),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _searchController,
                  textDirection: TextDirection.ltr,
                  textAlign: TextAlign.start,
                  decoration: const InputDecoration(
                    hintText: 'جست‌وجو در متن PDF؛ مثلاً Welding',
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(),
                    isDense: true,
                  ),
                  onSubmitted: (_) => _searchPdf(),
                ),
              ),
              const SizedBox(width: 8),
              IconButton.filled(
                onPressed: _searchPdf,
                icon: const Icon(Icons.search),
                tooltip: 'جست‌وجو',
              ),
            ],
          ),
        ),
        if (_hasSearched)
          Container(
            constraints: const BoxConstraints(maxHeight: 190),
            margin: const EdgeInsets.fromLTRB(10, 0, 10, 8),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainerLow,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: Theme.of(context).dividerColor,
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.find_in_page, size: 20),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'تعداد نتایج: ${matches.length}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      if (_textSearcher.isSearching)
                        const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                          ),
                        ),
                    ],
                  ),
                ),
                if (matches.isNotEmpty)
                  Flexible(
                    child: ListView.separated(
                      shrinkWrap: true,
                      itemCount: matches.length,
                      separatorBuilder: (_, __) =>
                          const Divider(height: 1),
                      itemBuilder: (context, index) {
                        final match = matches[index];

                        return ListTile(
                          dense: true,
                          leading: CircleAvatar(
                            radius: 17,
                            child: Text(
                              '${match.pageNumber}',
                              style: const TextStyle(fontSize: 12),
                            ),
                          ),
                          title: Text(
                            'صفحه ${match.pageNumber}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Text(
                            match.text,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            textDirection: TextDirection.rtl,
                          ),
                          trailing: const Icon(
                            Icons.arrow_forward_ios,
                            size: 16,
                          ),
                          onTap: () => _openSearchResult(index),
                        );
                      },
                    ),
                  )
                else if (!_textSearcher.isSearching)
                  const Padding(
                    padding: EdgeInsets.all(14),
                    child: Text(
                      'نتیجه‌ای پیدا نشد. ممکن است PDF اسکن‌شده باشد و متن قابل جست‌وجو نداشته باشد.',
                      textAlign: TextAlign.center,
                    ),
                  ),
              ],
            ),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
      ),
      body: Column(
        children: [
          _buildSearchPanel(),
          Expanded(
            child: PdfViewer.file(
              widget.filePath,
              controller: _pdfController,
              params: PdfViewerParams(
                pagePaintCallbacks: [
                  _textSearcher.pageTextMatchPaintCallback,
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
