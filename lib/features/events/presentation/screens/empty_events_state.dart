import 'package:event_hub/core/widgets/blue_primary_button.dart';
import 'package:flutter/material.dart';

class EmptyEventsState extends StatelessWidget {
  final VoidCallback onExplore;

  const EmptyEventsState({super.key, required this.onExplore});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
       Center(
              child: Image.asset(
                'assets/images/empty_state.png',
                width: 300,
                height: 300,
                errorBuilder: (_, _, _) => const Icon(
                  Icons.calendar_today_rounded,
                  size: 72,
                  color: Color(0xFF5669FF),
                ),
              ),
            ),
        

          const SizedBox(height: 28),

          const Text(
            "No Upcoming Event",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Color(0xFF222222),
            ),
          ),

          const SizedBox(height: 10),

          const Text(
            "Lorem ipsum dolor sit amet,\nconsectetur",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Color(0xFF888888),
              height: 1.5,
            ),
          ),

          const SizedBox(height: 40),

          BluePrimaryButton(
            label: "Explore Events",
            onPressed: onExplore,
          ),
        ],
      ),
    );
  }
}