
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:josariyaw/Model/Actualite.dart';

class ActualiteService{

  FirebaseFirestore _firebaseFirestore= FirebaseFirestore.instance;

  // Ajouter une actualité
Future<void> AjouterActu(Actualite actualite) async{
  try{
    await _firebaseFirestore
        .collection('actualites')
        .doc(actualite.id)
        .set(actualite.Tofirestore());
  } catch (e) {
    print(e);
  }
}

Stream <List<Actualite>> recupereractualite(){
  return _firebaseFirestore.collection('actualites').snapshots().map((snapshot){
    print('Nombre d\'actualité recupéré: ${snapshot.docs.length}');
    return snapshot.docs
        .map((doc)=>Actualite.fromFirestore(
      doc.data() as Map<String, dynamic>, doc.id))
        .toList();
  });
}
  Future <void> supprimeractualite(String id) async{
  await _firebaseFirestore.collection('actualites').doc(id).delete();
  }

  Future <void> modifieractualite(Actualite actualite) async{
  await _firebaseFirestore.collection('actualites').doc(actualite.id).update(actualite.Tofirestore());
  }


}