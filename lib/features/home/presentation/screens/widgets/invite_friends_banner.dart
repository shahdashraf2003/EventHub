import 'package:flutter/material.dart';

class InviteFriendsBanner extends StatelessWidget {
  final VoidCallback onInvite;

  const InviteFriendsBanner({super.key, required this.onInvite});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF00F8FF).withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Invite your friends",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF222222),
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  "Get \$20 for ticket",
                  style: TextStyle(fontSize: 13, color: Color(0xFF666666)),
                ),
                const SizedBox(height: 14),
                ElevatedButton(
                  onPressed: onInvite,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF00F8FF),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    elevation: 0,
                  ),
                  child: const Text(
                    "INVITE",
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      letterSpacing: 0.8,
                    ),
                  ),
                ),
              ],
            ),
          ),

          Image.asset(
            'assets/images/invite.png',
            width:180,
            height: 100,
            fit: BoxFit.contain,
            errorBuilder: (_, _, _) => const Icon(
              Icons.card_giftcard_rounded,
              size: 72,
              color: Color(0xFF5669FF),
            ),
          ),
        ],
      ),
    );
  }
}