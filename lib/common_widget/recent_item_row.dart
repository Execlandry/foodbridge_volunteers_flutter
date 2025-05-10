import 'package:flutter/material.dart';
import '../common/color_extension.dart';

class RecentItemRow extends StatelessWidget {
  final String price;
  final String originCity;
  final String destinationCity;
  final VoidCallback onTap;

  const RecentItemRow({
    super.key,
    required this.price,
    required this.originCity,
    required this.destinationCity,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(15),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                TColor.primary.withOpacity(0.05),
                TColor.primary.withOpacity(0.15),
              ],
            ),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: TColor.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.delivery_dining,
                      color: TColor.primary,
                      size: 28,
                    ),
                  ),
                  const SizedBox(height: 8),
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: '₹',
                          style: TextStyle(
                            color: TColor.primary,
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        TextSpan(
                          text: price,
                          style: TextStyle(
                            color: TColor.primaryText,
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 16),

              // Text Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 4),
                    _buildLocationRow(Icons.place_outlined, originCity, true),
                    const SizedBox(height: 12),
                    _buildLocationRow(Icons.flag_outlined, destinationCity, false),
                  ],
                ),
              ),

              // Chevron Icon
              Icon(
                Icons.chevron_right_rounded,
                color: TColor.secondaryText,
                size: 28,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLocationRow(IconData icon, String city, bool isOrigin) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: isOrigin
                ? TColor.primary.withOpacity(0.1)
                : Colors.green.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: isOrigin ? TColor.primary : Colors.green,
            size: 18,
          ),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              isOrigin ? "FROM" : "TO",
              style: TextStyle(
                color: TColor.secondaryText,
                fontSize: 10,
                fontWeight: FontWeight.w500,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              city,
              style: TextStyle(
                color: TColor.primaryText,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ],
    );
  }
}