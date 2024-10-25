import 'package:flutter/material.dart';

class BoxDashbord extends StatelessWidget {
  final String title;
  final IconData icon;

  const BoxDashbord({
    super.key,
    required this.title,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        color: Colors.white,
        child: Column(
          children: [
            SizedBox(height: 20),
            Icon(icon, size: 40, color: Colors.blue), // Affiche l'icône
            SizedBox(height: 8), // Espacement entre l'icône et le texte
            Text(
              title,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
