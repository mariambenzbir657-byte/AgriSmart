import 'package:flutter_test/flutter_test.dart';
import 'package:agrismart/models/activite.dart';
import 'package:agrismart/providers/calendar_provider.dart';

void main() {
  late CalendarProvider provider;

  setUp(() {
    provider = CalendarProvider(enableFirestore: false);
  });

  test('evenementsAVenir returns upcoming activities sorted by date', () {
    final upcoming = provider.evenementsAVenir;
    expect(upcoming.length, greaterThanOrEqualTo(3));

    for (var i = 0; i < upcoming.length - 1; i++) {
      expect(
        upcoming[i].date.isAfter(upcoming[i + 1].date),
        isFalse,
      );
    }
  });

  test('ajouterActivite adds a new activity and notifies listeners', () async {
    var notified = false;
    provider.addListener(() => notified = true);

    final initialCount = provider.toutesLesActivites.length;
    final date = DateTime.now().add(const Duration(days: 2));

    await provider.ajouterActivite(
      titre: 'Irrigation matin',
      type: TypeActivite.irrigation,
      date: date,
      zoneNom: 'Parcelle Nord',
      notes: '30 min',
    );

    expect(notified, isTrue);
    expect(provider.toutesLesActivites.length, initialCount + 1);
    expect(
      provider.toutesLesActivites.any((a) => a.titre == 'Irrigation matin'),
      isTrue,
    );
  });

  test('filtrerParType filters only matching activity type', () {
    final fertilisationList =
    provider.filtrerParType(TypeActivite.fertilisation);

    expect(fertilisationList, isNotEmpty);
    expect(
      fertilisationList.every((a) => a.type == TypeActivite.fertilisation),
      isTrue,
    );
  });

  test('modifierActivite and basculerStatut update activity properly', () async {
    final first = provider.toutesLesActivites.first;

    await provider.modifierActivite(
      first.copyWith(titre: 'Irrigation modifiée', notes: '60 min'),
    );
    await provider.basculerStatut(first.id);

    final updated =
    provider.toutesLesActivites.firstWhere((a) => a.id == first.id);
    expect(updated.titre, 'Irrigation modifiée');
    expect(updated.notes, '60 min');
    expect(updated.estTerminee, !first.estTerminee);
  });

  test('supprimerActivite removes activity by id', () async {
    final first = provider.toutesLesActivites.first;
    final initialCount = provider.toutesLesActivites.length;

    await provider.supprimerActivite(first.id);

    expect(provider.toutesLesActivites.length, initialCount - 1);
    expect(
      provider.toutesLesActivites.any((a) => a.id == first.id),
      isFalse,
    );
  });
}