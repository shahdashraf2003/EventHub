import 'package:event_hub/model/entities/category_model.dart';
import 'package:event_hub/model/entities/event_model.dart';
import 'package:event_hub/model/network/ticketmaster_service.dart';

class TicketmasterRepository {
  final TicketmasterService _service;

  TicketmasterRepository({TicketmasterService? service})
      : _service = service ?? TicketmasterService.instance;

  Future<List<CategoryModel>> getCategories() async {
    return await _service.getCategories();
  }

  Future<List<EventModel>> getUpcomingEvents({
    String city = 'New York',
    int page = 0,
    String? classificationId,
  }) async {
    return await _service.getUpcomingEvents(
      city: city,
      page: page,
      classificationId: classificationId,
    );
  }

  Future<List<EventModel>> getPastEvents({
    String city = 'New York',
    String? endDate,
    String? classificationId,
  }) async {
    return await _service.getPastEvents(
      city: city,
      endDate: endDate,
      classificationId: classificationId,
    );
  }

  Future<List<EventModel>> getTodayEvents({
    String city = 'New York',
    String classificationName = 'music',
    DateTime? date,
  }) async {
    return await _service.getTodayEvents(
      city: city,
      classificationName: classificationName,
      date: date,
    );
  }

  Future<List<EventModel>> searchByKeyword({
    required String keyword,
    int size = 20,
  }) async {
    return await _service.searchByKeyword(
      keyword: keyword,
      size: size,
    );
  }

  Future<List<EventModel>> getEvents({
    String? keyword,
    String? classificationId,
    String? city,
    int page = 0,
  }) async {
    return await _service.getEvents(
      keyword: keyword,
      classificationId: classificationId,
      city: city,
      page: page,
    );
  }
}
