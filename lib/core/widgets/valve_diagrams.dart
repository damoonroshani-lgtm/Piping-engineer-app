
import 'package:flutter/material.dart';

class ValveDiagramCard extends StatelessWidget {
  final String type;

  const ValveDiagramCard({
    super.key,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    final info = _diagramInfo(type);

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'شکل فنی و ساختمان داخلی شیر',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF07569A),
              ),
            ),
            const SizedBox(height: 10),
            Container(
              width: double.infinity,
              height: 230,
              decoration: BoxDecoration(
                color: const Color(0xFFF7FAFD),
                border: Border.all(color: const Color(0xFFD5E0EA)),
                borderRadius: BorderRadius.circular(12),
              ),
              child: CustomPaint(
                painter: _ValvePainter(type),
                child: const SizedBox.expand(),
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'راهنمای اجزای شکل',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            ...info.map(
              (item) => Padding(
                padding: const EdgeInsets.only(bottom: 7),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.circle,
                      size: 7,
                      color: Color(0xFF07569A),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        item,
                        textDirection: TextDirection.rtl,
                        style: const TextStyle(height: 1.6),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'توجه: این شکل، شماتیک آموزشی برای شناخت ساختمان شیر است؛ '
              'نقشه ساخت یا نقشه ابعادی سازنده محسوب نمی‌شود.',
              textDirection: TextDirection.rtl,
              style: TextStyle(
                fontSize: 11,
                color: Colors.blueGrey,
                height: 1.6,
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<String> _diagramInfo(String name) {
    if (name.contains('Gate')) {
      return [
        'Handwheel: فلکه دستی برای باز و بسته کردن شیر',
        'Stem: محور انتقال حرکت',
        'Gate: صفحه یا گوه مسدودکننده',
        'Seat: نشیمنگاه آب‌بندی',
        'Body: بدنه اصلی شیر',
      ];
    }
    if (name.contains('Globe')) {
      return [
        'Handwheel: فلکه دستی',
        'Stem: محور حرکت دیسک',
        'Disc: دیسک متحرک',
        'Seat: محل نشستن دیسک',
        'Body: بدنه با مسیر جریان تغییرجهت‌یافته',
      ];
    }
    if (name.contains('Ball')) {
      return [
        'Stem: محور چرخش توپ',
        'Ball: توپ دارای سوراخ عبور سیال',
        'Seat: نشیمنگاه آب‌بندی اطراف توپ',
        'Body: بدنه شیر',
        'Flow Passage: مجرای عبور سیال',
      ];
    }
    if (name.contains('Butterfly')) {
      return [
        'Actuator: عملگر چرخاننده محور',
        'Stem: محور متصل به دیسک',
        'Disc: صفحه پروانه‌ای داخل مسیر',
        'Seat: سطح آب‌بندی',
        'Body: بدنه شیر',
      ];
    }
    if (name.contains('Check')) {
      return [
        'Hinge: محور لولایی',
        'Disc: صفحه متحرک شیر',
        'Seat: نشیمنگاه آب‌بندی',
        'Body: بدنه شیر',
        'Flow Direction: جهت مجاز جریان',
      ];
    }
    if (name.contains('Plug')) {
      return [
        'Stem: محور چرخش',
        'Plug: قطعه مخروطی یا استوانه‌ای سوراخ‌دار',
        'Passage: مجرای عبور سیال',
        'Body: بدنه شیر',
      ];
    }
    if (name.contains('Diaphragm')) {
      return [
        'Actuator: مکانیزم حرکت‌دهنده',
        'Stem: محور انتقال حرکت',
        'Diaphragm: دیافراگم انعطاف‌پذیر',
        'Weir: برجستگی نشیمنگاه در طرح Weir',
        'Body: بدنه شیر',
      ];
    }
    if (name.contains('Control')) {
      return [
        'Actuator: عملگر پنوماتیکی یا برقی',
        'Stem: محور انتقال حرکت',
        'Plug: قطعه کنترل‌کننده جریان',
        'Seat: نشیمنگاه',
        'Body: بدنه شیر',
      ];
    }
    return [
      'Body: بدنه اصلی شیر',
      'Internal Parts: قطعات داخلی',
      'Flow Path: مسیر عبور سیال',
    ];
  }
}

class _ValvePainter extends CustomPainter {
  final String type;

  _ValvePainter(this.type);

  final Paint _body = Paint()
    ..color = const Color(0xFFDCE7F0)
    ..style = PaintingStyle.fill;

  final Paint _outline = Paint()
    ..color = const Color(0xFF173B5C)
    ..strokeWidth = 3
    ..style = PaintingStyle.stroke;

  final Paint _metal = Paint()
    ..color = const Color(0xFF6689A8)
    ..style = PaintingStyle.fill;

  final Paint _flow = Paint()
    ..color = const Color(0xFF168BCE)
    ..strokeWidth = 4
    ..style = PaintingStyle.stroke
    ..strokeCap = StrokeCap.round;

  final Paint _seat = Paint()
    ..color = const Color(0xFFCE8B32)
    ..strokeWidth = 5
    ..style = PaintingStyle.stroke
    ..strokeCap = StrokeCap.round;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.save();
    canvas.translate(size.width / 2, size.height / 2);
    canvas.scale(size.width / 380, size.height / 230);

    _drawPipe(canvas);

    if (type.contains('Gate')) {
      _drawGate(canvas);
    } else if (type.contains('Globe')) {
      _drawGlobe(canvas);
    } else if (type.contains('Ball')) {
      _drawBall(canvas);
    } else if (type.contains('Butterfly')) {
      _drawButterfly(canvas);
    } else if (type.contains('Check')) {
      _drawCheck(canvas);
    } else if (type.contains('Plug')) {
      _drawPlug(canvas);
    } else if (type.contains('Diaphragm')) {
      _drawDiaphragm(canvas);
    } else if (type.contains('Control')) {
      _drawControl(canvas);
    } else {
      _drawGate(canvas);
    }

    _drawText(canvas, 'FLOW', -165, 78, 12);
    _drawArrow(canvas, -125, 76, 1);

    canvas.restore();
  }

  void _drawPipe(Canvas canvas) {
    final pipe = Paint()
      ..color = const Color(0xFFB7C9D8)
      ..style = PaintingStyle.fill;

    canvas.drawRect(
      const Rect.fromLTRB(-175, -24, 175, 24),
      pipe,
    );

    canvas.drawRect(
      const Rect.fromLTRB(-175, -24, 175, 24),
      _outline,
    );
  }

  void _drawGate(Canvas canvas) {
    final bodyPath = Path()
      ..moveTo(-75, -24)
      ..lineTo(-48, -60)
      ..lineTo(48, -60)
      ..lineTo(75, -24)
      ..lineTo(75, 24)
      ..lineTo(48, 60)
      ..lineTo(-48, 60)
      ..lineTo(-75, 24)
      ..close();

    canvas.drawPath(bodyPath, _body);
    canvas.drawPath(bodyPath, _outline);

    canvas.drawRect(
      const Rect.fromLTRB(-12, -105, 12, 5),
      _metal,
    );
    canvas.drawRect(
      const Rect.fromLTRB(-12, -105, 12, 5),
      _outline,
    );

    canvas.drawRect(
      const Rect.fromLTRB(-25, -115, 25, -105),
      _metal,
    );

    canvas.drawLine(
      const Offset(-30, 5),
      const Offset(30, 5),
      _seat,
    );

    canvas.drawRect(
      const Rect.fromLTRB(-24, -7, 24, 7),
      _metal,
    );
    canvas.drawRect(
      const Rect.fromLTRB(-24, -7, 24, 7),
      _outline,
    );

    _drawHandwheel(canvas, 0, -132);
    _drawText(canvas, 'GATE', -20, 92, 13);
    _drawText(canvas, 'STEM', 20, -90, 10);
  }

  void _drawGlobe(Canvas canvas) {
    final path = Path()
      ..moveTo(-75, -24)
      ..lineTo(-45, -60)
      ..lineTo(45, -60)
      ..lineTo(75, -24)
      ..lineTo(75, 24)
      ..lineTo(45, 60)
      ..lineTo(-45, 60)
      ..lineTo(-75, 24)
      ..close();

    canvas.drawPath(path, _body);
    canvas.drawPath(path, _outline);

    canvas.drawRect(
      const Rect.fromLTRB(-10, -105, 10, -3),
      _metal,
    );
    canvas.drawRect(
      const Rect.fromLTRB(-10, -105, 10, -3),
      _outline,
    );

    canvas.drawLine(
      const Offset(-32, 8),
      const Offset(32, 8),
      _seat,
    );

    canvas.drawCircle(
      const Offset(0, -1),
      15,
      _metal,
    );
    canvas.drawCircle(
      const Offset(0, -1),
      15,
      _outline,
    );

    _drawHandwheel(canvas, 0, -132);
    _drawText(canvas, 'DISC', 22, -8, 10);
    _drawText(canvas, 'SEAT', -48, 12, 10);
    _drawText(canvas, 'GLOBE', -25, 92, 13);
  }

  void _drawBall(Canvas canvas) {
    final path = Path()
      ..moveTo(-78, -24)
      ..lineTo(-52, -55)
      ..lineTo(52, -55)
      ..lineTo(78, -24)
      ..lineTo(78, 24)
      ..lineTo(52, 55)
      ..lineTo(-52, 55)
      ..lineTo(-78, 24)
      ..close();

    canvas.drawPath(path, _body);
    canvas.drawPath(path, _outline);

    canvas.drawCircle(
      Offset.zero,
      42,
      _metal,
    );
    canvas.drawCircle(
      Offset.zero,
      42,
      _outline,
    );

    canvas.drawRect(
      const Rect.fromLTRB(-9, -105, 9, -38),
      _metal,
    );
    canvas.drawRect(
      const Rect.fromLTRB(-9, -105, 9, -38),
      _outline,
    );

    canvas.drawRect(
      const Rect.fromLTRB(-25, -8, 25, 8),
      Paint()..color = const Color(0xFFF7FAFD),
    );
    canvas.drawRect(
      const Rect.fromLTRB(-25, -8, 25, 8),
      _outline,
    );

    canvas.drawLine(
      const Offset(-46, 0),
      const Offset(-25, 0),
      _flow,
    );
    canvas.drawLine(
      const Offset(25, 0),
      const Offset(46, 0),
      _flow,
    );

    _drawText(canvas, 'BALL', -18, 92, 13);
    _drawText(canvas, 'BORE', -18, 5, 10);
    _drawText(canvas, 'STEM', 15, -88, 10);
  }

  void _drawButterfly(Canvas canvas) {
    final path = Path()
      ..moveTo(-75, -24)
      ..lineTo(-50, -55)
      ..lineTo(50, -55)
      ..lineTo(75, -24)
      ..lineTo(75, 24)
      ..lineTo(50, 55)
      ..lineTo(-50, 55)
      ..lineTo(-75, 24)
      ..close();

    canvas.drawPath(path, _body);
    canvas.drawPath(path, _outline);

    canvas.drawRect(
      const Rect.fromLTRB(-8, -105, 8, 105),
      _metal,
    );
    canvas.drawRect(
      const Rect.fromLTRB(-8, -105, 8, 105),
      _outline,
    );

    canvas.save();
    canvas.rotate(-0.55);
    canvas.drawOval(
      const Rect.fromLTRB(-10, -55, 10, 55),
      _metal,
    );
    canvas.drawOval(
      const Rect.fromLTRB(-10, -55, 10, 55),
      _outline,
    );
    canvas.restore();

    canvas.drawLine(
      const Offset(-50, 0),
      const Offset(50, 0),
      _flow,
    );

    _drawText(canvas, 'DISC', 18, 32, 10);
    _drawText(canvas, 'BUTTERFLY', -38, 92, 13);
    _drawText(canvas, 'SHAFT', 15, -88, 10);
  }

  void _drawCheck(Canvas canvas) {
    final path = Path()
      ..moveTo(-75, -24)
      ..lineTo(-48, -55)
      ..lineTo(48, -55)
      ..lineTo(75, -24)
      ..lineTo(75, 24)
      ..lineTo(48, 55)
      ..lineTo(-48, 55)
      ..lineTo(-75, 24)
      ..close();

    canvas.drawPath(path, _body);
    canvas.drawPath(path, _outline);

    canvas.drawCircle(
      const Offset(0, -45),
      7,
      _metal,
    );
    canvas.drawLine(
      const Offset(0, -45),
      const Offset(40, 8),
      _outline,
    );

    final flap = Path()
      ..moveTo(40, 8)
      ..lineTo(40, 24)
      ..lineTo(-25, 24)
      ..lineTo(-25, 8)
      ..close();

    canvas.drawPath(flap, _metal);
    canvas.drawPath(flap, _outline);

    canvas.drawLine(
      const Offset(-48, 0),
      const Offset(-15, 0),
      _flow,
    );

    _drawText(canvas, 'DISC', 25, 30, 10);
    _drawText(canvas, 'CHECK', -25, 92, 13);
    _drawText(canvas, 'HINGE', 12, -55, 10);
  }

  void _drawPlug(Canvas canvas) {
    final path = Path()
      ..moveTo(-75, -24)
      ..lineTo(-48, -55)
      ..lineTo(48, -55)
      ..lineTo(75, -24)
      ..lineTo(75, 24)
      ..lineTo(48, 55)
      ..lineTo(-48, 55)
      ..lineTo(-75, 24)
      ..close();

    canvas.drawPath(path, _body);
    canvas.drawPath(path, _outline);

    final plug = Path()
      ..moveTo(-30, -38)
      ..lineTo(30, -38)
      ..lineTo(22, 38)
      ..lineTo(-22, 38)
      ..close();

    canvas.drawPath(plug, _metal);
    canvas.drawPath(plug, _outline);

    canvas.drawRect(
      const Rect.fromLTRB(-20, -7, 20, 7),
      Paint()..color = const Color(0xFFF7FAFD),
    );

    canvas.drawRect(
      const Rect.fromLTRB(-8, -105, 8, -38),
      _metal,
    );

    canvas.drawRect(
      const Rect.fromLTRB(-8, -105, 8, -38),
      _outline,
    );

    _drawHandwheel(canvas, 0, -132);
    _drawText(canvas, 'PLUG', -18, 92, 13);
    _drawText(canvas, 'BORE', -18, 5, 10);
  }

  void _drawDiaphragm(Canvas canvas) {
    final path = Path()
      ..moveTo(-75, -24)
      ..lineTo(-48, -55)
      ..lineTo(48, -55)
      ..lineTo(75, -24)
      ..lineTo(75, 24)
      ..lineTo(48, 55)
      ..lineTo(-48, 55)
      ..lineTo(-75, 24)
      ..close();

    canvas.drawPath(path, _body);
    canvas.drawPath(path, _outline);

    final weir = Path()
      ..moveTo(-35, 24)
      ..lineTo(-20, -5)
      ..lineTo(20, -5)
      ..lineTo(35, 24;

    canvas.drawPath(weir, _seat);

    final diaphragm = Path()
      ..moveTo(-42, -10)
      ..quadraticBezierTo(0, -28, 42, -10);

    final diaphragmPaint = Paint()
      ..color = const Color(0xFF168BCE)
      ..strokeWidth = 6
      ..style = PaintingStyle.stroke;

    canvas.drawPath(diaphragm, diaphragmPaint);

    canvas.drawRect(
      const Rect.fromLTRB(-8, -105, 8, -18),
      _metal,
    );
    canvas.drawRect(
      const Rect.fromLTRB(-8, -105, 8, -18),
      _outline,
    );

    canvas.drawRect(
      const Rect.fromLTRB(-35, -115, 35, -105),
      _metal,
    );

    _drawText(canvas, 'DIAPHRAGM', -42, 92, 12);
    _drawText(canvas, 'MEMBRANE', 22, -28, 9);
  }

  void _drawControl(Canvas canvas) {
    final path = Path()
      ..moveTo(-75, -24)
      ..lineTo(-48, -55)
      ..lineTo(48, -55)
      ..lineTo(75, -24)
      ..lineTo(75, 24)
      ..lineTo(48, 55)
      ..lineTo(-48, 55)
      ..lineTo(-75, 24)
      ..close();

    canvas.drawPath(path, _body);
    canvas.drawPath(path, _outline);

    canvas.drawRect(
      const Rect.fromLTRB(-9, -60, 9, -2),
      _metal,
    );
    canvas.drawRect(
      const Rect.fromLTRB(-9, -60, 9, -2),
      _outline,
    );

    canvas.drawCircle(
      const Offset(0, -82),
      24,
      _body,
    );
    canvas.drawCircle(
      const Offset(0, -82),
      24,
      _outline,
    );

    canvas.drawLine(
      const Offset(-24, -82),
      const Offset(24, -82),
      _outline,
    );

    canvas.drawCircle(
      const Offset(0, -82),
      5,
      _metal,
    );

    canvas.drawLine(
      const Offset(-30, 8),
      const Offset(30, 8),
      _seat,
    );

    canvas.drawCircle(
      const Offset(0, -1),
      13,
      _metal,
    );

    _drawText(canvas, 'ACTUATOR', -30, -115, 10);
    _drawText(canvas, 'CONTROL', -28, 92, 13);
    _drawText(canvas, 'PLUG', 20, 5, 10);
  }

  void _drawHandwheel(Canvas canvas, double x, double y) {
    final p = Paint()
      ..color = const Color(0xFF173B5C)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4;

    canvas.drawCircle(Offset(x, y), 22, p);
    canvas.drawLine(
      Offset(x - 22, y),
      Offset(x + 22, y),
      p,
    );
    canvas.drawLine(
      Offset(x, y - 22),
      Offset(x, y + 22),
      p,
    );
  }

  void _drawArrow(Canvas canvas, double x, double y, double direction) {
    final p = Paint()
      ..color = const Color(0xFF168BCE)
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    canvas.drawLine(
      Offset(x, y),
      Offset(x + 18 * direction, y),
      p,
    );

    canvas.drawLine(
      Offset(x + 18 * direction, y),
      Offset(x + 10 * direction, y - 7),
      p,
    );

    canvas.drawLine(
      Offset(x + 18 * direction, y),
      Offset(x + 10 * direction, y + 7),
      p,
    );
  }

  void _drawText(
    Canvas canvas,
    String value,
    double x,
    double y,
    double fontSize,
  ) {
    final painter = TextPainter(
      text: TextSpan(
        text: value,
        style: TextStyle(
          color: const Color(0xFF173B5C),
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
    );

    painter.layout();
    painter.paint(canvas, Offset(x, y));
  }

  @override
  bool shouldRepaint(covariant _ValvePainter oldDelegate) {
    return oldDelegate.type != type;
  }
}
