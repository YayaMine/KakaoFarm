import 'package:flutter/material.dart';

class Homepage1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: ClipPath(
              clipper: RefinedCurvedAppBarClipper(),
              child: Container(
                color: Color(0xFF14A741),
                height: 210.0,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Icon(
                        Icons.ac_unit_outlined,
                        color: Colors.white,
                        size: 30,
                      ),
                      SizedBox(width: 10),
                      Text(
                        "Kakao Farm",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.normal,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          Positioned(
            top: 160.0,
            left: 0,
            right: 0,
            bottom: 0,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 20,
                mainAxisSpacing: 16,
                children: <Widget>[
                  _buildCard(Icons.home, "Remote Control"),
                  _buildCard(Icons.ac_unit, "Environment Status"),
                  _buildCard(Icons.schedule, "Schedule"),
                  _buildCard(Icons.history, "History"),
                  _buildCard(Icons.code, "Script"),
                  _buildCard(Icons.settings, "Technique"),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCard(IconData icon, String title) {
    return Card(
      color: Colors.green[50],
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () {
          // Add your navigation or functionality here
        },
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(icon, size: 50, color: Colors.green),
              SizedBox(height: 10),
              Text(title, style: TextStyle(fontSize: 16, color: Colors.green)),
            ],
          ),
        ),
      ),
    );
  }
}

class RefinedCurvedAppBarClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, 0);
    path.lineTo(
      0,
      size.height - 90,
    ); // Slightly reduced curve height for balance
    path.quadraticBezierTo(
      size.width / 15, // Control point for smoother curve on the left side
      size.height + 60, // Raised curve for a more pronounced effect
      size.width, // Right side of the curve
      size.height + 30, // Lower end for the curve
    );
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
