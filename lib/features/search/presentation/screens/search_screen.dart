import 'dart:async';

import 'package:event_hub/core/widgets/events_list_tile.dart';
import 'package:event_hub/features/event_details/presentation/screens/event_details_screen.dart';
import 'package:event_hub/features/filter/pressentation/screens/filter_bottom_sheet.dart'
    show FilterBottomSheet;
import 'package:event_hub/features/search/presentation/screens/widgets/search_input_bar.dart';
import 'package:event_hub/models/event_model.dart';
import 'package:event_hub/services/ticketmaster_service.dart';
import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _service    = TicketmasterService.instance;
  final _controller = TextEditingController();

  List<EventModel> _results  = [];
  bool _loading              = false;
  bool _hasSearched          = false;
  String? _error;
  Timer? _debounce;
  String? _selectedClassificationId;

  @override
  void initState() {
    super.initState();
    _browseFeatured();
  }

  @override
  void dispose() {
    _controller.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  Future<void> _browseFeatured() async {
    setState(() { _loading = true; _error = null; });
    try {
      final results = await _service.getUpcomingEvents(
        city: 'New York',
        classificationId: _selectedClassificationId,
      );
      if (mounted) {
        setState(() {
          _results      = results;
          _loading      = false;
          _hasSearched  = true;
        });
      }
    } catch (_) {
      if (mounted) setState(() { _error = 'Could not load events.'; _loading = false; });
    }
  }

  Future<void> _searchByKeyword(String keyword) async {
    setState(() { _loading = true; _error = null; });
    try {
      final results = keyword.isEmpty
          ? await _service.getUpcomingEvents(
              city: 'New York',
              classificationId: _selectedClassificationId,
            )
          : await _service.searchByKeyword(
              keyword: keyword,
              classificationId: _selectedClassificationId,
            );

      if (mounted) {
        setState(() {
          _results      = results;
          _loading      = false;
          _hasSearched  = true;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error   = 'Search failed. Please try again.';
          _loading = false;
        });
      }
    }
  }

  void _onSearch(String query) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 400), () {
      _searchByKeyword(query.trim());
    });
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
          'Search',
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
              onFilterTap: () async {
                final classificationId = await FilterBottomSheet.show(context);
                if (classificationId != null || _selectedClassificationId != null) {
                  setState(() {
                    _selectedClassificationId = classificationId;
                  });
                  _searchByKeyword(_controller.text.trim());
                }
              },
            ),
          ),

          const SizedBox(height: 8),

          Expanded(child: _buildBody()),
        ],
      ),
    );
  }

  Widget _buildBody() {
    if (_loading) {
      return const Center(
        child: CircularProgressIndicator(color: Color(0xFF5669FF)),
      );
    }
    if (_error != null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(_error!, style: const TextStyle(color: Colors.redAccent, fontSize: 14)),
            const SizedBox(height: 12),
            TextButton(
              onPressed: () => _searchByKeyword(_controller.text.trim()),
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }
    if (_hasSearched && _results.isEmpty) {
      return const Center(
        child: Text(
          'No events found',
          style: TextStyle(color: Color(0xFF888888), fontSize: 15),
        ),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: _results.length,
      itemBuilder: (_, i) => EventListTile(
        event: _results[i],
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => EventDetailsScreen(event: _results[i]),
          ),
        ),
      ),
    );
  }
}