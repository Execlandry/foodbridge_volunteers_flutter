part of 'delivery_bloc.dart';

sealed class DeliveryEvent extends Equatable {
  const DeliveryEvent();

  @override
  List<Object> get props => [];
}

class LoadAvailableOrders extends DeliveryEvent {}

class OrderAccepted extends DeliveryEvent {
  final String orderId;
  const OrderAccepted(this.orderId);

  @override
  List<Object> get props => [orderId];
}

class LoadCurrentOrders extends DeliveryEvent {}

class LoadDeliveryHistory extends DeliveryEvent {} 