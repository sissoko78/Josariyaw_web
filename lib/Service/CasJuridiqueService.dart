import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:josariyaw/Model/CasJurique.dart';

class CasJuriqueService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  //ma methode pour envoyer un cas
  Future<void> Envoiecasjuridique(CasJuridique casjurique) async {
    try {
      await _firestore
          .collection('cas_juridiques')
          .doc(casjurique.id)
          .set(casjurique.Tofirestore());
    } catch (e) {
      print(e);
    }
  }

  //ma methode pour recuperer tous les cas juridique
  Future<List<CasJuridique>> recupererCasJuridiques() async {
    try {
      QuerySnapshot querySnapshot =
          await _firestore.collection('cas_juridiques').get();
      return querySnapshot.docs.map((doc) {
        return CasJuridique.fromFirestore(
            doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
    } catch (e) {
      throw Exception('Erreur lors de la récupération des cas juridiques: $e');
    }
  }

  // Méthode pour récupérer un cas juridique spécifique par son ID
  Future<CasJuridique?> recupererCasJuridiqueParId(String id) async {
    try {
      DocumentSnapshot doc =
          await _firestore.collection('cas_juridiques').doc(id).get();
      if (doc.exists) {
        return CasJuridique.fromFirestore(
            doc.data() as Map<String, dynamic>, doc.id);
      }
    } catch (e) {
      throw Exception('Erreur lors de la récupération du cas juridique: $e');
    }
    return null; // Retourne null si le cas n'existe pas
  }

  Stream<List<CasJuridique>> recupererlesCas() {
    return _firestore.collection('cas_juridiques').snapshots().map((snapshot) {
      print(
          "Nombre de documents: ${snapshot.docs.length}"); // Ajoute cette ligne
      return snapshot.docs
          .map((doc) => CasJuridique.fromFirestore(
              doc.data() as Map<String, dynamic>, doc.id))
          .toList();
    });
  }

  // Méthode pour récupérer les cas juridiques envoyés par un civil (expéditeur)
  Stream<List<CasJuridique>> recupererCasParExpediteur(String expediteurId) {
    return _firestore
        .collection('cas_juridiques')
        .where('expediteurId', isEqualTo: expediteurId)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return CasJuridique.fromFirestore(
            doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
    });
  }

  // Méthode pour récupérer les cas juridiques reçus par un conseiller
  Stream<List<CasJuridique>> recupererCasParConseiller(String userId) {
    return _firestore
        .collection('cas_juridiques')
        .where('conseillerId',
            isEqualTo:
                userId) // Assurez-vous que cette clé existe dans Firestore
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return CasJuridique.fromFirestore(
            doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
    });
  }
}
