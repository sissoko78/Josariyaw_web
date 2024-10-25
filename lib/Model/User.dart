class User {
  String id;
  String nom;
  String prenom;
  String adresse;
  String role;
  String specialite;
  String email;
  String password;
  String imageUrl;
  String numero_tel;
  String descriptionAudio;
  String honaire_suivi;

  User(
      {required this.id,
      required this.nom,
      required this.prenom,
      required this.specialite,
      required this.role,
      required this.adresse,
      required this.email,
      required this.password,
      required this.descriptionAudio,
      required this.imageUrl,
      required this.numero_tel,
      required this.honaire_suivi});

  // methode pour convertir un document firestore en instance de User
  factory User.fromFirestore(Map<String, dynamic> data, String id) {
    return User(
      id: id,
      nom: data['nom'] ?? '', // Défaut à une chaîne vide si null
      prenom: data['prenom'] ?? '',
      role: data['role'] ?? '',
      specialite: data['specialite'] ?? '',
      adresse: data['adresse'] ?? '',
      email: data['email'] ?? '',
      password: data['password'] ?? '', // À utiliser avec précaution
      imageUrl: data['imageUrl'] ?? '',
      numero_tel: data['numero_tel'] ?? '',
      descriptionAudio: data['descriptionAudio'] ?? '',
      honaire_suivi: data['honaire_suivi'] ?? '',
    );
  }

  // ma methode pour convertir l'utilisateur pourqu'il soit accepté dans firestore
  Map<String, dynamic> toFirestore() {
    return {
      'nom': nom,
      'prenom': prenom,
      'role': role,
      'specialite': specialite,
      'adresse': adresse,
      'email': email,
      'password': password,
      'imageUrl': imageUrl,
      'numero_tel': numero_tel,
      'descriptionAudio': descriptionAudio,
      'honaire_suivi': honaire_suivi
    };
  }

  // Nouvelle méthode pour convertir un document Firestore en instance de User
  factory User.fromMap(Map<String, dynamic> data) {
    return User(
      id: data['id'] ?? '',
      nom: data['nom'] ?? '',
      prenom: data['prenom'] ?? '',
      role: data['role'] ?? '',
      specialite: data['specialite'] ?? '',
      adresse: data['adresse'] ?? '',
      email: data['email'] ?? '',
      password: data['password'] ?? '', // À utiliser avec précaution
      imageUrl: data['imageUrl'] ?? '',
      numero_tel: data['numero_tel'] ?? '',
      descriptionAudio: data['descriptionAudio'] ?? '',
      honaire_suivi: data['honaire_suivi'] ?? '',
    );
  }
}
