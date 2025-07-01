// import 'package:flutter/material.dart';
// import 'package:flutter_stripe/flutter_stripe.dart';
// import 'package:foodbridge_volunteers_flutter/view/more/thankyou_message_view.dart';
// import 'package:qr_flutter/qr_flutter.dart';

// class PaymentQRCodeScreen extends StatefulWidget {
//   final String qrData;
//   final String clientSecret;

//   const PaymentQRCodeScreen({
//     super.key,
//     required this.qrData,
//     required this.clientSecret,
//   });

//   @override
//   State<PaymentQRCodeScreen> createState() => _PaymentQRCodeScreenState();
// }

// class _PaymentQRCodeScreenState extends State<PaymentQRCodeScreen> {
//   bool _paymentSuccess = false;

//   @override
//   void initState() {
//     super.initState();
//     _monitorPaymentStatus();
//   }

//   Future<void> _monitorPaymentStatus() async {
//     final paymentIntent = await Stripe.instance.retrievePaymentIntent(widget.clientSecret);
    
//     if (paymentIntent.status == PaymentIntentsStatus.Succeeded) {
//       setState(() => _paymentSuccess = true);
//       await Future.delayed(Duration(seconds: 2));
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(
//           builder: (context) => const CheckoutMessageView(),
//         ),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Scan to Pay')),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             QrImageView(
//               data: widget.qrData,
//               version: QrVersions.auto,
//               size: 250,
//             ),
//             SizedBox(height: 30),
//             _paymentSuccess
//                 ? Icon(Icons.check_circle, color: Colors.green, size: 50)
//                 : CircularProgressIndicator(),
//           ],
//         ),
//       ),
//     );
//   }
// }