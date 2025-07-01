import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodbridge_volunteers_flutter/core/repository/auth_repository.dart';

part 'stripe_event.dart';
part 'stripe_state.dart';

class StripeBloc extends Bloc<StripeEvent, StripeState> {
  final AuthRepository authRepository;

  StripeBloc({required this.authRepository}) : super(StripeInitial()) {
    on<GetStripeRefreshUrl>(_onGetStripeRefreshUrl);
  }

  Future<void> _onGetStripeRefreshUrl(
    GetStripeRefreshUrl event,
  Emitter<StripeState> emit,
  ) async {
    emit(StripeUrlLoading());
    try {
      final url = await authRepository.stripeRefreshUrl();
      emit(StripeUrlLoaded(url: url));
    } catch (e) {
      emit(StripeUrlError(message: e.toString()));
    }
  }
}