import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodbridge_volunteers_flutter/common/color_extension.dart';
import 'package:foodbridge_volunteers_flutter/common_widget/components/custom_error_dialog.dart';
import 'package:foodbridge_volunteers_flutter/common_widget/components/navbar_view.dart';
import 'package:foodbridge_volunteers_flutter/common_widget/round_button.dart';
import 'package:foodbridge_volunteers_flutter/logic/delivery/bloc/delivery_bloc.dart';
import 'package:foodbridge_volunteers_flutter/view/home/home_view.dart';
import 'package:foodbridge_volunteers_flutter/view/navigation/navigate_pickup_view.dart';

class CheckoutView extends StatefulWidget {
  final String pickupLocation;
  final double pickupLat;
  final double pickupLng;
  final String dropLocation;
  final double dropLat;
  final double dropLng;
  final double amount;
  final String itemId;

  const CheckoutView({
    super.key,
    required this.pickupLocation,
    required this.pickupLat,
    required this.pickupLng,
    required this.dropLocation,
    required this.dropLat,
    required this.dropLng,
    required this.amount,
    required this.itemId,
  }) : assert(pickupLat >= -90 && pickupLat <= 90);

  @override
  State<CheckoutView> createState() => _CheckoutViewState();
}

class _CheckoutViewState extends State<CheckoutView> {
  void _handleOrderAcceptance() {
    context.read<DeliveryBloc>().add(OrderAccepted(widget.itemId));
  }

  @override
  Widget build(BuildContext context) {
    double serviceFee = widget.amount * 0.2;
    double totalAmount = widget.amount - serviceFee;

    return BlocListener<DeliveryBloc, DeliveryState>(
      listener: (context, state) {
        if (state is DeliveryOrderAccepted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => NavigatePickupView(
                pickupLat: widget.pickupLat,
                pickupLng: widget.pickupLng,
                dropLat: widget.dropLat,
                dropLng: widget.dropLng,
                amount: widget.amount,
                orderId: widget.itemId,
              ),
            ),
          );
        } else if (state is DeliveryError) {
          _showErrorDialog(state.message);
        }
      },
      child: Scaffold(
        backgroundColor: TColor.white,
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 46),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: Image.asset("assets/img/btn_back.png",
                            width: 20, height: 20),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          "Checkout",
                          style: TextStyle(
                              color: TColor.primaryText,
                              fontSize: 20,
                              fontWeight: FontWeight.w800),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 15, horizontal: 25),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Delivery Details",
                        style: TextStyle(
                            color: TColor.secondaryText, fontSize: 12),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              "Pickup: ${widget.pickupLocation}\nDrop: ${widget.dropLocation}\nAmount: ${widget.amount == 0 ? 'Free' : 'Rs ${widget.amount.toStringAsFixed(2)}'}",
                              style: TextStyle(
                                  color: TColor.primaryText,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  decoration: BoxDecoration(color: TColor.textfield),
                  height: 8,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: Column(
                    children: [
                      const SizedBox(height: 15),
                      _buildCostRow("Delivery Cost", widget.amount),
                      _buildCostRow("Service Fee (20%)", serviceFee),
                      const SizedBox(height: 15),
                      Divider(
                        color: TColor.secondaryText.withOpacity(0.5),
                        height: 1,
                      ),
                      const SizedBox(height: 15),
                      _buildCostRow("Total", totalAmount, isTotal: true),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  decoration: BoxDecoration(color: TColor.textfield),
                  height: 8,
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 20, horizontal: 25),
                  child: BlocBuilder<DeliveryBloc, DeliveryState>(
                    builder: (context, state) {
                      if (state is DeliveryLoading) {
                        return const CircularProgressIndicator();
                      }
                      return RoundButton(
                          title: "Accept Delivery",
                          onPressed: _handleOrderAcceptance);
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCostRow(String label, double amount, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: TColor.primaryText,
              fontSize: 13,
              fontWeight: isTotal ? FontWeight.w700 : FontWeight.w500,
            ),
          ),
          Text(
            amount == 0 ? 'Free' : 'Rs ${amount.toStringAsFixed(2)}',
            style: TextStyle(
              color: TColor.primaryText,
              fontSize: isTotal ? 15 : 13,
              fontWeight: FontWeight.w700,
            ),
          )
        ],
      ),
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => CustomErrorDialog(
        onPressed: () {
          // Navigator.of(ctx).pop();
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => NavbarView(selectedIndex: 1,)));
        },
        title: 'Acceptance Failed',
        message: 'Complete your current order\nbefore accepting another.',
      ),
    );
  }
}
