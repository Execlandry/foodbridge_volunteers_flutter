import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodbridge_volunteers_flutter/core/api/api_endpoints.dart';
import 'package:foodbridge_volunteers_flutter/core/api/dio_client.dart';

part 'payment_event.dart';
part 'payment_state.dart';

class PaymentBloc extends Bloc<PaymentEvent, PaymentState> {
  final DioClient dioClient;

  PaymentBloc({required this.dioClient}) : super(PaymentInitial()) {
    on<PaymentRequested>(_onPaymentRequested);
    on<PaymentCompleted>(_onPaymentCompleted);
  }

  Future<void> _onPaymentRequested(
    PaymentRequested event,
    Emitter<PaymentState> emit,
  ) async {
    emit(PaymentLoading());
    try {
      final dio = await dioClient.getDio();
      final response = await dio.post(
        ApiEndpoints.acceptOrderId(event.orderId),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final clientSecret = response.data['client_secret'] as String;
        emit(PaymentIntentCreated(clientSecret));
      } else {
        emit(const PaymentFailure('Failed to create payment intent'));
      }
    } on DioException catch (e) {
      final errorMsg = e.response?.data?['message'] ?? e.message;
      emit(PaymentFailure(errorMsg ?? 'Payment request failed'));
    } catch (e) {
      emit(PaymentFailure('An unexpected error occurred'));
    }
  }

  Future<void> _onPaymentCompleted(
    PaymentCompleted event,
    Emitter<PaymentState> emit,
  ) async {
    try {
      final dio = await dioClient.getDio();
      await dio.post('${ApiEndpoints.createPaymentIntent}/${event.orderId}');
      emit(PaymentSuccess());
    } on DioException catch (e) {
      final errorMsg = e.response?.data?['message'] ?? e.message;
      emit(PaymentFailure(errorMsg ?? 'Payment confirmation failed'));
    } catch (e) {
      emit(PaymentFailure('Payment confirmation error'));
    }
  }
}