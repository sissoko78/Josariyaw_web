import 'package:flutter/material.dart';
import 'package:josariyaw/Composant/Formulaire.dart';
import 'package:josariyaw/Model/TextLoi.dart';
import 'package:josariyaw/Model/type_de_loi.dart';
import 'package:josariyaw/Service/TextdeloiService.dart';
import 'package:josariyaw/Service/Type_de_loiService.dart'; // Importez le service

class FormulaireAjouteTexteDeLoi extends StatefulWidget {
  const FormulaireAjouteTexteDeLoi({super.key});

  @override
  State<FormulaireAjouteTexteDeLoi> createState() =>
      _FormulaireAjouteTexteDeLoiState();
}

class _FormulaireAjouteTexteDeLoiState
    extends State<FormulaireAjouteTexteDeLoi> {
  final articleController = TextEditingController();
  final descriptionController = TextEditingController();
  String? _typeLoi; // Maintenant nullable
  final TextdeloiService textdeloiService = TextdeloiService();
  final TypeDeLoiService typeDeLoiService = TypeDeLoiService();
  List<TypeDeLoi> typesDeLoi = []; // Liste pour stocker les types de loi

  @override
  void initState() {
    super.initState();
    // Récupérez les types de loi
    typeDeLoiService.recupererTypesDeLoi().listen((data) {
      setState(() {
        typesDeLoi = data;
        _typeLoi = typesDeLoi.isNotEmpty
            ? typesDeLoi[0].nom
            : null; // Valeur par défaut
      });
    });
  }

  // Méthode pour soumettre le texte de loi
  void AjouterTextloi() {
    final newtextloi = TextLoi(
      id: '',
      article: articleController.text,
      description: descriptionController.text,
      typeloi: _typeLoi ?? 'Droit de l\'homme', // Valeur par défaut si null
    );

    textdeloiService.AjouterLoi(newtextloi).then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Texte de loi ajouté avec succès')),
      );
    }).catchError((e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur : $e')),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ajouter un nouveau texte de loi'),
        backgroundColor: const Color(0xFFE1F3F3),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Formulaire(controller: articleController, hintText: 'Article'),
              const SizedBox(height: 30),
              Formulaire(
                controller: descriptionController,
                hintText: 'Description de la loi',
              ),
              const SizedBox(height: 30),
              DropdownButton<String>(
                value: _typeLoi,
                items: typesDeLoi.map((TypeDeLoi type) {
                  return DropdownMenuItem<String>(
                    value: type.nom,
                    child: Text(type.nom),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _typeLoi = newValue;
                  });
                },
                hint: const Text('Sélectionner le type de loi'),
              ),
              const SizedBox(height: 30),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    AjouterTextloi();
                  },
                  child: const Text('Ajouter un nouveau'),
                ),
              ),
            ],
          ),
        ),
      ),
      backgroundColor: const Color(0xFFE1F3F3),
    );
  }
}
