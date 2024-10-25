import 'package:cloud_firestore/cloud_firestore.dart';
import '../Model/type_de_loi.dart';

class TypeDeLoiService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Ajouter un nouveau type de loi
  Future<void> ajouterTypeDeLoi(TypeDeLoi typeDeLoi) {
    return _firestore.collection('types_de_loi').add(typeDeLoi.toFirestore());
  }

  // Récupérer tous les types de loi
  Stream<List<TypeDeLoi>> recupererTypesDeLoi() {
    return _firestore.collection('types_de_loi').snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => TypeDeLoi.fromFirestore(
              doc.data() as Map<String, dynamic>, doc.id))
          .toList();
    });
  }

  // Mettre à jour un type de loi
  Future<void> mettreAJourTypeDeLoi(String id, TypeDeLoi typeDeLoi) {
    return _firestore
        .collection('types_de_loi')
        .doc(id)
        .update(typeDeLoi.toFirestore());
  }

  // Supprimer un type de loi
  Future<void> supprimerTypeDeLoi(String id) {
    return _firestore.collection('types_de_loi').doc(id).delete();
  }
}
