class Maladie {
  final String id;
  final String nom;
  final String plante;
  final String symptomes;
  final String traitement;
  final String gravite; // faible, moyenne, elevee
  final DateTime date;

  Maladie({
    required this.id,
    required this.nom,
    required this.plante,
    required this.symptomes,
    required this.traitement,
    required this.gravite,
    required this.date,
  });

  Map<String, dynamic> toMap() => {
    'id': id,
    'nom': nom,
    'plante': plante,
    'symptomes': symptomes,
    'traitement': traitement,
    'gravite': gravite,
    'date': date.toIso8601String(),
  };

  factory Maladie.fromMap(Map<String, dynamic> m) => Maladie(
    id: m['id'],
    nom: m['nom'],
    plante: m['plante'],
    symptomes: m['symptomes'] ?? '',
    traitement: m['traitement'] ?? '',
    gravite: m['gravite'] ?? 'moyenne',
    date: DateTime.parse(m['date']),
  );
}