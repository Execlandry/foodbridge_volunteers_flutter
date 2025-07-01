part of 'stripe_bloc.dart';

abstract class StripeState with EquatableMixin {
  const StripeState();

  @override
  List<Object?> get props => [];
}

class StripeInitial extends StripeState {}

class StripeUrlLoading extends StripeState {}

class StripeUrlLoaded extends StripeState {
  final String url;

  const StripeUrlLoaded({required this.url});

  @override
  List<Object?> get props => [url];
}

class StripeUrlError extends StripeState {
  final String message;

  const StripeUrlError({required this.message});

  @override
  List<Object?> get props => [message];
}