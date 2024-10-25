class CasJuridique {
  String id;
  String titre;
  String description;
  String statut;
  String expediteurId;
  String conseillerId;
  List<Map<String, dynamic>>
      historiqueStatuts; // Nouvelle liste pour l'historique

  CasJuridique({
    required this.id,
    required this.titre,
    required this.description,
    required this.statut,
    required this.conseillerId,
    required this.expediteurId,
    this.historiqueStatuts = const [], // Initialiser avec une liste vide
  });

  // Méthode pour convertir un document Firestore en instance de CasJuridique
  factory CasJuridique.fromFirestore(Map<String, dynamic> data, String id) {
    return CasJuridique(
      id: id,
      titre: data['titre'],
      description: data['description'],
      statut: data['statut'],
      conseillerId: data['conseillerId'],
      expediteurId: data['expediteurId'],
      historiqueStatuts: List<Map<String, dynamic>>.from(
          data['historiqueStatuts'] ?? []), // Récupérer l'historique
    );
  }

  // Méthode pour convertir en document Firestore
  Map<String, dynamic> Tofirestore() {
    return {
      'titre': titre,
      'description': description,
      'statut': statut,
      'conseillerId': conseillerId,
      'expediteurId': expediteurId,
      'historiqueStatuts': historiqueStatuts, // Ajouter l'historique
    };
  }
}
