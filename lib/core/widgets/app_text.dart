
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

  String _prepareText(String value) {
    final pattern = RegExp(
      r'[A-Za-z][A-Za-z0-9&._/#:+-]*(?:[ \t]+[A-Za-z0-9&._/#:+-]+)*',
    );

    return value.replaceAllMapped(
      pattern,
      (match) => '\u2066${match.group(0)}\u2069',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      _prepareText(text),
      textDirection: TextDirection.rtl,
      textAlign: textAlign ?? TextAlign.start,
      style: style,
      maxLines: maxLines,
      overflow: overflow,
    );
  }
}
