import 'package:flutter/material.dart';
import 'package:josariyaw/Page%20en%20commun/Pagechat.dart';
import 'package:josariyaw/Service/AuthentificationService.dart';
import 'package:josariyaw/Service/MessageService.dart';
import 'package:josariyaw/Model/User.dart';

class Discussionpage extends StatefulWidget {
  const Discussionpage({super.key});

  @override
  State<Discussionpage> createState() => _DiscussionpageState();
}

class _DiscussionpageState extends State<Discussionpage> {
  final MessageService messageService = MessageService();
  List<User> utilisateurs = [];
  String? expediteurId;

  @override
  void initState() {
    super.initState();
    expediteurId = AuthService().getCurrentUserId();
    recupererUtilisateurs();
  }

  Future<void> recupererUtilisateurs() async {
    try {
      final List<User> utilisateursRecuperes =
          await messageService.recupererListeUtilisateurs(expediteurId!);
      setState(() {
        utilisateurs = utilisateursRecuperes;
      });
    } catch (e) {
      print('Erreur: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE1F3F3),
      appBar: AppBar(
        title: Text(
          'Liste des discussions',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: const Color(0xFFE1F3F3),
        elevation: 4,
      ),
      body: utilisateurs.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: utilisateurs.length,
              itemBuilder: (context, index) {
                final utilisateur = utilisateurs[index];
                return Card(
                  margin: const EdgeInsets.symmetric(
                      vertical: 8.0, horizontal: 16.0),
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(utilisateur.imageUrl),
                    ),
                    title: Text(
                      '${utilisateur.prenom} ${utilisateur.nom}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              Pagechat(conseillerId: utilisateur.id),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
    );
  }
}
