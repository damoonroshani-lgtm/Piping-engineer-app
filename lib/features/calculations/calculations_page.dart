
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CalculationsPage extends StatefulWidget {
  const CalculationsPage({super.key});

  @override
  State<CalculationsPage> createState() => _CalculationsPageState();
}

class _CalculationsPageState extends State<CalculationsPage> {
  static const Color primary = Color(0xFF07569A);

  final _flow = TextEditingController(text: '50');
  final _velocity = TextEditingController(text: '2');
  final _diameter = TextEditingController(text: '100');

  final _length = TextEditingController(text: '100');
  final _friction = TextEditingController(text: '0.02');
  final _density = TextEditingController(text: '1000');

  final _pressureDiff = TextEditingController(text: '2');
  final _elevation = TextEditingController(text: '0');
  final _efficiency = TextEditingController(text: '75');

  final _designPressure = TextEditingController(text: '1');
  final _outsideDiameter = TextEditingController(text: '114.3');
  final _allowableStress = TextEditingController(text: '138');
  final _jointFactor = TextEditingController(text: '1');
  final _weldFactor = TextEditingController(text: '1');
  final _yFactor = TextEditingController(text: '0.4');
  final _corrosion = TextEditingController(text: '3');

  final _barInput = TextEditingController(text: '3');
  final _temperatureInput = TextEditingController(text: '40');
  final _flowConvert = TextEditingController(text: '50');
  final _lengthConvert = TextEditingController(text: '100');

  final List<TextEditingController> _controllers = [];

  @override
  void initState() {
    super.initState();
    _controllers.addAll([
      _flow, _velocity, _diameter,
      _length, _friction, _density,
      _pressureDiff, _elevation, _efficiency,
      _designPressure, _outsideDiameter,
      _allowableStress, _jointFactor,
      _weldFactor, _yFactor, _corrosion,
      _barInput, _temperatureInput,
      _flowConvert, _lengthConvert,
    ]);
  }

  @override
  void dispose() {
    for (final controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  double? _number(TextEditingController controller) {
    return double.tryParse(
      controller.text.trim().replaceAll(',', '.'),
    );
  }

  String _format(double? value, [int digits = 2]) {
    if (value == null || !value.isFinite) return '---';
    return value.toStringAsFixed(digits);
  }

  bool _valid(List<double?> values) {
    return values.every(
      (v) => v != null && v.isFinite,
    );
  }

  Widget _field(
    String label,
    TextEditingController controller,
    String unit,
  ) {
    return SizedBox(
      width: 145,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 6),
          TextField(
            controller: controller,
            keyboardType: const TextInputType.numberWithOptions(
              decimal: true,
              signed: true,
            ),
            inputFormatters: [
              FilteringTextInputFormatter.allow(
                RegExp(r'[0-9.,-]'),
              ),
            ],
            onChanged: (_) => setState(() {}),
            decoration: InputDecoration(
              suffixText: unit,
              isDense: true,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(9),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _inputs(List<Widget> fields) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: fields,
    );
  }

  Widget _formula(String text) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(11),
      decoration: BoxDecoration(
        color: Colors.blue.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(9),
      ),
      child: SelectableText(
        text,
        textDirection: TextDirection.ltr,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: primary,
          height: 1.8,
        ),
      ),
    );
  }

  Widget _answer(String title, String value, {String unit = ''}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.green.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(9),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            '$value $unit',
            textDirection: TextDirection.ltr,
            style: const TextStyle(
              fontSize: 21,
              fontWeight: FontWeight.bold,
              color: Colors.green,
            ),
          ),
        ],
      ),
    );
  }

  Widget _note(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 12,
        height: 1.8,
        color: Colors.grey,
      ),
    );
  }

  Widget _section({
    required int number,
    required String title,
    required String english,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 14),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(13),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 16,
                  backgroundColor: primary,
                  child: Text(
                    '$number',
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                const SizedBox(width: 9),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                      Text(
                        english,
                        textDirection: TextDirection.ltr,
                        style: const TextStyle(
                          fontSize: 11,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(icon, color: primary),
              ],
            ),
            const Divider(height: 24),
            ...children.map(
              (child) => Padding(
                padding: const EdgeInsets.only(bottom: 11),
                child: child,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _pipeSizing() {
    final q = _number(_flow);
    final v = _number(_velocity);
    final valid = _valid([q, v]) && q! > 0 && v! > 0;
    final d = valid
        ? math.sqrt(4 * (q! / 3600) / (math.pi * v!)) * 1000
        : null;

    return _section(
      number: 1,
      title: 'محاسبه سایز لوله',
      english: 'Pipe Sizing',
      icon: Icons.straighten,
      children: [
        _inputs([
          _field('دبی حجمی', _flow, 'm³/h'),
          _field('سرعت سیال', _velocity, 'm/s'),
        ]),
        _formula('D = √(4Q / πV)'),
        _formula(
          valid
              ? 'D = √[4 × (${_format(q! / 3600, 6)}) / '
                  '(π × ${_format(v!)})]'
              : 'مقادیر معتبر وارد کنید.',
        ),
        _answer(
          'قطر داخلی تئوری',
          _format(d),
          unit: 'mm',
        ),
        _answer(
          'قطر بر حسب اینچ',
          _format(d == null ? null : d / 25.4, 3),
          unit: 'inch',
        ),
        _note(
          'این نتیجه قطر داخلی تئوری است، نه سایز اسمی نهایی. '
          'انتخاب NPS و Schedule و کنترل سرعت و افت فشار ضروری است.',
        ),
      ],
    );
  }

  Widget _flowRate() {
    final v = _number(_velocity);
    final d = _number(_diameter);
    final valid = _valid([v, d]) && v! > 0 && d! > 0;
    final q = valid
        ? v! * math.pi * math.pow(d! / 1000, 2) / 4 * 3600
        : null;

    return _section(
      number: 2,
      title: 'محاسبه دبی حجمی',
      english: 'Flow Rate',
      icon: Icons.water_drop,
      children: [
        _inputs([
          _field('سرعت سیال', _velocity, 'm/s'),
          _field('قطر داخلی', _diameter, 'mm'),
        ]),
        _formula('Q = V × A = V × πD² / 4'),
        _formula(
          valid
              ? 'Q = ${_format(v!)} × π × '
                  '(${_format(d! / 1000, 4)})² / 4'
              : 'مقادیر معتبر وارد کنید.',
        ),
        _answer('دبی حجمی', _format(q), unit: 'm³/h'),
        _answer(
          'دبی بر حسب لیتر بر ثانیه',
          _format(q == null ? null : q / 3.6),
          unit: 'L/s',
        ),
      ],
    );
  }

  Widget _fluidVelocity() {
    final q = _number(_flow);
    final d = _number(_diameter);
    final valid = _valid([q, d]) && q! > 0 && d! > 0;
    final v = valid
        ? (q! / 3600) /
            (math.pi * math.pow(d! / 1000, 2) / 4)
        : null;

    return _section(
      number: 3,
      title: 'محاسبه سرعت سیال',
      english: 'Fluid Velocity',
      icon: Icons.speed,
      children: [
        _inputs([
          _field('دبی حجمی', _flow, 'm³/h'),
          _field('قطر داخلی', _diameter, 'mm'),
        ]),
        _formula('V = Q / A = 4Q / πD²'),
        _formula(
          valid
              ? 'V = 4 × ${_format(q! / 3600, 6)} / '
                  '[π × (${_format(d! / 1000, 4)})²]'
              : 'مقادیر معتبر وارد کنید.',
        ),
        _answer('سرعت سیال', _format(v), unit: 'm/s'),
      ],
    );
  }

  Widget _pressureDrop() {
    final q = _number(_flow);
    final d = _number(_diameter);
    final l = _number(_length);
    final f = _number(_friction);
    final rho = _number(_density);

    final valid = _valid([q, d, l, f, rho]) &&
        q! > 0 &&
        d! > 0 &&
        l! >= 0 &&
        f! > 0 &&
        rho! > 0;

    final velocity = valid
        ? (q! / 3600) /
            (math.pi * math.pow(d! / 1000, 2) / 4)
        : null;

    final dp = valid
        ? f! * (l! / (d! / 1000)) *
            (rho! * math.pow(velocity!, 2) / 2)
        : null;

    return _section(
      number: 4,
      title: 'محاسبه افت فشار',
      english: 'Pressure Drop - Darcy-Weisbach',
      icon: Icons.trending_down,
      children: [
        _inputs([
          _field('دبی حجمی', _flow, 'm³/h'),
          _field('قطر داخلی', _diameter, 'mm'),
          _field('طول لوله', _length, 'm'),
          _field('ضریب اصطکاک f', _friction, '-'),
          _field('چگالی سیال', _density, 'kg/m³'),
        ]),
        _formula('ΔP = f × (L/D) × (ρV²/2)'),
        _formula(
          valid
              ? 'V = ${_format(velocity!)} m/s\n'
                  'ΔP = ${_format(f!)} × '
                  '(${_format(l!)} / ${_format(d! / 1000, 4)}) × '
                  '(${_format(rho!)} × ${_format(velocity * velocity)}/2)'
              : 'مقادیر معتبر وارد کنید.',
        ),
        _answer(
          'افت فشار',
          _format(dp == null ? null : dp / 100000),
          unit: 'bar',
        ),
        _answer(
          'افت فشار',
          _format(dp == null ? null : dp / 1000),
          unit: 'kPa',
        ),
        _note(
          'این محاسبه افت فشار اصطکاکی مستقیم در لوله است. '
          'افت اتصالات، شیرآلات، تجهیزات و اختلاف ارتفاع در آن لحاظ نشده است. '
          'ضریب اصطکاک باید متناسب با رژیم جریان و زبری تعیین شود.',
        ),
      ],
    );
  }

  Widget _pump() {
    final dp = _number(_pressureDiff);
    final rho = _number(_density);
    final z = _number(_elevation);
    final q = _number(_flow);
    final eta = _number(_efficiency);

    final valid = _valid([dp, rho, z, q, eta]) &&
        rho! > 0 &&
        q! > 0 &&
        eta! > 0 &&
        eta! <= 100;

    final head = valid
        ? (dp! * 100000) / (rho! * 9.80665) + z!
        : null;

    final hydraulicPower = valid && head != null
        ? rho! * 9.80665 * (q! / 3600) * head / 1000
        : null;

    final shaftPower = hydraulicPower == null
        ? null
        : hydraulicPower / (eta! / 100);

    return _section(
      number: 5,
      title: 'محاسبه پمپ و هد',
      english: 'Pump Head & Power',
      icon: Icons.water,
      children: [
        _inputs([
          _field('اختلاف فشار', _pressureDiff, 'bar'),
          _field('چگالی سیال', _density, 'kg/m³'),
          _field('اختلاف ارتفاع', _elevation, 'm'),
          _field('دبی حجمی', _flow, 'm³/h'),
          _field('راندمان پمپ', _efficiency, '%'),
        ]),
        _formula('H = ΔP / (ρg) + ΔZ'),
        _formula(
          valid
              ? 'H = (${_format(dp!)} × 100000) / '
                  '(${_format(rho!)} × 9.80665) + ${_format(z!)}'
              : 'مقادیر معتبر وارد کنید.',
        ),
        _answer('هد محاسبه‌شده', _format(head), unit: 'm'),
        _formula('P hydraulic = ρ × g × Q × H'),
        _answer(
          'توان هیدرولیکی',
          _format(hydraulicPower),
          unit: 'kW',
        ),
        _answer(
          'توان موردنیاز محور پمپ',
          _format(shaftPower),
          unit: 'kW',
        ),
        _note(
          'این محاسبه ساده است و افت مسیر مکش و دهش، '
          'افت تجهیزات و منحنی عملکرد پمپ باید در طراحی واقعی لحاظ شوند. '
          'اختلاف فشار باید فشار دهش منهای فشار مکش باشد.',
        ),
      ],
    );
  }

  Widget _pipeThickness() {
    final p = _number(_designPressure);
    final d = _number(_outsideDiameter);
    final s = _number(_allowableStress);
    final e = _number(_jointFactor);
    final w = _number(_weldFactor);
    final y = _number(_yFactor);
    final ca = _number(_corrosion);

    final valid = _valid([p, d, s, e, w, y, ca]) &&
        p! > 0 &&
        d! > 0 &&
        s! > 0 &&
        e! > 0 &&
        w! > 0 &&
        ca! >= 0 &&
        (s! * e! * w! + p! * y!) > 0;

    final pressureThickness = valid
        ? (p! * d!) / (2 * (s! * e! * w! + p! * y!))
        : null;

    final totalThickness = pressureThickness == null
        ? null
        : pressureThickness + ca!;

    return _section(
      number: 6,
      title: 'محاسبه ضخامت لوله',
      english: 'Pipe Wall Thickness - Preliminary',
      icon: Icons.layers,
      children: [
        _inputs([
          _field('فشار طراحی', _designPressure, 'MPa'),
          _field('قطر خارجی لوله', _outsideDiameter, 'mm'),
          _field('تنش مجاز متریال', _allowableStress, 'MPa'),
          _field('ضریب کیفیت اتصال E', _jointFactor, '-'),
          _field('ضریب جوش W', _weldFactor, '-'),
          _field('ضریب Y', _yFactor, '-'),
          _field('خوردگی مجاز', _corrosion, 'mm'),
        ]),
        _formula('t = P × D / [2 × (S × E × W + P × Y)]'),
        _formula(
          valid
              ? 't = (${_format(p!)} × ${_format(d!)}) / '
                  '[2 × (${_format(s!)} × ${_format(e!)} × '
                  '${_format(w!)} + ${_format(p)} × ${_format(y!)})]'
              : 'مقادیر معتبر وارد کنید.',
        ),
        _answer(
          'ضخامت موردنیاز با خوردگی',
          _format(totalThickness, 3),
          unit: 'mm',
        ),
        _note(
          'این رابطه برای بررسی اولیه بر مبنای رابطه فشار داخلی لوله مستقیم '
          'در ASME B31.3 است. ضرایب، تنش مجاز در دمای طراحی، الزامات ساخت، '
          'تلرانس ضخامت منفی، خوردگی و نسخه کد باید توسط مهندس بررسی شوند. '
          'این خروجی به‌تنهایی ضخامت خرید نهایی نیست.',
        ),
      ],
    );
  }

  Widget _unitConversion() {
    final bar = _number(_barInput);
    final temp = _number(_temperatureInput);
    final flow = _number(_flowConvert);
    final length = _number(_lengthConvert);

    return _section(
      number: 7,
      title: 'تبدیل واحدها',
      english: 'Unit Converter',
      icon: Icons.swap_horiz,
      children: [
        _field('فشار', _barInput, 'bar'),
        _answer(
          'معادل فشار',
          _format(bar == null ? null : bar * 100),
          unit: 'kPa',
        ),
        _answer(
          'معادل فشار',
          _format(bar == null ? null : bar * 14.5038),
          unit: 'psi',
        ),
        const Divider(),
        _field('دما', _temperatureInput, '°C'),
        _answer(
          'دمای معادل',
          _format(temp == null ? null : temp * 9 / 5 + 32),
          unit: '°F',
        ),
        const Divider(),
        _field('دبی حجمی', _flowConvert, 'm³/h'),
        _answer(
          'دبی معادل',
          _format(flow == null ? null : flow / 3.6),
          unit: 'L/s',
        ),
        const Divider(),
        _field('طول', _lengthConvert, 'mm'),
        _answer(
          'طول معادل',
          _format(length == null ? null : length / 25.4, 3),
          unit: 'inch',
        ),
      ],
    );
  }

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
          backgroundColor: primary,
          foregroundColor: Colors.white,
          centerTitle: true,
        ),
        body: ListView(
          padding: const EdgeInsets.all(12),
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              margin: const EdgeInsets.only(bottom: 14),
              decoration: BoxDecoration(
                color: primary,
                borderRadius: BorderRadius.circular(13),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'ماشین‌حساب مهندسی پایپینگ',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 19,
                    ),
                  ),
                  SizedBox(height: 7),
                  Text(
                    'تمام محاسبات در یک صفحه؛ '
                    'اعداد را وارد کنید و نتیجه را ببینید.',
                    style: TextStyle(
                      color: Colors.white,
                      height: 1.8,
                    ),
                  ),
                ],
              ),
            ),
            _pipeSizing(),
            _flowRate(),
            _fluidVelocity(),
            _pressureDrop(),
            _pump(),
            _pipeThickness(),
            _unitConversion(),
            const SizedBox(height: 10),
            const Text(
              'نتایج این ماشین‌حساب‌ها برای آموزش و برآورد اولیه هستند. '
              'طراحی نهایی باید با استانداردها و مدارک پروژه کنترل شود.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey,
                fontSize: 11,
                height: 1.8,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
