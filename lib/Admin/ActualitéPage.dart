import 'package:flutter/material.dart';
import 'package:josariyaw/Composant/FormulaireAjoutActualite.dart';
import 'package:josariyaw/Composant/Navbarlateral.dart';
import 'package:josariyaw/Model/Actualite.dart';
import 'package:josariyaw/Service/ActualiteService.dart';

class Actualitepage extends StatefulWidget {
  const Actualitepage({super.key});

  @override
  State<Actualitepage> createState() => _ActualitepageState();
}

class _ActualitepageState extends State<Actualitepage> {
  final ActualiteService actualiteService = ActualiteService();

  void Afficherformulaire() {
    showDialog(
        context: context, builder: (context) => Formulaireajoutactualite());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Menubar(),
          Expanded(
              child: Column(
            children: [
              Card(
                margin: EdgeInsets.all(16),
                color: Colors.white,
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "LISTE DES ACTUALITES",
                        style: TextStyle(
                            fontSize: 24,
                            color: Colors.blueAccent,
                            fontWeight: FontWeight.bold),
                      ),
                      IconButton(
                        onPressed: Afficherformulaire,
                        icon: Icon(Icons.add),
                        color: Colors.blueAccent,
                        tooltip: 'Ajouter une actualité',
                      )
                    ],
                  ),
                ),
              ),
              Expanded(
                child: StreamBuilder<List<Actualite>>(
                  stream: actualiteService.recupereractualite(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      print('${snapshot.error}');
                      return Center(child: Text('Erreur de chargement'));
                    }
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child:
                            CircularProgressIndicator(color: Colors.blueAccent),
                      );
                    }
                    if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return Center(child: Text('Aucune actualité'));
                    }
                    var actualites = snapshot.data!;
                    print('Données récupérées: $actualites');
                    return ListView.builder(
                      padding: EdgeInsets.all(16),
                      itemCount: actualites.length,
                      itemBuilder: (context, index) {
                        var actualite = actualites[index];
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
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                shape: BoxShape.rectangle,
                                borderRadius: BorderRadius.circular(8),
                                image: DecorationImage(
                                  image: NetworkImage(actualite.image),
                                  fit: BoxFit.cover,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.blueAccent.withOpacity(0.2),
                                    spreadRadius: 2,
                                    blurRadius: 6,
                                    offset: Offset(0, 2),
                                  ),
                                ],
                              ),
                            ),
                            title: Text(
                              actualite.description,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ))
        ],
      ),
    );
  }
}
