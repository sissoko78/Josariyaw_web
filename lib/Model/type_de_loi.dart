class TypeDeLoi {
  final String id;
  final String nom;

  TypeDeLoi({required this.id, required this.nom});

  // Méthode pour convertir un document Firestore en instance de TypeDeLoi
  factory TypeDeLoi.fromFirestore(Map<String, dynamic> data, String id) {
    return TypeDeLoi(
      id: id,
      nom: data['nom'] ?? '',
    );
  }

  // Méthode pour convertir TypeDeLoi en document Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'nom': nom,
    };
  }
}
