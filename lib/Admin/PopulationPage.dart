import 'package:flutter/material.dart';
import 'package:josariyaw/Model/User.dart';
import 'package:josariyaw/Service/UserService.dart';
import '../Composant/Navbarlateral.dart'; // Assure-toi d'importer le Menubar

class Populationpage extends StatefulWidget {
  const Populationpage({super.key});

  @override
  State<Populationpage> createState() => _PopulationpageState();
}

class _PopulationpageState extends State<Populationpage> {
  final Userservice _userservice = Userservice();

  /* void ajouterCivil() {
    showDialog(
      context: context,
      builder: (context) => null(), // Remplace par ton formulaire d'ajout
    ).then((_) => setState(() {})); // Rafraîchir la liste après ajout
  }*/

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
                          'LISTE DES CIVILS ENREGISTRES',
                          style: TextStyle(
                            fontSize: 24,
                            color: Colors.blueAccent,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.add),
                          onPressed: null,
                          color: Colors.blueAccent,
                          tooltip: 'Ajouter un civil',
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: StreamBuilder<List<User>>(
                      stream: _userservice.RecupererCivile(),
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return Center(
                            child: Text("Erreur de chargement"),
                          );
                        }
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        if (!snapshot.hasData || snapshot.data!.isEmpty) {
                          return Center(
                            child: Text(
                              'Aucun civil enregistré.',
                              style: TextStyle(
                                  fontSize: 18, color: Colors.black54),
                            ),
                          );
                        }
                        var civil = snapshot.data!;
                        return ListView.builder(
                          padding: const EdgeInsets.all(16.0),
                          itemCount: civil.length,
                          itemBuilder: (context, index) {
                            var population = civil[index];
                            return Card(
                              color: Colors.white,
                              elevation: 4,
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
                                      ]),
                                  child: CircleAvatar(
                                    radius: 30,
                                    backgroundImage: population
                                            .imageUrl.isNotEmpty
                                        ? NetworkImage(population.imageUrl)
                                        : AssetImage(
                                                'assets/images/default_avatar.png')
                                            as ImageProvider,
                                  ),
                                ),
                                title: Text(
                                  '${population.nom} ${population.prenom}',
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
                                        population.email,
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                      SizedBox(height: 4),
                                      Text(
                                        'Adresse : ${population.adresse}',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.teal,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      }),
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
