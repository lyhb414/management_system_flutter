import 'package:flutter/material.dart';

class AwaitButton extends StatefulWidget {
  final String? text;
  final Color? color;
  final Color textColor;
  final Function? onPress;
  final double fontSize;
  final int maxLines;
  final MainAxisAlignment mainAxisAlignment;

  const AwaitButton(
      {super.key,
      this.text = '',
      this.color = Colors.white,
      this.textColor = Colors.black,
      required this.onPress,
      this.fontSize = 20.0,
      this.mainAxisAlignment = MainAxisAlignment.center,
      this.maxLines = 1});

  @override
  // ignore: library_private_types_in_public_api
  _AwaitButtonState createState() => _AwaitButtonState();
}

class _AwaitButtonState extends State<AwaitButton> {
  bool _loading = false;

  late final String? text;
  late final Color? color;
  late final Color textColor;
  late final Function? onPress;
  late final double fontSize;
  late final int maxLines;
  late final MainAxisAlignment mainAxisAlignment;

  @override
  void initState() {
    super.initState();
    text = widget.text;
    color = widget.color;
    textColor = widget.textColor;
    onPress = widget.onPress;
    fontSize = widget.fontSize;
    maxLines = widget.maxLines;
    mainAxisAlignment = widget.mainAxisAlignment;
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        style: TextButton.styleFrom(
            backgroundColor: color, padding: const EdgeInsets.only(left: 20.0, top: 10.0, right: 20.0, bottom: 10.0)),
        child: _loading
            ? const Center(child: CircularProgressIndicator())
            : Text(text!,
                style: TextStyle(color: textColor, fontSize: fontSize, height: 1),
                textAlign: TextAlign.center,
                maxLines: maxLines,
                overflow: TextOverflow.ellipsis),
        onPressed: () async {
          setState(() {
            _loading = true;
          });
          await onPress?.call();
          setState(() {
            _loading = false;
          });
        });
  }
}
