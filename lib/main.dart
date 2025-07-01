import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:foodbridge_volunteers_flutter/core/api/dio_client.dart';
import 'package:foodbridge_volunteers_flutter/core/repository/auth_repository.dart';
import 'package:foodbridge_volunteers_flutter/core/repository/delivery_repository.dart';
import 'package:foodbridge_volunteers_flutter/core/repository/user_repository.dart';
import 'package:foodbridge_volunteers_flutter/logic/auth/bloc/auth_bloc.dart';
import 'package:foodbridge_volunteers_flutter/logic/delivery/bloc/delivery_bloc.dart';
import 'package:foodbridge_volunteers_flutter/logic/deliveryview/bloc/navigate_delivery_bloc.dart';
import 'package:foodbridge_volunteers_flutter/logic/payment/bloc/payment_bloc.dart';
import 'package:foodbridge_volunteers_flutter/logic/pickupview/bloc/pickup_navigation_bloc.dart';
import 'package:foodbridge_volunteers_flutter/view/on_boarding/startup_view.dart';

import 'logic/user_profile/bloc/user_profile_bloc.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await dotenv.load(fileName: ".env");
  } catch (e) {
    debugPrint("Failed to load .env file: $e");
  }
  try {
    final dioClient = DioClient();
    await dioClient.getDio(); // Force initialization
  } catch (e) {
    debugPrint("DioClient initialization failed: $e");
  }

  Stripe.publishableKey = dotenv.env['PAYMENT_PUBLISHABLE_KEY']!;
  await Stripe.instance.applySettings();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (context) => AuthBloc(AuthRepository()),
        ),
        BlocProvider<DeliveryBloc>(
          create: (context) => DeliveryBloc(DeliveryRepository()),
        ),
        BlocProvider<UserProfileBloc>(
            create: (context) =>
                UserProfileBloc(userRepository: UserRepository())),
        BlocProvider(
          create: (context) => NavigatePickupBloc(DioClient().dio),
        ),
        BlocProvider(
          create: (context) => NavigateDeliveryBloc(DioClient().dio),
        ),
        BlocProvider(
          create: (context) => PaymentBloc(dioClient: DioClient()),
        ),
      ],
      child: MaterialApp(
        title: 'FoodBridge Volunteers',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          fontFamily: "Metropolis",
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: StartupView(),
        // home: TestDesign()
      ),
    );
  }
}
