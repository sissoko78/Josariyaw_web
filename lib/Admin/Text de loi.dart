import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_icon_class/font_awesome_icon_class.dart';
import 'package:josariyaw/Composant/FormulaireAjoutetextdeloi.dart';
import 'package:josariyaw/Composant/LoiCard.dart';

class Testloi extends StatefulWidget {
  const Testloi({super.key});

  @override
  State<Testloi> createState() => _TestloiState();
}

class _TestloiState extends State<Testloi> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<String> typesDeLoi = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    obtenirTypesDeLoi().then((types) {
      setState(() {
        typesDeLoi = types;
        _tabController = TabController(length: typesDeLoi.length, vsync: this);
        isLoading = false;
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void Ajouterloitext() {
    showDialog(
      context: context,
      builder: (context) => FormulaireAjouteTexteDeLoi(),
    );
  }

  Future<List<String>> obtenirTypesDeLoi() async {
    var snapshot =
        await FirebaseFirestore.instance.collection('types_de_loi').get();
    return snapshot.docs.map((doc) => doc['nom'] as String).toList();
  }

  Stream<QuerySnapshot> obtenirTextesParType(String type) {
    return FirebaseFirestore.instance
        .collection('textes_loi')
        .where('typeloi', isEqualTo: type)
        .snapshots();
  }

  IconData getIcon(String type) {
    switch (type) {
      case 'Droit de l\'homme':
        return Icons.man;

      case 'Droit des femmes':
        return FontAwesomeIcons.personDress;
      case 'Constitution':
        return Icons.account_balance;
      case 'Droit du travail':
        return Icons.work;
      case 'Droit des enfants':
        return Icons.child_care;
      case 'Logement':
        return Icons.home;
      default:
        return Icons.article;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Texte de loi'),
        bottom: isLoading
            ? null
            : TabBar(
                controller: _tabController,
                isScrollable: true,
                tabs: typesDeLoi.map((type) => Tab(text: type)).toList(),
              ),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : TabBarView(
              controller: _tabController,
              children: typesDeLoi.map((type) {
                return StreamBuilder<QuerySnapshot>(
                  stream: obtenirTextesParType(type),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    }

                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return Center(
                        child: Text(
                          'Aucun texte de loi pour le type $type',
                          style: TextStyle(fontSize: 18, color: Colors.black54),
                        ),
                      );
                    }

                    var textesLoi = snapshot.data!.docs;
                    return ListView.separated(
                      itemCount: textesLoi.length,
                      separatorBuilder: (context, index) => Divider(height: 1),
                      itemBuilder: (context, index) {
                        var texteLoi = textesLoi[index].data() as Map;
                        return LoiCard(
                          texteLoi: texteLoi,
                          icon: getIcon(texteLoi['typeloi']),
                        );
                      },
                    );
                  },
                );
              }).toList(),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: Ajouterloitext,
        child: Icon(Icons.add),
        backgroundColor: Colors.amber,
        tooltip: 'Ajouter un texte',
      ),
      backgroundColor: const Color(0xFFE1F3F3),
    );
  }
}
