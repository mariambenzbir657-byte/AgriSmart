# AgriSmart

Application mobile Flutter de gestion et de suivi des exploitations agricoles (Atelier Framework Cross-Platform | DSI31 - DSI32).

## Fonctionnalités

- **Authentification avec Firebase**
- **Gestion des zones agricoles (CRUD)**
- **Dashboard et navigation multi-onglets**
- **Informations météorologiques via API**
- **Calendrier agricole (Membre 4)** :
    - Planification des activités agricoles (`Irrigation`, `Fertilisation`, `Semis`, `Récolte`, `Autre`) avec date et heure.
    - Association de chaque activité à une zone agricole et ajout de notes/dosage.
    - Affichage des événements à venir triés par date, filtrage par type, marquage comme terminée, modification et suppression.
    - Gestion d'état avec `Provider` (`CalendarProvider`) et synchronisation avec **Cloud Firestore** (collection `activites_agricoles`).
- **Autres modules du plan d'équipe** :
    - Historique d'irrigation (Membre 1)
    - Notifications intelligentes (Membre 2)
    - Scanner QR Code avec Google ML Kit (Membre 3)

## Structure du projet (Calendrier agricole)

- `lib/models/activite.dart` : modèle `ActiviteAgricole` et énumération `TypeActivite` (`toMap` / `fromMap`).
- `lib/providers/calendar_provider.dart` : gestion d'état (`ChangeNotifier`) et intégration Firestore.
- `lib/screens/calendar_page.dart` : interface utilisateur du calendrier agricole.
- `test/calendar_provider_test.dart` : tests unitaires de `CalendarProvider`.

## Exécution et tests

```bash
flutter pub get
flutter analyze
flutter test
---

### 6. L'exécution finale fil terminal (`C:\projets\AgriSmart-Git`)
Baad ma tcopier les fichiers w tsavegi (`Ctrl + S`), chaghel l'awamer hedhom b tartib:

```powershell
flutter pub get
flutter analyze
flutter test
git add .
git commit -m "Complete Member 4 agricultural calendar with Firestore and README"
git push
git checkout main
git merge facture/achraf
git push origin main
git checkout facture/achraf