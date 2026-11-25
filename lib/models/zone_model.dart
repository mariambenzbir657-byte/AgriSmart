class AgriculturalZone {
  final String id;
  final String name;
  final String crop;
  final double soilMoisture;
  final bool irrigationActive;

  const AgriculturalZone({
    required this.id,
    required this.name,
    required this.crop,
    required this.soilMoisture,
    required this.irrigationActive,
  });

  AgriculturalZone copyWith({
    String? id,
    String? name,
    String? crop,
    double? soilMoisture,
    bool? irrigationActive,
  }) {
    return AgriculturalZone(
      id: id ?? this.id,
      name: name ?? this.name,
      crop: crop ?? this.crop,
      soilMoisture: soilMoisture ?? this.soilMoisture,
      irrigationActive: irrigationActive ?? this.irrigationActive,
    );
  }
}
