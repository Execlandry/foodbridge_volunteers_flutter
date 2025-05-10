import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:foodbridge_volunteers_flutter/core/model/available_order.dart';
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
        emit(DeliveryError("Failed to fetch orders"));
      }
    });
  }
}
