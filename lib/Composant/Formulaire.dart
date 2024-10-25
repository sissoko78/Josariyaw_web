import 'package:flutter/material.dart';

class Formulaire extends StatefulWidget {
  final TextEditingController controller; // Pour récupérer les données saisies
  final String hintText; // Nom du champ
  final bool obscureText; // Pour masquer le texte (mot de passe)
  final IconData? icon; // Icône du champ

  Formulaire({
    super.key,
    required this.controller,
    required this.hintText,
    this.obscureText = false,
    this.icon,
  });

  @override
  State<Formulaire> createState() => _FormulaireState();
}

class _FormulaireState extends State<Formulaire> {
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      obscureText: widget.obscureText,
      decoration: InputDecoration(
        prefixIcon: widget.icon != null ? Icon(widget.icon) : null,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide(color: Colors.blueGrey),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide(color: Colors.blue),
        ),
        fillColor: Colors.white,
        filled: true,
        hintText: widget.hintText,
      ),
    );
  }
}
