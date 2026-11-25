enum TypeActivite {
  irrigation('Irrigation'),
  fertilisation('Fertilisation'),
  semis('Semis'),
  recolte('Récolte'),
  autre('Autre');

  final String label;
  const TypeActivite(this.label);

  static TypeActivite fromName(String? name) {
    return TypeActivite.values.firstWhere(
          (e) => e.name == name,
      orElse: () => TypeActivite.autre,
    );
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

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'titre': titre,
      'type': type.name,
      'date': date.toIso8601String(),
      'zoneNom': zoneNom,
      'notes': notes,
      'estTerminee': estTerminee,
    };
  }

  factory ActiviteAgricole.fromMap(Map<String, dynamic> map, {String? docId}) {
    final rawDate = map['date'];
    DateTime parsedDate;
    if (rawDate is DateTime) {
      parsedDate = rawDate;
    } else if (rawDate is String) {
      parsedDate = DateTime.tryParse(rawDate) ?? DateTime.now();
    } else {
      parsedDate = DateTime.now();
    }

    return ActiviteAgricole(
      id: (map['id'] as String?)?.isNotEmpty == true
          ? map['id'] as String
          : (docId ?? ''),
      titre: (map['titre'] as String?) ?? '',
      type: TypeActivite.fromName(map['type'] as String?),
      date: parsedDate,
      zoneNom: (map['zoneNom'] as String?) ?? 'Parcelle Principale',
      notes: (map['notes'] as String?) ?? '',
      estTerminee: (map['estTerminee'] as bool?) ?? false,
    );
  }
}