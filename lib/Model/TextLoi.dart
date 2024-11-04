import 'package:cloud_firestore/cloud_firestore.dart';

class TextLoi {
  String id;
  String article;
  String description;
  String typeloi;
  String descriptionvocal;
  Timestamp date;

  TextLoi({
    required this.id,
    required this.article,
    required this.description,
    required this.typeloi,
    required this.descriptionvocal,
    required this.date,
  });

  // Méthode pour convertir un document Firestore en instance de TextLoi
  factory TextLoi.fromFirestore(Map<String, dynamic> data, String id) {
    return TextLoi(
      id: id,
      article: data['article'],
      description: data['description'],
      typeloi: data['typeloi'],
      descriptionvocal: data['descriptionvocal'],
      date: data['date'] ??
          Timestamp.now(), // Utilise `Timestamp.now()` si le champ est absent
    );
  }

  // Méthode pour convertir un texte de loi en document Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'article': article,
      'description': description,
      'typeloi': typeloi,
      'descriptionvocal': descriptionvocal,
      'date': date,
    };
  }
}
