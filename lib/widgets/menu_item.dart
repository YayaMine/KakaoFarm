import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

class MenuItem extends StatelessWidget {
  final String assetPath;
  final String title;
  final VoidCallback onTap;

  const MenuItem({
    super.key,
    required this.assetPath,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return SizedBox(
      width: width * 0.4,
      height: width * 0.4,
      child: Card(
        elevation: 12,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: GestureDetector(
          onTap: onTap,
          child: Stack(
            children: [
              Center(
                child: SvgPicture.asset(
                  assetPath,
                  height: 60,
                  width: 60,
                ),
              ),
              Positioned(
                bottom: 10,
                left: 0,
                right: 0,
                child: Center(
                  child: Text(
                    title,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.nunito(
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF14A741),
                      fontSize: 15,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
