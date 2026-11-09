
import 'dart:async';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:piping_engineer/core/theme/app_theme.dart';
import 'package:piping_engineer/core/diagnostics/error_logger.dart';
import 'package:piping_engineer/features/notes/pages/notes_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.presentError(details);

    unawaited(
      ErrorLogger.instance.saveError(
        details.exceptionAsString(),
        source: 'Flutter Framework',
        stackTrace: details.stack?.toString(),
      ),
    );
  };

  ui.PlatformDispatcher.instance.onError = (
    Object error,
    StackTrace stack,
  ) {
    unawaited(
      ErrorLogger.instance.saveError(
        error.toString(),
        source: 'Platform Dispatcher',
        stackTrace: stack.toString(),
      ),
    );

    return false;
  };

  runApp(const PipingApp());
}

class PipingApp extends StatelessWidget {
  const PipingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Piping Engineering',
      theme: AppTheme.lightTheme,
      home: const Directionality(
        textDirection: TextDirection.rtl,
        child: HomePage(),
      ),
    );
  }
}

class Lesson {
  final int number;
  final String title;
  final String subtitle;
  final IconData icon;

  const Lesson(this.number, this.title, this.subtitle, this.icon);
}

const List<Lesson> lessons = [
  Lesson(1, 'مبانی پایپینگ', 'آشنایی با صنعت و اصطلاحات', Icons.school),
  Lesson(2, 'قطر اسمی و ضخامت لوله', 'NPS و Schedule', Icons.straighten),
  Lesson(3, 'استانداردهای صنعتی', 'ASME، API و ASTM', Icons.menu_book),
  Lesson(4, 'متریال لوله و اتصالات', 'Pipe Material Specification', Icons.category),
  Lesson(5, 'فلنج و گسکت', 'Flanges, Gaskets & Bolts', Icons.settings),
  Lesson(6, 'انواع شیرآلات صنعتی', 'Industrial Valves', Icons.tune),
  Lesson(7, 'نقشه‌خوانی P&ID', 'Process & Instrumentation Diagram', Icons.account_tree),
  Lesson(8, 'شماره‌گذاری خطوط', 'Line Numbering', Icons.numbers),
  Lesson(9, 'کلاس لوله‌کشی', 'Piping Class', Icons.list_alt),
  Lesson(10, 'جدول انشعاب', 'Branch Table', Icons.call_split),
  Lesson(11, 'نقشه ایزومتریک', 'Isometric Drawing', Icons.draw),
  Lesson(12, 'تکیه‌گاه لوله', 'Pipe Support', Icons.architecture),
  Lesson(13, 'مسیرگذاری لوله', 'Pipe Routing', Icons.route),
  Lesson(14, 'محاسبات هیدرولیکی', 'Hydraulic Calculation', Icons.water_drop),
  Lesson(15, 'تنش لوله', 'Pipe Stress Analysis', Icons.analytics),
  Lesson(16, 'جوشکاری و بازرسی', 'Welding & NDT', Icons.construction),
  Lesson(17, 'PWHT و تست لوله', 'Testing & Heat Treatment', Icons.thermostat),
  Lesson(18, 'متره و برآورد', 'MTO', Icons.calculate),
  Lesson(19, 'کنترل کیفیت', 'Quality Control', Icons.verified),
  Lesson(20, 'پروژه عملی صنعتی', 'Industrial Practice', Icons.factory),
];

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
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
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF07569A), Color(0xFF062D55)],
              ),
              borderRadius: BorderRadius.circular(18),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.engineering, color: Colors.white, size: 42),
                SizedBox(height: 12),
                Text(
                  'آموزش جامع مهندسی پایپینگ',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 21,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'از مبانی تا طراحی و کاربردهای صنعتی',
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                ),
              ],
            ),
          ),
          const SizedBox(height: 22),
          const Text(
            'بخش‌های اصلی برنامه',
            style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          _menuCard(
            context,
            'دوره جامع آموزشی',
            '۲۰ فصل آموزش گام‌به‌گام',
            Icons.menu_book,
            () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const LessonsPage()),
            ),
          ),
          _menuCard(
            context,
            'یادداشت‌های من',
            'ثبت، جست‌وجو، ویرایش و مدیریت یادداشت‌ها',
            Icons.note_alt,
            () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const NotesPage()),
            ),
          ),
          _menuCard(
            context,
            'تحلیل نقشه با هوش مصنوعی',
            'بررسی P&ID و نقشه‌های صنعتی',
            Icons.document_scanner,
            () => _showMessage(context, 'بخش تحلیل هوشمند در مرحله توسعه است.'),
          ),
          _menuCard(
            context,
            'محاسبات مهندسی',
            'ابزارهای محاسباتی پایپینگ',
            Icons.calculate,
            () => _showMessage(context, 'بخش محاسبات در مرحله توسعه است.'),
          ),
          _menuCard(
            context,
            'کتابخانه استانداردها و PDF',
            'مرجع آموزشی و فایل‌های تخصصی',
            Icons.picture_as_pdf,
            () => _showMessage(context, 'کتابخانه PDF در مرحله توسعه است.'),
          ),
          const SizedBox(height: 18),
          const Card(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'هدف آموزشی ما',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'یادگیری مفاهیم مهندسی با تصاویر واضح، '
                    'مثال‌های واقعی، توضیحات کامل و تمرین‌های کاربردی.',
                    style: TextStyle(fontSize: 14, height: 1.8),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _menuCard(
    BuildContext context,
    String title,
    String subtitle,
    IconData icon,
    VoidCallback action,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        leading: CircleAvatar(
          backgroundColor: const Color(0xFFE0EDFA),
          child: Icon(icon, color: const Color(0xFF07569A)),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.arrow_back_ios_new, size: 17),
        onTap: action,
      ),
    );
  }

  void _showMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}

class LessonsPage extends StatelessWidget {
  const LessonsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('دوره جامع آموزشی')),
      body: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: lessons.length,
        itemBuilder: (context, index) {
          final lesson = lessons[index];

          return Card(
            margin: const EdgeInsets.only(bottom: 10),
            child: ListTile(
              contentPadding: const EdgeInsets.all(12),
              leading: CircleAvatar(
                backgroundColor: const Color(0xFFE0EDFA),
                child: Icon(lesson.icon, color: const Color(0xFF07569A)),
              ),
              title: Text(
                'درس ${lesson.number}: ${lesson.title}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(lesson.subtitle),
              trailing: const Icon(Icons.arrow_back_ios, size: 17),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => LessonPage(lesson: lesson),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class LessonPage extends StatelessWidget {
  final Lesson lesson;

  const LessonPage({super.key, required this.lesson});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('درس ${lesson.number}')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            lesson.title,
            style: const TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(lesson.subtitle, style: const TextStyle(color: Colors.blueGrey)),
          const SizedBox(height: 20),
          if (lesson.number == 6)
            const ValveLesson()
          else
            const Card(
              child: Padding(
                padding: EdgeInsets.all(18),
                child: Text(
                  'محتوای کامل این درس در مرحله آماده‌سازی است. '
                  'در نسخه آموزشی نهایی، توضیحات، تصاویر فنی، '
                  'مثال‌های صنعتی و آزمون اختصاصی اضافه خواهند شد.',
                  style: TextStyle(fontSize: 16, height: 2),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class ValveLesson extends StatelessWidget {
  const ValveLesson({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'آشنایی با شیرآلات صنعتی',
          style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        const Text(
          'شیر صنعتی وسیله‌ای مکانیکی برای کنترل جریان سیال '
          'در خطوط لوله است. بسته به نوع طراحی، شیر می‌تواند '
          'جریان را قطع کند، وصل کند، تنظیم کند یا از برگشت آن جلوگیری کند.',
          style: TextStyle(fontSize: 15, height: 1.9),
        ),
        const SizedBox(height: 20),
        const Text(
          'انواع اصلی شیرآلات',
          style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        _valve('Gate Valve', 'شیر کشویی', 'قطع و وصل کامل جریان'),
        _valve('Globe Valve', 'شیر کروی', 'تنظیم جریان'),
        _valve('Ball Valve', 'شیر توپی', 'قطع و وصل سریع'),
        _valve('Butterfly Valve', 'شیر پروانه‌ای', 'کنترل و قطع جریان'),
        _valve('Check Valve', 'شیر یک‌طرفه', 'جلوگیری از برگشت جریان'),
        const SizedBox(height: 20),
        const Text(
          'ساختمان شیر کشویی',
          style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        const Card(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                Icon(Icons.settings, size: 85, color: Color(0xFF07569A)),
                Text(
                  'تصویر فنی برش‌خورده شیر کشویی در مرحله بعد اضافه می‌شود.',
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        const Text(
          'نکته مهندسی',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const Card(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              'شیر کشویی معمولاً برای قطع و وصل کامل جریان استفاده می‌شود '
              'و برای تنظیم مداوم دبی در حالت نیمه‌باز مناسب نیست.',
              style: TextStyle(height: 1.9),
            ),
          ),
        ),
      ],
    );
  }

  Widget _valve(String english, String persian, String use) {
    return Card(
      child: ListTile(
        leading: const Icon(Icons.settings, color: Color(0xFF07569A)),
        title: Text(english, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text('$persian — $use'),
      ),
    );
  }
}
