class SoilData {
  final String id;
  final double conductivity;
  final double moisture;
  final double potassium;
  final double nitrogen;
  final double phosphorus;
  final double pH;
  final double temperature;

  SoilData({
    required this.id,
    required this.conductivity,
    required this.moisture,
    required this.potassium,
    required this.nitrogen,
    required this.phosphorus,
    required this.pH,
    required this.temperature,
  });

  factory SoilData.fromJson(Map<String, dynamic> json, String id) {
    return SoilData(
      id: id,
      conductivity: double.tryParse(json['cond'] ?? '0') ?? 0.0,
      moisture: double.tryParse(json['hum'] ?? '0') ?? 0.0,
      potassium: double.tryParse(json['k'] ?? '0') ?? 0.0,
      nitrogen: double.tryParse(json['n'] ?? '0') ?? 0.0,
      phosphorus: double.tryParse(json['p'] ?? '0') ?? 0.0,
      pH: double.tryParse(json['ph'] ?? '0') ?? 0.0,
      temperature: double.tryParse(json['temp'] ?? '0') ?? 0.0,
    );
  }
}
