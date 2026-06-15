import 'package:dio/dio.dart';
import 'package:event_hub/model/network/api_constatnts.dart';

class TicketmasterApiClient {
  TicketmasterApiClient._() {
    _dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.ticketmasterBaseUrl,
        queryParameters: {
          'apikey': ApiConstants.ticketmasterApiKey,
          'locale': 'en-us',
        },
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
      ),
    );

    _dio.interceptors.add(
      LogInterceptor(requestBody: false, responseBody: false),
    );
  }

  static final TicketmasterApiClient instance = TicketmasterApiClient._();

  late final Dio _dio;

  Future<Map<String, dynamic>> fetchEvents({
    String? keyword,
    String? city,
    String? classificationName,
    String? classificationId,
    String? startDateTime,
    String? endDateTime,
    String sort = 'date,asc',
    int page = 0,
    int size = 20,
  }) async {
    final params = <String, dynamic>{
      'sort': sort,
      'size': size,
      'page': page,
    };

    if (keyword != null && keyword.isNotEmpty) params['keyword'] = keyword;
    if (city != null && city.isNotEmpty) params['city'] = city;
    if (classificationName != null && classificationName.isNotEmpty) {
      params['classificationName'] = classificationName;
    }
    if (classificationId != null && classificationId.isNotEmpty) {
      params['classificationId'] = classificationId;
    }
    if (startDateTime != null && startDateTime.isNotEmpty) {
      params['startDateTime'] = startDateTime;
    }
    if (endDateTime != null && endDateTime.isNotEmpty) {
      params['endDateTime'] = endDateTime;
    }

    final response = await _dio.get<Map<String, dynamic>>(
      'events.json',
      queryParameters: params,
    );
    return response.data ?? {};
  }

  Future<Map<String, dynamic>> fetchClassifications() async {
    final response = await _dio.get<Map<String, dynamic>>(
      'classifications.json',
      queryParameters: {'size': 20},
    );
    return response.data ?? {};
  }


  Future<Map<String, dynamic>> fetchByKeyword({
  required String keyword,
  int size = 20,
}) async {
  final response = await _dio.get<Map<String, dynamic>>(
    'events.json',
    queryParameters: {
      'keyword': keyword,
      'size': size,
    },
  );
  return response.data ?? {};
}


}

