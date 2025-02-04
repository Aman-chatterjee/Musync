import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:musync/core/theme/app_pallete.dart';

class AuthField extends StatelessWidget {
  final String text1;
  final String text2;
  final VoidCallback onPressed;

  const AuthField(
      {super.key,
      required this.text1,
      required this.text2,
      required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        text: text1,
        style: Theme.of(context).textTheme.titleMedium,
        children: [
          TextSpan(
            text: text2,
            style: TextStyle(
              color: Pallete.gradient2,
              fontWeight: FontWeight.bold,
            ),
            recognizer: TapGestureRecognizer()..onTap = onPressed,
          ),
        ],
      ),
    );
  }
}
