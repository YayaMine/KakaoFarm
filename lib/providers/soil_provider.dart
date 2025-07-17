import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import '../models/soil_data.dart';

class SoilProvider with ChangeNotifier {
  final List<SoilData> _soilDataList = [];
  List<String> _registeredNodeIds = [];
  bool _activeValve = false;
  bool _isLoading = true;

  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref();

  List<SoilData> get soilDataList => _soilDataList;
  List<String> get registeredNodeIds => _registeredNodeIds;
  bool get activeValve => _activeValve;
  bool get isLoading => _isLoading;

  Future<void> loadData() async {
    _isLoading = true;
    notifyListeners();

    try {
      final snapshot = await _dbRef.get();

      if (snapshot.exists) {
        final data = snapshot.value as Map;

        // Ambil registered node IDs
        final rawIds = data['registeredNodes'] as List<dynamic>? ?? [];
        _registeredNodeIds = rawIds.map((e) => e.toString()).toList();

        // Ambil data node berdasarkan ID
        final nodeDataMap = data['dataNodes'] as Map<dynamic, dynamic>? ?? {};
        _soilDataList.clear();

        for (var id in _registeredNodeIds) {
          final nodeRaw = nodeDataMap[id];
          if (nodeRaw != null) {
            final parsed = Map<String, dynamic>.from(nodeRaw);
            _soilDataList.add(SoilData.fromJson(parsed, id));
          }
        }

        // Ambil data status valve
        final valveSnapshot = await _dbRef.child('statusValve').once();
        if (valveSnapshot.snapshot.value != null) {
          _activeValve = valveSnapshot.snapshot.value as bool;
        }
      }
    } catch (e) {
      debugPrint('Error loading soil data: $e');
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> toggleValve(bool value) async {
    _activeValve = value;
    notifyListeners();
    await _dbRef.child('statusValve').set(value);
  }

  SoilData? getSoilDataById(String? id) {
    try {
      return _soilDataList.firstWhere((data) => data.id == id);
    } catch (e) {
      return null;
    }
  }
}
