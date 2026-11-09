import 'package:flutter/material.dart';

class ValveDiagramCard extends StatelessWidget {
  final String type;

  const ValveDiagramCard({
    super.key,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    final valve = _getValve(type);

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'نقشه شماتیک ${valve.title}',
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              height: 210,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(12),
              ),
              child: CustomPaint(
                painter: _ValvePainter(
                  type: valve.type,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              valve.description,
              style: const TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 8),
            const Text(
              'توجه: این تصویر یک شماتیک آموزشی است و جایگزین نقشه مقطعی سازنده یا نقشه مهندسی پروژه نیست.',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  _ValveInfo _getValve(String title) {
    final value = title.toLowerCase();

    if (value.contains('gate')) {
      return const _ValveInfo(
        'Gate Valve',
        'gate',
        'در این شیر، حرکت عمودی گیت باعث باز و بسته شدن مسیر عبور سیال می‌شود.',
      );
    }

    if (value.contains('globe')) {
      return const _ValveInfo(
        'Globe Valve',
        'globe',
        'دیسک روی نشیمنگاه حرکت می‌کند و برای کنترل و تنظیم جریان مناسب است.',
      );
    }

    if (value.contains('ball')) {
      return const _ValveInfo(
        'Ball Valve',
        'ball',
        'با چرخش یک توپ سوراخ‌دار، مسیر عبور سیال باز یا بسته می‌شود.',
      );
    }

    if (value.contains('butterfly')) {
      return const _ValveInfo(
        'Butterfly Valve',
        'butterfly',
        'دیسک داخل بدنه با چرخش حول محور خود، جریان را کنترل می‌کند.',
      );
    }

    if (value.contains('check')) {
      return const _ValveInfo(
        'Check Valve',
        'check',
        'این شیر برای جلوگیری از برگشت جریان به‌صورت خودکار عمل می‌کند.',
      );
    }

    if (value.contains('plug')) {
      return const _ValveInfo(
        'Plug Valve',
        'plug',
        'با چرخش پلاگ دارای مجرای عبور، مسیر جریان باز یا بسته می‌شود.',
      );
    }

    if (value.contains('diaphragm')) {
      return const _ValveInfo(
        'Diaphragm Valve',
        'diaphragm',
        'دیافراگم انعطاف‌پذیر با حرکت بالا و پایین، مسیر عبور سیال را کنترل می‌کند.',
      );
    }

    if (value.contains('control')) {
      return const _ValveInfo(
        'Control Valve',
        'control',
        'حرکت ساقه و پلاگ با فرمان عملگر، میزان عبور سیال را تنظیم می‌کند.',
      );
    }

    return const _ValveInfo(
      'Industrial Valve',
      'gate',
      'نمای شماتیک آموزشی یک شیر صنعتی.',
    );
  }
}

class _ValveInfo {
  final String title;
  final String type;
  final String description;

  const _ValveInfo(
    this.title,
    this.type,
    this.description,
  );
}

class _ValvePainter extends CustomPainter {
  final String type;
  final Color color;

  _ValvePainter({
    required this.type,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final centerX = size.width / 2;
    final centerY = size.height / 2 + 15;

    final bodyPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final detailPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;

    final fillPaint = Paint()
      ..color = color.withValues(alpha: 0.18)
      ..style = PaintingStyle.fill;

    final pipeY = centerY + 15;

    canvas.drawLine(
      Offset(15, pipeY),
      Offset(centerX - 65, pipeY),
      bodyPaint,
    );

    canvas.drawLine(
      Offset(centerX + 65, pipeY),
      Offset(size.width - 15, pipeY),
      bodyPaint,
    );

    final body = Path()
      ..moveTo(centerX - 65, pipeY)
      ..lineTo(centerX - 42, centerY - 30)
      ..lineTo(centerX + 42, centerY - 30)
      ..lineTo(centerX + 65, pipeY)
      ..lineTo(centerX + 42, centerY + 60)
      ..lineTo(centerX - 42, centerY + 60)
      ..close();

    canvas.drawPath(body, fillPaint);
    canvas.drawPath(body, bodyPaint);

    switch (type) {
      case 'gate':
        _drawGate(canvas, centerX, centerY, detailPaint);
        break;
      case 'globe':
        _drawGlobe(canvas, centerX, centerY, detailPaint);
        break;
      case 'ball':
        _drawBall(canvas, centerX, centerY, detailPaint, fillPaint);
        break;
      case 'butterfly':
        _drawButterfly(canvas, centerX, centerY, detailPaint);
        break;
      case 'check':
        _drawCheck(canvas, centerX, centerY, detailPaint);
        break;
      case 'plug':
        _drawPlug(canvas, centerX, centerY, detailPaint);
        break;
      case 'diaphragm':
        _drawDiaphragm(canvas, centerX, centerY, detailPaint);
        break;
      case 'control':
        _drawControl(canvas, centerX, centerY, detailPaint);
        break;
    }

    _drawLabel(
      canvas,
      'FLOW',
      Offset(size.width / 2, size.height - 12),
    );
  }

  void _drawGate(
    Canvas canvas,
    double x,
    double y,
    Paint paint,
  ) {
    canvas.drawLine(
      Offset(x, y - 75),
      Offset(x, y + 5),
      paint,
    );
    canvas.drawLine(
      Offset(x - 28, y - 5),
      Offset(x + 28, y - 5),
      paint,
    );
    canvas.drawLine(
      Offset(x - 28, y - 5),
      Offset(x - 28, y + 15),
      paint,
    );
    canvas.drawLine(
      Offset(x + 28, y - 5),
      Offset(x + 28, y + 15),
      paint,
    );
    canvas.drawLine(
      Offset(x - 28, y + 15),
      Offset(x + 28, y + 15),
      paint,
    );
    canvas.drawLine(
      Offset(x - 18, y - 75),
      Offset(x + 18, y - 75),
      paint,
    );
  }

  void _drawGlobe(
    Canvas canvas,
    double x,
    double y,
    Paint paint,
  ) {
    canvas.drawLine(
      Offset(x, y - 75),
      Offset(x, y - 5),
      paint,
    );

    final disk = Path()
      ..moveTo(x - 22, y - 5)
      ..lineTo(x + 22, y + 5)
      ..lineTo(x - 22, y + 15)
      ..close();

    canvas.drawPath(disk, paint);
    canvas.drawLine(
      Offset(x - 35, y + 25),
      Offset(x + 35, y + 25),
      paint,
    );
  }

  void _drawBall(
    Canvas canvas,
    double x,
    double y,
    Paint paint,
    Paint fillPaint,
  ) {
    canvas.drawCircle(
      Offset(x, y + 15),
      31,
      fillPaint,
    );
    canvas.drawCircle(
      Offset(x, y + 15),
      31,
      paint,
    );
    canvas.drawLine(
      Offset(x - 25, y + 15),
      Offset(x + 25, y + 15),
      paint,
    );
    canvas.drawLine(
      Offset(x, y - 75),
      Offset(x, y - 16),
      paint,
    );
    canvas.drawLine(
      Offset(x - 20, y - 75),
      Offset(x + 20, y - 75),
      paint,
    );
  }

  void _drawButterfly(
    Canvas canvas,
    double x,
    double y,
    Paint paint,
  ) {
    canvas.drawLine(
      Offset(x, y - 75),
      Offset(x, y + 15),
      paint,
    );
    canvas.drawLine(
      Offset(x - 27, y - 10),
      Offset(x + 27, y + 40),
      paint,
    );
    canvas.drawLine(
      Offset(x + 27, y - 10),
      Offset(x - 27, y + 40),
      paint,
    );
  }

  void _drawCheck(
    Canvas canvas,
    double x,
    double y,
    Paint paint,
  ) {
    final flap = Path()
      ..moveTo(x - 32, y + 35)
      ..lineTo(x + 20, y - 25)
      ..lineTo(x + 32, y + 35);

    canvas.drawPath(flap, paint);
    canvas.drawCircle(
      Offset(x + 20, y - 25),
      5,
      paint,
    );
  }

  void _drawPlug(
    Canvas canvas,
    double x,
    double y,
    Paint paint,
  ) {
    final plug = Path()
      ..moveTo(x - 25, y - 15)
      ..lineTo(x + 25, y - 15)
      ..lineTo(x + 18, y + 45)
      ..lineTo(x - 18, y + 45)
      ..close();

    canvas.drawPath(plug, paint);
    canvas.drawLine(
      Offset(x, y - 75),
      Offset(x, y - 15),
      paint,
    );
  }

  void _drawDiaphragm(
    Canvas canvas,
    double x,
    double y,
    Paint paint,
  ) {
    canvas.drawLine(
      Offset(x, y - 75),
      Offset(x, y - 30),
      paint,
    );

    final diaphragm = Path()
      ..moveTo(x - 35, y - 5)
      ..lineTo(x - 20, y - 25)
      ..lineTo(x + 20, y - 25)
      ..lineTo(x + 35, y - 5);

    canvas.drawPath(diaphragm, paint);
    canvas.drawLine(
      Offset(x - 35, y - 5),
      Offset(x + 35, y - 5),
      paint,
    );
  }

  void _drawControl(
    Canvas canvas,
    double x,
    double y,
    Paint paint,
  ) {
    final actuator = Rect.fromCenter(
      center: Offset(x, y - 60),
      width: 65,
      height: 35,
    );

    canvas.drawRect(actuator, paint);
    canvas.drawLine(
      Offset(x, y - 42),
      Offset(x, y - 5),
      paint,
    );

    final plug = Path()
      ..moveTo(x - 22, y - 5)
      ..lineTo(x + 22, y + 5)
      ..lineTo(x, y + 25)
      ..close();

    canvas.drawPath(plug, paint);
  }

  void _drawLabel(
    Canvas canvas,
    String label,
    Offset position,
  ) {
    final textPainter = TextPainter(
      text: TextSpan(
        text: label,
        style: TextStyle(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
    );

    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(
        position.dx - textPainter.width / 2,
        position.dy - textPainter.height / 2,
      ),
    );
  }

  @override
  bool shouldRepaint(covariant _ValvePainter oldDelegate) {
    return oldDelegate.type != type || oldDelegate.color != color;
  }
}
