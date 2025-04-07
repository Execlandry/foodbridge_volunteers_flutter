import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:foodbridge_volunteers_flutter/core/api/dio_client.dart';
import 'package:foodbridge_volunteers_flutter/core/repository/delivery_repository.dart';
import 'package:foodbridge_volunteers_flutter/core/repository/user_service.dart';
import 'package:foodbridge_volunteers_flutter/logic/delivery_auth/bloc/auth_bloc.dart';
import 'package:foodbridge_volunteers_flutter/logic/delivery_auth/bloc/auth_event.dart';
import 'package:foodbridge_volunteers_flutter/view/login/login_view.dart';
import 'package:foodbridge_volunteers_flutter/view/main_tabview/main_tabview.dart';
import 'package:foodbridge_volunteers_flutter/view/on_boarding/startup_view.dart';
import 'package:foodbridge_volunteers_flutter/view/payment/keys.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await dotenv.load(fileName: ".env");
  } catch (e) {
    debugPrint("Failed to load .env file: $e");
  }
  try {
    DioClient();
  } catch (e) {
    debugPrint("Failed to load AppUrl file: $e");
  }

  Stripe.publishableKey = publishableKey;
  await Stripe.instance.applySettings();

  await checkHealth();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (context) => AuthBloc(DeliveryRepository()),
        )
      ],
      child: MaterialApp(
        title: 'FoodBridge Volunteers',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          fontFamily: "Metropolis",
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const StartupView(),
      ),
    );
  }
}