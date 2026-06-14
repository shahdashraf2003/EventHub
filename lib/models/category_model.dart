import 'dart:ui';

class CategoryModel {

  final String label;
  final String emoji;
  final Color? color;

  CategoryModel({
    required this.label,
    required this.emoji,
     this.color=const Color(0xFF5669FF),
  });
}