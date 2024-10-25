import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/material.dart';
import 'package:josariyaw/Conseiller/Detailcasjuridique.dart';
import 'package:josariyaw/Model/CasJurique.dart';
import 'package:josariyaw/Service/AuthentificationService.dart';
import 'package:josariyaw/Service/CasJuridiqueService.dart';
import 'package:josariyaw/Service/UserService.dart';

class CasJuridiqueConseillerPage extends StatefulWidget {
  const CasJuridiqueConseillerPage({super.key});

  @override
  State<CasJuridiqueConseillerPage> createState() =>
      _CasJuridiqueConseillerPageState();
}

class _CasJuridiqueConseillerPageState
    extends State<CasJuridiqueConseillerPage> {
  final CasJuriqueService casJuridiqueService = CasJuriqueService();
  final AuthService authService = AuthService();
  String? conseillerId;

  String? imageUrl;
  String? nom;
  String? prenom;

  final Userservice userService = Userservice(); // Instance de UserService

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
    conseillerId = authService.getCurrentUserId();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      body: StreamBuilder<List<CasJuridique>>(
        stream: conseillerId != null
            ? casJuridiqueService.recupererCasParConseiller(conseillerId!)
            : Stream<List<CasJuridique>>.value([]),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text("Erreur de chargement"));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasData && snapshot.data!.isNotEmpty) {
            return ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                CasJuridique cas = snapshot.data![index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8.0),
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16.0),
                    title: Text(
                      cas.titre,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    subtitle: Text(
                      cas.description,
                      style: TextStyle(
                        color: Colors.grey[700],
                      ),
                    ),
                    trailing: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8.0, vertical: 4.0),
                      decoration: BoxDecoration(
                        color: _getStatutColor(cas.statut),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        cas.statut,
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    leading: Icon(Icons.gavel, color: Colors.blue),
                    onTap: () {
                      // Naviguer vers la page de détails
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetailCasPage(cas: cas),
                        ),
                      );
                    },
                  ),
                );
              },
            );
          } else {
            return Center(child: Text("Aucun cas soumis."));
          }
        },
      ),
    );
  }

  Color _getStatutColor(String statut) {
    switch (statut) {
      case 'Soumis mais pas encore accepté':
        return Colors.orange;
      case 'En cour':
        return Colors.orange;
      case 'Accepté':
        return Colors.blueAccent;
      case 'Résolu':
        return Colors.green;
      case 'Réfusé':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}
