import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:agrismart/models/zone.dart';
import 'package:agrismart/providers/zones_provider.dart';
import 'package:agrismart/widgets/meteo_card.dart';
import 'package:agrismart/widgets/resume_exploitation.dart';

class StatistiquesPage extends StatelessWidget {
  const StatistiquesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Zone> zones = context.watch<ZonesProvider>().zones;

    final tri = [...zones]..sort((a, b) => a.humidite.compareTo(b.humidite));

    final aIrriguer = zones.where((z) => z.besoinIrrigation).length;

    final pourcentage =
    zones.isEmpty ? 0 : (aIrriguer * 100 / zones.length).round();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Statistiques'),
      ),
      body: ListView(
        children: [
          const MeteoCard(),
          if (zones.isEmpty)
            const Padding(
              padding: EdgeInsets.all(24),
              child: Center(child: Text('Aucune donnée à afficher')),
            )
          else ...[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ResumeExploitation(zones: zones),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '$aIrriguer zone(s) sur ${zones.length} '
                              'à irriguer ($pourcentage %)',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 20),
                        Text(
                          'Humidité par zone',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 8),
                        for (final z in tri)
                          ListTile(
                            contentPadding: EdgeInsets.zero,
                            title: Text(z.nom),
                            subtitle: Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: LinearProgressIndicator(
                                value: (z.humidite / 100).clamp(0.0, 1.0),
                                color: z.besoinIrrigation
                                    ? Colors.red
                                    : Colors.green,
                                backgroundColor: Colors.grey.shade300,
                              ),
                            ),
                            trailing: Text('${z.humidite.toInt()} %'),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}