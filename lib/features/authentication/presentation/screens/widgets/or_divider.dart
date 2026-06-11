import 'package:flutter/material.dart';

class OrDivider extends StatelessWidget {
  const OrDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(child: Divider(color: Color(0xFFEEEEEE))),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Text(
            "OR",
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey.shade400,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        const Expanded(child: Divider(color: Color(0xFFEEEEEE))),
      ],
    );
  }
}