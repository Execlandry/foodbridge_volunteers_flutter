import 'package:latlong2/latlong.dart';

abstract class NavigatePickupState {}

class NavigatePickupInitial extends NavigatePickupState {}

class NavigatePickupLoading extends NavigatePickupState {}

class NavigatePickupLocationUpdated extends NavigatePickupState {
  final LatLng currentLocation;
  NavigatePickupLocationUpdated(this.currentLocation);
}

class NavigatePickupRouteLoaded extends NavigatePickupState {
  final List<LatLng> route;
  NavigatePickupRouteLoaded(this.route);
}

class NavigatePickupOtpVerified extends NavigatePickupState {}

class NavigatePickupOtpAlreadyVerified extends NavigatePickupState {}

class NavigatePickupError extends NavigatePickupState {
  final String message;
  NavigatePickupError(this.message);
}
