import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/soil_provider.dart';
import '../screens/environment_screen.dart';
import '../widgets/header_section.dart';
import '../widgets/menu_item.dart';
import '../widgets/navigation_bottom.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  void _handleToggleValve(BuildContext context, bool newValue) {
    final provider = Provider.of<SoilProvider>(context, listen: false);
    provider.toggleValve(newValue);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F2),
      body: Stack(
        children: [
          Positioned.fill(
            bottom: 70,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const HeaderSection(
                    title: 'Kakao Farm',
                    subtitle: 'online',
                    description:
                        'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has',
                  ),
                  Transform.translate(
                    offset: const Offset(0, -75),
                    child: Wrap(
                      spacing: 10,
                      runSpacing: 20,
                      alignment: WrapAlignment.center,
                      children: [
                        MenuItem(
                          assetPath: 'assets/images/front-page-svgrepo-com.svg',
                          title: 'Control Sistem',
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const HomeScreen(),
                              ),
                            );
                          },
                        ),
                        MenuItem(
                          assetPath:
                              'assets/images/soil-temperature-svgrepo-com.svg',
                          title: 'Env status',
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => EnvironmentScreen(),
                              ),
                            );
                          },
                        ),
                        MenuItem(
                          assetPath:
                              'assets/images/event-calender-date-note-svgrepo-com.svg',
                          title: 'History',
                          onTap: () {},
                        ),
                        MenuItem(
                          assetPath: '',
                          title: 'Valve Staus',
                          onTap: () {},
                          customCenterWidget: Consumer<SoilProvider>(
                            builder: (context, provider, child) {
                              return Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Switch(
                                    value: provider.activeValve,
                                    activeColor: const Color(0xFF14A741),
                                    activeTrackColor: const Color(0xFFB2E0C2),
                                    onChanged: (value) {
                                      final soilProvider =
                                          Provider.of<SoilProvider>(
                                            context,
                                            listen: false,
                                          );
                                      soilProvider.toggleValve(value);
                                    },
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 50),
                ],
              ),
            ),
          ),
          NavigationBottom(
            currentIndex: _currentIndex,
            onTap: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
          ),
        ],
      ),
    );
  }
}
