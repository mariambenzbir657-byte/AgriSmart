enum TypeActivite {
  irrigation,
  fertilisation,
  semis,
  recolte,
  autre,
}

extension TypeActiviteExtension on TypeActivite {
  String get label {
    switch (this) {
      case TypeActivite.irrigation:
        return 'Irrigation';
      case TypeActivite.fertilisation:
        return 'Fertilisation';
      case TypeActivite.semis:
        return 'Semis';
      case TypeActivite.recolte:
        return 'Récolte';
      case TypeActivite.autre:
        return 'Autre';
    }
  }
}

class ActiviteAgricole {
  final String id;
  final String titre;
  final TypeActivite type;
  final DateTime date;
  final String zoneNom;
  final String notes;
  final bool estTerminee;

  const ActiviteAgricole({
    required this.id,
    required this.titre,
    required this.type,
    required this.date,
    required this.zoneNom,
    this.notes = '',
    this.estTerminee = false,
  });

  ActiviteAgricole copyWith({
    String? id,
    String? titre,
    TypeActivite? type,
    DateTime? date,
    String? zoneNom,
    String? notes,
    bool? estTerminee,
  }) {
    return ActiviteAgricole(
      id: id ?? this.id,
      titre: titre ?? this.titre,
      type: type ?? this.type,
      date: date ?? this.date,
      zoneNom: zoneNom ?? this.zoneNom,
      notes: notes ?? this.notes,
      estTerminee: estTerminee ?? this.estTerminee,
    );
  }
}