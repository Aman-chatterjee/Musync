import 'package:flutter/material.dart';

class CustomField extends StatelessWidget {
  final String hintText;
  final TextEditingController? controller;
  final bool isObscure;
  final bool isReadOnly;
  final VoidCallback? onTap;
  final String? Function(String?)? validator;

  const CustomField({
    super.key,
    required this.hintText,
    required this.controller,
    this.onTap,
    this.isReadOnly = false,
    this.isObscure = false,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: isObscure,
      onTap: onTap,
      readOnly: isReadOnly,
      validator: validator,
      decoration: InputDecoration(hintText: hintText),
    );
  }
}
