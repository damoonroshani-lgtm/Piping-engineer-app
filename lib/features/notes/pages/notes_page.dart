
import 'package:flutter/material.dart';

import 'package:piping_engineer/features/notes/models/note_model.dart';
import 'package:piping_engineer/features/notes/repositories/note_repository.dart';

class NotesPage extends StatefulWidget {
  const NotesPage({super.key});

  @override
  State<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  final NoteRepository _repository = NoteRepository.instance;
  final TextEditingController _searchController =
      TextEditingController();

  List<NoteModel> _notes = [];
  bool _isLoading = true;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _loadNotes();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadNotes() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final result = await _repository.searchNotes(_searchQuery);

      if (!mounted) return;

      setState(() {
        _notes = result;
        _isLoading = false;
      });
    } catch (error) {
      if (!mounted) return;

      setState(() {
        _isLoading = false;
      });

      _showMessage('خطا در دریافت یادداشت‌ها: $error');
    }
  }

  Future<void> _showNoteEditor({NoteModel? note}) async {
    final titleController = TextEditingController(
      text: note?.title ?? '',
    );

    final contentController = TextEditingController(
      text: note?.content ?? '',
    );

    final result = await showDialog<Map<String, String>>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(
            note == null ? 'یادداشت جدید' : 'ویرایش یادداشت',
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(
                    labelText: 'عنوان یادداشت',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: contentController,
                  minLines: 4,
                  maxLines: 8,
                  decoration: const InputDecoration(
                    labelText: 'متن یادداشت',
                    alignLabelWithHint: true,
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('انصراف'),
            ),
            ElevatedButton(
              onPressed: () {
                final title = titleController.text.trim();
                final content = contentController.text.trim();

                if (title.isEmpty || content.isEmpty) {
                  return;
                }

                Navigator.pop(dialogContext, {
                  'title': title,
                  'content': content,
                });
              },
              child: const Text('ذخیره'),
            ),
          ],
        );
      },
    );

    titleController.dispose();
    contentController.dispose();

    if (result == null) return;

    try {
      if (note == null) {
        final now = DateTime.now();

        final newNote = NoteModel(
          title: result['title']!,
          content: result['content']!,
          createdAt: now,
          updatedAt: now,
        );

        await _repository.createNote(newNote);
      } else {
        final updatedNote = note.copyWith(
          title: result['title'],
          content: result['content'],
          updatedAt: DateTime.now(),
        );

        await _repository.updateNote(updatedNote);
      }

      if (!mounted) return;

      await _loadNotes();
      _showMessage('یادداشت ذخیره شد.');
    } catch (error) {
      _showMessage('خطا در ذخیره یادداشت: $error');
    }
  }

  Future<void> _deleteNote(NoteModel note) async {
    if (note.id == null) return;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('حذف یادداشت'),
          content: const Text(
            'آیا از حذف این یادداشت مطمئن هستید؟',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: const Text('انصراف'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(dialogContext, true),
              child: const Text('حذف'),
            ),
          ],
        );
      },
    );

    if (confirmed != true) return;

    try {
      await _repository.deleteNote(note.id!);

      if (!mounted) return;

      await _loadNotes();
      _showMessage('یادداشت حذف شد.');
    } catch (error) {
      _showMessage('خطا در حذف یادداشت: $error');
    }
  }

  void _showMessage(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('یادداشت‌های من'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'جست‌وجوی یادداشت...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                    _searchQuery = '';
                    _loadNotes();
                  },
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onChanged: (value) {
                _searchQuery = value;
                _loadNotes();
              },
            ),
          ),
          Expanded(
            child: _isLoading
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : _notes.isEmpty
                    ? const Center(
                        child: Text('هنوز یادداشتی ثبت نشده است.'),
                      )
                    : RefreshIndicator(
                        onRefresh: _loadNotes,
                        child: ListView.builder(
                          padding: const EdgeInsets.all(12),
                          itemCount: _notes.length,
                          itemBuilder: (context, index) {
                            final note = _notes[index];

                            return Card(
                              child: ListTile(
                                title: Text(
                                  note.title,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                subtitle: Text(
                                  note.content,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                onTap: () =>
                                    _showNoteEditor(note: note),
                                trailing: PopupMenuButton<String>(
                                  onSelected: (value) {
                                    if (value == 'edit') {
                                      _showNoteEditor(note: note);
                                    } else if (value == 'delete') {
                                      _deleteNote(note);
                                    }
                                  },
                                  itemBuilder: (context) => [
                                    const PopupMenuItem(
                                      value: 'edit',
                                      child: Text('ویرایش'),
                                    ),
                                    const PopupMenuItem(
                                      value: 'delete',
                                      child: Text('حذف'),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showNoteEditor(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
