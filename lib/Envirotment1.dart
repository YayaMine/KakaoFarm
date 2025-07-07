import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

import 'Home.dart';

class Envirotment1 extends StatefulWidget {
  @override
  _Envirotment1State createState() => _Envirotment1State();
}

class _Envirotment1State extends State<Envirotment1> {
  int selectedIndex = 0;

  String cond = "-";
  String hum = "-";
  String k = "-";
  String n = "-";
  String p = "-";
  String ph = "-";
  String temp = "-";

  late DatabaseReference farm1Ref;
  StreamSubscription<DatabaseEvent>? _farm1Subscription;

  @override
  void initState() {
    super.initState();

    farm1Ref = FirebaseDatabase.instance.ref('fajar');

    _farm1Subscription = farm1Ref.onValue.listen((DatabaseEvent event) {
      final dataSnapshot = event.snapshot;
      if (dataSnapshot.exists) {
        final data = Map<String, dynamic>.from(dataSnapshot.value as Map);
        print('Data Updated: $data');

        setState(() {
          cond = data['cond']?.toString() ?? "-";
          hum = data['hum']?.toString() ?? "-";
          k = data['k']?.toString() ?? "-";
          n = data['n']?.toString() ?? "-";
          p = data['p']?.toString() ?? "-";
          ph = data['ph']?.toString() ?? "-";
          temp = data['temp']?.toString() ?? "-";
        });
      } else {
        _resetData();
      }
    });
  }

  void _resetData() {
    setState(() {
      cond = "-";
      hum = "-";
      k = "-";
      n = "-";
      p = "-";
      ph = "-";
      temp = "-";
    });
  }

  @override
  void dispose() {
    _farm1Subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              IconButton(
                                icon: Icon(
                                  Icons.arrow_back,
                                  color: Colors.white,
                                ),
                                onPressed: () {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => Home(),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                        Positioned(
                          top: 45,
                          right: 20,
                          child: SvgPicture.asset(
                            'assets/images/test.svg',
                            width: 28,
                            height: 28,
                          ),
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
                              Text(
                                'online',
                                style: GoogleFonts.nunito(
                                  color: Colors.white,
                                  fontSize: 15,
                                  height: 0.15,
                                  fontWeight: FontWeight.w400,
                                ),
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
                              children: List.generate(5, (index) {
                                return Padding(
                                  padding: EdgeInsets.only(right: 12),
                                  child: _buildCustomCard(
                                    'Farm ${index + 1}',
                                    'assets/images/earth-svgrepo-com.svg',
                                    selectedIndex == index
                                        ? Color(0xFF113A1D)
                                        : Colors.white,
                                    selectedIndex == index
                                        ? Colors.white
                                        : Color(0xFF113A1D),
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
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      elevation: 5,
                      child: Container(
                        padding: EdgeInsets.all(12),
                        width: double.infinity,
                        height: 600,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Color(0xFF14A741),
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 16.0),
                                child: Text(
                                  'Farm ${selectedIndex + 1}',
                                  style: TextStyle(
                                    color: Color(0xFF113A1D),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                              SizedBox(height: 10),
                              ...(selectedIndex == 0
                                  ? _buildFarmDetails(
                                    cond,
                                    hum,
                                    k,
                                    n,
                                    p,
                                    ph,
                                    temp,
                                  )
                                  : _buildFarmDetails(
                                    "-",
                                    "-",
                                    "-",
                                    "-",
                                    "-",
                                    "-",
                                    "-",
                                  )),
                            ],
                          ),
                        ),
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
  }

  List<Widget> _buildFarmDetails(
    String cond,
    String hum,
    String k,
    String n,
    String p,
    String ph,
    String temp,
  ) {
    return [
      _buildFarmInfoBox('Condition', 'assets/images/air.svg', cond),
      _buildFarmInfoBox('Humidity', 'assets/images/air.svg', hum),
      _buildFarmInfoBox('K', 'assets/images/air.svg', k),
      _buildFarmInfoBox('N', 'assets/images/air.svg', n),
      _buildFarmInfoBox('P', 'assets/images/air.svg', p),
      _buildFarmInfoBox('pH', 'assets/images/air.svg', ph),
      _buildFarmInfoBox('Temperature', 'assets/images/air.svg', temp),
    ];
  }

  Widget _buildFarmInfoBox(String label, String iconPath, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Color(0xFFF4F4F4),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Color(0xFF14A741), width: 1),
        ),
        child: Row(
          children: [
            SvgPicture.asset(iconPath, width: 30, height: 30),
            SizedBox(width: 10),
            Text(
              label,
              style: TextStyle(
                color: Color(0xFF113A1D),
                fontWeight: FontWeight.w500,
                fontSize: 16,
              ),
            ),
            Spacer(),
            Text(
              value,
              style: TextStyle(
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
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 6,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(svgPath, color: textColor, width: 50, height: 40),
            SizedBox(height: 8),
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
