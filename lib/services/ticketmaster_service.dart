import 'package:event_hub/core/network/ticketmaster_api_client.dart';
import 'package:event_hub/models/category_model.dart';
import 'package:event_hub/models/event_model.dart';
import 'package:event_hub/models/ticketmaster_category_model.dart';

/// High-level service that wraps [TicketmasterApiClient] and returns
/// strongly-typed model objects for use in the UI layer.
class TicketmasterService {
  TicketmasterService._();
  static final TicketmasterService instance = TicketmasterService._();

  final _client = TicketmasterApiClient.instance;

  // ── Categories ──────────────────────────────────────────────────────────

  /// Returns the top-level Ticketmaster segments as [CategoryModel] list.
  /// Filters out "Undefined" and deduplicates by segment ID.
  Future<List<CategoryModel>> getCategories() async {
    final data = await _client.fetchClassifications();
    final embedded = data['_embedded'] as Map? ?? {};
    final classifications = (embedded['classifications'] as List?) ?? [];

    final seen = <String>{};
    final categories = <CategoryModel>[];

    for (final cls in classifications) {
      final tc = TicketmasterCategory.fromJson(cls as Map<String, dynamic>);
      if (tc.id.isEmpty || tc.name == 'Undefined') continue;
      if (seen.contains(tc.id)) continue;
      seen.add(tc.id);
      categories.add(tc.toCategoryModel());
    }

    return categories;
  }

  // ── Events ───────────────────────────────────────────────────────────────

  /// Returns a list of upcoming events.
  ///
  /// [keyword]          – free-text search term (optional)
  /// [classificationId] – Ticketmaster segment ID to filter (optional)
  /// [page]             – 0-indexed page number
  Future<List<EventModel>> getEvents({
    String? keyword,
    String? classificationId,
    int page = 0,
  }) async {
    final data = await _client.fetchEvents(
      keyword: keyword,
      classificationId: classificationId,
      page: page,
    );
    final embedded = data['_embedded'] as Map? ?? {};
    final rawEvents = (embedded['events'] as List?) ?? [];

    return rawEvents
        .map((e) => EventModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
