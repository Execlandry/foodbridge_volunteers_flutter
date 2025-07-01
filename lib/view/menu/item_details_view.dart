import 'package:flutter/material.dart';
import 'package:foodbridge_volunteers_flutter/common_widget/round_button.dart';
import 'package:foodbridge_volunteers_flutter/core/utils/helper_func.dart';
import 'package:foodbridge_volunteers_flutter/view/menu/checkout_view.dart';
import '../../common/color_extension.dart';

class ItemDetailsView extends StatefulWidget {
  final Map<String, dynamic> itemDetails;
  final String itemId;

  const ItemDetailsView(
      {super.key, required this.itemDetails, required this.itemId});

  @override
  State<ItemDetailsView> createState() => _ItemDetailsViewState();
}

class _ItemDetailsViewState extends State<ItemDetailsView> {
  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: TColor.lightGrey,
      body: SafeArea(
        child: Stack(
          children: [
            Positioned(
              top: 0,
              child: Stack(
                children: [
                  Image.network(
                    widget.itemDetails['order']['business']['banner'] ?? '',
                    width: media.width,
                    height: media.width * 0.9,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Image.asset(
                      "assets/img/volunteerjpg.jpg",
                      width: media.width,
                      height: media.width * 0.9,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Container(
                    height: media.width * 0.9,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.black.withOpacity(0.3),
                          Colors.transparent
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: media.width * 0.8),
                  Container(
                    width: media.width,
                    decoration: BoxDecoration(
                      color: TColor.lightGrey,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(40),
                        topRight: Radius.circular(40),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 25, vertical: 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Center(
                                child: Text(
                                  "Delivery Details",
                                  style:
                                      theme.textTheme.headlineSmall?.copyWith(
                                    color: TColor.primaryText,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 25),
                              _buildDetailCard(
                                icon: Icons.receipt_long,
                                title: "Order ID",
                                value: widget.itemId.substring(0, 8),
                              ),
                              _buildDetailCard(
                                icon: Icons.store,
                                title: "Business Name",
                                value: capitalizeWords(
                                  widget.itemDetails['order']['business']
                                              ['name']
                                          ?.toString() ??
                                      "N/A",
                                ),
                              ),
                              _buildDetailCard(
                                icon: Icons.people,
                                title: "Organization Name",
                                value: capitalizeWords(
                                  widget.itemDetails['order']['address']['user']
                                              ['name']
                                          ?.toString() ??
                                      "N/A",
                                ),
                              ),
                              _buildDetailCard(
                                icon: Icons.pin_drop,
                                title: "Pickup Location",
                                value: [
                                  widget.itemDetails['order']['business']
                                      ['address']['street'],
                                  widget.itemDetails['order']['business']
                                      ['address']['city'],
                                  widget.itemDetails['order']['business']
                                      ['address']['state']
                                ]
                                    .where((part) => part?.isNotEmpty ?? false)
                                    .map((part) => capitalizeWords(part!))
                                    .join(", "),
                              ),
                              _buildDetailCard(
                                icon: Icons.location_on,
                                title: "Drop Location",
                                value: [
                                  widget.itemDetails['order']['address']
                                      ['street'],
                                  widget.itemDetails['order']['address']
                                      ['city'],
                                  widget.itemDetails['order']['address']
                                      ['state']
                                ]
                                    .where((part) => part?.isNotEmpty ?? false)
                                    .map((part) => capitalizeWords(part!))
                                    .join(", "),
                              ),
                              const SizedBox(height: 20),
                              Container(
                                padding: const EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.1),
                                      spreadRadius: 2,
                                      blurRadius: 8,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: Center(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        "Total Amount",
                                        style:
                                            theme.textTheme.bodyLarge?.copyWith(
                                          color: TColor.secondaryText,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        widget.itemDetails['order']['amount'] ==
                                                "0"
                                            ? "Free"
                                            : "₹${(double.tryParse(widget.itemDetails['order']['amount'] ?? 0.0)?.toStringAsFixed(2))}",
                                        style: theme.textTheme.headlineMedium
                                            ?.copyWith(
                                          color: TColor.primary,
                                          fontWeight: FontWeight.w800,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(height: 30),
                              RoundButton(
                                title: "Proceed to Delivery",
                                icon: Icons.directions_car,
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => CheckoutView(
                                        pickupLat: double.tryParse(widget
                                                    .itemDetails['order']
                                                        ['business']['latitude']
                                                    ?.toString() ??
                                                '0') ??
                                            0.0,
                                        pickupLng: double.tryParse(widget
                                                    .itemDetails['order']
                                                        ['business']
                                                        ['longitude']
                                                    ?.toString() ??
                                                '0') ??
                                            0.0,
                                        dropLat: double.tryParse(widget
                                                    .itemDetails['order']
                                                        ['address']['lat']
                                                    ?.toString() ??
                                                '0') ??
                                            0.0,
                                        dropLng: double.tryParse(widget
                                                    .itemDetails['order']
                                                        ['address']['long']
                                                    ?.toString() ??
                                                '0') ??
                                            0.0,
                                        dropLocation: [
                                          widget.itemDetails['order']['address']
                                              ['street'],
                                          widget.itemDetails['order']['address']
                                              ['city']
                                        ]
                                            .where((part) =>
                                                part?.isNotEmpty ?? false)
                                            .map((part) =>
                                                capitalizeWords(part!))
                                            .join(", "),
                                        amount: double.tryParse(widget
                                                    .itemDetails['order']
                                                        ['amount']
                                                    ?.toString() ??
                                                '0') ??
                                            0.0,
                                        pickupLocation: [
                                          widget.itemDetails['order']
                                              ['business']['address']['street'],
                                          widget.itemDetails['order']
                                              ['business']['address']['city']
                                        ]
                                            .where((part) =>
                                                part?.isNotEmpty ?? false)
                                            .map((part) =>
                                                capitalizeWords(part!))
                                            .join(", "),
                                        itemId: (widget.itemDetails['order']
                                                        ['id']
                                                    ?.toString() ??
                                                '')
                                            .trim(),
                                      ),
                                    ),
                                  );
                                },
                              ),
                              const SizedBox(height: 20),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              top: 40,
              left: 20,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.9),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      spreadRadius: 2,
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    )
                  ],
                ),
                child: IconButton(
                  icon: Icon(Icons.arrow_back, color: TColor.primary),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailCard({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: TColor.primary, size: 22),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: TColor.secondaryText,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(
                    color: TColor.primaryText,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
