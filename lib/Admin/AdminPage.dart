import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:josariyaw/Composant/Box_dashbord.dart';
import 'package:josariyaw/Composant/Navbarlateral.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:josariyaw/Service/AuthentificationService.dart';

class Adminpage extends StatefulWidget {
  Adminpage({super.key});

  @override
  State<Adminpage> createState() => _AdminpageState();
}

class _AdminpageState extends State<Adminpage> {
  AuthService authService = AuthService();
  final List<Map<String, dynamic>> griditems = [
    {'title': 'Populations', 'icon': FontAwesomeIcons.peopleArrows},
    {'title': 'Conseillers', 'icon': FontAwesomeIcons.userNurse},
    {'title': 'Cas Juridique', 'icon': Icons.folder_shared_outlined}
  ];

  String? imageUrl;
  String? nom;
  String? prenom;

  Future<void> _loadUserProfile() async {
    final auth.User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      if (userDoc.exists) {
        setState(() {
          imageUrl = userDoc['imageUrl'];
          nom = userDoc['nom'];
          prenom = userDoc['prenom'];
        });
      }
    }
  }

  Future<void> _logout() async {
    await FirebaseAuth.instance.signOut();
    // Redirigez l'utilisateur vers la page de connexion ou une autre page appropriée
  }

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Menubar(),
          Expanded(
            child: Column(
              children: [
                // Affichage des informations de l'utilisateur
                Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment
                        .spaceBetween, // Ajout pour l'espacement
                    children: [
                      // Affichage de l'image de profil
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 30,
                            backgroundImage: imageUrl != null
                                ? NetworkImage(imageUrl!)
                                : AssetImage('assets/default_profile.png')
                                    as ImageProvider, // Image par défaut
                          ),
                          SizedBox(width: 16),
                          // Affichage du nom et prénom
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '$nom $prenom',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                'Utilisateur connecté',
                                style: TextStyle(color: Colors.grey),
                              ),
                            ],
                          ),
                        ],
                      ),
                      // Bouton de déconnexion
                      ElevatedButton(
                        onPressed: () async {
                          await authService.Deconnexion(
                              context); // Pass context to Deconnexion
                        },
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.blue, // Couleur du texte
                        ),
                        child: Text('Déconnexion'),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                    height: 10), // Espace entre le profil et le tableau de bord
                AspectRatio(
                  aspectRatio: 3,
                  child: SizedBox(
                    width: double.infinity,
                    child: GridView.builder(
                      itemCount: griditems.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        mainAxisSpacing: 20.0,
                        crossAxisSpacing: 20.0,
                      ),
                      itemBuilder: (context, index) {
                        return BoxDashbord(
                          title: griditems[index]['title'],
                          icon: griditems[index]['icon'],
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      backgroundColor: const Color(0xFFE1F3F3),
    );
  }
}
