import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodbridge_volunteers_flutter/common/color_extension.dart';
import 'package:foodbridge_volunteers_flutter/logic/auth/bloc/auth_bloc.dart';
import 'package:foodbridge_volunteers_flutter/logic/auth/bloc/auth_event.dart';
import 'package:foodbridge_volunteers_flutter/logic/auth/bloc/auth_state.dart';
import 'package:foodbridge_volunteers_flutter/view/login/welcome_view.dart';
import 'package:foodbridge_volunteers_flutter/common_widget/components/navbar_view.dart';

class StartupView extends StatefulWidget {
  const StartupView({super.key});

  @override
  State<StartupView> createState() => _StartupViewState();
}

class _StartupViewState extends State<StartupView>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );

    // Trigger auth check
    context.read<AuthBloc>().add(AppStartCheck());
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthAuthenticated || state is AuthUnauthenticated) {
          _handleNavigation(state);
        }
      },
      builder: (context, state) {
        return _buildSplashUI(context);
      },
    );
  }

  Widget _buildSplashUI(BuildContext context) {
    var media = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          FadeTransition(
            opacity: ReverseAnimation(_fadeAnimation),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Image.asset(
                  "assets/img/splash_bg.png",
                  width: media.width,
                  height: media.height,
                  fit: BoxFit.cover,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      "assets/img/1.png",
                      width: media.width * 0.55,
                      height: media.width * 0.55,
                      fit: BoxFit.contain,
                    ),
                    const SizedBox(height: 20),
                    Text(
                      "FoodBridge",
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: TColor.primary,
                        fontFamily: 'Lobster',
                        shadows: [
                          Shadow(
                            offset: Offset(2, 2),
                            blurRadius: 4,
                            color: Colors.black45,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          FadeTransition(
            opacity: _fadeAnimation,
            child: Container(color: Colors.white),
          ),
        ],
      ),
    );
  }

  Future<void> _handleNavigation(AuthState state) async {
    await Future.delayed(const Duration(seconds: 3));
    _animationController.forward();

    await Future.delayed(const Duration(milliseconds: 800));

    if (state is AuthAuthenticated) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const NavbarView()),
      );
    } else {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const WelcomeView()),
      );
    }
  }
}
