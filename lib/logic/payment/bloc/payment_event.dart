part of 'payment_bloc.dart';

abstract class PaymentEvent extends Equatable {
  const PaymentEvent();

  @override
  List<Object> get props => [];
}

class PaymentRequested extends PaymentEvent {
  final String orderId;
  const PaymentRequested(this.orderId);
  @override List<Object> get props => [orderId];
}

class PaymentCompleted extends PaymentEvent {
  final String orderId;
  const PaymentCompleted(this.orderId);
  @override List<Object> get props => [orderId];
}