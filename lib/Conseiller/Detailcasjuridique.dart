import 'package:flutter/material.dart';
import 'package:josariyaw/Model/CasJurique.dart';
import 'package:josariyaw/Service/CasJuridiqueService.dart';

class DetailCasPage extends StatefulWidget {
  final CasJuridique cas;

  const DetailCasPage({Key? key, required this.cas}) : super(key: key);

  @override
  _DetailCasPageState createState() => _DetailCasPageState();
}

class _DetailCasPageState extends State<DetailCasPage> {
  final CasJuriqueService casJuridiqueService = CasJuriqueService();
  final TextEditingController titreController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  String? selectedStatut; // Pour stocker le statut sélectionné

  @override
  void initState() {
    super.initState();
    titreController.text = widget.cas.titre;
    descriptionController.text = widget.cas.description;
    selectedStatut = widget.cas.statut; // Initialiser avec le statut actuel
  }

  void _modifierCas() async {
    CasJuridique modifiedCas = CasJuridique(
      id: widget.cas.id,
      titre: titreController.text,
      description: descriptionController.text,
      statut: selectedStatut ?? widget.cas.statut, // Utiliser le nouveau statut
      expediteurId: widget.cas.expediteurId,
      conseillerId: widget.cas.conseillerId,
    );

    await casJuridiqueService.Envoiecasjuridique(modifiedCas);
    Navigator.pop(context); // Retour à la page précédente
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Détails du cas'),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _modifierCas,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: titreController,
              decoration: InputDecoration(labelText: 'Titre'),
            ),
            TextField(
              controller: descriptionController,
              decoration: InputDecoration(labelText: 'Description'),
              maxLines: 5,
            ),
            SizedBox(height: 16), // Espacement
            DropdownButton<String>(
              value: selectedStatut,
              onChanged: (String? newValue) {
                setState(() {
                  selectedStatut = newValue;
                });
              },
              items: <String>['En cour', 'Accepté', 'Résolu', 'Réfusé']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              hint: Text('Sélectionnez un statut'),
              isExpanded: true, // Pour un meilleur affichage
            ),
          ],
        ),
      ),
    );
  }
}
