import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/zones_provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => ZonesProvider(),
      child: const AgriSmartApp(),
    ),
  );
}

class AgriSmartApp extends StatelessWidget {
  const AgriSmartApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AgriSmart',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorSchemeSeed: Colors.green,
        useMaterial3: true,
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        colorSchemeSeed: Colors.green,
        useMaterial3: true,
        brightness: Brightness.dark,
      ),
      themeMode: ThemeMode.system,
      home: const AgriSmartHome(),
    );
  }
}

class AgriSmartHome extends StatefulWidget {
  const AgriSmartHome({super.key});

  @override
  State<AgriSmartHome> createState() => _AgriSmartHomeState();
}

class _AgriSmartHomeState extends State<AgriSmartHome> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final pages = [
      const ZonesScreen(),
      const IrrigationSummaryScreen(),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('AgriSmart'),
      ),
      body: pages[_selectedIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) => setState(() => _selectedIndex = index),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.grass_outlined),
            selectedIcon: Icon(Icons.grass),
            label: 'Zones',
          ),
          NavigationDestination(
            icon: Icon(Icons.water_drop_outlined),
            selectedIcon: Icon(Icons.water_drop),
            label: 'Irrigation',
          ),
        ],
      ),
    );
  }
}

class ZonesScreen extends StatelessWidget {
  const ZonesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final zonesProvider = context.watch<ZonesProvider>();
    final zones = zonesProvider.zones;

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: zones.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final zone = zones[index];
        return Card(
          child: ListTile(
            title: Text('${zone.name} — ${zone.crop}'),
            subtitle: Text('Humidité sol : ${zone.soilMoisture.toStringAsFixed(1)}%'),
            trailing: Switch(
              value: zone.irrigationActive,
              onChanged: (_) =>
                  context.read<ZonesProvider>().toggleIrrigation(zone.id),
            ),
          ),
        );
      },
    );
  }
}

class IrrigationSummaryScreen extends StatelessWidget {
  const IrrigationSummaryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ZonesProvider>();

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.water_drop, size: 48),
                const SizedBox(height: 12),
                Text(
                  'Zones en irrigation : ${provider.activeIrrigationCount} / ${provider.zones.length}',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
