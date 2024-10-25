import 'package:flutter/material.dart';
import 'package:josariyaw/Model/type_de_loi.dart';
import 'package:josariyaw/Service/Type_de_loiService.dart';

class FormulaireAjouteTypeDeLoi extends StatefulWidget {
  const FormulaireAjouteTypeDeLoi({Key? key}) : super(key: key);

  @override
  State<FormulaireAjouteTypeDeLoi> createState() =>
      _FormulaireAjouteTypeDeLoiState();
}

class _FormulaireAjouteTypeDeLoiState extends State<FormulaireAjouteTypeDeLoi> {
  final TextEditingController nomController = TextEditingController();
  final TypeDeLoiService typeDeLoiService = TypeDeLoiService();

  void ajouterTypeDeLoi() {
    final String nom = nomController.text.trim();
    if (nom.isNotEmpty) {
      final newTypeDeLoi = TypeDeLoi(id: '', nom: nom);
      typeDeLoiService.ajouterTypeDeLoi(newTypeDeLoi).then((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Type de loi ajouté avec succès')),
        );
        Navigator.pop(context); // Fermer le formulaire
      }).catchError((error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur : $error')),
        );
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Veuillez entrer un nom valide')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ajouter un Type de Loi'),
        backgroundColor: const Color(0xFFE1F3F3),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Ajouter un nouveau type de loi',
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: nomController,
              decoration: InputDecoration(
                labelText: 'Nom du type de loi',
                border: OutlineInputBorder(),
                hintText: 'Entrez le nom du type de loi',
                filled: true,
                fillColor: Colors.white,
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: ajouterTypeDeLoi,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  textStyle: const TextStyle(fontSize: 18),
                ),
                child: const Text(
                  'Ajouter',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
      backgroundColor: const Color(0xFFE1F3F3),
    );
  }
}
