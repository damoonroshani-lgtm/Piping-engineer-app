
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

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Text.rich(
        TextSpan(
          text: '',
          children: [
            TextSpan(text: text),
          ],
        ),
        textDirection: TextDirection.rtl,
        textAlign: textAlign ?? TextAlign.start,
        style: style,
        maxLines: maxLines,
        overflow: overflow,
      ),
    );
  }
}
