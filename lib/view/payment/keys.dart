import 'package:flutter_dotenv/flutter_dotenv.dart';

String publishableKey = dotenv.env['PAYMENT_PUBLISHABLE_KEY']!;

String secretKey = dotenv.env['PAYMENT_SECRET_KEY']!;
