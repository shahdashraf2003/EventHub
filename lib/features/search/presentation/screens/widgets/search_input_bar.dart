import 'package:flutter/material.dart';

class SearchInputBar extends StatelessWidget {
  final ValueChanged<String>? onChanged;
  final VoidCallback onFilterTap;
  final TextEditingController? controller;

  const SearchInputBar({
    super.key,
    this.onChanged,
    required this.onFilterTap,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 48,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30),
              border: Border.all(color: const Color(0xFFEEEEEE)),
            ),
            child: TextField(
              controller: controller,
              onChanged: onChanged,
              decoration: const InputDecoration(
                hintText: "Search...",
                hintStyle: TextStyle(color: Color(0xFFAAAAAA), fontSize: 15),
                prefixIcon: Icon(Icons.search, color: Color(0xFF5669FF), size: 22),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(vertical: 14),
              ),
            ),
          ),
        ),

        const SizedBox(width: 10),
        GestureDetector(
          onTap: onFilterTap,
          child: Container(
            height: 48,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: const Color(0xFF5669FF),
              borderRadius: BorderRadius.circular(30),
            ),
            child: Row(
              children: const [
                Icon(Icons.tune, color: Colors.white, size: 18),
                SizedBox(width: 6),
                Text(
                  "Filters",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}