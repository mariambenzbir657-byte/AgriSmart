
import 'package:flutter/material.dart';

class ConsommationCard extends StatelessWidget {
  final double consommation;

  const ConsommationCard({
    super.key,
    required this.consommation,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.12),
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Icon(
                Icons.water_drop,
                color: Colors.blue,
                size: 30,
              ),
            ),
            const SizedBox(width: 15),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Consommation totale',
                  style: TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 5),
                Text(
                  '${consommation.toStringAsFixed(1)} L',
                  style: const TextStyle(
                    fontSize: 23,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
