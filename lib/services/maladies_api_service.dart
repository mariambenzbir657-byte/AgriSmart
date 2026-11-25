
import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:agrismart/config.dart';
import 'package:agrismart/models/maladie.dart';

class MaladiesApiService {
  final Uri _base = Uri.parse('$apiUrl/maladies');

  final Map<String, String> _entetes = {
    'Content-Type': 'application/json',
  };

  // Lister les maladies
  Future<List<Maladie>> lister() async {
    final r = await http
        .get(_base)
        .timeout(const Duration(seconds: 10));

    if (r.statusCode != 200) {
      throw Exception('Erreur serveur (${r.statusCode}) : ${r.body}');
    }

    final liste = jsonDecode(r.body) as List<dynamic>;

    return liste
        .map((e) => Maladie.fromMap(
      Map<String, dynamic>.from(e),
    ))
        .toList();
  }

  // Ajouter une maladie
  Future<void> ajouter(Maladie m) async {
    final r = await http.post(
      _base,
      headers: _entetes,
      body: jsonEncode(m.toMap()),
    );

    if (r.statusCode != 201) {
      throw Exception('Ajout impossible (${r.statusCode}) : ${r.body}');
    }
  }

  // Modifier une maladie
  Future<void> modifier(Maladie m) async {
    final r = await http.put(
      Uri.parse('$apiUrl/maladies/${m.id}'),
      headers: _entetes,
      body: jsonEncode(m.toMap()),
    );

    if (r.statusCode != 200) {
      throw Exception('Modification impossible (${r.statusCode}) : ${r.body}');
    }
  }

  // Supprimer une maladie
  Future<void> supprimer(String id) async {
    final r = await http.delete(
      Uri.parse('$apiUrl/maladies/$id'),
    );

    if (r.statusCode != 204) {
      throw Exception('Suppression impossible (${r.statusCode}) : ${r.body}');
    }
  }
}
