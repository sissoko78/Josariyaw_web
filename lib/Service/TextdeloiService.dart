import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:josariyaw/Model/TextLoi.dart';

class TextdeloiService {
  final CollectionReference _loisCollection =
      FirebaseFirestore.instance.collection('textes_loi');

  //methode pour ajouter text de loi
  Future<void> AjouterLoi(TextLoi textloi) async {
    try {
      final textLoiData = textloi.toFirestore();
      textLoiData['date'] = Timestamp.now(); // Ajoute la date actuelle

      await _loisCollection.add(textLoiData);
      print('Loi ajoutée avec succès !');
    } catch (e) {
      print('Erreur lors de l\'ajout de la loi: $e');
    }
  }

  //methode pour afficher tous les texts de loi
  Stream<List<TextLoi>> afficherTextLoi() {
    return _loisCollection.snapshots().map((snapshot) {
      // Transformer les documents en instances de TextLoi
      List<TextLoi> lois = snapshot.docs.map((doc) {
        return TextLoi.fromFirestore(
            doc.data() as Map<String, dynamic>, doc.id);
      }).toList();

      // Trier la liste localement par le numéro d'article
      lois.sort((a, b) {
        int numeroA = int.parse(a.article.replaceAll(RegExp(r'[^0-9]'), ''));
        int numeroB = int.parse(b.article.replaceAll(RegExp(r'[^0-9]'), ''));
        return numeroA.compareTo(numeroB);
      });

      return lois;
    });
  }

  //Modifier text de loi
  Future<void> Modifiertextdeloi(String id, TextLoi textloi) async {
    try {
      await _loisCollection.doc(id).update(textloi.toFirestore());
      print('yeahhhh modifier avec succès');
    } catch (e) {
      print(e);
    }
  }

  //Supprimer Text de loi

  Future<void> SupprimerTextdeloi(String id) async {
    try {
      await _loisCollection.doc(id).delete();
      print("Yeahhhhh Supprimé avec succès");
    } catch (e) {
      print(e);
    }
  }
}
