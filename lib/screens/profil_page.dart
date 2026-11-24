import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:agrismart/providers/auth_provider.dart';
import 'package:agrismart/providers/reglages_provider.dart';
import 'package:agrismart/providers/zones_provider.dart';

class ProfilPage extends StatelessWidget {
  const ProfilPage({super.key});

  Future<void> _confirmerDeconnexion(BuildContext context) async {
    final confirme = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Se déconnecter ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Annuler'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Se déconnecter'),
          ),
        ],
      ),
    );
    if (confirme != true || !context.mounted) return;
    // AuthGate revient tout seul à l'écran de connexion
    await context.read<AuthProvider>().deconnexion();
  }

  @override
  Widget build(BuildContext context) {
    final texte = Theme.of(context).textTheme;

    final nombreZones = context.select<ZonesProvider, int>(
          (provider) => provider.nombre,
    );

    final email = context.select<AuthProvider, String>(
          (a) => a.utilisateur?.email ?? '',
    );

    final themeMode = context.select<ReglagesProvider, ThemeMode>(
          (r) => r.themeMode,
    );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Profil'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const SizedBox(height: 8),

          const Center(
            child: CircleAvatar(
              radius: 40,
              child: Icon(Icons.agriculture, size: 40),
            ),
          ),

          const SizedBox(height: 12),

          Center(
            child: Text(
              'Exploitation AgriSmart',
              style: texte.titleLarge,
            ),
          ),

          // remplace "Kébili, Tunisie" par l'email
          Center(child: Text(email)),

          const SizedBox(height: 16),

          const Divider(),

          ListTile(
            leading: const Icon(Icons.grass),
            title: const Text('Zones suivies'),
            trailing: Text('$nombreZones'),
          ),

          const ListTile(
            leading: Icon(Icons.brightness_6),
            title: Text('Thème'),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: SegmentedButton<ThemeMode>(
              segments: const [
                ButtonSegment(
                    value: ThemeMode.system, label: Text('Système')),
                ButtonSegment(value: ThemeMode.light, label: Text('Clair')),
                ButtonSegment(value: ThemeMode.dark, label: Text('Sombre')),
              ],
              selected: {themeMode},
              onSelectionChanged: (choix) {
                context.read<ReglagesProvider>().changerTheme(choix.first);
              },
            ),
          ),
          const SizedBox(height: 8),

          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Se déconnecter'),
            onTap: () => _confirmerDeconnexion(context),
          ),
        ],
      ),
    );
  }
}