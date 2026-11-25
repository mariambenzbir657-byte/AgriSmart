import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../models/activite.dart';

class CalendarProvider extends ChangeNotifier {
  final bool enableFirestore;
  final FirebaseFirestore? _customFirestore;

  static const String _collectionName = 'activites_agricoles';

  final List<ActiviteAgricole> _activites = [
    ActiviteAgricole(
      id: '1',
      titre: 'Irrigation goutte-à-goutte',
      type: TypeActivite.irrigation,
      date: DateTime.now().add(const Duration(hours: 4)),
      zoneNom: 'Parcelle Nord',
      notes: '45 min • Humidité < 35%',
    ),
    ActiviteAgricole(
      id: '2',
      titre: 'Apport engrais azoté',
      type: TypeActivite.fertilisation,
      date: DateTime.now().add(const Duration(days: 1, hours: 2)),
      zoneNom: 'Serre Est',
      notes: '15 kg/ha',
    ),
    ActiviteAgricole(
      id: '3',
      titre: 'Semis tomates',
      type: TypeActivite.semis,
      date: DateTime.now().add(const Duration(days: 3)),
      zoneNom: 'Parcelle Sud',
      notes: 'Ligne 1 à 12',
    ),
  ];

  bool _isLoading = false;
  String? _lastError;

  CalendarProvider({
    this.enableFirestore = true,
    FirebaseFirestore? firestore,
  }) : _customFirestore = firestore {
    if (enableFirestore && _db != null) {
      chargerActivites();
    }
  }

  FirebaseFirestore? get _db {
    if (!enableFirestore) return null;
    if (_customFirestore != null) return _customFirestore;
    try {
      return FirebaseFirestore.instance;
    } catch (_) {
      return null;
    }
  }

  bool get isLoading => _isLoading;
  String? get lastError => _lastError;

  List<ActiviteAgricole> get toutesLesActivites =>
      List.unmodifiable(_activites);

  List<ActiviteAgricole> get evenementsAVenir {
    final maintenant = DateTime.now().subtract(const Duration(hours: 1));
    final liste =
    _activites.where((a) => a.date.isAfter(maintenant)).toList();
    liste.sort((a, b) => a.date.compareTo(b.date));
    return liste;
  }

  List<ActiviteAgricole> filtrerParType(TypeActivite? type) {
    if (type == null) return evenementsAVenir;
    return evenementsAVenir.where((a) => a.type == type).toList();
  }

  Future<void> chargerActivites() async {
    final db = _db;
    if (db == null) return;

    _isLoading = true;
    _lastError = null;
    notifyListeners();

    try {
      final snapshot = await db.collection(_collectionName).get();
      if (snapshot.docs.isNotEmpty) {
        final loaded = snapshot.docs.map((doc) {
          final data = Map<String, dynamic>.from(doc.data());
          final rawDate = data['date'];
          if (rawDate is Timestamp) {
            data['date'] = rawDate.toDate().toIso8601String();
          }
          return ActiviteAgricole.fromMap(data, docId: doc.id);
        }).toList();

        _activites
          ..clear()
          ..addAll(loaded);
      }
    } catch (e) {
      _lastError = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> ajouterActivite({
    required String titre,
    required TypeActivite type,
    required DateTime date,
    required String zoneNom,
    String notes = '',
  }) async {
    final nouvelle = ActiviteAgricole(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      titre: titre.trim(),
      type: type,
      date: date,
      zoneNom: zoneNom,
      notes: notes.trim(),
    );
    _activites.add(nouvelle);
    notifyListeners();

    final db = _db;
    if (db != null) {
      try {
        await db
            .collection(_collectionName)
            .doc(nouvelle.id)
            .set(nouvelle.toMap());
      } catch (e) {
        _lastError = e.toString();
      }
    }
  }

  Future<void> modifierActivite(ActiviteAgricole modifiee) async {
    final index = _activites.indexWhere((a) => a.id == modifiee.id);
    if (index == -1) return;
    _activites[index] = modifiee;
    notifyListeners();

    final db = _db;
    if (db != null) {
      try {
        await db
            .collection(_collectionName)
            .doc(modifiee.id)
            .update(modifiee.toMap());
      } catch (e) {
        _lastError = e.toString();
      }
    }
  }

  Future<void> basculerStatut(String id) async {
    final index = _activites.indexWhere((a) => a.id == id);
    if (index == -1) return;
    final actuelle = _activites[index];
    final miseAJour = actuelle.copyWith(estTerminee: !actuelle.estTerminee);
    _activites[index] = miseAJour;
    notifyListeners();

    final db = _db;
    if (db != null) {
      try {
        await db
            .collection(_collectionName)
            .doc(id)
            .update({'estTerminee': miseAJour.estTerminee});
      } catch (e) {
        _lastError = e.toString();
      }
    }
  }

  Future<void> supprimerActivite(String id) async {
    _activites.removeWhere((a) => a.id == id);
    notifyListeners();

    final db = _db;
    if (db != null) {
      try {
        await db.collection(_collectionName).doc(id).delete();
      } catch (e) {
        _lastError = e.toString();
      }
    }
  }
}