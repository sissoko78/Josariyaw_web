import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class PageTextesDeLoi extends StatelessWidget {
  final String typeDeLoi; // Type de loi à filtrer

  const PageTextesDeLoi({super.key, required this.typeDeLoi});

  // Fonction pour obtenir les textes de loi par type
  Stream<QuerySnapshot> obtenirTextesParType(String type) {
    return FirebaseFirestore.instance
        .collection('textes_loi')
        .where('typeloi', isEqualTo: type)
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Textes de loi - $typeDeLoi'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: obtenirTextesParType(typeDeLoi),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Text(
                'Aucun texte de loi pour le type $typeDeLoi',
                style: const TextStyle(fontSize: 18, color: Colors.black54),
              ),
            );
          }

          var textesLoi = snapshot.data!.docs;

          return ListView.separated(
            itemCount: textesLoi.length,
            separatorBuilder: (context, index) => const Divider(height: 1),
            itemBuilder: (context, index) {
              var texteLoi = textesLoi[index].data() as Map;
              return ListTile(
                title: Text(texteLoi['titre'] ?? 'Titre du texte'),
                subtitle: Text(texteLoi['description'] ?? 'Description...'),
              );
            },
          );
        },
      ),
    );
  }
}
