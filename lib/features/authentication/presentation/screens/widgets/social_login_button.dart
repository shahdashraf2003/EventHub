import 'package:flutter/material.dart';

class SocialLoginButton extends StatelessWidget {
  final String label;
  final String iconAsset;
  final VoidCallback onPressed;

  const SocialLoginButton({
    super.key,
    required this.label,
    required this.iconAsset,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 54,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          backgroundColor: Colors.white,
          side: const BorderSide(color: Color(0xFFEEEEEE)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center, 
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(iconAsset, width: 24, height: 24),

            const SizedBox(width: 12),

            Flexible(
              child: Text(
                label,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF222222),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}