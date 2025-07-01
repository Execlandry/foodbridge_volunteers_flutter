part of 'navigate_delivery_bloc.dart';

abstract class NavigateDeliveryState {}

class NavigateDeliveryInitial extends NavigateDeliveryState {}

class NavigateDeliveryLocationUpdated extends NavigateDeliveryState {
  final LatLng currentLocation;
  NavigateDeliveryLocationUpdated(this.currentLocation);
}

class NavigateDeliveryRouteLoaded extends NavigateDeliveryState {
  final List<LatLng> route;
  NavigateDeliveryRouteLoaded(this.route);
}

class NavigateDeliveryError extends NavigateDeliveryState {
  final String message;
  NavigateDeliveryError(this.message);
}