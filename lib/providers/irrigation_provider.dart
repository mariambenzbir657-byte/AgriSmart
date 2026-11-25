import 'package:flutter/foundation.dart';

class IrrigationProvider extends ChangeNotifier {
  double _consommationTotale = 0;
  bool _modeAutomatique = false;

  double get consommationTotale => _consommationTotale;
  bool get modeAutomatique => _modeAutomatique;

  void activerModeAutomatique(bool valeur) {
    _modeAutomatique = valeur;
    notifyListeners();
  }

  void demarrerIrrigation(String nomZone) {
    _consommationTotale += 10; // litres
    notifyListeners();
  }

  void reinitialiserConsommation() {
    _consommationTotale = 0;
    notifyListeners();
  }
}