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

  @override
  List<Object?> get props => [orders];
}

class DeliveryError extends DeliveryState {
  final String message;

  DeliveryError(this.message);

  @override
  List<Object?> get props => [message];
}
