import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

/// Une irrigation programmée
class IrrigationEvent {
  final String parcelle;
  final TimeOfDay heure;
  final int dureeMin;

  IrrigationEvent({
    required this.parcelle,
    required this.heure,
    required this.dureeMin,
  });
}

class IrrigationCalendar extends StatefulWidget {
  /// Liste des parcelles (ex: ['Parcelle Nord', 'Parcelle Sud'])
  final List<String> parcelles;

  const IrrigationCalendar({
    super.key,
    this.parcelles = const ['Parcelle Nord', 'Parcelle Sud'],
  });

  @override
  State<IrrigationCalendar> createState() => _IrrigationCalendarState();
}

class _IrrigationCalendarState extends State<IrrigationCalendar> {
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();
  CalendarFormat _format = CalendarFormat.month;

  // Clé = date normalisée (sans heure)
  final Map<DateTime, List<IrrigationEvent>> _events = {};

  DateTime _key(DateTime d) => DateTime.utc(d.year, d.month, d.day);

  List<IrrigationEvent> _eventsOf(DateTime day) => _events[_key(day)] ?? [];

  Future<void> _addEvent() async {
    String parcelle = widget.parcelles.first;
    TimeOfDay heure = const TimeOfDay(hour: 6, minute: 0);
    int duree = 30;

    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setD) => AlertDialog(
          title: const Text('Programmer une irrigation'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<String>(
                value: parcelle,
                decoration: const InputDecoration(labelText: 'Parcelle'),
                items: widget.parcelles
                    .map((p) => DropdownMenuItem(value: p, child: Text(p)))
                    .toList(),
                onChanged: (v) => setD(() => parcelle = v!),
              ),
              const SizedBox(height: 12),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.access_time),
                title: Text('Heure : ${heure.format(ctx)}'),
                onTap: () async {
                  final t = await showTimePicker(
                      context: ctx, initialTime: heure);
                  if (t != null) setD(() => heure = t);
                },
              ),
              Row(
                children: [
                  const Icon(Icons.timer_outlined),
                  const SizedBox(width: 12),
                  Expanded(child: Text('Durée : $duree min')),
                  IconButton(
                    icon: const Icon(Icons.remove_circle_outline),
                    onPressed: () =>
                        setD(() => duree = duree > 5 ? duree - 5 : duree),
                  ),
                  IconButton(
                    icon: const Icon(Icons.add_circle_outline),
                    onPressed: () => setD(() => duree += 5),
                  ),
                ],
              ),
            ],
          ),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(ctx, false),
                child: const Text('Annuler')),
            FilledButton(
                onPressed: () => Navigator.pop(ctx, true),
                child: const Text('Ajouter')),
          ],
        ),
      ),
    );

    if (ok == true) {
      setState(() {
        _events.putIfAbsent(_key(_selectedDay), () => []).add(
          IrrigationEvent(
              parcelle: parcelle, heure: heure, dureeMin: duree),
        );
        _events[_key(_selectedDay)]!.sort((a, b) =>
            (a.heure.hour * 60 + a.heure.minute)
                .compareTo(b.heure.hour * 60 + b.heure.minute));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final green = Theme.of(context).colorScheme.primary;
    final todays = _eventsOf(_selectedDay);

    return Card(
      elevation: 1,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.calendar_month, color: Colors.green),
                const SizedBox(width: 8),
                const Expanded(
                  child: Text('Calendrier d\'irrigation',
                      style: TextStyle(
                          fontSize: 18, fontWeight: FontWeight.w600)),
                ),
                FilledButton.icon(
                  onPressed: _addEvent,
                  icon: const Icon(Icons.add),
                  label: const Text('Programmer'),
                ),
              ],
            ),
            TableCalendar<IrrigationEvent>(
              locale: 'fr_FR',
              firstDay: DateTime.utc(2024, 1, 1),
              lastDay: DateTime.utc(2030, 12, 31),
              focusedDay: _focusedDay,
              calendarFormat: _format,
              startingDayOfWeek: StartingDayOfWeek.monday,
              availableCalendarFormats: const {
                CalendarFormat.month: 'Mois',
                CalendarFormat.twoWeeks: '2 sem.',
                CalendarFormat.week: 'Semaine',
              },
              selectedDayPredicate: (d) => isSameDay(d, _selectedDay),
              eventLoader: _eventsOf,
              onDaySelected: (sel, foc) => setState(() {
                _selectedDay = sel;
                _focusedDay = foc;
              }),
              onFormatChanged: (f) => setState(() => _format = f),
              onPageChanged: (f) => _focusedDay = f,
              calendarStyle: CalendarStyle(
                todayDecoration: BoxDecoration(
                    color: green.withOpacity(0.35), shape: BoxShape.circle),
                selectedDecoration:
                BoxDecoration(color: green, shape: BoxShape.circle),
                markerDecoration: const BoxDecoration(
                    color: Colors.orange, shape: BoxShape.circle),
              ),
            ),
            const Divider(),
            if (todays.isEmpty)
              const Padding(
                padding: EdgeInsets.all(8),
                child: Text('Aucune irrigation programmée ce jour'),
              )
            else
              ...todays.asMap().entries.map((e) {
                final ev = e.value;
                return ListTile(
                  dense: true,
                  leading: const Icon(Icons.water_drop, color: Colors.blue),
                  title: Text(ev.parcelle),
                  subtitle: Text(
                      '${ev.heure.format(context)} • ${ev.dureeMin} min'),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete_outline),
                    onPressed: () => setState(
                            () => _events[_key(_selectedDay)]!.removeAt(e.key)),
                  ),
                );
              }),
          ],
        ),
      ),
    );
  }
}