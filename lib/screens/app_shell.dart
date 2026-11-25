import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:agrismart/providers/zones_provider.dart';
import 'package:agrismart/screens/accueil_page.dart';
import 'package:agrismart/screens/maladies_screen.dart'; // NOUVEAU
import 'package:agrismart/screens/profil_page.dart';
import 'package:agrismart/screens/statistiques_page.dart';

class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _onglet = 0;

  @override
  Widget build(BuildContext context) {
    final aIrriguer = context.select<ZonesProvider, int>(
          (provider) => provider.nombreAIrriguer,
    );

    return Scaffold(
      body: IndexedStack(
        index: _onglet,
        children: const [
          AccueilPage(),
          MaladiesScreen(), // NOUVEAU
          StatistiquesPage(),
          ProfilPage(),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _onglet,
        onDestinationSelected: (index) {
          setState(() {
            _onglet = index;
          });
        },
        destinations: [
          NavigationDestination(
            icon: Badge(
              isLabelVisible: aIrriguer > 0,
              label: Text('$aIrriguer'),
              child: const Icon(Icons.grass_outlined),
            ),
            selectedIcon: Badge(
              isLabelVisible: aIrriguer > 0,
              label: Text('$aIrriguer'),
              child: const Icon(Icons.grass),
            ),
            label: 'Zones',
          ),
          const NavigationDestination( // NOUVEAU
            icon: Icon(Icons.bug_report_outlined),
            selectedIcon: Icon(Icons.bug_report),
            label: 'Maladies',
          ),
          const NavigationDestination(
            icon: Icon(Icons.bar_chart_outlined),
            selectedIcon: Icon(Icons.bar_chart),
            label: 'Statistiques',
          ),
          const NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Profil',
          ),
        ],
      ),
    );
  }
}