import 'package:flutter/material.dart';
import 'package:josariyaw/Composant/FormulaireAjouttypeloi.dart';
import 'package:josariyaw/Service/Type_de_loiService.dart';
import '../Composant/Navbarlateral.dart'; // Assure-toi d'importer le Menubar

class Typedeloipage extends StatefulWidget {
  const Typedeloipage({super.key});

  @override
  State<Typedeloipage> createState() => _TypedeloipageState();
}

class _TypedeloipageState extends State<Typedeloipage> {
  final TypeDeLoiService _typeDeLoiService = TypeDeLoiService();

  void ajouterTypeDeLoi() {
    showDialog(
      context: context,
      builder: (context) => FormulaireAjouteTypeDeLoi(),
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
                          'Liste des types de loi',
                          style: TextStyle(
                            fontSize: 24,
                            color: Colors.blueAccent,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.add),
                          onPressed: ajouterTypeDeLoi,
                          color: Colors.blueAccent,
                          tooltip: 'Ajouter un type de loi',
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: StreamBuilder(
                    stream: _typeDeLoiService.recupererTypesDeLoi(),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return Center(child: Text("Erreur de chargement"));
                      }
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      }
                      if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return Center(
                          child: Text('Aucun type de loi disponible'),
                        );
                      }
                      var typedelois = snapshot.data!;
                      return ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: typedelois.length,
                        itemBuilder: (context, index) {
                          var typedeloi = typedelois[index];
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
                              title: Text('Type de loi : ${typedeloi.nom}'),
                            ),
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
