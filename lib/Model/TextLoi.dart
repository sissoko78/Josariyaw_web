import 'package:cloud_firestore/cloud_firestore.dart';

class TextLoi {
  String id;
  String article;
  String description;
  String typeloi;

  TextLoi(
      {required this.id,
      required this.article,
      required this.description,
      required this.typeloi});

// methode pour convertir un document firestore en instance de User
  factory TextLoi.fromFirestore(Map<String, dynamic> data, String id) {
    return TextLoi(
        id: id,
        article: data['article'],
        description: data['description'],
        typeloi: data['typeloi']);
  }

  //methode pour convertir un text de loi en doc firestore
  Map<String, dynamic> ToFirestore() {
    return {'article': article, 'description': description, 'typeloi': typeloi};
  }
}
