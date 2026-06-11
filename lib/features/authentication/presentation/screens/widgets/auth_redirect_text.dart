import 'package:flutter/material.dart';

class AuthRedirectText extends StatelessWidget {
  final String question;
  final String actionLabel;
  final VoidCallback onTap;

  const AuthRedirectText({
    super.key,
    required this.question,
    required this.actionLabel,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          question,
          style: const TextStyle(fontSize: 14, color: Color(0xFF888888)),
        ),
        GestureDetector(
          onTap: onTap,
          child: Text(
            " $actionLabel",
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF5669FF),
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}