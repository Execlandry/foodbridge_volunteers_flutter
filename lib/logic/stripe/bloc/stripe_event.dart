part of 'stripe_bloc.dart';

abstract class StripeEvent with EquatableMixin {
  const StripeEvent();

  @override
  List<Object?> get props => [];
}

class GetStripeRefreshUrl extends StripeEvent {}