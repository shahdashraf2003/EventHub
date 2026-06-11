import 'package:event_hub/features/onboading/presentation/screens/widgets/buttons_row.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class BottomSheetContent extends StatelessWidget {
  final String title;
  final String desc;
  final bool isLastPage;
  final int pagesCount;
  final PageController controller;
  final VoidCallback onNext;
  final VoidCallback onSkip;

  const BottomSheetContent({
    super.key,
    required this.title,
    required this.desc,
    required this.isLastPage,
    required this.pagesCount,
    required this.controller,
    required this.onNext,
    required this.onSkip,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Color(0xFF5669FF),
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      padding: const EdgeInsets.fromLTRB(28, 32, 28, 40),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: Colors.white,
              height: 1.35,
            ),
          ),
          const SizedBox(height: 12),

          Text(
            desc,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xCCFFFFFF),
              height: 1.6,
            ),
          ),

          const SizedBox(height: 24),

          SmoothPageIndicator(
            controller: controller,
            count: pagesCount,
            effect: const WormEffect(
              dotHeight: 8,
              dotWidth: 8,
              activeDotColor: Colors.white,
              dotColor: Color(0x66FFFFFF),
              spacing: 6,
            ),
          ),

          const SizedBox(height: 24),

          ButtonsRow(
            isLastPage: isLastPage,
            onNext: onNext,
            onSkip: onSkip,
          ),
        ],
      ),
    );
  }
}
