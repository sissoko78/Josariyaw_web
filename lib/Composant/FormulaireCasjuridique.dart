import 'package:flutter/material.dart';
import 'package:josariyaw/Composant/Formulaire.dart';
import 'package:josariyaw/Model/CasJurique.dart';
import 'package:josariyaw/Service/AuthentificationService.dart';
import 'package:josariyaw/Service/CasJuridiqueService.dart';

class Formulairecasjuridique extends StatefulWidget {
  final String conseillerId;
  const Formulairecasjuridique({super.key, required this.conseillerId});

  @override
  State<Formulairecasjuridique> createState() => _FormulairecasjuridiqueState();
}

class _FormulairecasjuridiqueState extends State<Formulairecasjuridique> {
  final titrecontroller = TextEditingController();
  final descriptioncontroller = TextEditingController();
  final CasJuriqueService casJuridiqueService = CasJuriqueService();
  final AuthService authService = AuthService();

  Future<void> Soumettrecas() async {
    String titre = titrecontroller.text.trim();
    String description = descriptioncontroller.text.trim();
    String? userId = authService.getCurrentUserId();
    if (titre.isNotEmpty && description.isNotEmpty && userId != null) {
      // créer une nouvelle instance de mon cas juridique
      CasJuridique casJuridique = CasJuridique(
          id: DateTime.now()
              .millisecondsSinceEpoch
              .toString(), // va me permettre de créer un ID unique
          titre: titre,
          description: description,
          statut: 'Soumis mais pas encore accepté',
          expediteurId: userId,
          conseillerId: widget.conseillerId);
      try {
        await casJuridiqueService.Envoiecasjuridique(casJuridique);
        Navigator.pop(context);
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Cas soumis avec succès!')));
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Erreur lors de l\'envoi du cas: $e')));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Veuillez remplir tous les champs.')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Soumettre un cas '),
          backgroundColor: const Color(0xFFE1F3F3),
        ),
        body: SingleChildScrollView(
            child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Formulaire(
                          controller: titrecontroller,
                          hintText: 'Titre ou Motif'),
                      const SizedBox(height: 30),
                      Formulaire(
                        controller: descriptioncontroller,
                        hintText: 'Description de votre problème',
                      ),
                      const SizedBox(height: 30),
                      Center(
                        child: ElevatedButton(
                            onPressed: Soumettrecas,
                            child: Text('Envoyer le cas')),
                      )
                    ]))));
  }
}
