import 'package:flutter/material.dart';

class CommonButton extends StatelessWidget {
  final String? text;

  final Color? color;

  final Color textColor;

  final VoidCallback? onPress;

  final double fontSize;
  final int maxLines;

  final MainAxisAlignment mainAxisAlignment;

  const CommonButton(
      {super.key,
      this.text,
      this.color,
      this.textColor = Colors.black,
      this.onPress,
      this.fontSize = 20.0,
      this.mainAxisAlignment = MainAxisAlignment.center,
      this.maxLines = 1});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        style: TextButton.styleFrom(
            backgroundColor: color, padding: const EdgeInsets.only(left: 20.0, top: 10.0, right: 20.0, bottom: 10.0)),
        child: Text(text!,
            style: TextStyle(color: textColor, fontSize: fontSize, height: 1),
            textAlign: TextAlign.center,
            maxLines: maxLines,
            overflow: TextOverflow.ellipsis),
        onPressed: () {
          onPress?.call();
        });
  }
}
