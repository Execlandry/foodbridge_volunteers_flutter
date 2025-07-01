import 'package:flutter/material.dart';
import 'package:foodbridge_volunteers_flutter/common/color_extension.dart';

class GradientBackground extends StatelessWidget {
  final Widget child;
  
  const GradientBackground({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            TColor.primary.withOpacity(0.05),
            TColor.primary.withOpacity(0.01),
          ],
        ),
      ),
      child: child,
    );
  }
}