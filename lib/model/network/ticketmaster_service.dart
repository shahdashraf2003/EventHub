import 'package:event_hub/model/network/ticketmaster_api_client.dart';
import 'package:event_hub/model/entities/category_model.dart';
import 'package:event_hub/model/entities/ticketmaster_category_model.dart';
import 'package:event_hub/model/entities/event_model.dart';

class TicketmasterService {
  TicketmasterService._();
  static final TicketmasterService instance = TicketmasterService._();

  final _client = TicketmasterApiClient.instance;

  List<EventModel> _parseEvents(Map<String, dynamic> data) {
    final embedded = data['_embedded'] as Map? ?? {};
    final rawEvents = (embedded['events'] as List?) ?? [];
    return rawEvents
        .map((e) => EventModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

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


  Future<List<EventModel>> getUpcomingEvents({
    String city = 'New York',
    int page = 0,
    String? classificationId,
  }) async {
    final data = await _client.fetchEvents(
      city: city,
      sort: 'date,asc',
      size: 20,
      page: page,
      classificationId: classificationId,
    );
    return _parseEvents(data);
  }

  Future<List<EventModel>> getPastEvents({
    String city = 'New York',
    String? endDate,
    String? classificationId,
  }) async {
    final cutoff = endDate ??
        '${DateTime.now().toUtc().toIso8601String().substring(0, 10)}T00:00:00Z';

    final data = await _client.fetchEvents(
      city: city,
      endDateTime: cutoff,
      sort: 'date,desc',
      size: 20,
      classificationId: classificationId,
    );
    return _parseEvents(data);
  }


  Future<List<EventModel>> getTodayEvents({
    String city = 'New York',
    String classificationName = 'music',
    DateTime? date,
  }) async {
    final target = (date ?? DateTime.now().toUtc());
    final dateStr = target.toIso8601String().substring(0, 10);
    final start = '${dateStr}T00:00:00Z';
    final end   = '${dateStr}T23:59:59Z';

    final data = await _client.fetchEvents(
      city: city,
      classificationName: classificationName,
      startDateTime: start,
      endDateTime: end,
      sort: 'date,asc',
      size: 20,
    );
    return _parseEvents(data);
  }


Future<List<EventModel>> searchByKeyword({
  required String keyword,
  int size = 20,
}) async {
  final data = await _client.fetchByKeyword( 
    keyword: keyword,
    size: size,
  );
  return _parseEvents(data);
} 


  Future<List<EventModel>> getEvents({
    String? keyword,
    String? classificationId,
    String? city,
    int page = 0,
  }) async {
    final data = await _client.fetchEvents(
      keyword: keyword,
      classificationId: classificationId,
      city: city,
      sort: 'date,asc',
      size: 20,
      page: page,
    );
    return _parseEvents(data);
  }
}
