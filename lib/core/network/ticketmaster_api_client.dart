import 'package:dio/dio.dart';
import 'package:event_hub/core/config/api_config.dart';


class TicketmasterApiClient {
  TicketmasterApiClient._() {
    _dio = Dio(
      BaseOptions(
        baseUrl: ApiConfig.ticketmasterBaseUrl,
        queryParameters: {'apikey': ApiConfig.ticketmasterApiKey, 'locale': 'en-us'},
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
    String? classificationId,
    int page = 0,
    int size = 20,
  }) async {
    final params = <String, dynamic>{
      'page': page,
      'size': size,
      'sort': 'date,asc',
    };
    if (keyword != null && keyword.isNotEmpty) params['keyword'] = keyword;
    if (classificationId != null && classificationId.isNotEmpty) {
      params['classificationId'] = classificationId;
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
}
