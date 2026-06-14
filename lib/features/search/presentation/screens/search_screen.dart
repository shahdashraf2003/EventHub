import 'package:event_hub/core/widgets/events_list_tile.dart';
import 'package:event_hub/features/events/presentation/screens/event_screen.dart';
import 'package:event_hub/features/filter/pressentation/screens/filter_bottom_sheet.dart' show FilterBottomSheet;
import 'package:event_hub/features/search/presentation/screens/widgets/search_input_bar.dart';
import 'package:event_hub/models/event_model.dart';
import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _controller = TextEditingController();
  List<EventModel> _results = sampleSearchEvents;

  void _onSearch(String query) {
    setState(() {
      _results = sampleSearchEvents
          .where((e) =>
              e.title.toLowerCase().contains(query.toLowerCase()) ||
              e.location.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const BackButton(color: Color(0xFF222222)),
        title: const Text(
          "Search",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: Color(0xFF222222),
          ),
        ),
      ),
      body: Column(
        children: [
          Container(
            color: Colors.white,
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
            child: SearchInputBar(
              controller: _controller,
              onChanged: _onSearch,
              onFilterTap: () => FilterBottomSheet.show(context),
            ),
          ),

          const SizedBox(height: 8),

          Expanded(
            child: _results.isEmpty
                ? const Center(
                    child: Text(
                      "No events found",
                      style: TextStyle(color: Color(0xFF888888), fontSize: 15),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    itemCount: _results.length,
                    itemBuilder: (_, i) => EventListTile(
                      event: _results[i],
                      onTap: () {},
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}