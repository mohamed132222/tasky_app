import 'package:flutter/material.dart';

class CustomCheckBox extends StatelessWidget {
  final bool? value;
  Function(bool?)? onTap;

  CustomCheckBox({super.key, required this.value, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Checkbox(
      value: value,
      onChanged: onTap,

      activeColor: Color(0xFF15B86C),
    );
  }
}
