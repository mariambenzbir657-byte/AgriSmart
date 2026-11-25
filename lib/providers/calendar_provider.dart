import 'package:flutter/foundation.dart';
import '../models/activite.dart';

class CalendarProvider extends ChangeNotifier {
  final List<ActiviteAgricole> _activites = [
    ActiviteAgricole(
      id: 'act_1',
      titre: 'Irrigation goutte-à-goutte',
      type: TypeActivite.irrigation,
      date: DateTime.now().add(const Duration(days: 1, hours: 2)),
      zoneNom: 'Parcelle Nord',
      notes: 'Durée prévue : 45 min',
    ),
    ActiviteAgricole(
      id: 'act_2',
      titre: 'Apport engrais organique NPK',
      type: TypeActivite.fertilisation,
      date: DateTime.now().add(const Duration(days: 3)),
      zoneNom: 'Serre Sud',
      notes: 'Dosage standard tomates',
    ),
    ActiviteAgricole(
      id: 'act_3',
      titre: 'Fertilisation foliaire',
      type: TypeActivite.fertilisation,
      date: DateTime.now().add(const Duration(days: 6)),
      zoneNom: 'Champ Est',
      notes: 'Vérifier météo avant application',
    ),
  ];

  List<ActiviteAgricole> get toutesLesActivites {
    final copie = List<ActiviteAgricole>.from(_activites);
    copie.sort((a, b) => a.date.compareTo(b.date));
    return List.unmodifiable(copie);
  }

  List<ActiviteAgricole> get evenementsAVenir {
    final maintenant = DateTime.now().subtract(const Duration(hours: 1));
    final aVenir = _activites.where((a) => a.date.isAfter(maintenant)).toList();
    aVenir.sort((a, b) => a.date.compareTo(b.date));
    return List.unmodifiable(aVenir);
  }

  List<ActiviteAgricole> filtrerParType(TypeActivite? type) {
    final liste = evenementsAVenir;
    if (type == null) return liste;
    return liste.where((a) => a.type == type).toList();
  }

  void ajouterActivite({
    required String titre,
    required TypeActivite type,
    required DateTime date,
    required String zoneNom,
    String notes = '',
  }) {
    final nouvelle = ActiviteAgricole(
      id: 'act_${DateTime.now().millisecondsSinceEpoch}',
      titre: titre.trim(),
      type: type,
      date: date,
      zoneNom: zoneNom.trim(),
      notes: notes.trim(),
    );
    _activites.add(nouvelle);
    notifyListeners();
  }

  void modifierActivite(ActiviteAgricole activiteModifiee) {
    final index = _activites.indexWhere((a) => a.id == activiteModifiee.id);
    if (index == -1) return;
    _activites[index] = activiteModifiee;
    notifyListeners();
  }

  void basculerStatut(String id) {
    final index = _activites.indexWhere((a) => a.id == id);
    if (index == -1) return;
    final actuelle = _activites[index];
    _activites[index] = actuelle.copyWith(estTerminee: !actuelle.estTerminee);
    notifyListeners();
  }

  void supprimerActivite(String id) {
    _activites.removeWhere((a) => a.id == id);
    notifyListeners();
  }
}