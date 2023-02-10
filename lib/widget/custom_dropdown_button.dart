import 'package:flutter/material.dart';

class CustomDropdownButton<T> extends StatelessWidget {
  final String hint;
  final List<DropdownMenuItem<T>> items;
  final T value;
  final void Function(T?) onChanged;

  const CustomDropdownButton({
    Key? key,
    required this.hint,
    required this.items,
    required this.value,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.transparent),
        borderRadius: BorderRadius.circular(5.0),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<T>(
          hint: Text(hint),
          value: value,
          items: items,
          onChanged: onChanged,
        ),
      ),
    );
  }
}
