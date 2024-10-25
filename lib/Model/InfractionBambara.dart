class Infraction {
  String id;
  String article;
  String descriptionecrit;
  String descriptionvocal;

  Infraction(
      {required this.id,
      required this.article,
      required this.descriptionecrit,
      required this.descriptionvocal});

  // methode pour convertir un doc firestore en instance de Infraction
  factory Infraction.fromFiredtore(Map<String, dynamic> data, String id) {
    return Infraction(
        id: id,
        article: data['article'] ?? '',
        descriptionecrit: data['descriptionecrit'] ?? '',
        descriptionvocal: data['descriptionvocal'] ?? '');
  }
  // methode pour convertir une infraction en doc firestore
  Map<String, dynamic> ToFirestore() {
    return {
      'article': article,
      'descriptionecrit': descriptionecrit,
      'descriptionvocal': descriptionvocal
    };
  }
}
