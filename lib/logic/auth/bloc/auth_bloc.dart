import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodbridge_volunteers_flutter/core/repository/auth_repository.dart';
import 'package:foodbridge_volunteers_flutter/core/utils/shared_storage.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;

  AuthBloc(this.authRepository) : super(AuthInitial()) {
    on<AppStartCheck>(_onAppStartCheck);
    on<RegisterRequestedUserEvent>(_onRegisterRequestedUserEvent);
    on<LoginRequestedUserEvent>(_onLoginRequestedUserEvent);
    on<LoggedOutRequestedUserEvent>(_onLoggedOutRequestedUserEvent);
  }

  Future<void> _onAppStartCheck(
      AppStartCheck event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final token = await SharedStorage.getToken();
      if (token != null)
        emit(AuthAuthenticated(token));
      else
        emit(AuthUnauthenticated());
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }

  Future<void> _onLoginRequestedUserEvent(
      LoginRequestedUserEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      await authRepository.loginUser(
          email: event.email, password: event.password);

      final token = await SharedStorage.getToken();
      emit(AuthAuthenticated(token!));
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }

  Future<void> _onLoggedOutRequestedUserEvent(
      LoggedOutRequestedUserEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      await SharedStorage.clearToken();
      emit(AuthUnauthenticated());
    } catch (e) {
      emit(AuthFailure("Logout failed: ${e.toString()}"));
    }
  }

  Future<void> _onRegisterRequestedUserEvent(
    RegisterRequestedUserEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      await authRepository.registerUser(
        firstName: event.firstName,
        lastName: event.lastName,
        email: event.email,
        password: event.password,
        mobno: event.mobno,
      );
      emit(AuthRegistrationSuccess());
    } on DioException catch (e) {
      final errorMessage =
          e.response?.data?['message'] ?? 'Registration failed';
      emit(AuthFailure(errorMessage));
    } catch (e) {
      emit(AuthFailure('An unexpected error occurred'));
    }
  }
}
