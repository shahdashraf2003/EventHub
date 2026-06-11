import 'package:flutter/material.dart';

class ImageSlider extends StatelessWidget {
  final PageController controller;
  final List<Map<String, String>> pages;
  final Function(int) onPageChanged;

  const ImageSlider({
    super.key,
    required this.controller,
    required this.pages,
    required this.onPageChanged,
  });

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      controller: controller,
      itemCount: pages.length,
      onPageChanged: onPageChanged,
      itemBuilder: (_, i) {
        return Image.asset(
          pages[i]["image"]!,
          fit: BoxFit.contain,
        );
      },
    );
  }
}