import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/activite.dart';
import '../providers/calendar_provider.dart';
import '../providers/zones_provider.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  TypeActivite? _filtreSelectionne;

  String _formaterDate(DateTime dt) {
    final j = dt.day.toString().padLeft(2, '0');
    final m = dt.month.toString().padLeft(2, '0');
    final a = dt.year;
    final h = dt.hour.toString().padLeft(2, '0');
    final min = dt.minute.toString().padLeft(2, '0');
    return '$j/$m/$a à $h:$min';
  }

  IconData _iconeType(TypeActivite type) {
    switch (type) {
      case TypeActivite.irrigation:
        return Icons.water_drop;
      case TypeActivite.fertilisation:
        return Icons.science;
      case TypeActivite.semis:
        return Icons.spa;
      case TypeActivite.recolte:
        return Icons.agriculture;
      case TypeActivite.autre:
        return Icons.event_note;
    }
  }

  Future<void> _ouvrirFormulaireActivite(
      BuildContext context, {
        ActiviteAgricole? activiteExistante,
      }) async {
    final formKey = GlobalKey<FormState>();
    final titreCtrl = TextEditingController(text: activiteExistante?.titre ?? '');
    final notesCtrl = TextEditingController(text: activiteExistante?.notes ?? '');

    final zonesDisponibles = context
        .read<ZonesProvider>()
        .zones
        .map((z) => z.name)
        .toList();
    if (zonesDisponibles.isEmpty) {
      zonesDisponibles.add('Parcelle Principale');
    }

    String zoneSelectionnee = activiteExistante != null &&
        zonesDisponibles.contains(activiteExistante.zoneNom)
        ? activiteExistante.zoneNom
        : zonesDisponibles.first;

    TypeActivite typeSelectionne =
        activiteExistante?.type ?? TypeActivite.irrigation;
    DateTime dateSelectionnee =
        activiteExistante?.date ?? DateTime.now().add(const Duration(days: 1));

    await showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: Text(
                activiteExistante == null
                    ? 'Planifier une activité'
                    : 'Modifier l\'activité',
              ),
              content: Form(
                key: formKey,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      DropdownButtonFormField<TypeActivite>(
                        value: typeSelectionne,
                        decoration: const InputDecoration(
                          labelText: 'Type d\'opération',
                        ),
                        items: TypeActivite.values
                            .map(
                              (t) => DropdownMenuItem(
                            value: t,
                            child: Text(t.label),
                          ),
                        )
                            .toList(),
                        onChanged: (val) {
                          if (val != null) {
                            setDialogState(() => typeSelectionne = val);
                          }
                        },
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: titreCtrl,
                        decoration: const InputDecoration(
                          labelText: 'Titre de l\'activité',
                          hintText: 'Ex: Irrigation matinale',
                        ),
                        validator: (v) =>
                        (v == null || v.trim().isEmpty) ? 'Titre requis' : null,
                      ),
                      const SizedBox(height: 12),
                      DropdownButtonFormField<String>(
                        value: zoneSelectionnee,
                        decoration: const InputDecoration(
                          labelText: 'Zone agricole',
                        ),
                        items: zonesDisponibles
                            .map(
                              (z) => DropdownMenuItem(
                            value: z,
                            child: Text(z),
                          ),
                        )
                            .toList(),
                        onChanged: (val) {
                          if (val != null) {
                            setDialogState(() => zoneSelectionnee = val);
                          }
                        },
                      ),
                      const SizedBox(height: 12),
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: const Icon(Icons.calendar_today),
                        title: const Text('Date et heure'),
                        subtitle: Text(_formaterDate(dateSelectionnee)),
                        onTap: () async {
                          final dateChoisie = await showDatePicker(
                            context: context,
                            initialDate: dateSelectionnee,
                            firstDate: DateTime(2025),
                            lastDate: DateTime(2030),
                          );
                          if (dateChoisie == null || !context.mounted) return;

                          final heureChoisie = await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.fromDateTime(dateSelectionnee),
                          );
                          setDialogState(() {
                            dateSelectionnee = DateTime(
                              dateChoisie.year,
                              dateChoisie.month,
                              dateChoisie.day,
                              heureChoisie?.hour ?? dateSelectionnee.hour,
                              heureChoisie?.minute ?? dateSelectionnee.minute,
                            );
                          });
                        },
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: notesCtrl,
                        maxLines: 2,
                        decoration: const InputDecoration(
                          labelText: 'Notes / Dosage (optionnel)',
                        ),
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
                    final provider = context.read<CalendarProvider>();
                    if (activiteExistante == null) {
                      provider.ajouterActivite(
                        titre: titreCtrl.text,
                        type: typeSelectionne,
                        date: dateSelectionnee,
                        zoneNom: zoneSelectionnee,
                        notes: notesCtrl.text,
                      );
                    } else {
                      provider.modifierActivite(
                        activiteExistante.copyWith(
                          titre: titreCtrl.text.trim(),
                          type: typeSelectionne,
                          date: dateSelectionnee,
                          zoneNom: zoneSelectionnee,
                          notes: notesCtrl.text.trim(),
                        ),
                      );
                    }
                    Navigator.pop(dialogContext);
                  },
                  child: Text(activiteExistante == null ? 'Ajouter' : 'Enregistrer'),
                ),
              ],
            );
          },
        );
      },
    );

    titreCtrl.dispose();
    notesCtrl.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final calendarProvider = context.watch<CalendarProvider>();
    final activites = calendarProvider.filtrerParType(_filtreSelectionne);

    return Scaffold(
      body: Column(
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
            child: Row(
              children: [
                FilterChip(
                  label: const Text('Toutes'),
                  selected: _filtreSelectionne == null,
                  onSelected: (_) => setState(() => _filtreSelectionne = null),
                ),
                const SizedBox(width: 8),
                ...TypeActivite.values.map(
                      (type) => Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: FilterChip(
                      label: Text(type.label),
                      selected: _filtreSelectionne == type,
                      onSelected: (_) => setState(
                            () => _filtreSelectionne =
                        _filtreSelectionne == type ? null : type,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: activites.isEmpty
                ? const Center(
              child: Text('Aucune activité planifiée à venir.'),
            )
                : ListView.separated(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 88),
              itemCount: activites.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                final act = activites[index];
                return Card(
                  child: ListTile(
                    leading: CircleAvatar(
                      child: Icon(_iconeType(act.type)),
                    ),
                    title: Text(
                      act.titre,
                      style: TextStyle(
                        decoration: act.estTerminee
                            ? TextDecoration.lineThrough
                            : null,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('${act.type.label} • ${act.zoneNom}'),
                        Text(_formaterDate(act.date)),
                        if (act.notes.isNotEmpty)
                          Text(
                            act.notes,
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                      ],
                    ),
                    isThreeLine: true,
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Checkbox(
                          value: act.estTerminee,
                          onChanged: (_) => context
                              .read<CalendarProvider>()
                              .basculerStatut(act.id),
                        ),
                        IconButton(
                          icon: const Icon(Icons.edit_outlined),
                          tooltip: 'Modifier',
                          onPressed: () => _ouvrirFormulaireActivite(
                            context,
                            activiteExistante: act,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete_outline),
                          tooltip: 'Supprimer',
                          onPressed: () => context
                              .read<CalendarProvider>()
                              .supprimerActivite(act.id),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _ouvrirFormulaireActivite(context),
        icon: const Icon(Icons.event_available),
        label: const Text('Planifier'),
      ),
    );
  }
}