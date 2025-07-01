part of 'delivery_bloc.dart';

abstract class DeliveryState extends Equatable {
  @override
  List<Object?> get props => [];
}

class DeliveryInitial extends DeliveryState {}

class DeliveryLoading extends DeliveryState {}

class DeliveryLoaded extends DeliveryState {
  final List<AvailableOrder> orders;
  DeliveryLoaded(this.orders);
  @override List<Object?> get props => [orders];
}

class DeliveryOrderAccepted extends DeliveryState {
  final String orderId;
  DeliveryOrderAccepted(this.orderId);
  @override List<Object?> get props => [orderId];
}

class CurrentOrdersLoaded extends DeliveryState {
  final CurrentOrderResponse? response;
  CurrentOrdersLoaded(this.response);
  @override List<Object?> get props => [response];
}

class DeliveryHistoryLoaded extends DeliveryState {
  final List<OrderHistory> history;
  DeliveryHistoryLoaded(this.history);
  @override List<Object?> get props => [history];
}

class DeliveryError extends DeliveryState {
  final String message;
  DeliveryError(this.message);
  @override List<Object?> get props => [message];
}