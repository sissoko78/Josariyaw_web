import 'package:cloud_firestore/cloud_firestore.dart';

import '../Model/InfractionBambara.dart';

class InfractionService {
  final CollectionReference collection =
      FirebaseFirestore.instance.collection('infractions');

  // Ajouter une infraction
  Future<void> addInfraction(Infraction infraction) async {
    await collection.doc(infraction.id).set(infraction.ToFirestore());
  }

  // Récupérer une infraction par ID
  Future<Infraction?> getInfraction(String id) async {
    DocumentSnapshot doc = await collection.doc(id).get();
    if (doc.exists) {
      return Infraction.fromFiredtore(
          doc.data() as Map<String, dynamic>, doc.id);
    }
    return null;
  }

  // Récupérer toutes les infractions
  Future<List<Infraction>> getAllInfractions() async {
    QuerySnapshot snapshot = await collection.get();
    return snapshot.docs
        .map((doc) => Infraction.fromFiredtore(
            doc.data() as Map<String, dynamic>, doc.id))
        .toList();
  }

  // Mettre à jour une infraction
  Future<void> updateInfraction(Infraction infraction) async {
    await collection.doc(infraction.id).update(infraction.ToFirestore());
  }

  // Supprimer une infraction
  Future<void> deleteInfraction(String id) async {
    await collection.doc(id).delete();
  }
}
