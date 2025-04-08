
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodbridge_volunteers_flutter/core/repository/user_repository.dart';
import 'package:foodbridge_volunteers_flutter/logic/user_profile/bloc/user_profile_event.dart';
import 'package:foodbridge_volunteers_flutter/logic/user_profile/bloc/user_profile_state.dart';

class UserProfileBloc extends Bloc<UserProfileEvent, UserProfileState> {
  final UserRepository userRepository;

  UserProfileBloc({required this.userRepository}) : super(UserProfileInitial()) {
    on<FetchUserProfile>(_onFetchUserProfile);
  }

  Future<void> _onFetchUserProfile(
    FetchUserProfile event,
    Emitter<UserProfileState> emit,
  ) async {
    emit(UserProfileLoading());
    try { 
      final user = await userRepository.fetchUserProfileDetails();
      debugPrint("from auth bloc $user");
      emit(UserProfileLoaded(user));

    } on DioException catch (e) {
    if (e.response?.statusCode == 401) {
      emit(UserProfileError('Session expired. Please login again.'));
    } else {
      emit(UserProfileError('Failed to load profile: ${e.message}'));
    }
  } catch (e) {
    emit(UserProfileError('Unexpected error: $e'));
  }
}
}
