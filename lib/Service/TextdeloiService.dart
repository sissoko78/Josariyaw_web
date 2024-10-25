import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:josariyaw/Model/TextLoi.dart';

class TextdeloiService {
  final CollectionReference _loisCollection =
      FirebaseFirestore.instance.collection('textes_loi');

  //methode pour ajouter text de loi
  Future<void> AjouterLoi(TextLoi textloi) async {
    try {
      await _loisCollection.add(textloi.ToFirestore());
      print('Loi ajoutez avec succès yeaaahhh!!!!!!!');
    } catch (e) {
      print(e);
    }
  }

  //methode pour afficher tous les texts de loi
  Stream<List<TextLoi>> AffichertextLoi() {
    return _loisCollection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return TextLoi.fromFirestore(
            doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
    });
  }

  //Modifier text de loi
  Future<void> Modifiertextdeloi(String id, TextLoi textloi) async {
    try {
      await _loisCollection.doc(id).update(textloi.ToFirestore());
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
