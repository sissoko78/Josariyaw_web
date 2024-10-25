import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  String id;
  String message;
  Timestamp dateenvoi;
  String expediteurId;
  String recepteurId;
  bool estPartage;
  bool estVu;
  String? destinataireNom; // Ajoutez ces champs si nécessaire
  String? destinatairePrenom;
  String? destinatairePhoto;

  Message({
    required this.id,
    required this.message,
    required this.dateenvoi,
    required this.expediteurId,
    required this.recepteurId,
    required this.estPartage,
    required this.estVu,
    this.destinataireNom,
    this.destinatairePrenom,
    this.destinatairePhoto,
  });

  factory Message.fromMap(Map<String, dynamic> data, String id) {
    return Message(
      id: id,
      message: data['message'],
      dateenvoi: data['dateenvoi'],
      expediteurId: data['expediteurId'],
      recepteurId: data['recepteurId'],
      estPartage: data['estPartage'] ?? false,
      estVu: data['estVu'] ?? false,
      destinataireNom: data['destinataireNom'],
      destinatairePrenom: data['destinatairePrenom'],
      destinatairePhoto: data['destinatairePhoto'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'message': message,
      'dateenvoi': dateenvoi,
      'expediteurId': expediteurId,
      'recepteurId': recepteurId,
      'estPartage': estPartage,
      'estVu': estVu,
      'destinataireNom': destinataireNom,
      'destinatairePrenom': destinatairePrenom,
      'destinatairePhoto': destinatairePhoto,
    };
  }
}
