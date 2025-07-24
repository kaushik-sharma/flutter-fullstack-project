import 'package:budget_tracker/services/local_cache_service.dart';
import 'package:dio/dio.dart';

class DioService {
  DioService._();

  static final DioService instance = DioService._();

  static final BaseOptions _baseOptions = BaseOptions(
    baseUrl: "https://valid-hip-catfish.ngrok-free.app/api",
    headers: {'authorization': LocalCacheService.getString('authToken')},
    validateStatus: (status) => true,
    sendTimeout: const Duration(minutes: 5),
    receiveTimeout: const Duration(minutes: 5),
    connectTimeout: const Duration(minutes: 5),
  );

  final Dio _dio = Dio(_baseOptions);

  Dio get dio => _dio;

  static void setAuthToken() {
    _baseOptions.headers.addAll({
      'authorization': LocalCacheService.getString('authToken'),
    });
  }
}
