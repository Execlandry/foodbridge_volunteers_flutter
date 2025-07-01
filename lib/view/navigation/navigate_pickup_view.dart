import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:foodbridge_volunteers_flutter/logic/pickupview/bloc/pickup_navigation_bloc.dart';
import 'package:foodbridge_volunteers_flutter/logic/pickupview/bloc/pickup_navigation_event.dart';
import 'package:foodbridge_volunteers_flutter/logic/pickupview/bloc/pickup_navigation_state.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:foodbridge_volunteers_flutter/common_widget/round_button.dart';
import 'package:foodbridge_volunteers_flutter/common_widget/round_textfield.dart';
import 'package:foodbridge_volunteers_flutter/view/navigation/navigate_delivery_view.dart';
import 'package:foodbridge_volunteers_flutter/common/color_extension.dart';

class NavigatePickupView extends StatefulWidget {
  final double pickupLat;
  final double pickupLng;
  final double dropLat;
  final double dropLng;
  final double amount;
  final String orderId;

  const NavigatePickupView({
    super.key,
    required this.pickupLat,
    required this.pickupLng,
    required this.dropLat,
    required this.dropLng,
    required this.amount,
    required this.orderId,
  });

  @override
  State<NavigatePickupView> createState() => _NavigatePickupViewState();
}

class _NavigatePickupViewState extends State<NavigatePickupView> {
  late final MapController _mapController;
  late final LatLng pickupLocation;
  LatLng? currentLocation;
  double _currentHeading = 0.0;
  bool _isNavigating = false;
  bool _routeFetched = false;
  late StreamSubscription<Position> _positionStream;
  StreamSubscription<CompassEvent>? _compassStream;
  final TextEditingController otpController = TextEditingController();
  Timer? _locationUpdateTimer;

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
    pickupLocation = LatLng(widget.pickupLat, widget.pickupLng);
    context.read<NavigatePickupBloc>().add(CheckOtpStatusEvent());
    _startLocationTracking();
    _listenToCompass();
    _locationUpdateTimer = Timer.periodic(const Duration(seconds: 10), (_) {
      if (currentLocation != null) {
        context.read<NavigatePickupBloc>().add(UpdatePickupLocation(currentLocation!));
      }
    });
  }

  @override
  void dispose() {
    _positionStream.cancel();
    _compassStream?.cancel();
    _mapController.dispose();
    otpController.dispose();
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
        context.read<NavigatePickupBloc>().add(
              UpdateLocationEvent(updatedLocation, pickupLocation),
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
      Duration stepDuration = Duration(milliseconds: 100);

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

  void _showOtpBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
          ),
          child: Container(
            padding: const EdgeInsets.all(20),
            child: BlocConsumer<NavigatePickupBloc, NavigatePickupState>(
              listener: (context, state) {
                if (state is NavigatePickupOtpVerified) {
                  Navigator.pop(context);
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => NavigateDeliveryView(
                        dropLat: widget.dropLat,
                        dropLng: widget.dropLng,
                        amount: widget.amount,
                        orderId: widget.orderId,
                      ),
                    ),
                  );
                }
              },
              builder: (context, state) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25),
                      child: RoundTextfield(
                        hintText: "Enter 6-digit OTP",
                        controller: otpController,
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty)
                            return 'Enter OTP';
                          if (value.length != 6) return 'Must be 6 digits';
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(height: 20),
                    if (state is NavigatePickupLoading)
                      const Center(child: CircularProgressIndicator())
                    else
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25),
                        child: RoundButton(
                          title: "Order Collected",
                          onPressed: () {
                            final otp = otpController.text;
                            if (otp.isEmpty || otp.length != 6) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text('Please enter a valid OTP')),
                              );
                              return;
                            }
                            context.read<NavigatePickupBloc>().add(
                                  VerifyOtpEvent(otp),
                                );
                          },
                        ),
                      ),
                    if (state is NavigatePickupError)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25),
                        child: Text(
                          state.message,
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    const SizedBox(height: 20),
                  ],
                );
              },
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<NavigatePickupBloc, NavigatePickupState>(
      listener: (context, state) {
        if (state is NavigatePickupOtpAlreadyVerified || state is NavigatePickupOtpVerified) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => NavigateDeliveryView(
                dropLat: widget.dropLat,
                dropLng: widget.dropLng,
                amount: widget.amount,
                orderId: widget.orderId,
              ),
            ),
          );
        }
      },
      builder: (context, state) {
        List<Polyline> polylines = [];
        if (state is NavigatePickupRouteLoaded) {
          polylines.add(
            Polyline(points: state.route, color: Colors.blue, strokeWidth: 5),
          );
        }

        return Scaffold(
          appBar: AppBar(
            backgroundColor: TColor.white,
            title: Text(
              "Navigate to Pickup",
              style: TextStyle(
                color: TColor.primaryText,
                fontSize: 20,
                fontWeight: FontWeight.w800,
              ),
            ),
            centerTitle: true,
          ),
          body: Stack(
            children: [
              FlutterMap(
                mapController: _mapController,
                options: MapOptions(
                  initialCenter: currentLocation ?? pickupLocation,
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
                            angle: _currentHeading * (3.14159265359 / 180),
                            child: const Icon(
                              Icons.navigation,
                              color: Colors.blue,
                              size: 30,
                            ),
                          ),
                        ),
                      Marker(
                        point: pickupLocation,
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
                    title: "Verify OTP at Pickup",
                    onPressed: _showOtpBottomSheet,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
