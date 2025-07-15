import 'package:appspertanian/dump/env2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

import '../widgets/control_widget.dart';
import '../screens/environment_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF2F2F2),
      body: Stack(
        children: [
          Positioned.fill(
            bottom: 70,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    height: 280,
                    width: double.infinity,
                    decoration: BoxDecoration(
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
                          child: Center(
                            child: Text(
                              'LOGO KAKAO',
                              style: GoogleFonts.nunito(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          top: 100,
                          bottom: 20,
                          left: 40,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Kakao Farm',
                                style: GoogleFonts.nunito(
                                  color: Colors.white,
                                  fontSize: 36,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                'online',
                                style: GoogleFonts.nunito(
                                  color: Colors.white,
                                  fontSize: 15,
                                  height: 0.15,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              SizedBox(height: 10),
                              SizedBox(
                                width: 300,
                                child: Text(
                                  'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has',
                                  style: GoogleFonts.nunito(
                                    color: Colors.white,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Positioned(
                          top: 32,
                          right: 20,
                          child: SvgPicture.asset(
                            'assets/images/test.svg',
                            width: 28,
                            height: 28,
                          ),
                        ),
                      ],
                    ),
                  ),

                  Transform.translate(
                    offset: Offset(0, -75),
                    child: Column(
                      children: <Widget>[
                        Wrap(
                          spacing: 10,
                          runSpacing: 20,
                          alignment: WrapAlignment.center,
                          children: [
                            _buildResponsiveCard(
                              'assets/images/front-page-svgrepo-com.svg',
                              'Control Sistem',
                              context,
                            ),
                            _buildResponsiveCard(
                              'assets/images/soil-temperature-svgrepo-com.svg',
                              'Env status',
                              context,
                            ),
                            _buildResponsiveCard(
                              'assets/images/event-calender-date-note-svgrepo-com.svg',
                              'History',
                              context,
                            ),
                            _buildResponsiveCard(
                              'assets/images/event-calender-date-note-svgrepo-com.svg',
                              'History 1',
                              context,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 90),
                ],
              ),
            ),
          ),

          Positioned(
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
                    backgroundColor: Color(0xFF14A741),
                    selectedItemColor: Colors.white,
                    unselectedItemColor: Colors.white,
                    showUnselectedLabels: true,
                    type: BottomNavigationBarType.fixed,
                    currentIndex: _currentIndex,
                    onTap: (index) {
                      setState(() {
                        _currentIndex = index;
                      });
                      if (_currentIndex == 0) {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => HomeScreen()),
                        );
                      } else if (_currentIndex == 1) {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EnvironmentScreen(),
                          ),
                        );
                      } else if (_currentIndex == 3) {}
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => Env2()),
                      );
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
          ),
        ],
      ),
    );
  }

  Widget _buildResponsiveCard(
    String assetPath,
    String title,
    BuildContext context,
  ) {
    double width = MediaQuery.of(context).size.width;

    return SizedBox(
      width: width * 0.4,
      height: width * 0.4,
      child: Card(
        elevation: 12,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: GestureDetector(
          onTap: () {
            if (title == 'Control Sistem') {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ControlWidget()),
              );
            } else if (title == 'Env status') {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => EnvironmentScreen()),
              );
            } else if (title == 'History') {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Env2()),
              );
            }
          },
          child: Stack(
            children: [
              Center(child: SvgPicture.asset(assetPath, height: 60, width: 60)),
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
                      color: Color(0xFF14A741),
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
