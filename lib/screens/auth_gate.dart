
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:agrismart/providers/auth_provider.dart';
import 'package:agrismart/screens/app_shell.dart';
import 'package:agrismart/screens/connexion_page.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    // 1. Attente de l'initialisation
    if (!auth.initialise) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    // 2. Utilisateur non connecté
    if (!auth.connecte) {
      return const ConnexionPage();
    }

    // 3. Utilisateur connecté
    return const AppShell();
  }
}
