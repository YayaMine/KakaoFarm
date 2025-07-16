import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class FarmInfoBox extends StatelessWidget {
  final String label;
  final String iconPath;
  final String value;

  const FarmInfoBox({
    super.key,
    required this.label,
    required this.iconPath,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFFF4F4F4),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFF14A741), width: 1),
        ),
        child: Row(
          children: [
            SvgPicture.asset(iconPath, width: 30, height: 30),
            const SizedBox(width: 10),
            Text(
              label,
              style: const TextStyle(
                color: Color(0xFF113A1D),
                fontWeight: FontWeight.w500,
                fontSize: 16,
              ),
            ),
            const Spacer(),
            Text(
              value,
              style: const TextStyle(
                color: Color(0xFF113A1D),
                fontWeight: FontWeight.w500,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
