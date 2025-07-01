part of 'payment_bloc.dart';

abstract class PaymentState extends Equatable {
  const PaymentState();
  @override List<Object> get props => [];
}

class PaymentInitial extends PaymentState {}
class PaymentLoading extends PaymentState {}
class PaymentSuccess extends PaymentState {}

class PaymentIntentCreated extends PaymentState {
  final String clientSecret;
  const PaymentIntentCreated(this.clientSecret);
  @override List<Object> get props => [clientSecret];
}

class PaymentFailure extends PaymentState {
  final String errorMessage;
  const PaymentFailure(this.errorMessage);
  @override List<Object> get props => [errorMessage];
}