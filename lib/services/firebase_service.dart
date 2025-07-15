import 'package:firebase_database/firebase_database.dart';
import '../models/soil_data.dart';

class FirebaseService {
  final _db = FirebaseDatabase.instance.ref();

  Future<List<SoilData>> fetchSoilData() async {
    final snapshot = await _db.child('dataNodes').get();

    if (!snapshot.exists) return [];

    final rawData = Map<String, dynamic>.from(snapshot.value as Map);
    List<SoilData> result = [];

    rawData.forEach((key, value) {
      try {
        result.add(SoilData.fromJson(Map<String, dynamic>.from(value), key));
      } catch (e) {
        print("Error parsing data for ID $key: $e");
      }
    });

    return result;
  }

  /// Tambahan jika kamu ingin kendalikan valve (misal toggle tombol)
  Future<void> setValveState(bool isOpen) async {
    await _db.child('activeValves').set(isOpen);
  }

  /// Tambahan: untuk mendapatkan status valve sekarang
  Future<bool> getValveState() async {
    final snapshot = await _db.child('activeValves').get();
    return snapshot.value == true;
  }
}
