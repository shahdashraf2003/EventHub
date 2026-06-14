import 'package:flutter/material.dart';

class HomeBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const HomeBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  static const _items = [
    {'icon': Icons.explore_outlined, 'label': 'Explore'},
    {'icon': Icons.calendar_today_outlined, 'label': 'Events'},
    {'icon': Icons.location_on_outlined, 'label': 'Map'},
    {'icon': Icons.person_outline, 'label': 'Profile'},
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Color(0x12000000),
            blurRadius: 12,
            offset: Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        child: SizedBox(
          height: 64,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: List.generate(_items.length + 1, (i) {
                  if (i == 2) return const SizedBox(width: 56);
                  final idx = i > 2 ? i - 1 : i;
                  final selected = idx == currentIndex;
                  return GestureDetector(
                    onTap: () => onTap(idx),
                    behavior: HitTestBehavior.opaque,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          _items[idx]['icon'] as IconData,
                          size: 22,
                          color: selected
                              ? const Color(0xFF5669FF)
                              : const Color(0xFFAAAAAA),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          _items[idx]['label'] as String,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                            color: selected
                                ? const Color(0xFF5669FF)
                                : const Color(0xFFAAAAAA),
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ),

              Positioned(
                top: 0,
                child: GestureDetector(
                  onTap: () {
                  },
                  child: Container(
                    width: 50,
                    height: 50,
                    decoration: const BoxDecoration(
                      color: Color(0xFF5669FF),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Color(0x445669FF),
                          blurRadius: 10,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const Icon(Icons.add, color: Colors.white, size: 26),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}