import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();
  @override
  List<Object?> get props => [];
}

class AppStartCheck extends AuthEvent {}

class RegisterRequestedUserEvent extends AuthEvent {
  final String firstName;
  final String lastName;
  final String email;
  final String password;
  final String mobno;

  const RegisterRequestedUserEvent({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.password,
    required this.mobno,
  });

  @override
  List<Object?> get props => [firstName, lastName, email, password, mobno];
}

class LoginRequestedUserEvent extends AuthEvent {
  final String email;
  final String password;

  const LoginRequestedUserEvent({required this.email, required this.password});

  @override
  List<Object?> get props => [email, password];
}

class LoggedOutRequestedUserEvent extends AuthEvent {}
