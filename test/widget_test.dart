import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:agrismart/main.dart';
import 'package:agrismart/providers/calendar_provider.dart';
import 'package:agrismart/providers/zones_provider.dart';

Widget _buildTestApp() {
  return MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => ZonesProvider()),
      ChangeNotifierProvider(create: (_) => CalendarProvider()),
    ],
    child: const AgriSmartApp(),
  );
}

void main() {
  testWidgets('AgriSmart loads zones, opens add zone dialog, and switches tabs',
          (WidgetTester tester) async {
        await tester.pumpWidget(_buildTestApp());
        await tester.pumpAndSettle();

        // Vérifie l'affichage initial des zones
        expect(find.text('AgriSmart'), findsOneWidget);
        expect(find.textContaining('Parcelle Nord'), findsOneWidget);

        // Ouvre le formulaire d'ajout de zone via le bouton '+'
        await tester.tap(find.byIcon(Icons.add));
        await tester.pumpAndSettle();

        expect(find.text('Nouvelle zone agricole'), findsOneWidget);

        // Ferme le dialogue
        await tester.tap(find.text('Annuler'));
        await tester.pumpAndSettle();

        // Passe à l'onglet Calendrier
        await tester.tap(find.text('Calendrier'));
        await tester.pumpAndSettle();

        expect(find.text('Planifier'), findsOneWidget);
        expect(find.textContaining('Irrigation goutte-à-goutte'), findsOneWidget);
      });
}
