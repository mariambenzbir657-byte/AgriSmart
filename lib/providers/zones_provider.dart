import 'package:flutter/foundation.dart';
import '../models/zone_model.dart';

class ZonesProvider extends ChangeNotifier {
  final List<AgriculturalZone> _zones = const [
    AgriculturalZone(
      id: 'z1',
      name: 'Parcelle Nord',
      crop: 'Olivier',
      soilMoisture: 42.0,
      irrigationActive: false,
    ),
    AgriculturalZone(
      id: 'z2',
      name: 'Serre Sud',
      crop: 'Tomate',
      soilMoisture: 68.5,
      irrigationActive: true,
    ),
    AgriculturalZone(
      id: 'z3',
      name: 'Champ Est',
      crop: 'Blé dur',
      soilMoisture: 31.0,
      irrigationActive: true,
    ),
  ];

  List<AgriculturalZone> get zones => List.unmodifiable(_zones);

  int get activeIrrigationCount =>
      _zones.where((z) => z.irrigationActive).length;

  void toggleIrrigation(String zoneId) {
    final index = _zones.indexWhere((z) => z.id == zoneId);
    if (index == -1) return;

    final current = _zones[index];
    final nextActive = !current.irrigationActive;
    _zones[index] = current.copyWith(
      irrigationActive: nextActive,
      soilMoisture: nextActive
          ? (current.soilMoisture + 5.0).clamp(0.0, 100.0)
          : current.soilMoisture,
    );
    notifyListeners();
  }
}
