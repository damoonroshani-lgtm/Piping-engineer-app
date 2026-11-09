import 'package:flutter/material.dart';

class AppText extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;

  const AppText(
    this.text, {
    super.key,
    this.style,
    this.textAlign,
    this.maxLines,
    this.overflow,
  });

  String _prepareBidiText(String value) {
    // RLM: Right-to-Left Mark
    // LRI/PDI: Isolate embedded text direction.
    final result = StringBuffer();

    for (final rune in value.runes) {
      final character = String.fromCharCode(rune);

      if (RegExp(r'[\u0600-\u06FF]').hasMatch(character)) {
        result.write('\u200F');
      } else {
        result.write(character);
      }
    }

    return result.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Text(
        _prepareBidiText(text),
        textDirection: TextDirection.rtl,
        textAlign: textAlign ?? TextAlign.start,
        style: style,
        maxLines: maxLines,
        overflow: overflow,
      ),
    );
  }
}
