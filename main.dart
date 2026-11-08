import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

void main() => runApp(const PipingEngineerApp());

class PipingEngineerApp extends StatelessWidget {
  const PipingEngineerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Piping Engineer',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueGrey),
        useMaterial3: true,
      ),
      home: const Directionality(
        textDirection: TextDirection.rtl,
        child: HomePage(),
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final items = <(String, IconData, Widget)>[
      ('تحلیل نقشه پایپینگ', Icons.document_scanner, const DrawingPage()),
      ('آموزش پایپینگ', Icons.menu_book, const PlaceholderPage(title: 'آموزش پایپینگ')),
      ('استانداردها و مراجع', Icons.library_books, const PlaceholderPage(title: 'استانداردها و مراجع')),
      ('محاسبات مهندسی', Icons.calculate, const PlaceholderPage(title: 'محاسبات مهندسی')),
      ('تجهیزات و شیرآلات', Icons.settings, const PlaceholderPage(title: 'تجهیزات و شیرآلات')),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Piping Engineer')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'دستیار مهندسی پایپینگ',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text('آموزش، مرجع و تحلیل نقشه‌های صنعتی'),
          const SizedBox(height: 20),
          for (final item in items)
            Card(
              child: ListTile(
                leading: Icon(item.$2, size: 30),
                title: Text(item.$1),
                trailing: const Icon(Icons.chevron_left),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => Directionality(
                    textDirection: TextDirection.rtl,
                    child: item.$3,
                  )),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class DrawingPage extends StatefulWidget {
  const DrawingPage({super.key});

  @override
  State<DrawingPage> createState() => _DrawingPageState();
}

class _DrawingPageState extends State<DrawingPage> {
  final picker = ImagePicker();
  XFile? selected;

  Future<void> choose(ImageSource source) async {
    final image = await picker.pickImage(source: source, imageQuality: 90);
    if (image != null && mounted) setState(() => selected = image);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('تحلیل نقشه پایپینگ')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text('تصویر بخشی از P&ID یا نقشه ایزومتریک را انتخاب کن.'),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            children: [
              ElevatedButton.icon(
                onPressed: () => choose(ImageSource.camera),
                icon: const Icon(Icons.camera_alt),
                label: const Text('عکس‌برداری'),
              ),
              OutlinedButton.icon(
                onPressed: () => choose(ImageSource.gallery),
                icon: const Icon(Icons.photo_library),
                label: const Text('انتخاب از گالری'),
              ),
            ],
          ),
          const SizedBox(height: 20),
          if (selected != null)
            Text('تصویر انتخاب شد: ${selected!.name}')
          else
            const Text('هنوز تصویری انتخاب نشده است.'),
          const SizedBox(height: 16),
          const Card(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'موتور تحلیل هوشمند نقشه هنوز به این نسخه متصل نشده است. '
                'این نسخه فقط اسکلت اولیه رابط کاربری است.',
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class PlaceholderPage extends StatelessWidget {
  const PlaceholderPage({super.key, required this.title});
  final String title;

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: Text(title)),
        body: const Center(child: Text('این بخش در مراحل بعدی توسعه داده می‌شود.')),
      );
}
