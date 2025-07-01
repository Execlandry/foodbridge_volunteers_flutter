import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodbridge_volunteers_flutter/common_widget/components/gradient_bg.dart';
import 'package:foodbridge_volunteers_flutter/common_widget/components/section_header.dart';
import 'package:foodbridge_volunteers_flutter/core/model/delivery_history_model.dart';
import 'package:foodbridge_volunteers_flutter/core/utils/helper_func.dart';
import 'package:foodbridge_volunteers_flutter/logic/delivery/bloc/delivery_bloc.dart';
import 'package:foodbridge_volunteers_flutter/view/webview/webview.dart';

class DeliveryHistory extends StatefulWidget {
  const DeliveryHistory({super.key});

  @override
  State<DeliveryHistory> createState() => _DeliveryHistoryState();
}

class _DeliveryHistoryState extends State<DeliveryHistory> {
  bool _initialLoad = true;
  bool _showStripeOnboarding = true;

  @override
  void initState() {
    super.initState();
    context.read<DeliveryBloc>().add(LoadDeliveryHistory());
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: GradientBackground(
          child: Column(
            children: [
              const SizedBox(height: 20),
              const SectionHeader(title: "Delivery History"),
              const SizedBox(height: 10),
              if (_showStripeOnboarding) _buildOnboardingBanner(),
              Expanded(
                child: BlocConsumer<DeliveryBloc, DeliveryState>(
                  listener: (context, state) {
                    if (state is DeliveryError) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(state.message)),
                      );
                    }
                  },
                  builder: (context, state) {
                    if (state is DeliveryLoading && _initialLoad) {
                      return const Center(child: CircularProgressIndicator());
                    }
                
                    if (state is DeliveryHistoryLoaded) {
                      _initialLoad = false;
                      return _buildOrderList(context, state.history);
                    }
                
                    if (state is DeliveryError) {
                      return Center(
                        child: Text(
                          state.message,
                          style: const TextStyle(color: Colors.red),
                        ),
                      );
                    }
                
                    return const Center(child: Text('No delivery history found'));
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOnboardingBanner() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue.shade100),
      ),
      child: Row(
        children: [
          Icon(Icons.account_balance_wallet, color: Colors.blue.shade600),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Complete Stripe Onboarding',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.blue.shade800,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Required to receive payments',
                  style: TextStyle(
                    color: Colors.blue.shade600,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(Icons.arrow_forward, color: Colors.blue.shade600),
            onPressed: () => _navigateToStripe(context),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderList(BuildContext context, List<OrderHistory> orders) {
    if (orders.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.history, size: 60, color: Colors.grey.shade400),
            const SizedBox(height: 20),
            Text(
              'No completed deliveries yet',
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 16,
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () async => context.read<DeliveryBloc>().add(LoadDeliveryHistory()),
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
        itemCount: orders.length,
        separatorBuilder: (context, index) => const SizedBox(height: 10),
        itemBuilder: (context, index) => _buildOrderItem(orders[index], index),
      ),
    );
  }

  Widget _buildOrderItem(OrderHistory order, int index) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 15),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildInfoTile(
                  icon: Icons.receipt,
                  title: 'Order ID',
                  value: order.orderDetails.id.substring(0, 8),
                ),
                _buildStatusChip(order.orderStatus),
              ],
            ),
            const SizedBox(height: 12),
            _buildInfoTile(
              icon: Icons.currency_rupee,
              title: 'Amount',
              value: '₹${order.orderDetails.amount}',
            ),
            _buildInfoTile(
              icon: Icons.account_balance_wallet,
              title: 'Net Amount',
              value: '₹${order.paymentDetails.netAmount}',
            ),
            _buildInfoTile(
              icon: Icons.payment,
              title: 'Payment Method',
              value: capitalizeWords(order.paymentDetails.paymentMethod),
            ),
            const SizedBox(height: 8),
            const Divider(height: 1),
            const SizedBox(height: 8),
            _buildDetailRow(
              'Delivered to',
              capitalizeWords(order.orderDetails.address.name),
              Icons.location_on,
            ),
            _buildDetailRow(
              'Business',
              capitalizeWords(order.orderDetails.business.name),
              Icons.business,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoTile({required IconData icon, required String title, required String value}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.grey.shade600),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                ),
              ),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icon, size: 18, color: Colors.grey.shade500),
          const SizedBox(width: 12),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey.shade800,
                ),
                children: [
                  TextSpan(
                    text: '$label: ',
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                  TextSpan(text: value),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusChip(String status) {
    final color = Colors.green;
    return Chip(
      label: Text(
        capitalizeWords(status),
        style: TextStyle(
          color: color.shade900,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
      backgroundColor: color.withOpacity(0.2),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(color: color.withOpacity(0.3)),
      ),
    );
  }

  void _navigateToStripe(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const WebViewScreen()),
    ).then((_) {
      setState(() => _showStripeOnboarding = false);
    });
  }
}