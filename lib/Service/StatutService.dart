import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:josariyaw/Model/Statut.dart';

class StatutService {
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  Future<List<Statut>> recupererStatuts() async {
    QuerySnapshot snapshot =
        await firebaseFirestore.collection('statuts').get();
    return snapshot.docs.map((doc) {
      return Statut(id: doc.id, nom: doc['nom']);
    }).toList();
  }
}
