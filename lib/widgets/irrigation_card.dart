
import 'package:flutter/material.dart';

class IrrigationCard extends StatelessWidget {
  final String zoneNom;
  final String culture;
  final int humidite;
  final int seuil;
  final bool vanneOuverte;
  final VoidCallback onIrriguer;
  final VoidCallback onToggleVanne;

  const IrrigationCard({
    super.key,
    required this.zoneNom,
    required this.culture,
    required this.humidite,
    required this.seuil,
    required this.vanneOuverte,
    required this.onIrriguer,
    required this.onToggleVanne,
  });

  @override
  Widget build(BuildContext context) {
    final bool besoinEau = humidite < seuil;

    return Card(
      elevation: 3,
      margin: const EdgeInsets.only(bottom: 15),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.grass, color: Colors.green, size: 28),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        zoneNom,
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(culture),
                    ],
                  ),
                ),
                Icon(
                  besoinEau ? Icons.warning_amber : Icons.check_circle,
                  color: besoinEau ? Colors.orange : Colors.green,
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Humidité du sol'),
                Text(
                  '$humidite%',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            LinearProgressIndicator(
              value: (humidite / 100).clamp(0.0, 1.0),
              minHeight: 10,
              borderRadius: BorderRadius.circular(10),
              color: besoinEau ? Colors.orange : Colors.green,
              backgroundColor: Colors.grey.shade200,
            ),
            const SizedBox(height: 10),
            Text('Seuil d’irrigation : $seuil%'),
            const SizedBox(height: 10),
            Text(
              besoinEau ? 'Besoin d’irrigation' : 'Humidité suffisante',
              style: TextStyle(
                color: besoinEau ? Colors.orange : Colors.green,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Divider(height: 25),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  vanneOuverte ? 'Vanne ouverte' : 'Vanne fermée',
                ),
                Switch(
                  value: vanneOuverte,
                  activeColor: Colors.green,
                  onChanged: (_) => onToggleVanne(),
                ),
              ],
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: onIrriguer,
                icon: const Icon(Icons.water_drop),
                label: const Text('Démarrer irrigation'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 13),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
