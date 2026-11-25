import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/calendar_provider.dart';
import 'providers/zones_provider.dart';
import 'screens/calendar_page.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ZonesProvider()),
        ChangeNotifierProvider(create: (_) => CalendarProvider()),
      ],
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
      const CalendarPage(),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('AgriSmart'),
      ),
      body: pages[_selectedIndex],
      floatingActionButton: _selectedIndex == 0
          ? FloatingActionButton.extended(
        onPressed: () => _showAddZoneDialog(context),
        icon: const Icon(Icons.add),
        label: const Text('Ajouter zone'),
      )
          : null,
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
          NavigationDestination(
            icon: Icon(Icons.calendar_month_outlined),
            selectedIcon: Icon(Icons.calendar_month),
            label: 'Calendrier',
          ),
        ],
      ),
    );
  }

  Future<void> _showAddZoneDialog(BuildContext context) async {
    final formKey = GlobalKey<FormState>();
    final nameController = TextEditingController();
    final cropController = TextEditingController();
    final moistureController = TextEditingController(text: '50');
    bool active = false;

    await showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text('Nouvelle zone agricole'),
              content: Form(
                key: formKey,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFormField(
                        controller: nameController,
                        decoration: const InputDecoration(
                          labelText: 'Nom de la zone',
                          hintText: 'Ex: Parcelle Sud',
                        ),
                        validator: (v) =>
                        (v == null || v.trim().isEmpty) ? 'Nom requis' : null,
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: cropController,
                        decoration: const InputDecoration(
                          labelText: 'Culture',
                          hintText: 'Ex: Olivier, Tomate',
                        ),
                        validator: (v) =>
                        (v == null || v.trim().isEmpty) ? 'Culture requise' : null,
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: moistureController,
                        keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                        decoration: const InputDecoration(
                          labelText: 'Humidité du sol (%)',
                        ),
                        validator: (v) {
                          final parsed =
                          double.tryParse((v ?? '').replaceAll(',', '.'));
                          if (parsed == null || parsed < 0 || parsed > 100) {
                            return 'Entre 0 et 100';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 8),
                      SwitchListTile(
                        contentPadding: EdgeInsets.zero,
                        title: const Text('Irrigation active'),
                        value: active,
                        onChanged: (val) => setDialogState(() => active = val),
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(dialogContext),
                  child: const Text('Annuler'),
                ),
                FilledButton(
                  onPressed: () {
                    if (!formKey.currentState!.validate()) return;
                    final moisture = double.parse(
                        moistureController.text.replaceAll(',', '.'));
                    context.read<ZonesProvider>().addZone(
                      name: nameController.text,
                      crop: cropController.text,
                      soilMoisture: moisture,
                      irrigationActive: active,
                    );
                    Navigator.pop(dialogContext);
                  },
                  child: const Text('Ajouter'),
                ),
              ],
            );
          },
        );
      },
    );

    nameController.dispose();
    cropController.dispose();
    moistureController.dispose();
  }
}

class ZonesScreen extends StatelessWidget {
  const ZonesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final zonesProvider = context.watch<ZonesProvider>();
    final zones = zonesProvider.zones;

    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 88),
      itemCount: zones.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final zone = zones[index];
        return Card(
          child: ListTile(
            title: Text('${zone.name} — ${zone.crop}'),
            subtitle:
            Text('Humidité sol : ${zone.soilMoisture.toStringAsFixed(1)}%'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Switch(
                  value: zone.irrigationActive,
                  onChanged: (_) =>
                      context.read<ZonesProvider>().toggleIrrigation(zone.id),
                ),
                IconButton(
                  icon: const Icon(Icons.delete_outline),
                  tooltip: 'Supprimer',
                  onPressed: () =>
                      context.read<ZonesProvider>().removeZone(zone.id),
                ),
              ],
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