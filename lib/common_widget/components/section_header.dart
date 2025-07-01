import 'package:flutter/material.dart';
import 'package:foodbridge_volunteers_flutter/common/color_extension.dart';

class SectionHeader extends StatelessWidget {
  final String title;
  const SectionHeader({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Row(
        children: [
          const SizedBox(
            width: 8,
          ),
          Expanded(
              child: Text(
            title,
            style: TextStyle(
                color: TColor.primaryText,
                fontSize: 20,
                fontWeight: FontWeight.w800),
          ))
        ],
      ),
    );
  }
}
