import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/zones_provider.dart';
import '../providers/irrigation_provider.dart';
import '../widgets/irrigation_card.dart';
import '../widgets/consommation_card.dart';
import '../widgets/irrigation_calendar.dart'; // <-- NOUVEAU

class IrrigationPage extends StatelessWidget {
  const IrrigationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer2<ZonesProvider, IrrigationProvider>(
      builder: (context, zonesProvider, irrigationProvider, child) {
        final zones = zonesProvider.zones;

        return Scaffold(
          appBar: AppBar(
            title: const Text(
              'Irrigation intelligente',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
            centerTitle: true,
          ),
          body: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.eco, color: Colors.white, size: 40),
                    SizedBox(width: 15),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Gestion intelligente de l’eau',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            'Surveillez et gérez vos irrigations',
                            style: TextStyle(color: Colors.white70),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),

              ConsommationCard(
                consommation: irrigationProvider.consommationTotale,
              ),

              const SizedBox(height: 18),

              Card(
                child: SwitchListTile(
                  secondary: const Icon(Icons.auto_mode, color: Colors.green),
                  title: const Text(
                    'Mode automatique',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: const Text('Gestion selon le seuil d’humidité'),
                  value: irrigationProvider.modeAutomatique,
                  activeThumbColor: Colors.green,
                  onChanged: irrigationProvider.activerModeAutomatique,
                ),
              ),

              const SizedBox(height: 18),

              // ===== NOUVEAU : Calendrier d'irrigation =====
              // Affiché seulement s'il y a au moins une zone
              if (zones.isNotEmpty)
                IrrigationCalendar(
                  parcelles: zones.map((z) => z.nom as String).toList(),
                ),

              const SizedBox(height: 20),

              const Text(
                'Mes zones agricoles',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 12),

              if (zones.isEmpty)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.all(25),
                    child: Text('Aucune zone disponible'),
                  ),
                )
              else
                ...zones.map(
                      (zone) => IrrigationCard(
                    zoneNom: zone.nom,
                    culture: zone.culture,
                    humidite: zone.humidite.round(),
                    seuil: zone.seuil.round(),
                    vanneOuverte: zone.vanneOuverte,
                    onToggleVanne: () => zonesProvider.basculerVanne(zone),
                    onIrriguer: () {
                      irrigationProvider.demarrerIrrigation(zone.nom);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Irrigation démarrée pour ${zone.nom}'),
                        ),
                      );
                    },
                  ),
                ),

              const SizedBox(height: 15),

              OutlinedButton.icon(
                onPressed: irrigationProvider.reinitialiserConsommation,
                icon: const Icon(Icons.refresh),
                label: const Text('Réinitialiser consommation'),
              ),
            ],
          ),
        );
      },
    );
  }
}