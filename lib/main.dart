
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'features/calculations/calculations_page.dart';
import 'features/standards_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const PipingEngineerApp());
}

class PipingEngineerApp extends StatelessWidget {
  const PipingEngineerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Piping Engineering',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF07569A),
        ),
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
    final items = <(String, String, IconData, Widget)>[
      (
        'تحلیل نقشه پایپینگ',
        'بررسی نقشه‌های P&ID و ایزومتریک',
        Icons.document_scanner,
        const DrawingPage(),
      ),
      (
        'آموزش پایپینگ',
        'آموزش مفاهیم مهندسی پایپینگ',
        Icons.menu_book,
        const PlaceholderPage(title: 'آموزش پایپینگ'),
      ),
      (
        'کتابخانه استانداردها و PDF',
        'افزودن، جست‌وجو و مطالعه استانداردها',
        Icons.library_books,
        const StandardsPage(),
      ),
      (
        'محاسبات مهندسی',
        'ابزارهای محاسباتی پایپینگ',
        Icons.calculate,
        const CalculationsPage(),
      ),
      (
        'تجهیزات و شیرآلات',
        'آشنایی با تجهیزات صنعتی',
        Icons.settings,
        const PlaceholderPage(title: 'تجهیزات و شیرآلات'),
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Piping Engineering',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  Color(0xFF07569A),
                  Color(0xFF062D55),
                ],
              ),
              borderRadius: BorderRadius.circular(18),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.engineering,
                  color: Colors.white,
                  size: 42,
                ),
                SizedBox(height: 12),
                Text(
                  'دستیار مهندسی پایپینگ',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'آموزش، محاسبات، استانداردها و تحلیل نقشه‌های صنعتی',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                    height: 1.8,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 22),
          const Text(
            'بخش‌های اصلی برنامه',
            style: TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),

          ...items.map((item) {
            return Card(
              margin: const EdgeInsets.only(bottom: 10),
              child: ListTile(
                contentPadding: const EdgeInsets.all(12),
                leading: CircleAvatar(
                  backgroundColor: const Color(0xFFE0EDFA),
                  child: Icon(
                    item.$3,
                    color: const Color(0xFF07569A),
                  ),
                ),
                title: Text(
                  item.$1,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(item.$2),
                trailing: const Icon(
                  Icons.arrow_back_ios_new,
                  size: 17,
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => Directionality(
                        textDirection: TextDirection.rtl,
                        child: item.$4,
                      ),
                    ),
                  );
                },
              ),
            );
          }),
          const SizedBox(height: 16),
          const Card(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'هدف برنامه',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'ایجاد یک مرجع جامع آموزشی و مهندسی پایپینگ '
                    'با قابلیت مطالعه استانداردها، محاسبات مهندسی '
                    'و یادگیری کاربردی.',
                    style: TextStyle(height: 1.9),
                  ),
                ],
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
  final ImagePicker picker = ImagePicker();
  XFile? selected;

  Future<void> choose(ImageSource source) async {
    try {
      final image = await picker.pickImage(
        source: source,
        imageQuality: 90,
      );

      if (image != null && mounted) {
        setState(() {
          selected = image;
        });
      }
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('خطا در انتخاب تصویر: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('تحلیل نقشه پایپینگ'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'تصویر بخشی از P&ID یا نقشه ایزومتریک را انتخاب کن.',
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
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
                'موتور تحلیل هوشمند نقشه در مرحله توسعه است.',
                style: TextStyle(height: 1.8),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class PlaceholderPage extends StatelessWidget {
  const PlaceholderPage({
    super.key,
    required this.title,
  });

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: const Center(
        child: Text(
          'این بخش در مراحل بعدی توسعه داده می‌شود.',
        ),
      ),
    );
  }
}
