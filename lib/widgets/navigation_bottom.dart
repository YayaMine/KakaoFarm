import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../screens/environment_screen.dart';
import '../screens/home_screen.dart';

class NavigationBottom extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const NavigationBottom({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 20,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                spreadRadius: 1,
                blurRadius: 10,
                offset: Offset(0, 6),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(30),
            child: BottomNavigationBar(
              backgroundColor: const Color(0xFF14A741),
              selectedItemColor: Colors.white,
              unselectedItemColor: Colors.white,
              showUnselectedLabels: true,
              type: BottomNavigationBarType.fixed,
              currentIndex: currentIndex,
              onTap: (index) {
                onTap(index);
                switch (index) {
                  case 0:
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => const HomeScreen()),
                    );
                    break;
                  case 1:
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => EnvironmentScreen()),
                    );
                    break;
                  case 2:
                  // Future navigation logic for History screen
                    break;
                }
              },
              items: [
                BottomNavigationBarItem(
                  icon: SvgPicture.asset(
                    'assets/images/front-page-svgrepo-com.svg',
                    color: Colors.white,
                    height: 24.0,
                  ),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: SvgPicture.asset(
                    'assets/images/soil-temperature-svgrepo-com.svg',
                    color: Colors.white,
                    height: 24.0,
                  ),
                  label: 'Env',
                ),
                BottomNavigationBarItem(
                  icon: SvgPicture.asset(
                    'assets/images/event-calender-date-note-svgrepo-com.svg',
                    color: Colors.white,
                    height: 24.0,
                  ),
                  label: 'History',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
