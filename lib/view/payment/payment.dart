import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:foodbridge_volunteers_flutter/common/color_extension.dart';
import 'package:foodbridge_volunteers_flutter/logic/payment/bloc/payment_bloc.dart';
import 'package:foodbridge_volunteers_flutter/view/more/thankyou_message_view.dart';

class Payment extends StatefulWidget {
  final double amount;
  final String orderId;

  const Payment({
    super.key,
    required this.amount,
    required this.orderId,
  });

  @override
  State<Payment> createState() => _PaymentState();
}

class _PaymentState extends State<Payment> {
  late double amount;
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    amount = widget.amount;
  }

  Future<void> _handleStripePayment(String clientSecret) async {
    setState(() => _isProcessing = true);
    try {
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: clientSecret,
          merchantDisplayName: 'FoodBridge',
          appearance: PaymentSheetAppearance(
            colors: PaymentSheetAppearanceColors(
              primary: TColor.primary,
              componentBorder: TColor.secondaryText,
            ),
          ),
        ),
      );

      await Stripe.instance.presentPaymentSheet();
      
      final payment = await Stripe.instance.retrievePaymentIntent(clientSecret);
      if (payment.status == PaymentIntentsStatus.Succeeded) {
        context.read<PaymentBloc>().add(PaymentCompleted(widget.orderId));
      } else {
        throw Exception('Payment not completed');
      }
    } on StripeException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.error.localizedMessage ?? 'Payment failed'),
          backgroundColor: TColor.primary,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Payment failed: ${e.toString()}'),
          backgroundColor: TColor.primary,
        ),
      );
    } finally {
      if (mounted) setState(() => _isProcessing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<PaymentBloc, PaymentState>(
        listener: (context, state) {
          if (state is PaymentIntentCreated) {
            WidgetsBinding.instance.addPostFrameCallback(
              (_) => _handleStripePayment(state.clientSecret),
            );
          } else if (state is PaymentSuccess) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => const CheckoutMessageView(),
              ),
            );
          } else if (state is PaymentFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage),
                backgroundColor: TColor.primary,
              ),
            );
          }
        },
        child: BlocBuilder<PaymentBloc, PaymentState>(
          builder: (context, state) {
            return SingleChildScrollView(
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
                            onPressed: _isProcessing ? null : () => Navigator.pop(context),
                            icon: Image.asset("assets/img/btn_back.png", 
                                width: 20, height: 20),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              "Secure Card Payment",
                              style: TextStyle(
                                  color: TColor.primaryText,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w800),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Center(
                      child: Column(
                        children: [
                          const SizedBox(height: 30),
                          Icon(Icons.credit_card, size: 100, color: TColor.primary),
                          const SizedBox(height: 20),
                          Text(
                            'Total Amount: ₹${amount.toStringAsFixed(2)}',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: TColor.primaryText,
                            ),
                          ),
                          const SizedBox(height: 40),
                          ElevatedButton(
                            onPressed: _isProcessing || state is PaymentLoading
                                ? null
                                : () => context.read<PaymentBloc>().add(
                                      PaymentRequested(widget.orderId),
                                    ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: TColor.primary,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 40, vertical: 15),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: _isProcessing || state is PaymentLoading
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2,
                                    ),
                                  )
                                : const Text(
                                    "Pay with Card",
                                    style: TextStyle(
                                        fontSize: 18, 
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600),
                                  ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}