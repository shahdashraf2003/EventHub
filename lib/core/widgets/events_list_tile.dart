import 'package:event_hub/models/event_model.dart';
import 'package:flutter/material.dart';

Widget _tileImage(String src) {
  const size = 70.0;
  const placeholder = SizedBox(
    width: size,
    height: size,
    child: ColoredBox(
      color: Color(0xFFEEEEEE),
      child: Icon(Icons.image_outlined, color: Color(0xFF5669FF), size: 28),
    ),
  );
  if (src.startsWith('http')) {
    return Image.network(
      src,
      width: size,
      height: size,
      fit: BoxFit.cover,
      errorBuilder: (ctx, err, stack) => placeholder,
      loadingBuilder: (ctx, child, progress) => progress == null ? child : placeholder,
    );
  }
  if (src.isNotEmpty) {
    return Image.asset(
      src,
      width: size,
      height: size,
      fit: BoxFit.cover,
      errorBuilder: (ctx, err, stack) => placeholder,
    );
  }
  return placeholder;
}

class EventListTile extends StatelessWidget {
  final EventModel event;
  final VoidCallback onTap;

  const EventListTile({
    super.key,
    required this.event,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: _tileImage(event.coverImage),
            ),

            const SizedBox(width: 14),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    event.date.toString().split(' ')[0],
                    style: const TextStyle(
                      fontSize: 11,
                      color: Color(0xFF5669FF),
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.3,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    event.title,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF222222),
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(Icons.location_on_outlined,
                          size: 13, color: Color(0xFF888888)),
                      const SizedBox(width: 3),
                      Expanded(
                        child: Text(
                          event.location,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFF888888),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}