import 'dart:ui';

class CategoryModel {
  final String id;
  final String label;
  final String emoji;
  final Color? color;

  CategoryModel({
    this.id = '',
    required this.label,
    required this.emoji,
    this.color = const Color(0xFF5669FF),
  });
}