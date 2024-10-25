import 'package:flutter/material.dart';
import 'package:josariyaw/Composant/Navbarlateral.dart';
import 'package:josariyaw/Model/CasJurique.dart';
import 'package:josariyaw/Service/CasJuridiqueService.dart';

import 'DetailCasJuriquePage.dart';

class Casjuridiquepage extends StatefulWidget {
  const Casjuridiquepage({super.key});

  @override
  State<Casjuridiquepage> createState() => _CasjuridiquepageState();
}

class _CasjuridiquepageState extends State<Casjuridiquepage> {
  final CasJuriqueService _casJuriqueService = CasJuriqueService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(children: [
        Menubar(),
        Expanded(
            child: Column(children: [
          Card(
            margin: EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  " LISTE DES CAS JURIDIQUES",
                  style: TextStyle(
                      fontSize: 24,
                      color: Colors.blueAccent,
                      fontWeight: FontWeight.bold),
                ),
                IconButton(
                  onPressed: null,
                  icon: Icon(Icons.add),
                  color: Colors.blueAccent,
                  tooltip: 'Ajouter cas juridique',
                )
              ],
            ),
          ),
          Expanded(
            child: StreamBuilder<List<CasJuridique>>(
              stream: _casJuriqueService.recupererlesCas(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(
                    child: Text("Erreur de chargement: ${snapshot.error}"),
                  );
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(
                    child: Text("Aucun cas juridique trouvé"),
                  );
                }

                var casjuridiques = snapshot.data!;
                return ListView.builder(
                  padding: EdgeInsets.all(16),
                  itemCount: casjuridiques.length,
                  itemBuilder: (context, index) {
                    var casjuridique = casjuridiques[index];
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
                          title: Text(casjuridique.titre),
                          subtitle: Padding(
                            padding: EdgeInsets.only(top: 5.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(casjuridique.description,
                                    style: TextStyle(fontSize: 14)),
                                SizedBox(height: 4),
                                Text("Statut: ${casjuridique.statut}",
                                    style: TextStyle(fontSize: 14)),
                              ],
                            ),
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DetailCasJuriquePage(
                                    casId: casjuridique.id),
                              ),
                            );
                          }),
                    );
                  },
                );
              },
            ),
          )
        ]))
      ]),
      backgroundColor: const Color(0xFFE1F3F3),
    );
  }
}
