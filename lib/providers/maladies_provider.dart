import 'package:flutter/material.dart';

import 'package:agrismart/models/maladie.dart';
import 'package:agrismart/services/maladies_api_service.dart';

class MaladiesProvider extends ChangeNotifier {
  MaladiesProvider(this._service);

  final MaladiesApiService _service;

  List<Maladie> _maladies = [];
  bool _chargement = false;
  String? _erreur;

  List<Maladie> get maladies => List.unmodifiable(_maladies);
  bool get chargement => _chargement;
  String? get erreur => _erreur;

  Future<void> charger() async {
    _chargement = true;
    _erreur = null;
    notifyListeners();
    try {
      _maladies = await _service.lister();
    } catch (e) {
      _erreur = 'Serveur injoignable : $e';
    }
    _chargement = false;
    notifyListeners();
  }

  Future<void> _executer(Future<void> Function() action) async {
    try {
      await action();
      await charger();
    } catch (e) {
      _erreur = e.toString();
      notifyListeners();
    }
  }

  Future<void> ajouter(Maladie m) => _executer(() => _service.ajouter(m));
  Future<void> modifier(Maladie m) => _executer(() => _service.modifier(m));
  Future<void> supprimer(String id) => _executer(() => _service.supprimer(id));
}