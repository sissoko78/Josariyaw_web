import 'package:flutter/material.dart';
import 'package:josariyaw/Model/CasJurique.dart';
import 'package:josariyaw/Service/AuthentificationService.dart';
import 'package:josariyaw/Service/CasJuridiqueService.dart';

class Suiviscaspage extends StatefulWidget {
  const Suiviscaspage({super.key});

  @override
  State<Suiviscaspage> createState() => _SuiviscaspageState();
}

class _SuiviscaspageState extends State<Suiviscaspage> {
  final CasJuriqueService casJuridiqueService = CasJuriqueService();
  final AuthService authService = AuthService();
  String? expediteurId; // ID de l'utilisateur connecté

  @override
  void initState() {
    super.initState();
    // Obtenir l'ID de l'utilisateur connecté
    expediteurId = authService.getCurrentUserId();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Liste des cas juridiques soumis'),
        backgroundColor: const Color(0xFFE1F3F3),
      ),
      body: StreamBuilder<List<CasJuridique>>(
        stream: expediteurId != null
            ? casJuridiqueService.recupererCasParExpediteur(expediteurId!)
            : Stream.value([]),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text("Erreur de chargement"));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasData && snapshot.data!.isNotEmpty) {
            // Afficher la liste des cas juridiques
            return ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                CasJuridique cas = snapshot.data![index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8.0),
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16.0),
                    title: Text(
                      cas.titre,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    subtitle: Text(
                      cas.description,
                      style: TextStyle(
                        color: Colors.grey[700],
                      ),
                    ),
                    trailing: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8.0, vertical: 4.0),
                      decoration: BoxDecoration(
                        color: _getStatutColor(cas.statut),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        cas.statut,
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    leading: Icon(Icons.gavel, color: Colors.blue),
                    onTap: () {
                      // Action lorsque l'utilisateur tape sur un cas
                    },
                  ),
                );
              },
            );
          } else {
            return Center(child: Text("Aucun cas soumis."));
          }
        },
      ),
    );
  }

  Color _getStatutColor(String statut) {
    switch (statut) {
      case 'Soumis mais pas encore accepté':
        return Colors.orange;
      case 'Accepté':
        return Colors.green;
      case 'Résolu':
        return Colors.green;
      case 'Réfusé':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}
