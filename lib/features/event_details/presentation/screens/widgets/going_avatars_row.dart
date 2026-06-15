import 'package:flutter/material.dart';

class GoingAvatarsRow extends StatelessWidget {
  final List<String> avatarAssets;
  final double totalCount;
  final VoidCallback onInvite;

  const GoingAvatarsRow({
    super.key,
    required this.avatarAssets,
    required this.totalCount,
    required this.onInvite,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          height: 36,
          width: avatarAssets.length * 24.0 + 12,
          child: Stack(
            children: List.generate(avatarAssets.length, (i) {
              return Positioned(
                left: i * 24.0,
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                  child: CircleAvatar(
                    radius: 16,
                    backgroundImage: AssetImage(avatarAssets[i]),
                    backgroundColor: const Color(0xFFDDDDDD),
                  ),
                ),
              );
            }),
          ),
        ),

        const SizedBox(width: 8),

        Text(
          "\$${totalCount.toStringAsFixed(0)}",
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: Color(0xFF222222),
          ),
        ),

        const Spacer(),

        ElevatedButton(
          onPressed: onInvite,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF5669FF),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            elevation: 0,
          ),
          child: const Text(
            "Invite",
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}