import 'package:dio/dio.dart';
import 'package:laundry/utils/LSConstants.dart';

Dio dio() {
  Dio dio = new Dio();

  dio.options.baseUrl = '$host/api/';
  dio.options.headers['accept'] = 'Application/Json';

  return dio;
}