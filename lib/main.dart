import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart'; // NOUVEAU
import 'package:intl/date_symbol_data_local.dart'; // NOUVEAU
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:agrismart/config.dart';
import 'package:agrismart/firebase_options.dart';
import 'package:agrismart/providers/auth_provider.dart';
import 'package:agrismart/providers/irrigation_provider.dart';
import 'package:agrismart/providers/maladies_provider.dart';
import 'package:agrismart/providers/meteo_provider.dart';
import 'package:agrismart/providers/reglages_provider.dart';
import 'package:agrismart/providers/zones_provider.dart';
import 'package:agrismart/screens/auth_gate.dart';
import 'package:agrismart/services/auth_locale_service.dart';
import 'package:agrismart/services/auth_service.dart';
import 'package:agrismart/services/firebase_auth_service.dart';
import 'package:agrismart/services/maladies_api_service.dart';
import 'package:agrismart/theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // NOUVEAU : dates en français pour le calendrier
  await initializeDateFormatting('fr_FR');

  final AuthService authService;
  if (utiliserFirebase) {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    authService = FirebaseAuthService();
  } else {
    authService = AuthLocaleService();
  }

  final prefs = await SharedPreferences.getInstance();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider(authService)),
        ChangeNotifierProvider(create: (_) => ReglagesProvider(prefs)),
        ChangeNotifierProvider(
          create: (context) =>
              ZonesProvider(prefs, context.read<AuthProvider>()),
        ),
        ChangeNotifierProvider(create: (_) => MeteoProvider(prefs)..charger()),
        ChangeNotifierProvider(
          create: (_) => MaladiesProvider(MaladiesApiService())..charger(),
        ),
        ChangeNotifierProvider(create: (_) => IrrigationProvider()),
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
      debugShowCheckedModeBanner: false,
      title: 'AgriSmart',
      theme: AppTheme.clair(),
      darkTheme: AppTheme.sombre(),
      themeMode: context.watch<ReglagesProvider>().themeMode,

      // NOUVEAU : localisation française
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('fr', 'FR')],
      locale: const Locale('fr', 'FR'),

      home: const AuthGate(),
    );
  }
}