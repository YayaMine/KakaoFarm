import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../models/soil_data.dart';
import '../providers/soil_provider.dart';
import '../widgets/farm_info_box.dart';
import '../widgets/farm_selector_card.dart';
import '../widgets/header_section.dart';
import '../widgets/navigation_bottom.dart';

class EnvironmentScreen extends StatefulWidget {
  const EnvironmentScreen({super.key});

  @override
  _EnvironmentScreenState createState() => _EnvironmentScreenState();
}

class _EnvironmentScreenState extends State<EnvironmentScreen> {
  int _currentIndex = 1;
  int selectedIndex = 0;

  final _idController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Provider.of<SoilProvider>(context, listen: false).loadData();
  }

  @override
  void dispose() {
    _idController.dispose();
    super.dispose();
  }

  void _showRegisterNodeDialog(BuildContext context, List<String> existingIds) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Register New Node'),
          content: TextField(
            controller: _idController,
            decoration: const InputDecoration(labelText: 'Node ID'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                final newId = _idController.text.trim();
                if (newId.isEmpty) return;

                if (existingIds.contains(newId)) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Node ID already registered!'),
                    ),
                  );
                } else {
                  final db = FirebaseDatabase.instance.ref();
                  final timestamp = DateFormat(
                    'yyyy-MM-dd_HH-mm-ss',
                  ).format(DateTime.now());
                  final snapshot = await db.child('registeredNodes').get();
                  final length = snapshot.children.length;
                  await db.child('registeredNodes/$length').set(newId);
                  await db.child('dataNodes/$newId').set({
                    'cond': "0",
                    'hum': "0",
                    'k': "0",
                    'n': "0",
                    'p': "0",
                    'ph': "0",
                    'temp': "0",
                    'datetime': timestamp,
                  });
                  Navigator.pop(context);
                  _idController.clear();
                  Provider.of<SoilProvider>(context, listen: false).loadData();
                }
              },
              child: const Text('Register'),
            ),
          ],
        );
      },
    );
  }

  void _editNodeId(String oldId) {
    final editController = TextEditingController(text: oldId);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Node ID'),
          content: TextField(
            controller: editController,
            decoration: const InputDecoration(labelText: 'New Node ID'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                final newId = editController.text.trim();
                if (newId.isEmpty || newId == oldId) return;

                final db = FirebaseDatabase.instance.ref();

                // Cek apakah ID baru sudah ada
                final registeredSnapshot =
                    await db.child('registeredNodes').get();
                final isDuplicate = registeredSnapshot.children.any(
                  (node) => node.value == newId,
                );

                if (isDuplicate) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Node ID already exists!')),
                  );
                  return;
                }

                // Temukan key dari node yang akan diubah
                final target = registeredSnapshot.children.firstWhere(
                  (node) => node.value == oldId,
                );
                final key = target.key;

                // Update ID di registerednodes dan copy data di datanodes
                await db.child('registeredNodes/$key').set(newId);

                final oldData =
                    (await db.child('dataNodes/$oldId').get()).value;
                await db.child('dataNodes/$newId').set(oldData);
                await db.child('dataNodes/$oldId').remove();

                Navigator.pop(context);
                Provider.of<SoilProvider>(context, listen: false).loadData();
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _deleteNodeId(String id) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete Node'),
          content: Text('Are you sure you want to delete node "$id"?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                final db = FirebaseDatabase.instance.ref();

                final snapshot = await db.child('registeredNodes').get();
                final target = _findSnapshotByValue(snapshot.children, id);

                if (target != null) {
                  await db.child('registeredNodes/${target.key}').remove();
                  await db.child('dataNodes/$id').remove();
                }

                Navigator.pop(context);
                Provider.of<SoilProvider>(context, listen: false).loadData();
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  DataSnapshot? _findSnapshotByValue(
    Iterable<DataSnapshot> children,
    String id,
  ) {
    for (var child in children) {
      if (child.value == id) {
        return child;
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SoilProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final nodeIds = provider.registeredNodeIds;
        final currentNodeId =
            nodeIds.isNotEmpty && selectedIndex < nodeIds.length
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
                      HeaderSection(
                        title: 'Environment',
                        subtitle: 'online',
                        showBackButton: true,
                      ),
                      Transform.translate(
                        offset: const Offset(0, -100),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.only(left: 12),
                          child: Row(
                            children: List.generate(nodeIds.length, (index) {
                              return Padding(
                                padding: const EdgeInsets.only(right: 12),
                                child: FarmSelectorCard(
                                  title: 'Farm ${nodeIds[index]}',
                                  isSelected: selectedIndex == index,
                                  onTap: () {
                                    setState(() {
                                      selectedIndex = index;
                                    });
                                  },
                                ),
                              );
                            }),
                          ),
                        ),
                      ),
                      Transform.translate(
                        offset: const Offset(0, -75),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            elevation: 5,
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              width: double.infinity,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: const Color(0xFF14A741),
                                  width: 2,
                                ),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child:
                                  currentData != null
                                      ? Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                'Farm ${currentData.id}',
                                                style: const TextStyle(
                                                  color: Color(0xFF113A1D),
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 18,
                                                ),
                                              ),
                                              PopupMenuButton<String>(
                                                icon: const Icon(
                                                  Icons.settings,
                                                  color: Color(0xFF113A1D),
                                                ),
                                                onSelected: (value) {
                                                  if (value == 'edit') {
                                                    _editNodeId(currentNodeId!);
                                                  } else if (value ==
                                                      'delete') {
                                                    _deleteNodeId(
                                                      currentNodeId!,
                                                    );
                                                  }
                                                },
                                                itemBuilder:
                                                    (BuildContext context) => [
                                                      const PopupMenuItem<
                                                        String
                                                      >(
                                                        value: 'edit',
                                                        child: Text(
                                                          'Edit Node ID',
                                                        ),
                                                      ),
                                                      const PopupMenuItem<
                                                        String
                                                      >(
                                                        value: 'delete',
                                                        child: Text(
                                                          'Delete Node',
                                                        ),
                                                      ),
                                                    ],
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 10),
                                          ..._buildFarmDetails(currentData),
                                        ],
                                      )
                                      : const Center(child: Text("No Data")),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                right: 16,
                bottom: 90,
                child: FloatingActionButton(
                  backgroundColor: const Color(0xFF14A741),
                  onPressed: () => _showRegisterNodeDialog(context, nodeIds),
                  child: const Icon(Icons.add, color: Colors.white),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
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
      },
    );
  }

  List<Widget> _buildFarmDetails(SoilData data) {
    return [
      FarmInfoBox(
        label: 'Condition',
        iconPath: 'assets/images/air.svg',
        value: data.conductivity.toStringAsFixed(1),
      ),
      FarmInfoBox(
        label: 'Humidity',
        iconPath: 'assets/images/air.svg',
        value: data.moisture.toStringAsFixed(1),
      ),
      FarmInfoBox(
        label: 'K',
        iconPath: 'assets/images/air.svg',
        value: data.potassium.toStringAsFixed(1),
      ),
      FarmInfoBox(
        label: 'N',
        iconPath: 'assets/images/air.svg',
        value: data.nitrogen.toStringAsFixed(1),
      ),
      FarmInfoBox(
        label: 'P',
        iconPath: 'assets/images/air.svg',
        value: data.phosphorus.toStringAsFixed(1),
      ),
      FarmInfoBox(
        label: 'pH',
        iconPath: 'assets/images/air.svg',
        value: data.pH.toStringAsFixed(2),
      ),
      FarmInfoBox(
        label: 'Temperature',
        iconPath: 'assets/images/air.svg',
        value: data.temperature.toStringAsFixed(1),
      ),
    ];
  }
}
