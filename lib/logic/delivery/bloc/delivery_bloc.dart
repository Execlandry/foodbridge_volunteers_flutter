import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:foodbridge_volunteers_flutter/core/model/available_order_model.dart';
import 'package:foodbridge_volunteers_flutter/core/model/current_order_model.dart';
import 'package:foodbridge_volunteers_flutter/core/model/delivery_history_model.dart';
import 'package:foodbridge_volunteers_flutter/core/repository/delivery_repository.dart';

part 'delivery_event.dart';
part 'delivery_state.dart';

class DeliveryBloc extends Bloc<DeliveryEvent, DeliveryState> {
  final DeliveryRepository repository;

  DeliveryBloc(this.repository) : super(DeliveryInitial()) {
    on<LoadAvailableOrders>((event, emit) async {
      emit(DeliveryLoading());
      try {
        final orders = await repository.fetchAvailableOrders();
        emit(DeliveryLoaded(orders));
      } catch (e) {
        debugPrint("Error in LoadAvailableOrders: ${e.toString()}"); 
        emit(DeliveryError("Failed to fetch orders"));
      }
    });

    on<OrderAccepted>((event, emit) async {
      emit(DeliveryLoading());
      try {
        await repository.acceptOrder(event.orderId);
        emit(DeliveryOrderAccepted(event.orderId));
        add(LoadAvailableOrders());
      } catch (e) {
        emit(DeliveryError(e.toString()));
      }
    });

    on<LoadCurrentOrders>((event, emit) async {
      emit(DeliveryLoading());
      try {
        final response = await repository.fetchCurrentOrder();
        emit(CurrentOrdersLoaded(response));
      } catch (e) {
        debugPrint("Error fetching current orders: ${e.toString()}");
        emit(DeliveryError("Failed to fetch current orders"));
      }
    });

    on<LoadDeliveryHistory>((event, emit) async {
      emit(DeliveryLoading());
      try {
        final history = await repository.fetchOrderHistory();
        emit(DeliveryHistoryLoaded(history));
      } catch (e) {
        debugPrint("Error fetching delivery history: ${e.toString()}");
        emit(DeliveryError("Failed to fetch delivery history"));
      }
    });
  }
}