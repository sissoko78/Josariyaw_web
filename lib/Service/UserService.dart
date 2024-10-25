import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:josariyaw/Model/User.dart';

class Userservice {
  final CollectionReference _usersCollection =
      FirebaseFirestore.instance.collection('users');
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Méthode pour récupérer les utilisateurs ayant le rôle conseillers
  Stream<List<User>> Recupererconseillers() {
    return _usersCollection
        .where('role', isEqualTo: 'conseillers')
        .snapshots()
        .map((snapshot) {
      print(
          "Nombre de documents récupérés : ${snapshot.docs.length}"); // Debugging

      if (snapshot.docs.isEmpty) {
        print("Aucun conseiller trouvé."); // Debugging
      }

      return snapshot.docs.map((doc) {
        print("Document ID : ${doc.id}"); // Debugging
        return User.fromFirestore(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
    });
  }

  //Recupeper User par id

  Future<User?> recupererUtilisateurParId(String id) async {
    try {
      DocumentSnapshot doc = await _firestore.collection('users').doc(id).get();
      if (doc.exists) {
        return User.fromFirestore(doc.data() as Map<String, dynamic>, doc.id);
      }
    } catch (e) {
      print('Erreur lors de la récupération de l\'utilisateur: $e');
    }
    return null;
  }

  //Methode pour recuperer civile
  Stream<List<User>> RecupererCivile() {
    return _usersCollection
        .where('role', isEqualTo: 'civil')
        .snapshots()
        .map((snapshot) {
      print("Nombre de documents récupérés : ${snapshot.docs.length}");
      if (snapshot.docs.isEmpty) {
        print("Aucun civil trouvé.");
      }
      return snapshot.docs.map((doc) {
        return User.fromFirestore(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
    });
  }
}
