import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodbridge_volunteers_flutter/core/repository/delivery_repository.dart';
import 'package:foodbridge_volunteers_flutter/logic/pickupview/bloc/pickup_navigation_event.dart';
import 'package:foodbridge_volunteers_flutter/logic/pickupview/bloc/pickup_navigation_state.dart';
import 'package:latlong2/latlong.dart';

class NavigatePickupBloc extends Bloc<NavigatePickupEvent, NavigatePickupState> {
  final DeliveryRepository _repository = DeliveryRepository();
  final Dio dio;
  Timer? _throttleTimer;
  List<LatLng>? _lastRoute;

  NavigatePickupBloc(this.dio) : super(NavigatePickupInitial()) {
    on<CheckOtpStatusEvent>(_onCheckOtpStatus);
    on<UpdateLocationEvent>(_onUpdateLocation);
    on<FetchRouteEvent>(_onFetchRoute);
    on<UpdatePickupLocation>((event, emit) async {
      try {
        await _repository.updateCurrentLocation(event.location);
      } catch (e) {
        // ignore
      }
    });
    on<VerifyOtpEvent>(_onVerifyOtp);
  }

  Future<void> _onCheckOtpStatus(
      CheckOtpStatusEvent event, Emitter<NavigatePickupState> emit) async {
    emit(NavigatePickupLoading());
    try {
      final isVerified = await _repository.fetchOtpVerified();
      emit(isVerified ? NavigatePickupOtpAlreadyVerified() : NavigatePickupInitial());
    } catch (_) {
      emit(NavigatePickupError("Failed to check OTP status"));
    }
  }

  void _onUpdateLocation(
      UpdateLocationEvent event, Emitter<NavigatePickupState> emit) {
    emit(NavigatePickupLocationUpdated(event.currentLocation));
    if (_lastRoute != null) {
      emit(NavigatePickupRouteLoaded(_lastRoute!));
      return;
    }
    _throttleTimer?.cancel();
    _throttleTimer = Timer(const Duration(seconds: 5), () {
      add(FetchRouteEvent(event.currentLocation, event.destination));
    });
  }

  Future<void> _onFetchRoute(
      FetchRouteEvent event, Emitter<NavigatePickupState> emit) async {
    try {
      final url = 'http://router.project-osrm.org/route/v1/driving/'
          '${event.currentLocation.longitude},${event.currentLocation.latitude};'
          '${event.destination.longitude},${event.destination.latitude}?overview=full&geometries=polyline';
      final response = await dio.get(url);
      if (response.statusCode == 200 && response.data['routes'].isNotEmpty) {
        final geometry = response.data['routes'][0]['geometry'];
        final route = _decodePolyline(geometry);
        _lastRoute = route;
        emit(NavigatePickupRouteLoaded(route));
      } else {
        emit(NavigatePickupError("No routes found"));
      }
    } catch (e) {
      emit(NavigatePickupError("Error fetching route: $e"));
    }
  }

  Future<void> _onVerifyOtp(
      VerifyOtpEvent event, Emitter<NavigatePickupState> emit) async {
    emit(NavigatePickupLoading());

    if(event.otp.trim().isEmpty ) {
      emit(NavigatePickupError("Please enter a OTP"));
      return;
    }
    if (event.otp.length != 6 || !RegExp(r'^\d{6}$').hasMatch(event.otp)) {
      emit(NavigatePickupError("OTP must be 6-digit number"));
      return;
    }
    try {
      await _repository.verifyOtpAtPickup(event.otp);
      emit(NavigatePickupOtpVerified());
    }on DioException catch (dioErr) {
    final errorMessage = dioErr.response?.data['message'] ?? 'Something went wrong';
    emit(NavigatePickupError(errorMessage));
    
    } catch (e) {
      emit(NavigatePickupError('Invalid OTP'));
    }
  }

  List<LatLng> _decodePolyline(String polyline) {
    const factor = 1e5;
    List<LatLng> points = [];
    int index = 0, lat = 0, lon = 0;
    while (index < polyline.length) {
      int b, shift = 0, result = 0;
      do {
        b = polyline.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      lat += (result & 1) != 0 ? ~(result >> 1) : (result >> 1);
      shift = 0;
      result = 0;
      do {
        b = polyline.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      lon += (result & 1) != 0 ? ~(result >> 1) : (result >> 1);
      points.add(LatLng(lat / factor, lon / factor));
    }
    return points;
  }

  @override
  Future<void> close() {
    _throttleTimer?.cancel();
    return super.close();
  }
}
