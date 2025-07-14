import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodbridge_volunteers_flutter/common/color_extension.dart';
import 'package:foodbridge_volunteers_flutter/common_widget/components/gradient_bg.dart';
import 'package:foodbridge_volunteers_flutter/common_widget/components/section_header.dart';
import 'package:foodbridge_volunteers_flutter/core/utils/helper_func.dart';
import 'package:foodbridge_volunteers_flutter/logic/delivery/bloc/delivery_bloc.dart';
import 'package:foodbridge_volunteers_flutter/view/navigation/navigate_pickup_view.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';

class ActiveDelivery extends StatefulWidget {
  const ActiveDelivery({super.key});
  @override
  State<ActiveDelivery> createState() => _ActiveDeliveryState();
}

class _ActiveDeliveryState extends State<ActiveDelivery> {
  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    context.read<DeliveryBloc>().add(LoadCurrentOrders());
  }

  Color _getStatusColor(String? status) {
    switch (status?.toLowerCase()) {
      case 'pending':
        return Colors.orange;
      case 'in_transit':
        return Colors.blue;
      case 'delivered':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dateFormat = DateFormat('MMM dd, yyyy - hh:mm a');

    return Scaffold(
      body: GradientBackground(
        child: Column(
          children: [
            const SizedBox(height: 46),
            const SectionHeader(title: "Active Delivery"),
            Expanded(
              child: BlocBuilder<DeliveryBloc, DeliveryState>(
                builder: (context, state) {
                  if (state is DeliveryLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is DeliveryError) {
                    return Center(child: Text(state.message));
                  } else if (state is CurrentOrdersLoaded) {
                    final response = state.response;
                    final order = response?.currentOrder;

                    if (order == null) {
                      return RefreshIndicator(
                        onRefresh: _loadData,
                        child: Center(
                          child: ListView(
                            physics: const AlwaysScrollableScrollPhysics(),
                            children: [
                              const SizedBox(height: 100),
                              Center(
                                child: Lottie.asset(
                                    'assets/animations/no_orders.json',
                                    height: 200),
                              ),
                              const SizedBox(height: 20),
                              const Center(
                                child: Text(
                                  'No Active Deliveries',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 10),
                              const Center(
                                child: Text(
                                  'You have no active deliveries.\nPlease accept a new order.',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }

                    return RefreshIndicator(
                      onRefresh: _loadData,
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Order Status Card
                            Card(
                              elevation: 4,
                              color: _getStatusColor(response?.orderStatus),
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Row(
                                  children: [
                                    const Icon(Icons.local_shipping,
                                        color: Colors.white),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'ORDER STATUS',
                                            style: theme.textTheme.bodySmall
                                                ?.copyWith(
                                              color: Colors.white70,
                                            ),
                                          ),
                                          Text(
                                            response?.orderStatus
                                                    ?.toUpperCase() ??
                                                'UNKNOWN',
                                            style: theme.textTheme.titleLarge
                                                ?.copyWith(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            // Order Summary
                            _buildThemedCard(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _buildSectionTitle('Order Summary'),
                                  const Divider(color: Colors.black12),
                                  _buildInfoRow('Order ID:',
                                      order.id!.substring(0, 8) ?? 'N/A'),
                                  _buildInfoRow('Order Amount:',
                                      '₹${(order.amount ?? 0.0).toStringAsFixed(2)}'),
                                  _buildInfoRow(
                                      'Order Date:',
                                      dateFormat.format(DateTime.parse(
                                          order.createdAt ??
                                              DateTime.now().toString()))),
                                ],
                              ),
                            ),

                            // Delivery Details
                            _buildThemedCard(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _buildSectionTitle('Delivery Details'),
                                  const Divider(color: Colors.black12),
                                  if (order.business!.banner != null)
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: Image.network(
                                        order.address?.user?.pictureUrl ??
                                            'https://via.placeholder.com/150',
                                        height: 150,
                                        width: double.infinity,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  const SizedBox(height: 12),
                                  Text(
                                    capitalizeWords(
                                        order.address?.user?.name ?? 'No Name'),
                                    style: TextStyle(
                                        color: TColor.primaryText,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  const SizedBox(height: 8),
                                  _buildInfoRow(
                                    'Recipient:',
                                    capitalizeWords(
                                      '${order.address?.user?.firstName ?? ''} '
                                                  '${order.address?.user?.lastName ?? ''}'
                                              .trim()
                                              .isEmpty
                                          ? 'N/A'
                                          : '${order.address?.user?.firstName ?? ''} '
                                                  '${order.address?.user?.lastName ?? ''}'
                                              .trim(),
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 8),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          width: 100,
                                          child: Text(
                                            'Contact:',
                                            style: TextStyle(
                                              color: TColor.secondaryText,
                                              fontSize: 12,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: GestureDetector(
                                            onTap: () {
                                              final mobno =
                                                  order.address?.user?.mobno;
                                              if (mobno != null &&
                                                  mobno.isNotEmpty) {
                                                launchDialer(mobno);
                                              }
                                            },
                                            child: Row(
                                              children: [
                                                const Icon(Icons.phone,
                                                    color: Colors.green,
                                                    size: 16),
                                                const SizedBox(width: 8),
                                                Text(
                                                  order.address?.user?.mobno ??
                                                      'N/A',
                                                  style: TextStyle(
                                                    color: TColor.primaryText,
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w600,
                                                    decoration: TextDecoration
                                                        .underline,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  _buildInfoRow(
                                    'Address:',
                                    '${capitalizeWords(order.address?.street ?? '')}, '
                                        '${capitalizeWords(order.address?.city ?? '')}, '
                                        '${order.address?.pincode}',
                                  ),
                                ],
                              ),
                            ),

                            if (order.business != null) ...[
                              _buildThemedCard(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _buildSectionTitle('Business Details'),
                                    const Divider(color: Colors.black12),
                                    if (order.business!.banner != null)
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: Image.network(
                                          order.business!.banner!,
                                          height: 150,
                                          width: double.infinity,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    const SizedBox(height: 12),
                                    Text(
                                      capitalizeWords(
                                          order.business!.name ?? 'No Name'),
                                      style: TextStyle(
                                          color: TColor.primaryText,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    const SizedBox(height: 8),
                                    Padding(
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 8),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          width: 100,
                                          child: Text(
                                            'Contact:',
                                            style: TextStyle(
                                              color: TColor.secondaryText,
                                              fontSize: 12,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: GestureDetector(
                                            onTap: () {
                                              final mobno =
                                                  order.address?.user?.mobno;
                                              if (mobno != null &&
                                                  mobno.isNotEmpty) {
                                                launchDialer(mobno);
                                              }
                                            },
                                            child: Row(
                                              children: [
                                                const Icon(Icons.phone,
                                                    color: Colors.green,
                                                    size: 16),
                                                const SizedBox(width: 8),
                                                Text(
                                                  order.business!.contactNo ??
                                                      'N/A',
                                                  style: TextStyle(
                                                    color: TColor.primaryText,
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w600,
                                                    decoration: TextDecoration
                                                        .underline,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                    _buildInfoRow(
                                      'Address:',
                                      '${capitalizeWords(order.business!.address?.street ?? '')}, '
                                          '${capitalizeWords(order.business!.address?.city ?? '')}, '
                                          '${order.business!.address?.pincode}',
                                    ),
                                  ],
                                ),
                              ),
                            ],

                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                InkWell(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              NavigatePickupView(
                                            pickupLat:
                                                order.business?.latitude ?? 0.0,
                                            pickupLng:
                                                order.business?.longitude ??
                                                    0.0,
                                            dropLat: order.address?.lat ?? 0.0,
                                            dropLng: order.address?.long ?? 0.0,
                                            amount: order.amount ?? 0.00,
                                            orderId: order.id ?? "",
                                          ),
                                        ));
                                  },
                                  child:
                                      const Chip(label: Text("Navigate Maps")),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  }
                  return const Center(child: Text('Unexpected state.'));
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildThemedCard({required Widget child}) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: child,
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        color: TColor.primaryText,
        fontSize: 16,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: TextStyle(
                color: TColor.secondaryText,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                color: TColor.primaryText,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
