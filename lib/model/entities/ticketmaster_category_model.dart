import 'package:event_hub/model/entities/category_model.dart';
import 'package:flutter/material.dart';

const _segmentMeta = <String, (String emoji, Color color)>{
  'Music':         ('🎵', Color(0xFFFF9500)),
  'Sports':        ('🏀', Color(0xFFFF6B6B)),
  'Arts & Theatre':('🎨', Color(0xFF5669FF)),
  'Film':          ('🎬', Color(0xFF9C27B0)),
  'Miscellaneous': ('✨', Color(0xFF4CAF50)),
  'Undefined':     ('❓', Color(0xFF9E9E9E)),
};

class TicketmasterCategory {
  final String id;
  final String name;

  const TicketmasterCategory({required this.id, required this.name});
  CategoryModel toCategoryModel() {
    final meta = _segmentMeta[name] ??
        _segmentMeta.values.last; 
    return CategoryModel(
      id: id,
      label: name,
      emoji: meta.$1,
      color: meta.$2,
    );
  }

  factory TicketmasterCategory.fromJson(Map<String, dynamic> json) {
    final segment = json['segment'] as Map<String, dynamic>? ?? {};
    return TicketmasterCategory(
      id: (segment['id'] as String?) ?? '',
      name: (segment['name'] as String?) ?? '',
    );
  }
}
