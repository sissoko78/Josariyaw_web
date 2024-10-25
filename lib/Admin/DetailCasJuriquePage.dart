import 'package:flutter/material.dart';
import '../Model/CasJurique.dart';
import '../Model/User.dart';
import '../Service/CasJuridiqueService.dart';
import '../Service/UserService.dart';

class DetailCasJuriquePage extends StatefulWidget {
  final String casId;

  const DetailCasJuriquePage({Key? key, required this.casId}) : super(key: key);

  @override
  _DetailCasJuriquePageState createState() => _DetailCasJuriquePageState();
}

class _DetailCasJuriquePageState extends State<DetailCasJuriquePage> {
  final CasJuriqueService casJuridiqueService = CasJuriqueService();
  final Userservice userService = Userservice();
  CasJuridique? casJuridique;
  User? conseiller;
  User? expediteur;

  @override
  void initState() {
    super.initState();
    _fetchCasJuridique();
  }

  Future<void> _fetchCasJuridique() async {
    try {
      casJuridique =
          await casJuridiqueService.recupererCasJuridiqueParId(widget.casId);
      if (casJuridique != null) {
        conseiller = await userService
            .recupererUtilisateurParId(casJuridique!.conseillerId);
        User? utilisateur = await userService.recupererUtilisateurParId(
            casJuridique!
                .expediteurId); // Récupérer l'utilisateur qui a soumis le cas
        setState(() {
          this.expediteur =
              utilisateur; // Mettez à jour l'état avec l'utilisateur
        });
      }
      setState(() {});
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Détails du cas juridique',
            style: TextStyle(color: Colors.black)),
        backgroundColor: const Color(0xFFE1F3F3),
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: casJuridique == null
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Section Titre
                    Card(
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              casJuridique!.titre,
                              style: TextStyle(
                                fontSize: 26,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            SizedBox(height: 8),
                            Row(
                              children: [
                                Icon(Icons.rotate_left, color: Colors.grey),
                                SizedBox(width: 8),
                                Text(
                                  'Statut: ${casJuridique!.statut}',
                                  style: TextStyle(fontSize: 16),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),

                    SizedBox(height: 16),

                    // Section Description
                    Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Description',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.teal,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              casJuridique!.description,
                              style: TextStyle(fontSize: 16, height: 1.4),
                            ),
                          ],
                        ),
                      ),
                    ),

                    SizedBox(height: 16),

                    // Section Conseiller
                    Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.person, color: Colors.grey),
                                SizedBox(width: 8),
                                Text(
                                  'Conseiller en charge',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blueAccent,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 8),
                            Text(
                              '${conseiller?.nom ?? "Inconnu"} ${conseiller?.prenom ?? "Inconnu"}',
                              style: TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                    ),

                    SizedBox(height: 16),

                    // Section Soumis par
                    Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.person, color: Colors.grey),
                                SizedBox(width: 8),
                                Text(
                                  'Soumis par',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blueAccent,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 8),
                            Text(
                              '${expediteur?.nom ?? "Inconnu"} ${expediteur?.prenom ?? "Inconnu"}',
                              style: TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                    ),

                    SizedBox(height: 16),

                    // Section Historique des Statuts
                    Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Historique des statuts',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 8),
                            if (casJuridique!.historiqueStatuts.isEmpty)
                              Text(
                                'Aucun historique trouvé.',
                                style:
                                    TextStyle(fontSize: 16, color: Colors.grey),
                              )
                            else
                              for (var historique
                                  in casJuridique!.historiqueStatuts)
                                Text(
                                  'Statut: ${historique['statut']} - Date: ${historique['date']}',
                                  style: TextStyle(fontSize: 16),
                                ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
