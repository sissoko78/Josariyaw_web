import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:josariyaw/Civil/Conseillerdetailpage.dart';
import 'package:josariyaw/Civil/DetailTextedeloi.dart';
import 'package:josariyaw/Model/User.dart' as model;
import 'package:josariyaw/Service/Userservice.dart';

class Accueilhome extends StatefulWidget {
  const Accueilhome({super.key});

  @override
  State<Accueilhome> createState() => _AccueilhomeState();
}

class _AccueilhomeState extends State<Accueilhome> {
  String? imageUrl;
  String? nom;
  String? prenom;

  final Userservice userService = Userservice(); // Instance de UserService

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

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

  // Navigation vers la page avec le filtre des textes de loi
  void _navigateToTextesDeLoi(String typeDeLoi) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PageTextesDeLoi(typeDeLoi: typeDeLoi),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE1F3F3),
      appBar: AppBar(
        backgroundColor: const Color(0xFFE1F3F3),
        leading: Builder(
          builder: (context) => GestureDetector(
            onTap: () {
              Scaffold.of(context).openDrawer();
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircleAvatar(
                backgroundImage: imageUrl != null
                    ? NetworkImage(imageUrl!)
                    : const AssetImage('assets/default_avatar.png')
                        as ImageProvider,
              ),
            ),
          ),
        ),
        title: Text('Bienvenue ${prenom ?? ''} ${nom ?? ''}'),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.notifications))
        ],
      ),
      drawer: Drawer(
        child: Column(
          children: [
            UserAccountsDrawerHeader(
              accountName: Text(nom ?? 'Nom de l\'utilisateur'),
              accountEmail:
                  Text(FirebaseAuth.instance.currentUser?.email ?? 'Email'),
              currentAccountPicture: const SizedBox.shrink(),
            ),
            ListTile(
              title: const Text('Option 1'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Option 2'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Quelques Lois et Droits',
                style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w300,
                    color: Colors.blueAccent),
              ),
              const SizedBox(height: 16),
              GridView.count(
                crossAxisCount: 3,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  CategoryItem(
                      icon: Icons.people,
                      label: 'Droit de l\'homme',
                      onTap: () => _navigateToTextesDeLoi('Droit de l\'homme')),
                  CategoryItem(
                      icon: FontAwesomeIcons.personDress,
                      label: 'Droit des femmes',
                      onTap: () => _navigateToTextesDeLoi('Droit des femmes')),
                  CategoryItem(
                      icon: Icons.account_balance,
                      label: 'Constitution',
                      onTap: () => _navigateToTextesDeLoi('Constitution')),
                  CategoryItem(
                      icon: Icons.work,
                      label: 'Droit du travail',
                      onTap: () => _navigateToTextesDeLoi('Droit du travail')),
                  CategoryItem(
                      icon: Icons.home,
                      label: 'Logement',
                      onTap: () => _navigateToTextesDeLoi('Logement')),
                  CategoryItem(
                      icon: Icons.child_care,
                      label: 'Droit des enfants',
                      onTap: () => _navigateToTextesDeLoi('Droit des enfants')),
                  CategoryItem(
                      icon: Icons.more_horiz,
                      label: 'Autres',
                      onTap: () {
                        // On traitera cette partie plus tard selon tes instructions
                      }),
                ],
              ),
              Text(
                'Les conseillers Juridique',
                style: TextStyle(color: Colors.blueAccent, fontSize: 20),
              ),
              const SizedBox(
                  height: 16), // Espacement entre les icônes et la liste
              StreamBuilder<List<model.User>>(
                  stream: userService.Recupererconseillers(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(
                          child: Text('Aucun conseiller trouvé.'));
                    }

                    final conseillers = snapshot.data!;

                    return Container(
                        height: 200, // Hauteur fixe pour le GridView
                        child: GridView.builder(
                          scrollDirection: Axis.horizontal,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 1,
                            childAspectRatio: 0.75,
                          ),
                          itemCount: conseillers.length,
                          itemBuilder: (context, index) {
                            final conseiller = conseillers[index];
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => Conseillerdetailpage(
                                        conseiller: conseiller),
                                  ),
                                );
                              },
                              child: Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      12), // Bordures arrondies
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        Container(
                                          width: 150,
                                          height: 150,
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                              color: Colors.blueAccent,
                                              width: 2,
                                            ), // Bordure autour de l'image
                                            borderRadius: BorderRadius.circular(
                                                12), // Bordures arrondies
                                          ),
                                          clipBehavior: Clip.antiAlias,
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            child: Image.network(
                                              conseiller.imageUrl ??
                                                  'default_image_url',
                                              fit: BoxFit
                                                  .cover, // Ajuste l'image à l'intérieur du Container
                                            ),
                                          ),
                                        ),
                                        Positioned(
                                          bottom: 10, // Positionnement en bas
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 8.0, vertical: 4.0),
                                            color: Colors
                                                .black54, // Fond semi-transparent
                                            child: Text(
                                              '${conseiller.nom ?? 'Nom'} ${conseiller.prenom ?? 'Prénom'}',
                                              style: const TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                  ],
                                ),
                              ),
                            );
                          },
                        ));
                  })
            ],
          ),
        ),
      ),
    );
  }
}

// Classe modifiée pour accepter le onTap
class CategoryItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const CategoryItem(
      {super.key,
      required this.icon,
      required this.label,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: Colors.white,
            child: Icon(
              icon,
              size: 24,
              color: Colors.blueAccent,
            ),
          ),
          const SizedBox(height: 8),
          Text(label, textAlign: TextAlign.center),
        ],
      ),
    );
  }
}
