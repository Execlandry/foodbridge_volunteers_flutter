import 'package:latlong2/latlong.dart';

abstract class NavigatePickupEvent {}

class CheckOtpStatusEvent extends NavigatePickupEvent {}

class UpdateLocationEvent extends NavigatePickupEvent {
  final LatLng currentLocation;
  final LatLng destination;

  UpdateLocationEvent(this.currentLocation, this.destination);
}

class FetchRouteEvent extends NavigatePickupEvent {
  final LatLng currentLocation;
  final LatLng destination;

  FetchRouteEvent(this.currentLocation, this.destination);
}

class UpdatePickupLocation extends NavigatePickupEvent {
  final LatLng location;
  UpdatePickupLocation(this.location);
}

class VerifyOtpEvent extends NavigatePickupEvent {
  final String otp;
  VerifyOtpEvent(this.otp);
}
