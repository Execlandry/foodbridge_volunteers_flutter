import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:foodbridge_volunteers_flutter/common_widget/round_button.dart';
import 'package:foodbridge_volunteers_flutter/common/color_extension.dart';
import 'package:foodbridge_volunteers_flutter/view/payment/payment.dart';
import 'package:foodbridge_volunteers_flutter/logic/deliveryview/bloc/navigate_delivery_bloc.dart';

class NavigateDeliveryView extends StatefulWidget {
  final double dropLat;
  final double dropLng;
  final double amount;
  final String orderId;

  const NavigateDeliveryView({
    super.key,
    required this.dropLat,
    required this.dropLng,
    required this.amount,
    required this.orderId,
  });

  @override
  State<NavigateDeliveryView> createState() => _NavigateDeliveryViewState();
}

class _NavigateDeliveryViewState extends State<NavigateDeliveryView> {
  late final MapController _mapController;
  late final LatLng dropLocation;
  LatLng? currentLocation;
  double _currentHeading = 0.0;
  bool _isNavigating = false;
  bool _routeFetched = false;
  late StreamSubscription<Position> _positionStream;
  StreamSubscription<CompassEvent>? _compassStream;
  Timer? _locationUpdateTimer;

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
    dropLocation = LatLng(widget.dropLat, widget.dropLng);
    _startLocationTracking();
    _listenToCompass();

    _locationUpdateTimer = Timer.periodic(const Duration(seconds: 10), (_) {
      if (currentLocation != null) {
        context
            .read<NavigateDeliveryBloc>()
            .add(UpdateDeliveryLocation(currentLocation!));
      }
    });
  }

  @override
  void dispose() {
    _positionStream.cancel();
    _compassStream?.cancel();
    _mapController.dispose();
    _locationUpdateTimer?.cancel();
    super.dispose();
  }

  void _listenToCompass() {
    if (FlutterCompass.events != null) {
      _compassStream = FlutterCompass.events!.listen((CompassEvent event) {
        if (mounted && event.heading != null) {
          setState(() {
            _currentHeading = event.heading!;
          });
        }
      });
    }
  }

  void _startLocationTracking() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      permission = await Geolocator.requestPermission();
      if (!mounted) return;
    }

    _positionStream = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 1,
      ),
    ).listen((position) {
      final updatedLocation = LatLng(position.latitude, position.longitude);
      if (!mounted) return;

      setState(() => currentLocation = updatedLocation);

      if (!_routeFetched || !_isNavigating) {
        context.read<NavigateDeliveryBloc>().add(
              UpdateDeliveryLocationEvent(updatedLocation, dropLocation),
            );
        _routeFetched = true;
      }

      if (_isNavigating && _mapController.camera.center != updatedLocation) {
        _mapController.move(updatedLocation, 20);
      }
    });
  }

  void _startNavigation() {
    if (currentLocation != null) {
      setState(() {
        _isNavigating = true;
      });

      double startZoom = _mapController.camera.zoom;
      double targetZoom = 20;
      int steps = 10;
      Duration stepDuration = const Duration(milliseconds: 100);

      for (int i = 1; i <= steps; i++) {
        Future.delayed(stepDuration * i, () {
          if (mounted && currentLocation != null) {
            double newZoom = startZoom + (targetZoom - startZoom) * (i / steps);
            _mapController.move(currentLocation!, newZoom);
          }
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: TColor.white,
        title: Text(
          "Navigate to Delivery",
          style: TextStyle(
            color: TColor.primaryText,
            fontSize: 20,
            fontWeight: FontWeight.w800,
          ),
        ),
        centerTitle: true,
      ),
      body: BlocBuilder<NavigateDeliveryBloc, NavigateDeliveryState>(
        builder: (context, state) {
          List<Polyline> polylines = [];
          if (state is NavigateDeliveryRouteLoaded) {
            polylines.add(
              Polyline(points: state.route, color: Colors.blue, strokeWidth: 5),
            );
          }

          return Stack(
            children: [
              FlutterMap(
                mapController: _mapController,
                options: MapOptions(
                  initialCenter: currentLocation ?? dropLocation,
                  initialZoom: _isNavigating ? 20 : 15,
                ),
                children: [
                  TileLayer(
                    urlTemplate:
                        'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                    userAgentPackageName: 'com.foodbridge.volunteers',
                  ),
                  if (polylines.isNotEmpty) PolylineLayer(polylines: polylines),
                  MarkerLayer(
                    markers: [
                      if (currentLocation != null)
                        Marker(
                          point: currentLocation!,
                          width: 40,
                          height: 40,
                          child: Transform.rotate(
                            angle: _currentHeading *
                                (3.14159265359 / 180), // Degrees to radians
                            child: const Icon(
                              Icons.navigation,
                              color: Colors.blue,
                              size: 30,
                            ),
                          ),
                        ),
                      Marker(
                        point: dropLocation,
                        width: 40,
                        height: 40,
                        child: const Icon(
                          Icons.location_pin,
                          color: Colors.red,
                          size: 30,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Positioned(
                top: 20,
                right: 20,
                child: ElevatedButton(
                  onPressed: _isNavigating ? null : _startNavigation,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: TColor.primary,
                    foregroundColor: Colors.white,
                  ),
                  child: Text(
                    _isNavigating ? "Navigating..." : "Start Navigation",
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ),
              Positioned(
                bottom: 50,
                left: 20,
                right: 20,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: RoundButton(
                    title: "Proceed to Payment",
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Payment(
                            amount: widget.amount,
                            orderId: widget.orderId,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}