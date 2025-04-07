import 'package:flutter/material.dart';
import '../common/color_extension.dart';

enum RoundButtonType { bgPrimary, textPrimary }

class RoundButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String title;
  final RoundButtonType type;
  final double fontSize;
  final bool isLoading;
  
  const RoundButton({
    super.key,
    required this.title,
    required this.onPressed,
    this.isLoading = false,
    this.fontSize = 16,
    this.type = RoundButtonType.bgPrimary,
  });

  @override
  Widget build(BuildContext context) {
    final loaderColor = type == RoundButtonType.bgPrimary 
        ? TColor.white 
        : TColor.primary;

    return InkWell(
      onTap: isLoading ? null : onPressed,
      child: Container(
        height: 56,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          border: type == RoundButtonType.bgPrimary 
              ? null 
              : Border.all(color: TColor.primary, width: 1),
          color: type == RoundButtonType.bgPrimary 
              ? TColor.primary 
              : TColor.white,
          borderRadius: BorderRadius.circular(28),
        ),
        child: isLoading
            ? SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(loaderColor),
                ),
              )
            : Text(
                title,
                style: TextStyle(
                  color: type == RoundButtonType.bgPrimary 
                      ? TColor.white 
                      : TColor.primary,
                  fontSize: fontSize,
                  fontWeight: FontWeight.w600,
                ),
              ),
      ),
    );
  }
}