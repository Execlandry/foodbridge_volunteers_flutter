part of 'navigate_delivery_bloc.dart';

abstract class NavigateDeliveryEvent {}

class UpdateDeliveryLocationEvent extends NavigateDeliveryEvent {
  final LatLng currentLocation;
  final LatLng destination;

  UpdateDeliveryLocationEvent(this.currentLocation, this.destination);
}

class FetchDeliveryRouteEvent extends NavigateDeliveryEvent {
  final LatLng currentLocation;
  final LatLng destination;

  FetchDeliveryRouteEvent(this.currentLocation, this.destination);
}

class UpdateDeliveryLocation extends NavigateDeliveryEvent {
  final LatLng location;
  UpdateDeliveryLocation(this.location);
}