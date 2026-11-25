
import 'package:flutter/material.dart';

class VanneCard extends StatelessWidget {
  final String zoneNom;
  final bool vanneOuverte;
  final VoidCallback onToggle;

  const VanneCard({
    super.key,
    required this.zoneNom,
    required this.vanneOuverte,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor:
          vanneOuverte ? Colors.green.shade100 : Colors.grey.shade200,
          child: Icon(
            Icons.water,
            color: vanneOuverte ? Colors.green : Colors.grey,
          ),
        ),
        title: Text(
          zoneNom,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          vanneOuverte ? 'Vanne ouverte' : 'Vanne fermée',
        ),
        trailing: Switch(
          value: vanneOuverte,
          activeColor: Colors.green,
          onChanged: (_) => onToggle(),
        ),
      ),
    );
  }
}
