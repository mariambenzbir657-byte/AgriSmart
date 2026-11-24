class Zone {
  final String nom;
  final String culture;
  double humidite;
  final double seuil;
  bool vanneOuverte;

  Zone(
      this.nom,
      this.culture,
      this.humidite,
      this.seuil, {
        this.vanneOuverte = false,
      });

  bool get besoinIrrigation => humidite < seuil;

  // Conversion en JSON (pour l'enregistrer sur l'appareil)
  Map<String, dynamic> toJson() {
    return {
      'nom': nom,
      'culture': culture,
      'humidite': humidite,
      'seuil': seuil,
      'vanneOuverte': vanneOuverte,
    };
  }

  // Reconstruit une zone a partir d'un JSON
  factory Zone.fromJson(Map<String, dynamic> json) {
    return Zone(
      json['nom'] as String,
      json['culture'] as String,
      (json['humidite'] as num).toDouble(),
      (json['seuil'] as num).toDouble(),
      vanneOuverte: (json['vanneOuverte'] as bool?) ?? false,
    );
  }
}

double humiditeMoyenne(List<Zone> zones) {
  if (zones.isEmpty) return 0;

  double somme = 0;

  for (final z in zones) {
    somme += z.humidite;
  }

  return somme / zones.length;
}

String diagnostic(Zone zone) {
  if (zone.besoinIrrigation) {
    return "Besoin d'irrigation";
  }

  return 'Sol correct';
}