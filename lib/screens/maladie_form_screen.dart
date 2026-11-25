import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:agrismart/models/maladie.dart';
import 'package:agrismart/providers/maladies_provider.dart';

class MaladieFormScreen extends StatefulWidget {
  // null = nouvelle maladie, sinon = modification
  final Maladie? maladie;

  const MaladieFormScreen({super.key, this.maladie});

  @override
  State<MaladieFormScreen> createState() => _MaladieFormScreenState();
}

class _MaladieFormScreenState extends State<MaladieFormScreen> {
  late final TextEditingController _nom;
  late final TextEditingController _plante;
  late final TextEditingController _symptomes;
  late final TextEditingController _traitement;
  late String _gravite;
  late DateTime _date;

  bool get _modification => widget.maladie != null;

  @override
  void initState() {
    super.initState();
    final m = widget.maladie;
    _nom = TextEditingController(text: m?.nom ?? '');
    _plante = TextEditingController(text: m?.plante ?? '');
    _symptomes = TextEditingController(text: m?.symptomes ?? '');
    _traitement = TextEditingController(text: m?.traitement ?? '');
    _gravite = m?.gravite ?? 'moyenne';
    _date = m?.date ?? DateTime.now();
  }

  @override
  void dispose() {
    _nom.dispose();
    _plante.dispose();
    _symptomes.dispose();
    _traitement.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final d = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (d != null) setState(() => _date = d);
  }

  void _save() {
    if (_nom.text.trim().isEmpty || _plante.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Nom et plante obligatoires')),
      );
      return;
    }

    final maladie = Maladie(
      // en modification on garde le meme id
      id: widget.maladie?.id ??
          DateTime.now().millisecondsSinceEpoch.toString(),
      nom: _nom.text.trim(),
      plante: _plante.text.trim(),
      symptomes: _symptomes.text.trim(),
      traitement: _traitement.text.trim(),
      gravite: _gravite,
      date: _date,
    );

    final provider = context.read<MaladiesProvider>();
    if (_modification) {
      provider.modifier(maladie);
    } else {
      provider.ajouter(maladie);
    }
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_modification ? 'Modifier la maladie' : 'Nouvelle maladie'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _nom,
              decoration: const InputDecoration(
                labelText: 'Nom de la maladie (ex: Mildiou)',
              ),
            ),
            TextField(
              controller: _plante,
              decoration: const InputDecoration(
                labelText: 'Plante touchée (ex: Tomate)',
              ),
            ),
            TextField(
              controller: _symptomes,
              maxLines: 3,
              decoration: const InputDecoration(labelText: 'Symptômes'),
            ),
            TextField(
              controller: _traitement,
              maxLines: 3,
              decoration: const InputDecoration(labelText: 'Traitement'),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              initialValue: _gravite,
              decoration: const InputDecoration(labelText: 'Gravité'),
              items: const [
                DropdownMenuItem(value: 'faible', child: Text('Faible')),
                DropdownMenuItem(value: 'moyenne', child: Text('Moyenne')),
                DropdownMenuItem(value: 'elevee', child: Text('Élevée')),
              ],
              onChanged: (v) => setState(() => _gravite = v ?? 'moyenne'),
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text('Date : ${_date.toString().split(' ')[0]}'),
              trailing: const Icon(Icons.calendar_today),
              onTap: _pickDate,
            ),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: _save,
              child: Text(_modification ? 'Mettre à jour' : 'Enregistrer'),
            ),
          ],
        ),
      ),
    );
  }
}