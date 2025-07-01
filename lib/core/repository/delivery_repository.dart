import 'package:dio/dio.dart';
import 'package:foodbridge_volunteers_flutter/core/api/api_endpoints.dart';
import 'package:foodbridge_volunteers_flutter/core/api/dio_client.dart';
import 'package:foodbridge_volunteers_flutter/core/model/available_order_model.dart';
import 'package:foodbridge_volunteers_flutter/core/model/current_order_model.dart';
import 'package:foodbridge_volunteers_flutter/core/model/delivery_history_model.dart';
import 'package:latlong2/latlong.dart';

class DeliveryRepository {
  Future<Dio> get _dio async => await DioClient().getDio();

  Future<List<AvailableOrder>> fetchAvailableOrders() async {
    try {
      final dio = await _dio;
      final response = await dio.get(ApiEndpoints.getAvailableOrders);
      return (response.data as List)
          .map((e) => AvailableOrder.fromJson(e))
          .toList();
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<void> acceptOrder(String orderId) async {
    try {
      final dio = await _dio;
      await dio.post(ApiEndpoints.acceptOrderById(orderId));
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<CurrentOrderResponse?> fetchCurrentOrder() async {
    try {
      final dio = await _dio;
      final response = await dio.get(ApiEndpoints.getCurrentOrders);
      return CurrentOrderResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<void> updateCurrentLocation(LatLng location) async {
    try {
      final dio = await _dio;
      await dio.patch(ApiEndpoints.pickupCurrentLocation, data: {
        'lat': location.latitude,
        'lng': location.longitude,
      });
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

//TODO::This feels redundant
  Future<void> updateDeliveryLocation(LatLng location) async {
    try {
      final dio = await _dio;
      await dio.patch(ApiEndpoints.deliveryCurrentLocation, data: {
        'lat': location.latitude,
        'lng': location.longitude,
      });
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<bool> fetchOtpVerified() async {
    try {
      final dio = await _dio;
      final response = await dio.get(ApiEndpoints.checkOtpVerified);
      return response.data['is_otp_verified'] as bool;
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<void> verifyOtpAtPickup(String otp) async {
    try {
      final dio = await _dio;
      final response = await dio.patch(
        ApiEndpoints.verifyOtpAtPickup,
        data: {'otp': otp},
      );

      // Check for specific status codes if needed
      if (response.statusCode != 200) {
        throw Exception('OTP verification failed');
      }
    } on DioException catch (e) {
      // Handle specific Dio errors
      if (e.response?.statusCode == 400) {
        throw Exception('Invalid OTP');
      } else {
        throw _handleDioError(e);
      }
    }
  }

  Future<List<OrderHistory>> fetchOrderHistory() async {
    try {
      final dio = await _dio;
      final response = await dio.get(ApiEndpoints.getOrderWithSuccessfulPayout);
      return (response.data as List)
          .map((e) => OrderHistory.fromJson(e))
          .toList();
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Exception _handleDioError(DioException e) {
    final statusCode = e.response?.statusCode;
    final message = e.response?.data?['message'] ?? e.message;
    switch (statusCode) {
      case 400:
        return Exception('Bad request: $message');
      case 401:
        return Exception('Unauthorized: $message');
      case 403:
        return Exception('Forbidden: $message');
      case 404:
        return Exception('Not found');
      case 500:
        return Exception('Server error: $message');
      default:
        return Exception(message ?? 'Unexpected error');
    }
  }
}
