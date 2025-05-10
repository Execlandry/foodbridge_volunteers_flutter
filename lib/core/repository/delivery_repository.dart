import 'package:foodbridge_volunteers_flutter/core/api/api_endpoints.dart';
import 'package:foodbridge_volunteers_flutter/core/api/dio_client.dart';
import 'package:foodbridge_volunteers_flutter/core/model/available_order.dart';

class DeliveryRepository {
  final _dio = DioClient().dio;

  Future<List<AvailableOrder>> fetchAvailableOrders() async {
    final response = await _dio.get(ApiEndpoints.getAvailableOrders);
    return (response.data as List)
        .map((e) => AvailableOrder.fromJson(e))
        .toList();
  }
}
