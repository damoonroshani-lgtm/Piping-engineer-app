import 'dart:async';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:piping_engineer/core/theme/app_theme.dart';
import 'package:piping_engineer/core/diagnostics/error_logger.dart';
import 'package:piping_engineer/core/diagnostics/error_log_page.dart';
import 'package:piping_engineer/features/notes/pages/notes_page.dart';
import 'package:piping_engineer/core/widgets/app_text.dart';
import 'package:piping_engineer/core/widgets/valve_diagrams.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.presentError(details);
    unawaited(ErrorLogger.instance.saveError(
      details.exceptionAsString(),
      source: 'Flutter Framework',
      stackTrace: details.stack?.toString(),
    ));
  };

  ui.PlatformDispatcher.instance.onError = (
    Object error,
    StackTrace stack,
  ) {
    unawaited(ErrorLogger.instance.saveError(
      error.toString(),
      source: 'Platform Dispatcher',
      stackTrace: stack.toString(),
    ));
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
      builder: (context, child) => Directionality(
        textDirection: TextDirection.rtl,
        child: child ?? const SizedBox.shrink(),
      ),
      home: const HomePage(),
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
        title: const AppText(
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
                AppText(
                  'آموزش جامع مهندسی پایپینگ',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 21,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                AppText(
                  'از مبانی تا طراحی و کاربردهای صنعتی',
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                ),
              ],
            ),
          ),
          const SizedBox(height: 22),
          const AppText(
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
            'گزارش خطاهای برنامه',
            'مشاهده و کپی گزارش خطا برای بررسی',
            Icons.bug_report,
            () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ErrorLogPage()),
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
                  AppText(
                    'هدف آموزشی ما',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                  ),
                  SizedBox(height: 8),
                  AppText(
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
        title: AppText(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: AppText(subtitle),
        trailing: const Icon(Icons.arrow_back_ios_new, size: 17),
        onTap: action,
      ),
    );
  }

  void _showMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: AppText(message)),
    );
  }
}

class LessonsPage extends StatelessWidget {
  const LessonsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const AppText('دوره جامع آموزشی')),
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
              title: AppText(
                'درس ${lesson.number}: ${lesson.title}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: AppText(lesson.subtitle),
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
      appBar: AppBar(title: AppText('درس ${lesson.number}')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          AppText(
            lesson.title,
            style: const TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          AppText(
            lesson.subtitle,
            style: const TextStyle(color: Colors.blueGrey),
          ),
          const SizedBox(height: 20),
          if (lesson.number == 1)
            const FirstLesson()
          else if (lesson.number == 6)
            const ValveLesson()
          else
            const Card(
              child: Padding(
                padding: EdgeInsets.all(18),
                child: AppText(
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

// ---------------- درس اول ----------------

class FirstLesson extends StatelessWidget {
  const FirstLesson({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _section(
          '۱. پایپینگ چیست؟',
          'پایپینگ (Piping) به مجموعه‌ای از لوله‌ها، اتصالات، '
          'شیرآلات و تجهیزات جانبی گفته می‌شود که برای انتقال '
          'سیالات از یک نقطه به نقطه دیگر در یک واحد صنعتی استفاده می‌شوند.\n\n'
          'سیال می‌تواند مایع، گاز، بخار یا مخلوطی از چند ماده باشد. '
          'وظیفه سیستم پایپینگ فقط انتقال سیال نیست؛ بلکه باید شرایط '
          'مناسب فشار، دما، دبی، ایمنی و قابلیت بهره‌برداری را نیز فراهم کند.',
        ),
        _section(
          '۲. پایپینگ در چه صنایعی استفاده می‌شود؟',
          'سیستم‌های پایپینگ در بسیاری از صنایع نقش اساسی دارند:',
          bullets: const [
            'نفت و گاز: انتقال نفت خام، گاز طبیعی و محصولات پالایشگاهی',
            'پالایشگاه‌ها: ارتباط بین واحدهای فرآیندی و مخازن',
            'پتروشیمی: انتقال مواد اولیه، محصولات و مواد شیمیایی',
            'نیروگاه‌ها: انتقال آب، بخار و سوخت',
            'صنایع غذایی: انتقال مواد مایع و محلول‌های فرآیندی',
            'صنایع دارویی: انتقال سیالات با الزامات بهداشتی',
            'کارخانه‌ها: خطوط آب خنک‌کننده، هوای فشرده و بخار',
          ],
        ),
        _section(
          '۳. اجزای اصلی یک سیستم پایپینگ',
          'یک خط لوله صنعتی از اجزای مختلفی تشکیل می‌شود. '
          'هر جزء وظیفه مشخصی دارد و انتخاب صحیح آن برای عملکرد '
          'ایمن سیستم ضروری است.',
          bullets: const [
            'Pipe: لوله؛ مسیر اصلی عبور سیال',
            'Elbow: زانویی؛ تغییر جهت مسیر لوله',
            'Tee: سه‌راهی؛ ایجاد انشعاب از خط اصلی',
            'Reducer: تبدیل؛ تغییر قطر لوله',
            'Flange: فلنج؛ اتصال قابل بازشدن بین اجزا',
            'Gasket: گسکت؛ آب‌بندی محل اتصال فلنجی',
            'Valve: شیر؛ قطع، وصل یا کنترل جریان',
            'Pipe Support: تکیه‌گاه؛ نگهداری وزن لوله و تجهیزات',
          ],
        ),
        _section(
          '۴. مسیر حرکت سیال در یک واحد صنعتی',
          'برای درک بهتر پایپینگ، یک سیستم ساده انتقال آب را در نظر بگیرید.\n\n'
          'آب از مخزن خارج می‌شود، از طریق لوله به پمپ می‌رسد، '
          'پس از افزایش فشار توسط پمپ از شیرها و مسیر لوله عبور می‌کند '
          'و در نهایت به مصرف‌کننده یا مخزن مقصد می‌رسد.',
        ),
        const FlowDiagram(),
        _section(
          '۵. اصطلاحات پایه در پایپینگ',
          'در نقشه‌ها و مدارک مهندسی، اصطلاحات زیر بسیار پرکاربرد هستند:',
          bullets: const [
            'Flow: جریان سیال در داخل لوله',
            'Pressure: فشار سیال',
            'Temperature: دمای سیال',
            'Flow Rate: مقدار سیال عبوری در واحد زمان',
            'Diameter: قطر لوله',
            'Wall Thickness: ضخامت جداره لوله',
            'Material: جنس یا متریال قطعه',
            'Design Pressure: فشار طراحی',
            'Design Temperature: دمای طراحی',
            'Operating Condition: شرایط واقعی بهره‌برداری',
          ],
        ),
        _section(
          '۶. تفاوت طراحی و شرایط عملیاتی',
          'شرایط عملیاتی (Operating Conditions) به فشار و دمایی گفته '
          'می‌شود که سیستم در زمان کارکرد عادی تجربه می‌کند.\n\n'
          'شرایط طراحی (Design Conditions) مبنای طراحی مکانیکی سیستم است '
          'و معمولاً با در نظر گرفتن حاشیه ایمنی و الزامات استاندارد '
          'تعیین می‌شود.\n\n'
          'بنابراین فشار و دمای طراحی الزاماً با فشار و دمای عادی '
          'بهره‌برداری یکسان نیستند.',
        ),
        _section(
          '۷. مثال کاربردی صنعتی',
          'فرض کنید قرار است آب از یک مخزن ذخیره به یک مبدل حرارتی منتقل شود.\n\n'
          'برای طراحی اولیه این مسیر، مهندس پایپینگ باید اطلاعاتی مانند '
          'دبی آب، فشار و دمای کارکرد، فاصله مخزن تا مبدل، قطر موردنیاز '
          'لوله، جنس لوله و نوع اتصالات را بررسی کند.\n\n'
          'همچنین باید محل نصب شیرهای قطع و وصل، مسیر عبور لوله، '
          'تکیه‌گاه‌ها و امکان تعمیرات آینده در نظر گرفته شود.',
        ),
        const ExampleCard(),
        _section(
          '۸. وظایف مهندس پایپینگ',
          'مهندس پایپینگ در مراحل مختلف یک پروژه صنعتی با رشته‌های '
          'فرآیند، مکانیک، سازه، ابزار دقیق و برق همکاری می‌کند.',
          bullets: const [
            'بررسی مدارک فرآیندی و اطلاعات طراحی',
            'مطالعه نقشه‌های P&ID',
            'تعیین مسیر مناسب عبور لوله‌ها',
            'انتخاب لوله، اتصالات، شیرآلات و متریال',
            'بررسی کلاس لوله‌کشی و مشخصات فنی',
            'تهیه و بررسی نقشه‌های ایزومتریک',
            'بررسی تکیه‌گاه‌ها و محدودیت‌های نصب',
            'تهیه مقادیر موردنیاز و فهرست متریال (MTO)',
            'همکاری با واحدهای نصب، بازرسی و کنترل کیفیت',
          ],
        ),
        _section(
          '۹. نکات مهم این درس',
          '۱. پایپینگ فقط لوله نیست؛ مجموعه‌ای از اجزا و الزامات فنی است.\n\n'
          '۲. انتخاب متریال به نوع سیال، فشار، دما و شرایط محیطی وابسته است.\n\n'
          '۳. مسیر لوله باید از نظر ایمنی، بهره‌برداری و تعمیرات بررسی شود.\n\n'
          '۴. نقشه‌ها و استانداردها مبنای تصمیم‌گیری مهندس پایپینگ هستند.',
        ),
        const LessonQuiz(),
      ],
    );
  }

  static Widget _section(
    String title,
    String description, {
    List<String> bullets = const [],
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 14),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppText(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF07569A),
              ),
            ),
            const SizedBox(height: 10),
            AppText(
              description,
              style: const TextStyle(fontSize: 15, height: 1.9),
            ),
            if (bullets.isNotEmpty) ...[
              const SizedBox(height: 10),
              ...bullets.map(
                (item) => Padding(
                  padding: const EdgeInsets.only(bottom: 9),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(top: 7),
                        child: Icon(
                          Icons.circle,
                          size: 7,
                          color: Color(0xFF07569A),
                        ),
                      ),
                      const SizedBox(width: 9),
                      Expanded(
                        child: AppText(
                          item,
                          style: const TextStyle(fontSize: 14, height: 1.8),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class FlowDiagram extends StatelessWidget {
  const FlowDiagram({super.key});

  @override
  Widget build(BuildContext context) {
    final items = [
      ('مخزن آب', Icons.water_drop),
      ('پمپ', Icons.settings),
      ('شیرآلات', Icons.tune),
      ('خط لوله', Icons.linear_scale),
      ('مبدل حرارتی', Icons.device_thermostat),
    ];

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const AppText(
              'نمای ساده مسیر انتقال سیال',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 15),
            ...items.asMap().entries.map((entry) {
              return Column(
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(13),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEAF3FC),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(entry.value.$2, color: const Color(0xFF07569A)),
                        const SizedBox(width: 10),
                        AppText(
                          entry.value.$1,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  if (entry.key != items.length - 1)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 5),
                      child: Icon(
                        Icons.arrow_downward,
                        color: Color(0xFF07569A),
                        size: 25,
                      ),
                    ),
                ],
              );
            }),
            const SizedBox(height: 8),
            const AppText(
              'این شکل فقط مسیر مفهومی جریان را نشان می‌دهد و نقشه اجرایی نیست.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12, color: Colors.blueGrey),
            ),
          ],
        ),
      ),
    );
  }
}

class ExampleCard extends StatelessWidget {
  const ExampleCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      color: const Color(0xFFF1F6FB),
      child: const Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppText(
              'نمونه بررسی اولیه خط انتقال آب',
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 12),
            AppText('اطلاعات فرضی مسئله:', style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            AppText('سیال: آب'),
            AppText('مبدأ: مخزن ذخیره'),
            AppText('مقصد: مبدل حرارتی'),
            AppText('دبی موردنیاز: ۲۰ مترمکعب بر ساعت'),
            AppText('فشار و دمای طراحی: باید از مدارک پروژه دریافت شود.'),
            SizedBox(height: 12),
            AppText(
              'مهندس پایپینگ با این اطلاعات به‌تنهایی نمی‌تواند قطر نهایی '
              'لوله را تعیین کند. ابتدا باید سرعت مجاز سیال، افت فشار، '
              'طول مسیر، اختلاف ارتفاع و مشخصات تجهیزات بررسی شوند.',
              style: TextStyle(height: 1.9),
            ),
            SizedBox(height: 10),
            AppText(
              'نتیجه: انتخاب قطر لوله یک تصمیم مهندسی است و صرفاً با حدس '
              'یا مشاهده قطر اتصالات انجام نمی‌شود.',
              style: TextStyle(fontWeight: FontWeight.bold, height: 1.8),
            ),
          ],
        ),
      ),
    );
  }
}

class LessonQuiz extends StatefulWidget {
  const LessonQuiz({super.key});

  @override
  State<LessonQuiz> createState() => _LessonQuizState();
}

class _LessonQuizState extends State<LessonQuiz> {
  int? selectedAnswer;
  bool submitted = false;

  final List<String> answers = const [
    'فقط برای نگهداری لوله‌ها',
    'برای انتقال و کنترل سیالات در سیستم صنعتی',
    'فقط برای افزایش فشار سیال',
    'فقط برای اتصال مخازن',
  ];

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 20),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const AppText(
              'آزمون کوتاه درس اول',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            const AppText(
              'وظیفه اصلی یک سیستم پایپینگ چیست؟',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            ...List.generate(answers.length, (index) {
              return RadioListTile<int>(
                value: index,
                groupValue: selectedAnswer,
                contentPadding: EdgeInsets.zero,
                dense: true,
                title: AppText(
                  answers[index],
                  style: const TextStyle(fontSize: 14),
                ),
                onChanged: submitted
                    ? null
                    : (value) => setState(() => selectedAnswer = value),
              );
            }),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: selectedAnswer == null || submitted
                    ? null
                    : () => setState(() => submitted = true),
                child: const AppText('ثبت پاسخ'),
              ),
            ),
            if (submitted) ...[
              const SizedBox(height: 12),
              AppText(
                selectedAnswer == 1
                    ? 'آفرین! پاسخ صحیح است.'
                    : 'پاسخ صحیح گزینه دوم است. هدف اصلی پایپینگ انتقال و کنترل سیالات است.',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: selectedAnswer == 1 ? Colors.green : Colors.red,
                  height: 1.8,
                ),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    selectedAnswer = null;
                    submitted = false;
                  });
                },
                child: const AppText('تکرار آزمون'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// ---------------- درس ششم: شیرآلات صنعتی ----------------

class ValveLesson extends StatelessWidget {
  const ValveLesson({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _intro(),
        _section(
          '۱. شیر صنعتی چیست و چه وظایفی دارد؟',
          'شیر صنعتی (Industrial Valve) وسیله‌ای مکانیکی است که در مسیر '
          'عبور سیال نصب می‌شود تا جریان را قطع کند، برقرار کند، تنظیم کند، '
          'مسیر آن را تغییر دهد یا از برگشت جریان جلوگیری کند.\n\n'
          'انتخاب شیر مناسب به نوع سیال، فشار، دما، دبی، اندازه خط، '
          'شرایط کاری و وظیفه مورد انتظار بستگی دارد.',
          bullets: const [
            'Isolation: جداسازی و قطع جریان',
            'Throttling: تنظیم مقدار جریان',
            'Non-return: جلوگیری از برگشت جریان',
            'Pressure protection: محافظت در برابر فشار بیش از حد',
            'Flow direction: تغییر یا تقسیم مسیر جریان',
          ],
        ),
        _section(
          '۲. اجزای اصلی شیر صنعتی',
          'اگرچه ساختمان شیرها با یکدیگر تفاوت دارد، بیشتر شیرهای صنعتی '
          'از تعدادی قطعه اصلی تشکیل شده‌اند.',
          bullets: const [
            'Body: بدنه اصلی شیر که اجزای داخلی را در خود جای می‌دهد',
            'Bonnet: درپوش یا قسمت بالایی بدنه',
            'Trim: مجموعه قطعات داخلی در تماس با جریان، مانند دیسک و نشیمنگاه',
            'Disc / Closure Element: قطعه متحرکی که مسیر جریان را باز یا بسته می‌کند',
            'Seat: سطح نشیمنگاه برای ایجاد آب‌بندی',
            'Stem: محور انتقال حرکت از عملگر به قطعه داخلی',
            'Packing: مواد آب‌بندی اطراف محور برای جلوگیری از نشتی',
            'Gland: قطعه فشرده‌کننده پکینگ',
            'Actuator: وسیله حرکت‌دهنده شیر، مانند هندویل یا محرک برقی',
          ],
        ),
        const ValvePartsCard(),
        _section(
          '۳. دسته‌بندی شیرها بر اساس وظیفه',
          'پیش از انتخاب نوع شیر باید مشخص شود که شیر چه کاری انجام می‌دهد.',
          bullets: const [
            'شیرهای قطع و وصل: مانند Gate و Ball',
            'شیرهای تنظیم جریان: مانند Globe و Control Valve',
            'شیرهای یک‌طرفه: مانند Swing Check و Lift Check',
            'شیرهای محافظ فشار: مانند Pressure Safety Valve',
            'شیرهای مناسب سیالات خاص: مانند Diaphragm Valve',
          ],
        ),
        _valveType(
          title: '۴. شیر کشویی (Gate Valve)',
          icon: Icons.vertical_align_center,
          operation: 'در شیر کشویی، یک قطعه مسدودکننده به شکل گیت یا صفحه '
              'در مسیر جریان حرکت می‌کند. با بالا رفتن گیت، مسیر باز می‌شود '
              'و با پایین آمدن آن، مسیر بسته می‌شود.',
          applications: const [
            'خطوط انتقال آب و سیالات صنعتی',
            'خطوطی که معمولاً در حالت کاملاً باز یا کاملاً بسته کار می‌کنند',
            'سرویس‌هایی که افت فشار کم در حالت باز اهمیت دارد',
          ],
          advantages: const [
            'در حالت کاملاً باز، مسیر عبور نسبتاً مستقیم است',
            'افت فشار معمولاً کم است',
            'برای جداسازی جریان در خطوط مناسب است',
          ],
          limitations: const [
            'برای تنظیم مداوم دبی مناسب نیست',
            'باز و بسته شدن آن ممکن است زمان‌بر باشد',
            'در حالت نیمه‌باز ممکن است سایش و آسیب ایجاد شود',
          ],
          varieties: 'انواع رایج شامل Wedge Gate، Parallel Slide و Knife Gate '
              'هستند. نوع مناسب به طراحی، سیال و شرایط کاری بستگی دارد.',
          engineeringNote: 'Gate Valve معمولاً برای سرویس قطع و وصل انتخاب '
              'می‌شود، نه کنترل دائمی جریان در وضعیت نیمه‌باز.',
        ),
        _valveType(
          title: '۵. شیر کروی (Globe Valve)',
          icon: Icons.circle_outlined,
          operation: 'در شیر کروی، دیسک به سمت نشیمنگاه حرکت می‌کند و با '
              'تغییر فاصله دیسک از Seat، مقدار عبور سیال کنترل می‌شود. '
              'مسیر داخلی این شیر معمولاً باعث تغییر جهت جریان می‌شود.',
          applications: const [
            'تنظیم جریان در خطوط فرآیندی',
            'کنترل دستی دبی در برخی سرویس‌ها',
            'خطوطی که کنترل دقیق‌تر از شیرهای قطع و وصل لازم دارند',
          ],
          advantages: const [
            'قابلیت مناسب برای تنظیم جریان',
            'امکان کنترل نسبتاً دقیق‌تر نسبت به Gate Valve',
            'ساختار مناسب برای برخی کاربردهای کنترلی',
          ],
          limitations: const [
            'افت فشار آن معمولاً بیشتر از Gate Valve است',
            'ممکن است برای خطوط با دبی بالا به توان بیشتری نیاز داشته باشد',
            'انتخاب Trim به شرایط سرویس وابسته است',
          ],
          varieties: 'طرح‌های رایج شامل T-pattern، Y-pattern و Angle Globe '
              'هستند. تفاوت آن‌ها در شکل مسیر داخلی و افت فشار است.',
          engineeringNote: 'اگر وظیفه اصلی شیر تنظیم جریان باشد، Globe Valve '
              'می‌تواند گزینه مناسبی باشد؛ اما باید افت فشار و شرایط سرویس بررسی شود.',
        ),
        _valveType(
          title: '۶. شیر توپی (Ball Valve)',
          icon: Icons.circle,
          operation: 'عنصر مسدودکننده در این شیر یک توپ سوراخ‌دار است. '
              'با چرخش توپ، سوراخ آن در راستای مسیر لوله قرار می‌گیرد '
              'و جریان عبور می‌کند. با چرخش معمولاً ۹۰ درجه‌ای، مسیر بسته می‌شود.',
          applications: const [
            'خطوط گاز و مایعات',
            'قطع و وصل سریع جریان',
            'سیستم‌هایی که آب‌بندی مناسب در حالت بسته اهمیت دارد',
          ],
          advantages: const [
            'عملکرد سریع در بسیاری از طراحی‌ها',
            'افت فشار کم در نوع Full Bore',
            'قابلیت آب‌بندی مناسب در طراحی و شرایط صحیح',
          ],
          limitations: const [
            'همه مدل‌ها برای کنترل پیوسته جریان مناسب نیستند',
            'باقی‌ماندن سیال در حفره برخی طراحی‌ها ممکن است مسئله‌ساز شود',
            'نوع Seat باید با دما و سازگاری شیمیایی سیال تطبیق داشته باشد',
          ],
          varieties: 'مدل‌های رایج شامل Floating Ball و Trunnion Mounted Ball '
              'هستند. همچنین شیرها از نظر مسیر عبور می‌توانند Full Bore یا Reduced Bore باشند.',
          engineeringNote: 'در خطوط با قطر یا فشار بالا، نوع نگهداری توپ و '
              'طراحی Seat اهمیت زیادی دارد. صرفاً نام Ball Valve برای انتخاب کافی نیست.',
        ),
        _valveType(
          title: '۷. شیر پروانه‌ای (Butterfly Valve)',
          icon: Icons.sync,
          operation: 'در این شیر یک دیسک در داخل مسیر لوله قرار دارد. '
              'با چرخش محور، دیسک می‌چرخد و میزان باز بودن مسیر تغییر می‌کند.',
          applications: const [
            'خطوط آب و آب خنک‌کننده',
            'سیستم‌های تهویه و تأسیسات',
            'خطوط با قطر نسبتاً بزرگ',
            'کاربردهای قطع و وصل و در برخی طراحی‌ها تنظیم جریان',
          ],
          advantages: const [
            'وزن و ابعاد نسبتاً کم',
            'مناسب برای بسیاری از خطوط با قطر بزرگ',
            'عملکرد سریع در مدل‌های ربع‌گرد',
          ],
          limitations: const [
            'دیسک در مسیر جریان باقی می‌ماند',
            'افت فشار و عملکرد به زاویه دیسک وابسته است',
            'محدودیت دما و فشار به نوع Seat و طراحی وابسته است',
          ],
          varieties: 'مدل‌های رایج شامل Concentric، Double Offset و Triple Offset '
              'هستند. این مدل‌ها از نظر ساختمان و عملکرد آب‌بندی تفاوت دارند.',
          engineeringNote: 'برای انتخاب Butterfly Valve باید نوع نشیمنگاه، '
              'فشار تفاضلی، دما و سازگاری مواد آب‌بندی بررسی شود.',
        ),
        _valveType(
          title: '۸. شیر یک‌طرفه (Check Valve)',
          icon: Icons.arrow_forward,
          operation: 'شیر یک‌طرفه به‌طور خودکار و بر اساس اختلاف فشار و '
              'نیروی جریان عمل می‌کند. در جهت مجاز باز می‌شود و هنگام تلاش '
              'برای برگشت جریان، بسته می‌شود.',
          applications: const [
            'خروجی پمپ‌ها',
            'خطوط انتقال آب و سیالات',
            'جلوگیری از برگشت سیال به تجهیزات',
            'حفاظت از برخی بخش‌های سیستم در برابر جریان معکوس',
          ],
          advantages: const [
            'عملکرد خودکار و بدون نیاز به اپراتور',
            'جلوگیری از برگشت جریان در شرایط طراحی‌شده',
            'انواع مختلف برای شرایط نصب و جریان متفاوت وجود دارد',
          ],
          limitations: const [
            'انتخاب نامناسب می‌تواند باعث ضربه قوچ شود',
            'برخی مدل‌ها به حداقل فشار بازشدن نیاز دارند',
            'جهت نصب و وضعیت خط در عملکرد آن مؤثر است',
          ],
          varieties: 'انواع متداول شامل Swing Check، Lift Check، '
              'Dual Plate و Nozzle Check هستند.',
          engineeringNote: 'در خروجی پمپ، نوع Check Valve باید با سرعت جریان، '
              'احتمال برگشت جریان و خطر Water Hammer هماهنگ انتخاب شود.',
        ),
        _valveType(
          title: '۹. شیر سماوری (Plug Valve)',
          icon: Icons.settings,
          operation: 'در Plug Valve یک قطعه مخروطی یا استوانه‌ای دارای '
              'مجرای عبور در داخل بدنه می‌چرخد. با قرار گرفتن مجرا در راستای '
              'خط، شیر باز و با چرخش آن، مسیر بسته می‌شود.',
          applications: const [
            'برخی خطوط فرآیندی',
            'سرویس‌های گازی و مایع متناسب با طراحی شیر',
            'برخی سرویس‌های دارای ذرات یا سیالات خاص، در مدل مناسب',
          ],
          advantages: const [
            'ساختار ربع‌گرد در بسیاری از مدل‌ها',
            'امکان طراحی با مسیر عبور مستقیم',
            'وجود مدل‌های روان‌کاری‌شونده و بدون روان‌کاری',
          ],
          limitations: const [
            'گشتاور عملکرد می‌تواند قابل توجه باشد',
            'نوع آب‌بندی و روان‌کاری باید با سیال سازگار باشد',
            'همه مدل‌ها برای هر نوع سیال مناسب نیستند',
          ],
          varieties: 'مدل‌های Lubricated، Non-lubricated و Eccentric '
              'از انواع شناخته‌شده این خانواده هستند.',
          engineeringNote: 'در سرویس‌های خاص، نوع Plug و سیستم آب‌بندی آن '
              'باید مطابق مشخصات فرآیندی انتخاب شود.',
        ),
        _valveType(
          title: '۱۰. شیر دیافراگمی (Diaphragm Valve)',
          icon: Icons.water,
          operation: 'در این شیر یک دیافراگم انعطاف‌پذیر با حرکت به سمت '
              'کف بدنه، مسیر عبور را محدود یا مسدود می‌کند. در بسیاری از '
              'طراحی‌ها، سیال از بخش مکانیزم محرک جدا می‌ماند.',
          applications: const [
            'برخی سرویس‌های خورنده',
            'صنایع دارویی و غذایی در طراحی‌های بهداشتی',
            'سیالاتی که جداسازی بخش محرک از سیال اهمیت دارد',
          ],
          advantages: const [
            'امکان جداسازی سیال از بخش بالایی شیر',
            'وجود طراحی‌های مناسب برای سیالات خورنده',
            'ساختمان نسبتاً ساده در برخی مدل‌ها',
          ],
          limitations: const [
            'محدودیت دما و فشار به جنس دیافراگم وابسته است',
            'دیافراگم قطعه مصرفی است و ممکن است نیاز به تعویض داشته باشد',
            'برای همه شرایط فشار و دما مناسب نیست',
          ],
          varieties: 'دو طرح رایج Weir Type و Straight-through Type هستند.',
          engineeringNote: 'جنس دیافراگم باید از نظر سازگاری شیمیایی و '
              'محدوده دمایی با سیال بررسی شود.',
        ),
        _valveType(
          title: '۱۱. شیر کنترلی (Control Valve)',
          icon: Icons.tune,
          operation: 'Control Valve برای تغییر پیوسته یا مرحله‌ای جریان '
              'بر اساس فرمان سیستم کنترل استفاده می‌شود. کنترلر با دریافت '
              'اطلاعات اندازه‌گیری‌شده، فرمان مناسب را به عملگر شیر می‌فرستد.',
          applications: const [
            'کنترل دبی (Flow Control)',
            'کنترل فشار (Pressure Control)',
            'کنترل سطح مخازن (Level Control)',
            'کنترل دما (Temperature Control)',
          ],
          advantages: const [
            'امکان تنظیم خودکار فرآیند',
            'کمک به پایدار نگه‌داشتن شرایط عملیاتی',
            'قابلیت انتخاب مشخصه جریان متناسب با فرآیند',
          ],
          limitations: const [
            'نیازمند سایزینگ و انتخاب مهندسی است',
            'ممکن است به هوای ابزار دقیق یا برق نیاز داشته باشد',
            'پدیده‌هایی مانند Cavitation و Flashing باید بررسی شوند',
          ],
          varieties: 'از نظر ساختمان داخلی، Globe، Ball، Butterfly و '
              'طرح‌های دیگر می‌توانند به‌صورت Control Valve طراحی شوند. '
              'عملگر نیز می‌تواند Pneumatic، Electric یا Hydraulic باشد.',
          engineeringNote: 'Control Valve صرفاً یک شیر معمولی با عملگر نیست؛ '
              'انتخاب آن نیازمند محاسبات ظرفیت، افت فشار و بررسی شرایط فرآیند است.',
        ),
        _section(
          '۱۲. شیر اطمینان و شیر فشارشکن',
          'این دو گروه وظایف متفاوتی دارند و نباید با یکدیگر اشتباه گرفته شوند.',
          bullets: const [
            'Pressure Safety Valve (PSV): برای حفاظت تجهیزات در برابر فشار بیش از حد؛ در شرایط مشخص باز می‌شود تا فشار کنترل شود.',
            'Pressure Relief Valve (PRV): اصطلاحی برای شیر تخلیه فشار؛ تعریف دقیق آن باید از استاندارد و مشخصات پروژه خوانده شود.',
            'Pressure Reducing Valve: فشار خروجی را در محدوده موردنظر کاهش می‌دهد و تنظیم می‌کند.',
          ],
        ),
        _section(
          '۱۳. روش‌های راه‌اندازی شیر',
          'شیرها از نظر روش حرکت و راه‌اندازی نیز دسته‌بندی می‌شوند:',
          bullets: const [
            'Manual: راه‌اندازی دستی با هندویل یا اهرم',
            'Pneumatic: استفاده از هوای فشرده',
            'Electric: استفاده از موتور الکتریکی',
            'Hydraulic: استفاده از فشار روغن یا سیال هیدرولیک',
            'Self-operated: عملکرد خودکار با انرژی خود سیال یا مکانیزم داخلی',
          ],
        ),
        const ActuatorCard(),
        _section(
          '۱۴. اتصالات انتهایی شیر',
          'شیرها با روش‌های مختلف به خط لوله متصل می‌شوند. '
          'نوع اتصال باید با اندازه خط، فشار، دما، متریال و الزامات پروژه سازگار باشد.',
          bullets: const [
            'Flanged End: اتصال فلنجی؛ مناسب برای بازکردن و تعمیرات',
            'Butt Weld (BW): اتصال جوشی لب‌به‌لب',
            'Socket Weld (SW): اتصال جوشی ساکتی',
            'Threaded End: اتصال رزوه‌ای',
            'Wafer Type: نصب بین دو فلنج',
            'Lug Type: نصب بین فلنج‌ها با امکان پیچ‌شدن به بدنه شیر',
          ],
        ),
        _section(
          '۱۵. کلاس فشاری شیر چیست؟',
          'در مشخصات شیر ممکن است کلاس‌هایی مانند Class 150، 300، 600 '
          'و بالاتر دیده شود.\n\n'
          'این اعداد به‌تنهایی فشار مجاز ثابت بر حسب PSI نیستند. '
          'فشار مجاز وابسته به کلاس، جنس بدنه، دمای طراحی و جدول فشار-دما '
          'استاندارد مربوط است.\n\n'
          'بنابراین برای بررسی فشار مجاز، باید استاندارد و جدول مربوط '
          'به متریال و دمای کاری خوانده شود.',
        ),
        _section(
          '۱۶. متریال شیر و قطعات داخلی',
          'انتخاب متریال شیر باید بر اساس شرایط واقعی سرویس انجام شود. '
          'متریال بدنه الزاماً با متریال قطعات داخلی یکسان نیست.',
          bullets: const [
            'Carbon Steel: فولاد کربنی برای بسیاری از سرویس‌های عمومی',
            'Stainless Steel: فولاد زنگ‌نزن برای شرایط مناسب خوردگی و دما',
            'Alloy Steel: فولاد آلیاژی برای شرایط خاص دما و فشار',
            'Trim Material: جنس دیسک، Seat و سایر قطعات داخلی',
            'Seat Material: ممکن است فلزی یا نرم باشد؛ انتخاب آن به سرویس وابسته است',
          ],
        ),
        _section(
          '۱۷. نماد شیرها در نقشه P&ID',
          'در نقشه P&ID، شیرها با نمادهای گرافیکی و گاهی شناسه تجهیز '
          'مشخص می‌شوند. شکل دقیق نماد به استاندارد ترسیم و Legend پروژه '
          'وابسته است.\n\n'
          'برای تشخیص درست باید راهنمای علائم همان نقشه بررسی شود. '
          'همچنین نوع شیر، نوع عملگر و وضعیت عادی آن ممکن است با اطلاعات '
          'تکمیلی کنار نماد مشخص شود.',
          bullets: const [
            'Manual Valve: شیر با راه‌اندازی دستی',
            'MOV: شیر با عملگر الکتریکی',
            'AOV: شیر با عملگر هوایی',
            'SDV: شیر قطع اضطراری یا Shutdown Valve',
            'XV: شناسه‌ای که در بسیاری از پروژه‌ها برای شیر قطع و وصل استفاده می‌شود؛ تعریف نهایی تابع Legend پروژه است',
            'CV: ممکن است برای Control Valve به کار رود؛ باید از Legend تأیید شود',
          ],
        ),
        _section(
          '۱۸. مقایسه کاربردی شیرها',
          'جدول زیر یک مقایسه مقدماتی برای شناخت وظیفه معمول شیرها است. '
          'این مقایسه جایگزین بررسی دیتاشیت و مشخصات فنی پروژه نیست.',
        ),
        const ValveComparisonTable(),
        _section(
          '۱۹. مثال صنعتی: انتخاب شیر برای خط خروجی پمپ',
          'فرض کنید یک پمپ، آب را به سمت یک مبدل حرارتی ارسال می‌کند. '
          'در خط خروجی پمپ چند وظیفه متفاوت وجود دارد:\n\n'
          '۱. برای جلوگیری از برگشت جریان به پمپ، Check Valve بررسی می‌شود.\n\n'
          '۲. برای امکان جداسازی خط هنگام تعمیرات، یک شیر قطع و وصل '
          'مانند Gate یا Ball با توجه به مشخصات پروژه انتخاب می‌شود.\n\n'
          '۳. اگر کنترل خودکار دبی لازم باشد، Control Valve و تجهیزات '
          'اندازه‌گیری و کنترل مرتبط بررسی می‌شوند.\n\n'
          '۴. برای حفاظت در برابر فشار بیش از حد، راهکار حفاظتی مناسب '
          'باید توسط مهندس فرآیند و مکانیک تعیین شود.',
        ),
        _section(
          '۲۰. نکات نصب و نگهداری',
          'نصب نادرست می‌تواند حتی در یک شیر با کیفیت باعث نشتی یا خرابی شود.',
          bullets: const [
            'جهت جریان روی بدنه و مدارک سازنده بررسی شود.',
            'محدودیت جهت نصب برای Check Valve رعایت شود.',
            'قبل از نصب، داخل شیر و لوله از آلودگی و اجسام خارجی پاک شود.',
            'بار ناشی از وزن لوله و ناهم‌راستایی نباید به شیر تحمیل شود.',
            'برای سفت‌کردن اتصالات، روش و گشتاور مناسب پروژه رعایت شود.',
            'فضای کافی برای بازکردن، تعمیر و خارج‌کردن شیر در نظر گرفته شود.',
            'شرایط نگهداری و تست طبق دستورالعمل سازنده و پروژه انجام شود.',
          ],
        ),
        _section(
          '۲۱. خطاهای رایج در انتخاب شیر',
          'چند اشتباه رایج که باید از آن‌ها پرهیز کرد:',
          bullets: const [
            'انتخاب شیر فقط بر اساس قطر خط',
            'در نظر نگرفتن فشار و دمای طراحی',
            'استفاده از Gate Valve برای کنترل دائمی دبی بدون بررسی',
            'بی‌توجهی به سازگاری متریال با سیال',
            'نادیده گرفتن افت فشار و سرعت جریان',
            'اشتباه گرفتن شیر یک‌طرفه با شیر قطع و وصل',
            'فرض کردن اینکه تمام شیرهای یک کلاس فشار در همه دماها ظرفیت یکسان دارند',
          ],
        ),
        _section(
          '۲۲. استانداردها و مدارک مرتبط',
          'در پروژه‌های صنعتی، استاندارد و مشخصات فنی باید بر اساس '
          'نوع شیر و قرارداد پروژه انتخاب شوند. نمونه‌هایی از مراجع رایج:',
          bullets: const [
            'ASME B16.34: الزامات مرتبط با شیرهای فلنجی، رزوه‌ای و جوشی',
            'API 600: شیرهای کشویی فولادی در محدوده کاربرد استاندارد',
            'API 602: شیرهای فولادی فشرده در کاربردهای مشخص',
            'API 608: شیرهای توپی فلزی',
            'API 609: شیرهای پروانه‌ای',
            'API 598: بازرسی و تست شیرها',
            'API 6D: شیرهای خطوط لوله در کاربردهای تعریف‌شده',
          ],
        ),
        const ValveQuiz(),
      ],
    );
  }

  Widget _intro() {
    return Card(
      color: const Color(0xFFEAF3FC),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            AppText(
              'هدف این فصل',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            AppText(
              'در پایان این درس باید بتوانی وظیفه شیرهای اصلی را تشخیص بدهی، '
              'تفاوت آن‌ها را توضیح بدهی و برای یک کاربرد صنعتی، '
              'گزینه‌های مناسب را از نظر مهندسی بررسی کنی.',
              style: TextStyle(height: 1.9),
            ),
          ],
        ),
      ),
    );
  }

  Widget _section(
    String title,
    String description, {
    List<String> bullets = const [],
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 14),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppText(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF07569A),
              ),
            ),
            const SizedBox(height: 10),
            AppText(
              description,
              style: const TextStyle(fontSize: 14, height: 1.9),
            ),
            if (bullets.isNotEmpty) ...[
              const SizedBox(height: 10),
              ...bullets.map(
                (item) => Padding(
                  padding: const EdgeInsets.only(bottom: 9),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(top: 7),
                        child: Icon(
                          Icons.circle,
                          size: 7,
                          color: Color(0xFF07569A),
                        ),
                      ),
                      const SizedBox(width: 9),
                      Expanded(
                        child: AppText(
                          item,
                          style: const TextStyle(fontSize: 14, height: 1.8),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _valveType({
    required String title,
    required IconData icon,
    required String operation,
    required List<String> applications,
    required List<String> advantages,
    required List<String> limitations,
    required String varieties,
    required String engineeringNote,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 30, color: const Color(0xFF07569A)),
                const SizedBox(width: 10),
                Expanded(
                  child: AppText(
                    title,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF07569A),
                    ),
                  ),
                ),
              ],
            ),
            const Divider(height: 24),

            // نمایش شکل شماتیک اختصاصی شیر
            ValveDiagramCard(type: title),

            const AppText(
              'نحوه عملکرد',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            AppText(operation, style: const TextStyle(height: 1.8)),
            const SizedBox(height: 12),
            _miniList('کاربردها', applications),
            _miniList('مزایا', advantages),
            _miniList('محدودیت‌ها', limitations),
            const AppText(
              'انواع و مدل‌ها',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 5),
            AppText(varieties, style: const TextStyle(height: 1.8)),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFF1F6FB),
                borderRadius: BorderRadius.circular(10),
              ),
              child: AppText(
                'نکته مهندسی: $engineeringNote',
                style: const TextStyle(height: 1.8),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _miniList(String title, List<String> items) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 5),
          ...items.map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 5),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const AppText('• '),
                  Expanded(
                    child: AppText(
                      item,
                      style: const TextStyle(height: 1.7),
                    ),
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

class ValvePartsCard extends StatelessWidget {
  const ValvePartsCard({super.key});

  @override
  Widget build(BuildContext context) {
    final parts = [
      ('Handwheel', 'فلکه دستی', Icons.pan_tool),
      ('Stem', 'محور انتقال حرکت', Icons.linear_scale),
      ('Bonnet', 'درپوش بالایی', Icons.layers),
      ('Body', 'بدنه شیر', Icons.settings),
      ('Disc', 'قطعه مسدودکننده', Icons.circle),
      ('Seat', 'نشیمنگاه آب‌بندی', Icons.radio_button_checked),
    ];

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          children: [
            const AppText(
              'اجزای نمونه یک شیر صنعتی',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 12),
            ...parts.map(
              (part) => ListTile(
                dense: true,
                leading: Icon(part.$3, color: const Color(0xFF07569A)),
                title: AppText(
                  part.$1,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: AppText(part.$2),
              ),
            ),
            const AppText(
              'توجه: آرایش و شکل اجزا در انواع مختلف شیر یکسان نیست.',
              style: TextStyle(fontSize: 12, color: Colors.blueGrey),
            ),
          ],
        ),
      ),
    );
  }
}

class ActuatorCard extends StatelessWidget {
  const ActuatorCard({super.key});

  @override
  Widget build(BuildContext context) {
    final types = [
      ('Manual', 'دستی', 'اپراتور با هندویل یا اهرم شیر را حرکت می‌دهد.'),
      ('Pneumatic', 'هوایی', 'از هوای فشرده برای حرکت عملگر استفاده می‌شود.'),
      ('Electric', 'برقی', 'موتور الکتریکی حرکت شیر را تأمین می‌کند.'),
      ('Hydraulic', 'هیدرولیکی', 'نیروی حرکت از فشار سیال هیدرولیک تأمین می‌شود.'),
    ];

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const AppText(
              'انواع عملگر شیر',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 8),
            ...types.map(
              (item) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText(
                      '${item.$1} — ${item.$2}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    AppText(item.$3, style: const TextStyle(height: 1.7)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ValveComparisonTable extends StatelessWidget {
  const ValveComparisonTable({super.key});

  @override
  Widget build(BuildContext context) {
    final rows = [
      ('Gate', 'قطع و وصل', 'معمولاً نامناسب'),
      ('Globe', 'تنظیم و قطع', 'مناسب‌تر'),
      ('Ball', 'قطع و وصل', 'بسته به طراحی'),
      ('Butterfly', 'قطع و وصل', 'بسته به طراحی'),
      ('Check', 'جلوگیری از برگشت', 'وظیفه اصلی نیست'),
      ('Control', 'کنترل خودکار', 'وظیفه اصلی'),
    ];

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columns: const [
            DataColumn(label: AppText('نوع شیر')),
            DataColumn(label: AppText('وظیفه معمول')),
            DataColumn(label: AppText('تنظیم جریان')),
          ],
          rows: rows.map((row) {
            return DataRow(
              cells: [
                DataCell(AppText(row.$1)),
                DataCell(AppText(row.$2)),
                DataCell(AppText(row.$3)),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }
}

class ValveQuiz extends StatefulWidget {
  const ValveQuiz({super.key});

  @override
  State<ValveQuiz> createState() => _ValveQuizState();
}

class _ValveQuizState extends State<ValveQuiz> {
  final List<_Question> questions = const [
    _Question(
      'کدام شیر معمولاً برای قطع و وصل کامل جریان استفاده می‌شود؟',
      ['Gate Valve', 'Globe Valve', 'Control Valve', 'Pressure Reducing Valve'],
      0,
      'شیر کشویی معمولاً برای قطع و وصل کامل جریان استفاده می‌شود.',
    ),
    _Question(
      'وظیفه اصلی Check Valve چیست؟',
      ['تنظیم دما', 'جلوگیری از برگشت جریان', 'افزایش فشار', 'اندازه‌گیری دبی'],
      1,
      'شیر یک‌طرفه برای جلوگیری از برگشت جریان طراحی می‌شود.',
    ),
    _Question(
      'کدام شیر برای تنظیم جریان در بسیاری از کاربردها مناسب‌تر است؟',
      ['Gate Valve', 'Globe Valve', 'Check Valve', 'شیر قطع اضطراری'],
      1,
      'Globe Valve در بسیاری از کاربردها قابلیت تنظیم جریان دارد.',
    ),
    _Question(
      'در Ball Valve قطعه مسدودکننده اصلی چه شکلی دارد؟',
      ['صفحه تخت', 'توپ سوراخ‌دار', 'دیافراگم', 'گیت کشویی'],
      1,
      'در شیر توپی، یک توپ دارای مجرای عبور می‌چرخد.',
    ),
    _Question(
      'کدام عامل در انتخاب متریال شیر اهمیت دارد؟',
      ['فقط رنگ بدنه', 'فقط قیمت', 'نوع سیال، فشار و دما', 'فقط نام سازنده'],
      2,
      'انتخاب متریال به سیال و شرایط طراحی و بهره‌برداری وابسته است.',
    ),
    _Question(
      'آیا کلاس 150 به معنی فشار مجاز ثابت 150 PSI است؟',
      ['بله', 'خیر', 'فقط در دمای بالا', 'فقط برای فولاد زنگ‌نزن'],
      1,
      'کلاس فشاری به‌تنهایی فشار مجاز ثابت نیست؛ جدول فشار-دما و متریال باید بررسی شود.',
    ),
    _Question(
      'وظیفه اصلی Control Valve چیست؟',
      ['فقط جلوگیری از برگشت', 'کنترل جریان یا متغیر فرآیندی', 'فقط تخلیه مخزن', 'نگهداری وزن لوله'],
      1,
      'شیر کنترلی برای تنظیم متغیرهای فرآیندی مانند دبی، فشار، سطح یا دما استفاده می‌شود.',
    ),
    _Question(
      'قبل از نصب شیر یک‌طرفه چه چیزی باید بررسی شود؟',
      ['رنگ شیر', 'جهت جریان و وضعیت نصب', 'نام اپراتور', 'طول هندویل'],
      1,
      'جهت جریان و محدودیت‌های نصب Check Valve برای عملکرد درست آن ضروری است.',
    ),
  ];

  final Map<int, int> selected = {};
  bool submitted = false;

  @override
  Widget build(BuildContext context) {
    final score = questions.asMap().entries.where(
      (entry) => selected[entry.key] == entry.value.correct,
    ).length;

    return Card(
      margin: const EdgeInsets.only(bottom: 20),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const AppText(
              'آزمون تخصصی درس شیرآلات',
              style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const AppText(
              'به پرسش‌ها پاسخ بده. پس از ثبت، پاسخ صحیح و توضیح هر سؤال نمایش داده می‌شود.',
              style: TextStyle(height: 1.8),
            ),
            const SizedBox(height: 12),
            ...questions.asMap().entries.map((entry) {
              final index = entry.key;
              final question = entry.value;

              return Padding(
                padding: const EdgeInsets.only(bottom: 18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText(
                      '${index + 1}. ${question.title}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    ...List.generate(question.options.length, (optionIndex) {
                      return RadioListTile<int>(
                        value: optionIndex,
                        groupValue: selected[index],
                        contentPadding: EdgeInsets.zero,
                        dense: true,
                        title: AppText(
                          question.options[optionIndex],
                          style: const TextStyle(fontSize: 14),
                        ),
                        onChanged: submitted
                            ? null
                            : (value) {
                                setState(() {
                                  selected[index] = value!;
                                });
                              },
                      );
                    }),
                    if (submitted) ...[
                      AppText(
                        selected[index] == question.correct
                            ? 'پاسخ شما صحیح است.'
                            : 'پاسخ صحیح: ${question.options[question.correct]}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: selected[index] == question.correct
                              ? Colors.green
                              : Colors.red,
                        ),
                      ),
                      const SizedBox(height: 4),
                      AppText(
                        question.explanation,
                        style: const TextStyle(height: 1.7),
                      ),
                    ],
                    const Divider(height: 22),
                  ],
                ),
              );
            }),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: submitted || selected.length != questions.length
                    ? null
                    : () => setState(() => submitted = true),
                child: const AppText('ثبت نهایی پاسخ‌ها'),
              ),
            ),
            if (submitted) ...[
              const SizedBox(height: 14),
              AppText(
                'نتیجه شما: $score از ${questions.length}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF07569A),
                ),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    selected.clear();
                    submitted = false;
                  });
                },
                child: const AppText('تکرار آزمون'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _Question {
  final String title;
  final List<String> options;
  final int correct;
  final String explanation;

  const _Question(
    this.title,
    this.options,
    this.correct,
    this.explanation,
  );
}
