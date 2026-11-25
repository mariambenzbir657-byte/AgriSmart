import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:agrismart/providers/maladies_provider.dart';
import 'package:agrismart/screens/maladie_form_screen.dart';

class MaladiesScreen extends StatelessWidget {
  const MaladiesScreen({super.key});

  Color _couleur(String gravite) {
    switch (gravite) {
      case 'elevee':
        return Colors.red;
      case 'moyenne':
        return Colors.orange;
      default:
        return Colors.green;
    }
  }

  @override
  Widget build(BuildContext context) {
    final p = context.watch<MaladiesProvider>();
    final maladies = p.maladies;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Maladies des plantes'),
      ),
      body: Builder(
        builder: (context) {
          // 1. Chargement
          if (p.chargement && maladies.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          // 2. Erreur (serveur injoignable...)
          if (p.erreur != null && maladies.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(p.erreur!, textAlign: TextAlign.center),
                    const SizedBox(height: 12),
                    FilledButton(
                      onPressed: p.charger,
                      child: const Text('Réessayer'),
                    ),
                  ],
                ),
              ),
            );
          }

          // 3. Liste vide
          if (maladies.isEmpty) {
            return const Center(child: Text('Aucune maladie enregistrée'));
          }

          // 4. Liste
          return RefreshIndicator(
            onRefresh: p.charger,
            child: ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.only(bottom: 80),
              itemCount: maladies.length,
              itemBuilder: (_, i) {
                final m = maladies[i];
                return Card(
                  child: ListTile(
                    leading: Icon(
                      Icons.bug_report,
                      color: _couleur(m.gravite),
                    ),
                    title: Text('${m.nom} (${m.plante})'),
                    subtitle: Text(
                      'Symptômes : ${m.symptomes}\n'
                          'Traitement : ${m.traitement}',
                    ),
                    isThreeLine: true,
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit),
                          tooltip: 'Modifier',
                          onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => MaladieFormScreen(maladie: m),
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          tooltip: 'Supprimer',
                          onPressed: () => context
                              .read<MaladiesProvider>()
                              .supprimer(m.id),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: null,
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const MaladieFormScreen()),
        ),
        child: const Icon(Icons.add),
      ),
    );
  }
}