import 'package:flutter/material.dart';

class CalculationsPage extends StatelessWidget {
  const CalculationsPage({super.key});

  static const Color primaryColor = Color(0xFF07569A);

  static const List<Map<String, dynamic>> topics = [
    {
      'title': 'محاسبه سایز لوله',
      'english': 'Pipe Sizing',
      'icon': Icons.straighten,
    },
    {
      'title': 'محاسبه افت فشار',
      'english': 'Pressure Drop',
      'icon': Icons.speed,
    },
    {
      'title': 'محاسبه ضخامت لوله',
      'english': 'Pipe Wall Thickness',
      'icon': Icons.circle_outlined,
    },
    {
      'title': 'محاسبه سرعت سیال',
      'english': 'Fluid Velocity',
      'icon': Icons.water_drop,
    },
    {
      'title': 'محاسبات جریان سیال',
      'english': 'Fluid Flow',
      'icon': Icons.water,
    },
    {
      'title': 'محاسبات پمپ و هد',
      'english': 'Pump & Head',
      'icon': Icons.settings,
    },
    {
      'title': 'محاسبات فلنج و پیچ',
      'english': 'Flange & Bolting',
      'icon': Icons.build,
    },
    {
      'title': 'تبدیل واحدها',
      'english': 'Unit Conversion',
      'icon': Icons.swap_horiz,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'محاسبات مهندسی',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          centerTitle: true,
        ),
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: primaryColor,
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'آموزش و محاسبات مهندسی پایپینگ',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 19,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'آموزش مفاهیم، فرمول‌ها، مثال‌های صنعتی و ابزارهای محاسباتی',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      height: 1.8,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 22),
            const Text(
              'فهرست محاسبات مهندسی',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            ...topics.map((topic) {
              return Card(
                margin: const EdgeInsets.only(bottom: 10),
                elevation: 2,
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  leading: CircleAvatar(
                    backgroundColor: primaryColor.withValues(alpha: 0.1),
                    child: Icon(
                      topic['icon'] as IconData,
                      color: primaryColor,
                    ),
                  ),
                  title: Text(
                    topic['title'] as String,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                  subtitle: Text(topic['english'] as String),
                  trailing: const Icon(
                    Icons.arrow_back_ios_new,
                    size: 17,
                  ),
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'بخش ${topic['title']} در حال آماده‌سازی است.',
                        ),
                      ),
                    );
                  },
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
