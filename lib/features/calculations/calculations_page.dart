
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CalculationsPage extends StatelessWidget {
  const CalculationsPage({super.key});

  static const Color primaryColor = Color(0xFF07569A);

  @override
  Widget build(BuildContext context) {
    return const Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: _CalculationsAppBar(),
        body: PipeSizingCalculator(),
      ),
    );
  }
}

class _CalculationsAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  const _CalculationsAppBar();

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text(
        'محاسبات مهندسی پایپینگ',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      backgroundColor: const Color(0xFF07569A),
      foregroundColor: Colors.white,
      centerTitle: true,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class PipeSizingCalculator extends StatefulWidget {
  const PipeSizingCalculator({super.key});

  @override
  State<PipeSizingCalculator> createState() =>
      _PipeSizingCalculatorState();
}

class _PipeSizingCalculatorState extends State<PipeSizingCalculator> {
  static const Color primaryColor = Color(0xFF07569A);

  final TextEditingController _flowController =
      TextEditingController(text: '50');

  final TextEditingController _velocityController =
      TextEditingController(text: '2');

  double? _diameterMm;
  double? _diameterInch;
  String? _errorMessage;

  @override
  void dispose() {
    _flowController.dispose();
    _velocityController.dispose();
    super.dispose();
  }

  double? _parseNumber(String value) {
    return double.tryParse(value.trim().replaceAll(',', '.'));
  }

  void _calculate() {
    final flow = _parseNumber(_flowController.text);
    final velocity = _parseNumber(_velocityController.text);

    if (flow == null ||
        velocity == null ||
        flow <= 0 ||
        velocity <= 0) {
      setState(() {
        _errorMessage = 'لطفاً مقادیر معتبر و بزرگ‌تر از صفر وارد کنید.';
        _diameterMm = null;
        _diameterInch = null;
      });
      return;
    }

    final flowM3PerSecond = flow / 3600;
    final diameterMeter =
        math.sqrt(4 * flowM3PerSecond / (math.pi * velocity));

    setState(() {
      _errorMessage = null;
      _diameterMm = diameterMeter * 1000;
      _diameterInch = diameterMeter * 1000 / 25.4;
    });
  }

  void _reset() {
    _flowController.text = '50';
    _velocityController.text = '2';

    setState(() {
      _diameterMm = null;
      _diameterInch = null;
      _errorMessage = null;
    });
  }

  Widget _card({
    required String title,
    required Widget child,
    IconData icon = Icons.menu_book,
  }) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 14),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: primaryColor),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            child,
          ],
        ),
      ),
    );
  }

  Widget _inputField({
    required String label,
    required String unit,
    required TextEditingController controller,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          keyboardType:
              const TextInputType.numberWithOptions(decimal: true),
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]')),
          ],
          decoration: InputDecoration(
            suffixText: unit,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ],
    );
  }

  Widget _resultRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title),
          Text(
            value,
            textDirection: TextDirection.ltr,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _liveResult() {
    if (_diameterMm == null) return const SizedBox.shrink();

    return _card(
      title: 'نتیجه محاسبه ورودی شما',
      icon: Icons.check_circle_outline,
      child: Column(
        children: [
          const Text('قطر داخلی تئوری موردنیاز'),
          const SizedBox(height: 8),
          Text(
            '${_diameterMm!.toStringAsFixed(2)} mm',
            textDirection: TextDirection.ltr,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: primaryColor,
            ),
          ),
          Text(
            '${_diameterInch!.toStringAsFixed(3)} inch',
            textDirection: TextDirection.ltr,
          ),
          const Divider(height: 28),
          _resultRow('دبی ورودی', '${_flowController.text} m³/h'),
          _resultRow('سرعت ورودی', '${_velocityController.text} m/s'),
          const SizedBox(height: 8),
          const Text(
            'این مقدار قطر داخلی تئوری است و سایز اسمی نهایی لوله نیست.',
            style: TextStyle(
              color: Colors.orange,
              fontWeight: FontWeight.bold,
              height: 1.8,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: primaryColor,
            borderRadius: BorderRadius.circular(16),
          ),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'محاسبه سایز لوله',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 21,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 6),
              Text(
                'Pipe Sizing',
                textDirection: TextDirection.ltr,
                style: TextStyle(color: Colors.white70),
              ),
              SizedBox(height: 12),
              Text(
                'محاسبه قطر داخلی اولیه لوله بر اساس دبی حجمی و سرعت طراحی سیال.',
                style: TextStyle(color: Colors.white, height: 1.8),
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        _card(
          title: 'ماشین‌حساب سایز لوله',
          icon: Icons.calculate,
          child: Column(
            children: [
              _inputField(
                label: 'دبی حجمی سیال (Flow Rate)',
                unit: 'm³/h',
                controller: _flowController,
              ),
              const SizedBox(height: 18),
              _inputField(
                label: 'سرعت طراحی سیال (Velocity)',
                unit: 'm/s',
                controller: _velocityController,
              ),
              const SizedBox(height: 18),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _calculate,
                  icon: const Icon(Icons.calculate),
                  label: const Text('محاسبه قطر لوله'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                  ),
                ),
              ),
              OutlinedButton.icon(
                onPressed: _reset,
                icon: const Icon(Icons.refresh),
                label: const Text('بازنشانی'),
              ),
              if (_errorMessage != null)
                Text(
                  _errorMessage!,
                  style: const TextStyle(color: Colors.red),
                ),
            ],
          ),
        ),

        _liveResult(),

        _card(
          title: 'مثال عددی: انتقال مایع در یک خط لوله',
          icon: Icons.assignment,
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'صورت مسئله',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: primaryColor,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'یک خط لوله وظیفه انتقال مایع با دبی حجمی 50 مترمکعب بر ساعت را دارد. سرعت طراحی سیال 2 متر بر ثانیه در نظر گرفته شده است. قطر داخلی تئوری موردنیاز را محاسبه کنید.',
                style: TextStyle(height: 1.9),
              ),
              Divider(height: 25),
              Text(
                'داده‌های مسئله',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                'Q = 50 m³/h\n'
                'V = 2 m/s\n'
                'π = 3.14159',
                textDirection: TextDirection.ltr,
                style: TextStyle(height: 1.9),
              ),
            ],
          ),
        ),

        _card(
          title: 'حل مثال، مرحله به مرحله',
          icon: Icons.functions,
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'مرحله ۱: تبدیل واحد دبی',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 6),
              Text(
                'Q = 50 / 3600\n'
                'Q = 0.013889 m³/s',
                textDirection: TextDirection.ltr,
                style: TextStyle(height: 1.9),
              ),
              Divider(height: 22),
              Text(
                'مرحله ۲: نوشتن رابطه محاسبه قطر',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 6),
              Text(
                'D = √(4Q / πV)',
                textDirection: TextDirection.ltr,
                style: TextStyle(
                  fontSize: 19,
                  color: primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Divider(height: 22),
              Text(
                'مرحله ۳: جای‌گذاری اعداد',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 6),
              Text(
                'D = √[(4 × 0.013889) / (3.14159 × 2)]\n'
                'D = √0.008842\n'
                'D = 0.09403 m',
                textDirection: TextDirection.ltr,
                style: TextStyle(height: 1.9),
              ),
              Divider(height: 22),
              Text(
                'مرحله ۴: تبدیل به میلی‌متر',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 6),
              Text(
                'D = 0.09403 × 1000\n'
                'D = 94.03 mm',
                textDirection: TextDirection.ltr,
                style: TextStyle(height: 1.9),
              ),
              Divider(height: 22),
              Text(
                'جواب نهایی مثال',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: primaryColor,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'قطر داخلی تئوری موردنیاز تقریباً برابر 94.03 میلی‌متر است.',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  height: 1.9,
                ),
              ),
            ],
          ),
        ),

        _card(
          title: 'فرمول و معرفی پارامترها',
          icon: Icons.menu_book,
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'D = √(4Q / πV)',
                textDirection: TextDirection.ltr,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: primaryColor,
                ),
              ),
              SizedBox(height: 12),
              Text(
                'D: قطر داخلی لوله بر حسب متر\n'
                'Q: دبی حجمی بر حسب مترمکعب بر ثانیه\n'
                'V: سرعت سیال بر حسب متر بر ثانیه\n'
                'π: عدد پی، تقریباً 3.14159',
                style: TextStyle(height: 2),
              ),
            ],
          ),
        ),

        _card(
          title: 'نکات مهم مهندسی و انتخاب سایز واقعی',
          icon: Icons.engineering,
          child: const Text(
            '۱. قطر محاسبه‌شده، قطر داخلی تئوری است.\n'
            '۲. باید سایز اسمی مناسب از استاندارد ابعادی انتخاب شود.\n'
            '۳. قطر داخلی واقعی به NPS و Schedule بستگی دارد.\n'
            '۴. سرعت واقعی سیال با قطر داخلی واقعی دوباره محاسبه شود.\n'
            '۵. افت فشار خط باید کنترل شود.\n'
            '۶. فشار، دما، خوردگی، خواص سیال و شرایط فرآیندی باید بررسی شوند.\n\n'
            'انتخاب نهایی لوله صرفاً با این فرمول انجام نمی‌شود و باید با معیارهای طراحی پروژه و استانداردهای مربوطه تطبیق داده شود.',
            style: TextStyle(height: 1.9),
          ),
        ),

        const SizedBox(height: 12),
        const Text(
          'مبنای محاسبه: معادله پیوستگی جریان در مقطع دایره‌ای',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.grey, fontSize: 12),
        ),
      ],
    );
  }
}
