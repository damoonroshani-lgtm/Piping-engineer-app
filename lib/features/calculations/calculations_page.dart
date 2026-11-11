
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CalculationsPage extends StatelessWidget {
  const CalculationsPage({super.key});

  static const Color primaryColor = Color(0xFF07569A);

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'محاسبات مهندسی پایپینگ',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          centerTitle: true,
        ),
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: const [
            PipeSizingCalculator(),
          ],
        ),
      ),
    );
  }
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
  double? _actualVelocity;

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

    if (flow == null || velocity == null ||
        flow <= 0 || velocity <= 0) {
      setState(() {
        _errorMessage =
            'لطفاً دبی و سرعت را به‌صورت عددی بزرگ‌تر از صفر وارد کنید.';
        _diameterMm = null;
        _diameterInch = null;
        _actualVelocity = null;
      });
      return;
    }

    // Q: m3/h  ->  m3/s
    // D = sqrt(4Q / (pi * V))
    final flowM3PerSecond = flow / 3600;
    final diameterMeter =
        (4 * flowM3PerSecond / (3.141592653589793 * velocity))
            .sqrt();

    final diameterMm = diameterMeter * 1000;

    setState(() {
      _errorMessage = null;
      _diameterMm = diameterMm;
      _diameterInch = diameterMm / 25.4;
      _actualVelocity = velocity;
    });
  }

  void _reset() {
    _flowController.text = '50';
    _velocityController.text = '2';

    setState(() {
      _diameterMm = null;
      _diameterInch = null;
      _actualVelocity = null;
      _errorMessage = null;
    });
  }

  Widget _inputField({
    required String label,
    required String unit,
    required TextEditingController controller,
    required String hint,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          keyboardType: const TextInputType.numberWithOptions(
            decimal: true,
          ),
          inputFormatters: [
            FilteringTextInputFormatter.allow(
              RegExp(r'[0-9.,]'),
            ),
          ],
          decoration: InputDecoration(
            hintText: hint,
            suffixText: unit,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 14,
            ),
          ),
        ),
      ],
    );
  }

  Widget _sectionCard({
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

  Widget _resultBox() {
    if (_diameterMm == null) {
      return const SizedBox.shrink();
    }

    return _sectionCard(
      title: 'نتیجه محاسبه',
      icon: Icons.check_circle_outline,
      child: Column(
        children: [
          const Text(
            'قطر داخلی تئوری موردنیاز',
            style: TextStyle(fontSize: 14),
          ),
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
          const SizedBox(height: 8),
          Text(
            '${_diameterInch!.toStringAsFixed(3)} inch',
            textDirection: TextDirection.ltr,
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w600,
            ),
          ),
          const Divider(height: 28),
          _resultRow(
            'دبی ورودی',
            '${_flowController.text} m³/h',
          ),
          _resultRow(
            'سرعت مبنا',
            '${_actualVelocity!.toStringAsFixed(2)} m/s',
          ),
          const SizedBox(height: 12),
          const Text(
            'این مقدار قطر داخلی محاسباتی است، نه سایز اسمی نهایی لوله.',
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

  Widget _resultRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
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

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
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
                'Pipe Sizing Calculator',
                textDirection: TextDirection.ltr,
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 15,
                ),
              ),
              SizedBox(height: 12),
              Text(
                'محاسبه قطر داخلی اولیه لوله بر اساس دبی حجمی و سرعت طراحی سیال.',
                style: TextStyle(
                  color: Colors.white,
                  height: 1.8,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        _sectionCard(
          title: 'اطلاعات ورودی',
          icon: Icons.input,
          child: Column(
            children: [
              _inputField(
                label: 'دبی حجمی سیال (Flow Rate)',
                unit: 'm³/h',
                controller: _flowController,
                hint: 'مثلاً 50',
              ),
              const SizedBox(height: 18),
              _inputField(
                label: 'سرعت طراحی سیال (Velocity)',
                unit: 'm/s',
                controller: _velocityController,
                hint: 'مثلاً 2',
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
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              OutlinedButton.icon(
                onPressed: _reset,
                icon: const Icon(Icons.refresh),
                label: const Text('بازنشانی مقادیر'),
              ),
              if (_errorMessage != null) ...[
                const SizedBox(height: 12),
                Text(
                  _errorMessage!,
                  style: const TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ],
          ),
        ),

        _resultBox(),

        _sectionCard(
          title: 'فرمول محاسباتی',
          icon: Icons.functions,
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
              SizedBox(height: 14),
              Text(
                'D : قطر داخلی لوله بر حسب متر\n'
                'Q : دبی حجمی بر حسب مترمکعب بر ثانیه\n'
                'V : سرعت سیال بر حسب متر بر ثانیه\n'
                'π : عدد پی، تقریباً 3.14159',
                style: TextStyle(height: 2),
              ),
              Divider(height: 24),
              Text(
                'اگر دبی بر حسب m³/h باشد، ابتدا باید بر 3600 تقسیم شود تا به m³/s تبدیل گردد.',
                style: TextStyle(height: 1.8),
              ),
            ],
          ),
        ),

        _sectionCard(
          title: 'آموزش و نکات مهندسی',
          icon: Icons.school,
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'هدف محاسبه چیست؟',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 6),
              Text(
                'با داشتن دبی و سرعت طراحی، سطح مقطع لازم برای عبور سیال و سپس قطر داخلی تئوری لوله محاسبه می‌شود.',
                style: TextStyle(height: 1.8),
              ),
              SizedBox(height: 14),
              Text(
                'مراحل انتخاب سایز واقعی',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 6),
              Text(
                '۱. محاسبه قطر داخلی تئوری\n'
                '۲. انتخاب سایز اسمی نزدیک از استاندارد ابعادی لوله\n'
                '۳. بررسی قطر داخلی واقعی بر اساس NPS و Schedule\n'
                '۴. محاسبه مجدد سرعت واقعی سیال\n'
                '۵. بررسی افت فشار و محدودیت‌های فرآیندی\n'
                '۶. تأیید نهایی بر اساس مشخصات پروژه و استاندارد مربوطه',
                style: TextStyle(height: 2),
              ),
              SizedBox(height: 14),
              Text(
                'نکته مهم',
                style: TextStyle(
                  color: Colors.orange,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 6),
              Text(
                'قطر محاسبه‌شده به‌تنهایی برای سفارش لوله کافی نیست. فشار، دما، خواص سیال، خوردگی، افت فشار مجاز، نوع سرویس و ضخامت لوله باید بررسی شوند.',
                style: TextStyle(height: 1.8),
              ),
            ],
          ),
        ),

        _sectionCard(
          title: 'مثال کاربردی',
          icon: Icons.engineering,
          child: const Text(
            'فرض کنید دبی یک خط انتقال مایع 50 مترمکعب بر ساعت و سرعت طراحی انتخاب‌شده 2 متر بر ثانیه باشد. با قرار دادن این مقادیر در فرمول، قطر داخلی تئوری به دست می‌آید. سپس باید سایز اسمی و Schedule مناسب انتخاب و سرعت و افت فشار واقعی کنترل شود.',
            style: TextStyle(height: 1.9),
          ),
        ),

        const SizedBox(height: 10),
        const Text(
          'مبنای محاسبه: رابطه پیوستگی جریان برای جریان حجمی در لوله با سطح مقطع دایره‌ای.',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.grey,
            fontSize: 12,
            height: 1.8,
          ),
        ),
      ],
    );
  }
}

extension on double {
  double sqrt() {
    if (this < 0) {
      throw ArgumentError('Cannot calculate square root of negative value');
    }
    if (this == 0) return 0;

    double x = this;
    double result = x;

    for (int i = 0; i < 30; i++) {
      result = (result + x / result) / 2;
    }

    return result;
  }
}
