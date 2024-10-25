class Statut {
  String id;
  String nom;

  Statut({required this.id, required this.nom});

  factory Statut.fromFirestore(Map<String, dynamic> data, String id) {
    return Statut(id: id, nom: data['nom']);
  }

  Map<String, dynamic> ToFirestore() {
    return {'nom': nom};
  }
}
