import 'package:equatable/equatable.dart';

abstract class AuthState extends Equatable {
  const AuthState();
  @override
  List<Object?> get props => [];
}
class AuthRegistrationSuccess extends AuthState{}
class AuthInitial extends AuthState {}
class AuthLoading extends AuthState {}

// States for persistence
class AuthAuthenticated extends AuthState {
  final String token;
  const AuthAuthenticated(this.token);
  
  @override
  List<Object?> get props => [token];
}

class AuthUnauthenticated extends AuthState {}

class AuthFailure extends AuthState {
  final String error;
  const AuthFailure(this.error);

  @override
  List<Object?> get props => [error];
}
