import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

class HeaderSection extends StatelessWidget {
  final String title;
  final String subtitle;
  final String description;
  final bool showBackButton;
  final VoidCallback? onBack;

  const HeaderSection({
    super.key,
    required this.title,
    required this.subtitle,
    this.description = '',
    this.showBackButton = false,
    this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 280,
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Color(0xFF14A741),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(180),
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            top: 35,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (showBackButton)
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: onBack ?? () => Navigator.of(context).pop(),
                  )
                else
                  const SizedBox(width: 48),
                Text(
                  'LOGO KAKAO',
                  style: GoogleFonts.nunito(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 20),
                  child: SvgPicture.asset(
                    'assets/images/test.svg',
                    width: 28,
                    height: 28,
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: 100,
            left: 40,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.nunito(
                    color: Colors.white,
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  subtitle,
                  style: GoogleFonts.nunito(
                    color: Colors.white,
                    fontSize: 15,
                    height: 0.15,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: 300,
                  child: Text(
                    description,
                    style: GoogleFonts.nunito(
                      color: Colors.white,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
