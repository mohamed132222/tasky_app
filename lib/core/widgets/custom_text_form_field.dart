import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  final String title;
  TextEditingController controller = TextEditingController();
  final Function(String?)? validator;
  final String hintText;
  int? maxline;

  CustomTextFormField({
    super.key,
    required this.title,
    required this.controller,
    this.validator,
    required this.hintText,
    this.maxline,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: Theme.of(context).textTheme.labelSmall),
        const SizedBox(height: 8),
        TextFormField(
          maxLines: maxline,
          validator: (value) => validator != null ? validator!(value) : null,
          controller: controller,
          style: Theme.of(context).textTheme.labelSmall,
          decoration: InputDecoration(hintText: hintText),
        ),
      ],
    );
  }
}
