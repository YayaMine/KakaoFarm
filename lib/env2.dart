import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Home.dart';

class Env2 extends StatefulWidget {
  @override
  _Env2State createState() => _Env2State();
}

class _Env2State extends State<Env2> {
  List<String> farmNodes = [];
  int? selectedIndex;
  Map<String, Map<String, dynamic>> farmDataMap = {};
  bool loading = false;

  final TextEditingController _newNodeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadFarmNodes();
  }

  Future<void> _loadFarmNodes() async {
    final prefs = await SharedPreferences.getInstance();
    List<String>? savedNodes = prefs.getStringList('farmNodes');
    int? savedSelectedIndex = prefs.getInt('selectedIndex');

    if (savedNodes != null && savedNodes.isNotEmpty) {
      setState(() {
        farmNodes = savedNodes;
        if (savedSelectedIndex != null &&
            savedSelectedIndex < farmNodes.length) {
          selectedIndex = savedSelectedIndex;
        } else {
          selectedIndex = null;
        }
      });

      for (String node in farmNodes) {
        await fetchFarmData(node);
      }
    }
  }

  Future<void> _saveFarmNodes() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('farmNodes', farmNodes);
  }

  Future<void> _saveSelectedIndex() async {
    final prefs = await SharedPreferences.getInstance();
    if (selectedIndex != null) {
      await prefs.setInt('selectedIndex', selectedIndex!);
    } else {
      await prefs.remove('selectedIndex');
    }
  }

  Future<void> fetchFarmData(String node) async {
    setState(() {
      loading = true;
    });
    try {
      final ref = FirebaseDatabase.instance.ref(node);
      final snapshot = await ref.get();

      if (snapshot.exists) {
        Map<String, dynamic> data = Map<String, dynamic>.from(
          snapshot.value as Map,
        );
        setState(() {
          farmDataMap[node] = data;
        });
      } else {
        setState(() {
          farmDataMap[node] = {};
        });
      }
    } catch (e) {
      setState(() {
        farmDataMap[node] = {'error': 'Failed to fetch data'};
      });
    } finally {
      setState(() {
        loading = false;
      });
    }
  }

  void _showAddNodeDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Tambah Node Baru"),
          content: TextField(
            controller: _newNodeController,
            decoration: InputDecoration(
              hintText: "Masukkan nama node Firebase",
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                _newNodeController.clear();
                Navigator.pop(context);
              },
              child: Text("Batal"),
            ),
            TextButton(
              onPressed: () {
                String newNode = _newNodeController.text.trim();
                if (newNode.isNotEmpty && !farmNodes.contains(newNode)) {
                  setState(() {
                    farmNodes.add(newNode);
                  });
                  _saveFarmNodes(); // simpan list node ke shared prefs
                  fetchFarmData(newNode);
                  _setSelectedIndex(farmNodes.indexOf(newNode));
                }
                _newNodeController.clear();
                Navigator.pop(context);
              },
              child: Text("Tambah"),
            ),
          ],
        );
      },
    );
  }

  void _deleteNode(int index) {
    String node = farmNodes[index];
    setState(() {
      farmNodes.removeAt(index);
      farmDataMap.remove(node);
      if (selectedIndex != null) {
        if (farmNodes.isEmpty) {
          selectedIndex = null;
        } else if (selectedIndex! >= farmNodes.length) {
          selectedIndex = farmNodes.length - 1;
        }
      }
    });
    _saveFarmNodes();
    _saveSelectedIndex();
  }

  void _setSelectedIndex(int? index) {
    setState(() {
      selectedIndex = index;
    });
    _saveSelectedIndex();
  }

  String _getField(String node, String key) {
    if (farmDataMap[node] == null) return "-";
    return farmDataMap[node]![key]?.toString() ?? "-";
  }

  @override
  void dispose() {
    _newNodeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final hasSelection =
        selectedIndex != null && selectedIndex! < farmNodes.length;
    final currentNode = hasSelection ? farmNodes[selectedIndex!] : null;

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
                              children:
                                  farmNodes.asMap().entries.map((entry) {
                                    int index = entry.key;
                                    String node = entry.value;
                                    bool isSelected = selectedIndex == index;
                                    return Padding(
                                      padding: EdgeInsets.only(right: 12),
                                      child: Stack(
                                        children: [
                                          GestureDetector(
                                            onTap: () async {
                                              await fetchFarmData(node);
                                              _setSelectedIndex(index);
                                            },
                                            child: Container(
                                              width: 110,
                                              height: 110,
                                              padding: EdgeInsets.all(12),
                                              decoration: BoxDecoration(
                                                color:
                                                    isSelected
                                                        ? Color(0xFF113A1D)
                                                        : Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.black
                                                        .withOpacity(0.2),
                                                    blurRadius: 6,
                                                    offset: Offset(0, 3),
                                                  ),
                                                ],
                                              ),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  SvgPicture.asset(
                                                    'assets/images/earth-svgrepo-com.svg',
                                                    color:
                                                        isSelected
                                                            ? Colors.white
                                                            : Color(0xFF113A1D),
                                                    width: 50,
                                                    height: 40,
                                                  ),
                                                  SizedBox(height: 8),
                                                  Text(
                                                    node,
                                                    style: TextStyle(
                                                      color:
                                                          isSelected
                                                              ? Colors.white
                                                              : Color(
                                                                0xFF113A1D,
                                                              ),
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 13,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          // Tombol close di pojok kanan atas card kecil untuk deselect, bukan hapus node
                                          Positioned(
                                            right: 0,
                                            top: 0,
                                            child: GestureDetector(
                                              onTap: () {
                                                if (selectedIndex == index) {
                                                  _setSelectedIndex(null);
                                                }
                                              },
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  color: Colors.red,
                                                  shape: BoxShape.circle,
                                                ),
                                                padding: EdgeInsets.all(4),
                                                child: Icon(
                                                  Icons.close,
                                                  size: 16,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          ),
                                          // Tombol hapus node (delete) di pojok kiri bawah
                                          Positioned(
                                            left: 0,
                                            bottom: 0,
                                            child: GestureDetector(
                                              onTap: () {
                                                showDialog(
                                                  context: context,
                                                  builder: (context) {
                                                    return AlertDialog(
                                                      title: Text(
                                                        'Hapus Node Ini?',
                                                      ),
                                                      content: Text(
                                                        'Apakah kamu yakin ingin menghapus node "$node"?',
                                                      ),
                                                      actions: [
                                                        TextButton(
                                                          onPressed:
                                                              () =>
                                                                  Navigator.pop(
                                                                    context,
                                                                  ),
                                                          child: Text('Batal'),
                                                        ),
                                                        TextButton(
                                                          onPressed: () {
                                                            Navigator.pop(
                                                              context,
                                                            );
                                                            _deleteNode(index);
                                                          },
                                                          child: Text('Hapus'),
                                                        ),
                                                      ],
                                                    );
                                                  },
                                                );
                                              },
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  color: Colors.black54,
                                                  shape: BoxShape.circle,
                                                ),
                                                padding: EdgeInsets.all(4),
                                                child: Icon(
                                                  Icons.delete,
                                                  size: 16,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  }).toList(),
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
                        child:
                            loading
                                ? Center(child: CircularProgressIndicator())
                                : hasSelection
                                ? SingleChildScrollView(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(
                                          top: 16.0,
                                        ),
                                        child: Text(
                                          farmNodes[selectedIndex!],
                                          style: TextStyle(
                                            color: Color(0xFF113A1D),
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18,
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 10),
                                      ..._buildFarmDetails(
                                        _getField(currentNode!, 'cond'),
                                        _getField(currentNode, 'hum'),
                                        _getField(currentNode, 'k'),
                                        _getField(currentNode, 'n'),
                                        _getField(currentNode, 'p'),
                                        _getField(currentNode, 'ph'),
                                        _getField(currentNode, 'temp'),
                                      ),
                                    ],
                                  ),
                                )
                                : Center(
                                  child: Text(
                                    "Tidak ada data yang dipilih",
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.grey[600],
                                    ),
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
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddNodeDialog,
        backgroundColor: Color(0xFF14A741),
        child: Icon(Icons.add),
        tooltip: "Tambah Node Baru",
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
}
