import 'package:flutter/material.dart';
import 'package:josariyaw/Admin/DetailConseillerjuridique.dart';
import 'package:josariyaw/Composant/FormulaireAjoutConseillers.dart';
import 'package:josariyaw/Conseiller/Detailcasjuridique.dart';
import 'package:josariyaw/Model/User.dart';
import 'package:josariyaw/Service/UserService.dart';
import '../Composant/Navbarlateral.dart'; // Assure-toi d'importer le Menubar

class Conseillerspage extends StatefulWidget {
  const Conseillerspage({super.key});

  @override
  State<Conseillerspage> createState() => _ConseillerspageState();
}

class _ConseillerspageState extends State<Conseillerspage> {
  final Userservice _userservice = Userservice();

  void Ajouter_conseillers() {
    showDialog(
      context: context,
      builder: (context) => Formulaireajoutconseillers(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Menubar(), // Ajout du Menubar
          Expanded(
            child: Column(
              children: [
                Card(
                  margin: const EdgeInsets.all(16.0),
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'LISTE DES CONSEILLERS JURIDIQUE',
                          style: TextStyle(
                            fontSize: 24,
                            color: Colors.blueAccent,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.add),
                          onPressed: Ajouter_conseillers,
                          color: Colors.blueAccent,
                          tooltip: 'Ajouter un conseiller',
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: StreamBuilder<List<User>>(
                    stream: _userservice.Recupererconseillers(),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return Center(child: Text("Erreur de chargement"));
                      }

                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      }

                      if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return Center(
                          child: Text(
                            'Aucun conseiller disponible.',
                            style:
                                TextStyle(fontSize: 18, color: Colors.black54),
                          ),
                        );
                      }

                      var conseillers = snapshot.data!;
                      return ListView.builder(
                        padding: const EdgeInsets.all(16.0),
                        itemCount: conseillers.length,
                        itemBuilder: (context, index) {
                          var conseiller = conseillers[index];
                          return Card(
                            elevation: 4,
                            color: Colors.white,
                            margin: EdgeInsets.symmetric(vertical: 10),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: ListTile(
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 16),
                                leading: Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.2),
                                        spreadRadius: 2,
                                        blurRadius: 6,
                                        offset: Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: CircleAvatar(
                                    radius: 30,
                                    backgroundImage: conseiller
                                            .imageUrl.isNotEmpty
                                        ? NetworkImage(conseiller.imageUrl)
                                        : AssetImage(
                                                'assets/images/default_avatar.png')
                                            as ImageProvider,
                                  ),
                                ),
                                title: Text(
                                  '${conseiller.nom} ${conseiller.prenom}',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                                subtitle: Padding(
                                  padding: const EdgeInsets.only(top: 5.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        conseiller.email,
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                      SizedBox(height: 4),
                                      Text(
                                        'Spécialité: ${conseiller.specialite}',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.teal,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          Conseillerdetailpage(
                                              conseiller: conseiller =
                                                  conseiller),
                                    ),
                                  );
                                }),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      backgroundColor: const Color(0xFFE1F3F3),
    );
  }
}
