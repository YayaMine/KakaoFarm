import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class FarmSelectorCard extends StatelessWidget {
  final String title;
  final String iconPath;
  final bool isSelected;
  final double width;
  final double height;
  final VoidCallback onTap;

  const FarmSelectorCard({
    super.key,
    required this.title,
    this.iconPath = 'assets/images/earth-svgrepo-com.svg',
    required this.isSelected,
    this.width = 110,
    this.height = 110,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        height: height,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected ? Color(0xFF113A1D) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              iconPath,
              color: isSelected ? Colors.white : Color(0xFF113A1D),
              width: 50,
              height: 40,
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                color: isSelected ? Colors.white : Color(0xFF113A1D),
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }
}