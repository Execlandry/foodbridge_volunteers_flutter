import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodbridge_volunteers_flutter/common/color_extension.dart';
import 'package:foodbridge_volunteers_flutter/common_widget/components/gradient_bg.dart';
import 'package:foodbridge_volunteers_flutter/common_widget/round_button.dart';
import 'package:foodbridge_volunteers_flutter/common_widget/round_textfield.dart';
import 'package:foodbridge_volunteers_flutter/core/model/available_order_model.dart';
import 'package:foodbridge_volunteers_flutter/core/utils/helper_func.dart';
import 'package:foodbridge_volunteers_flutter/logic/delivery/bloc/delivery_bloc.dart';
import 'package:foodbridge_volunteers_flutter/logic/user_profile/bloc/user_profile_bloc.dart';
import 'package:foodbridge_volunteers_flutter/logic/user_profile/bloc/user_profile_event.dart';
import 'package:foodbridge_volunteers_flutter/logic/user_profile/bloc/user_profile_state.dart';
import 'package:foodbridge_volunteers_flutter/view/navigation/current_location_view.dart';
import 'package:foodbridge_volunteers_flutter/view/menu/item_details_view.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

import '../../common_widget/recent_item_row.dart';
import '../../common_widget/view_all_title_row.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  TextEditingController txtSearch = TextEditingController();
  bool _isDropdownOpen = false;
  String? _actualLocation;
  bool _showAll = false;
  String _greetingMessage = "Good morning";

  @override
  void initState() {
    super.initState();
    context.read<UserProfileBloc>().add(FetchUserProfile());
    context.read<DeliveryBloc>().add(LoadAvailableOrders());
    _determinePosition();
    _setGreetingMessage();
  }

  void _setGreetingMessage() {
    final hour = DateTime.now().hour;
    setState(() {
      _greetingMessage = hour >= 5 && hour < 12
          ? "Good morning"
          : hour < 17
              ? "Good afternoon"
              : "Good evening";
    });
  }

  Future<void> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Location Permission Required"),
          content:
              const Text("Please enable location permissions in settings."),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("OK"),
            ),
          ],
        ),
      );
      return;
    }

    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    try {
      List<Placemark> placemarks =
          await placemarkFromCoordinates(position.latitude, position.longitude);

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks.first;
        setState(() {
          _actualLocation = [
            place.name,
            place.locality,
            place.administrativeArea
          ]
              .where((part) => part?.isNotEmpty ?? false)
              .map((part) => capitalizeWords(part!))
              .join(", ");
        });
      }
    } catch (e) {
      if (kDebugMode) print("Error getting address: $e");
      setState(() {
        _actualLocation = "Location not available";
      });
    }
  }

  void _toggleDropdown() => setState(() => _isDropdownOpen = !_isDropdownOpen);

  void _navigateToCurrentLocationView() {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => const CurrentLocationView()));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: GradientBackground(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeaderSection(),
                const SizedBox(height: 24),
                _buildLocationSection(),
                const SizedBox(height: 24),
                _buildSearchSection(),
                const SizedBox(height: 32),
                Expanded(child: _buildDeliverySection()),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderSection() {
    return BlocBuilder<UserProfileBloc, UserProfileState>(
      builder: (context, userState) {
        String userName = "Guest";

        if (userState is UserProfileLoaded) {
          final user = userState.user;
          if (user.name != null && user.name!.isNotEmpty) {
            userName = capitalizeWords(user.name!);
          } else {
            userName = [user.firstName, user.lastName]
                .where((part) => part?.isNotEmpty ?? false)
                .map((part) => capitalizeWords(part!))
                .join(" ");
          }
        } else if (userState is UserProfileError) {
          userName = "User";
        }

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _greetingMessage,
                    style: TextStyle(
                      color: TColor.secondaryText,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    userName,
                    style: TextStyle(
                      color: TColor.primaryText,
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildLocationSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: _toggleDropdown,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Current Location",
                        style: TextStyle(
                          color: TColor.secondaryText,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      if (_actualLocation != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Text(
                            _actualLocation!,
                            style: TextStyle(
                              color: TColor.primaryText,
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                    ],
                  ),
                ),
                Icon(
                  _isDropdownOpen ? Icons.expand_less : Icons.expand_more,
                  color: TColor.primary,
                ),
              ],
            ),
          ),
        ),
        if (_isDropdownOpen)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: RoundButton(
              title: "Update Location",
              onPressed: _navigateToCurrentLocationView,
              fontSize: 14,
            ),
          ),
      ],
    );
  }

  Widget _buildSearchSection() {
    return RoundTextfield(
      hintText: "Search orders by cities...",
      controller: txtSearch,
      bgColor: Colors.white,
      left: Icon(
        Icons.search_rounded,
        color: TColor.secondaryText,
        size: 20,
      ),
      onChanged: (value) => setState(() {}),
      validator: (value) => null,
    );
  }

  Widget _buildDeliverySection() {
    return Column(
      children: [
        ViewAllTitleRow(
          title: "Available for Delivery",
          onView: () => setState(() => _showAll = !_showAll),
        ),
        const SizedBox(height: 16),
        Expanded(
          child: BlocBuilder<DeliveryBloc, DeliveryState>(
            builder: (context, state) {
              if (state is DeliveryLoading) {
                return _buildLoadingState();
              } else if (state is DeliveryLoaded) {
                return _buildDeliveryList(state.orders);
              } else if (state is DeliveryError) {
                return _buildErrorState(state.message);
              }
              return const SizedBox.shrink();
            },
          ),
        ),
      ],
    );
  }

  Widget _buildLoadingState() {
    return const Center(
      child: CircularProgressIndicator(
        strokeWidth: 2,
        valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
      ),
    );
  }

  Widget _buildDeliveryList(List<AvailableOrder> orders) {
    final searchLower = txtSearch.text.toLowerCase();
    final filteredOrders = orders.where((order) {
      return order.order.business.address.city
              .toLowerCase()
              .contains(searchLower) ||
          order.order.address.city.toLowerCase().contains(searchLower);
    }).toList();

    if (filteredOrders.isEmpty) {
      return _buildEmptyState();
    }

    return ListView.separated(
      itemCount: filteredOrders.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final order = filteredOrders[index];
        return RecentItemRow(
          price: order.order.amount,
          originCity: capitalizeWords(order.order.business.address.city),
          destinationCity: capitalizeWords(order.order.address.city),
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ItemDetailsView(
                itemDetails: order.toJson(),
                itemId: order.id,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.delivery_dining_rounded,
            size: 64,
            color: TColor.secondaryText.withOpacity(0.3),
          ),
          const SizedBox(height: 16),
          Text(
            "No Orders Available",
            style: TextStyle(
              color: TColor.secondaryText,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Check back later or try different search terms",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: TColor.secondaryText,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline_rounded,
            color: TColor.primary,
            size: 40,
          ),
          const SizedBox(height: 16),
          Text(
            "Oops! Something Went Wrong",
            style: TextStyle(
              color: TColor.primaryText,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            message,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: TColor.secondaryText,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}
