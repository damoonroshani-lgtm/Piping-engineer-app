
import 'dart:async';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:piping_engineer/core/theme/app_theme.dart';
import 'package:piping_engineer/core/diagnostics/error_logger.dart';
import 'package:piping_engineer/core/diagnostics/error_log_page.dart';
import 'package:piping_engineer/features/notes/pages/notes_page.dart';
import 'package:piping_engineer/core/widgets/app_text.dart';

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
      builder: (context, child) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: child ?? const SizedBox.shrink(),
        );
      },
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

// درس اول: مبانی پایپینگ

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
                        Icon(
                          entry.value.$2,
                          color: const Color(0xFF07569A),
                        ),
                        const SizedBox(width: 10),
                        AppText(
                          entry.value.$1,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
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
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
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
                    : (value) {
                        setState(() {
                          selectedAnswer = value;
                        });
                      },
              );
            }),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: selectedAnswer == null || submitted
                    ? null
                    : () {
                        setState(() {
                          submitted = true;
                        });
                      },
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

// درس ششم: شیرآلات صنعتی

class ValveLesson extends StatelessWidget {
  const ValveLesson({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const AppText(
          'آشنایی با شیرآلات صنعتی',
          style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        const AppText(
          'شیر صنعتی وسیله‌ای مکانیکی برای کنترل جریان سیال '
          'در خطوط لوله است. بسته به نوع طراحی، شیر می‌تواند '
          'جریان را قطع کند، وصل کند، تنظیم کند یا از برگشت آن جلوگیری کند.',
          style: TextStyle(fontSize: 15, height: 1.9),
        ),
        const SizedBox(height: 20),
        const AppText(
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
        const AppText(
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
                AppText(
                  'تصویر فنی برش‌خورده شیر کشویی در مرحله بعد اضافه می‌شود.',
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        const AppText(
          'نکته مهندسی',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const Card(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: AppText(
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
        title: AppText(
          english,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: AppText('$persian — $use'),
      ),
    );
  }
}
