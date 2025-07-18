
import 'package:equatable/equatable.dart';
import 'package:foodbridge_volunteers_flutter/core/model/user_profile_model.dart';

abstract class UserProfileState extends Equatable {
  const UserProfileState();
  
  @override
  List<Object?> get props => [];
}

class UserProfileInitial extends UserProfileState {}

class UserProfileLoading extends UserProfileState{}

class UserProfileLoaded extends UserProfileState{
  final UserProfileDetails user;

  const UserProfileLoaded(this.user);

  @override
  List<Object?> get props => [user];
}

class UserProfileError extends UserProfileState{
  final String message;
  const UserProfileError(this.message);

  @override
  List<Object?> get props => [message];
}