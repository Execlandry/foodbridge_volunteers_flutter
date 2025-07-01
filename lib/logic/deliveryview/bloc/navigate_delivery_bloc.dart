import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:latlong2/latlong.dart';
import 'package:foodbridge_volunteers_flutter/core/repository/delivery_repository.dart';

part 'navigate_delivery_event.dart';
part 'navigate_delivery_state.dart';

class NavigateDeliveryBloc extends Bloc<NavigateDeliveryEvent, NavigateDeliveryState> {
  final DeliveryRepository _repository = DeliveryRepository();
  final Dio dio;
  Timer? _throttleTimer;
  List<LatLng>? _lastRoute;

  NavigateDeliveryBloc(this.dio) : super(NavigateDeliveryInitial()) {
    on<UpdateDeliveryLocationEvent>(_onUpdateLocation);
    on<FetchDeliveryRouteEvent>(_onFetchRoute);
    on<UpdateDeliveryLocation>((event, emit) async {
      try {
        await _repository.updateDeliveryLocation(event.location);
      } catch (e) {
        debugPrint('Delivery location update failed: $e');
      }
    });
  }

  void _onUpdateLocation(UpdateDeliveryLocationEvent event, Emitter<NavigateDeliveryState> emit) {
    emit(NavigateDeliveryLocationUpdated(event.currentLocation));

    if (_lastRoute != null) {
      emit(NavigateDeliveryRouteLoaded(_lastRoute!));
      return;
    }

    _throttleTimer?.cancel();
    _throttleTimer = Timer(const Duration(seconds: 5), () {
      add(FetchDeliveryRouteEvent(event.currentLocation, event.destination));
    });
  }

  Future<void> _onFetchRoute(FetchDeliveryRouteEvent event, Emitter<NavigateDeliveryState> emit) async {
    try {
      final url = 'http://router.project-osrm.org/route/v1/driving/'
          '${event.currentLocation.longitude},${event.currentLocation.latitude};'
          '${event.destination.longitude},${event.destination.latitude}?overview=full&geometries=polyline';

      final response = await dio.get(url);
      if (response.statusCode == 200 && response.data['routes'].isNotEmpty) {
        final geometry = response.data['routes'][0]['geometry'];
        final route = _decodePolyline(geometry);
        _lastRoute = route;
        emit(NavigateDeliveryRouteLoaded(route));
      } else {
        emit(NavigateDeliveryError("No routes found"));
      }
    } catch (e) {
      emit(NavigateDeliveryError("Error fetching route: $e"));
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