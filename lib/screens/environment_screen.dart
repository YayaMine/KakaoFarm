import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../models/soil_data.dart';
import '../providers/soil_provider.dart';
import '../screens/home_screen.dart';

class EnvironmentScreen extends StatefulWidget {
  @override
  _EnvironmentScreenState createState() => _EnvironmentScreenState();
}

class _EnvironmentScreenState extends State<EnvironmentScreen> {
  int selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    // Trigger fetch saat pertama kali masuk halaman
    Provider.of<SoilProvider>(context, listen: false).loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SoilProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }

        final nodeIds = provider.registeredNodeIds;
        final currentNodeId = nodeIds.isNotEmpty && selectedIndex < nodeIds.length
            ? nodeIds[selectedIndex]
            : null;
        final currentData = provider.getSoilDataById(currentNodeId);

        return Scaffold(
          backgroundColor: Colors.white,
          body: Stack(
            children: [
              Positioned.fill(
                bottom: 70,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        height: 350,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: const Color(0xFF14A741),
                          borderRadius: const BorderRadius.only(
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
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                                    onPressed: () {
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(builder: (context) => HomeScreen()),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                            Positioned(
                              top: 45,
                              right: 20,
                              child: SvgPicture.asset('assets/images/test.svg', width: 28, height: 28),
                            ),
                            Positioned(
                              top: 45,
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
                              left: 40,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Environment',
                                    style: GoogleFonts.nunito(
                                      color: Colors.white,
                                      fontSize: 36,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const Text(
                                    'online',
                                    style: TextStyle(color: Colors.white, fontSize: 15, height: 0.15),
                                  ),
                                ],
                              ),
                            ),
                            Positioned(
                              top: 170,
                              left: 20,
                              right: 0,
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children: List.generate(nodeIds.length, (index) {
                                    return Padding(
                                      padding: const EdgeInsets.only(right: 12),
                                      child: _buildCustomCard(
                                        'Farm ${index + 1}',
                                        'assets/images/earth-svgrepo-com.svg',
                                        selectedIndex == index ? const Color(0xFF113A1D) : Colors.white,
                                        selectedIndex == index ? Colors.white : const Color(0xFF113A1D),
                                        110,
                                        110,
                                        index,
                                      ),
                                    );
                                  }),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Card(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                          elevation: 5,
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            width: double.infinity,
                            decoration: BoxDecoration(
                              border: Border.all(color: const Color(0xFF14A741), width: 2),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: currentData != null
                                ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Farm ${selectedIndex + 1} (${currentData.id})',
                                  style: const TextStyle(
                                    color: Color(0xFF113A1D),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                ..._buildFarmDetails(currentData),
                              ],
                            )
                                : const Center(child: Text("No Data")),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  List<Widget> _buildFarmDetails(SoilData data) {
    return [
      _buildFarmInfoBox('Condition', 'assets/images/air.svg', data.conductivity.toStringAsFixed(1)),
      _buildFarmInfoBox('Humidity', 'assets/images/air.svg', data.moisture.toStringAsFixed(1)),
      _buildFarmInfoBox('K', 'assets/images/air.svg', data.potassium.toStringAsFixed(1)),
      _buildFarmInfoBox('N', 'assets/images/air.svg', data.nitrogen.toStringAsFixed(1)),
      _buildFarmInfoBox('P', 'assets/images/air.svg', data.phosphorus.toStringAsFixed(1)),
      _buildFarmInfoBox('pH', 'assets/images/air.svg', data.pH.toStringAsFixed(2)),
      _buildFarmInfoBox('Temperature', 'assets/images/air.svg', data.temperature.toStringAsFixed(1)),
    ];
  }

  Widget _buildFarmInfoBox(String label, String iconPath, String value) {
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

  Widget _buildCustomCard(
      String title,
      String svgPath,
      Color bgColor,
      Color textColor,
      double width,
      double height,
      int index,
      ) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedIndex = index;
        });
      },
      child: Container(
        width: width,
        height: height,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: bgColor,
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
            SvgPicture.asset(svgPath, color: textColor, width: 50, height: 40),
            const SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                color: textColor,
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
