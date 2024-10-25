import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_sound/flutter_sound.dart';
import '../Composant/FormulaireAjoutInfraction.dart';
import '../Model/InfractionBambara.dart';
import '../Composant/Navbarlateral.dart'; // Assure-toi d'importer le Menubar

class Infractionpage extends StatefulWidget {
  const Infractionpage({Key? key}) : super(key: key);

  @override
  State<Infractionpage> createState() => _InfractionPageState();
}

class _InfractionPageState extends State<Infractionpage> {
  List<Infraction> infractions = []; // Liste pour stocker les infractions
  FlutterSoundPlayer? _player;
  bool _isPlaying = false; // Pour vérifier si un audio est en cours de lecture
  String?
      _currentPlayingUrl; // Pour savoir quel fichier est en cours de lecture

  @override
  void initState() {
    super.initState();
    _player = FlutterSoundPlayer();
    _initializePlayer(); // Initialiser le player
  }

  Future<void> _initializePlayer() async {
    try {
      await _player!.openPlayer();
      print("Lecteur audio ouvert avec succès");
      _fetchInfractions(); // Récupérer les infractions après l'ouverture du lecteur
    } catch (e) {
      print("Erreur lors de l'ouverture du lecteur audio : $e");
    }
  }

  Future<void> _fetchInfractions() async {
    QuerySnapshot snapshot =
        await FirebaseFirestore.instance.collection('infractions').get();
    setState(() {
      infractions = snapshot.docs
          .map((doc) => Infraction.fromFiredtore(
              doc.data() as Map<String, dynamic>, doc.id))
          .toList();
    });
  }

  Future<void> _playAudio(String audioUrl) async {
    if (_isPlaying && _currentPlayingUrl == audioUrl) {
      // Si l'audio est déjà en cours de lecture, on l'arrête
      await _player!.stopPlayer();
      setState(() {
        _isPlaying = false;
        _currentPlayingUrl = null;
      });
    } else {
      // Sinon, on commence à jouer l'audio
      try {
        await _player!.startPlayer(
          fromURI: audioUrl,
          codec: Codec.mp3, // Choisir le codec approprié
          whenFinished: () {
            // Lorsque l'audio se termine
            setState(() {
              _isPlaying = false;
              _currentPlayingUrl = null;
            });
            print("Lecture de l'audio terminée : $audioUrl");
          },
        );
        setState(() {
          _isPlaying = true;
          _currentPlayingUrl = audioUrl;
        });
        print("Lecture de l'audio démarrée : $audioUrl");
      } catch (e) {
        print("Erreur lors de la lecture de l'audio : $e");
      }
    }
  }

  void _deleteInfraction(String id) async {
    await FirebaseFirestore.instance.collection('infractions').doc(id).delete();
    _fetchInfractions(); // Mettre à jour la liste après suppression
  }

  void _ajouterInfraction() {
    showDialog(
      context: context,
      builder: (context) => const FormulaireAjoutInfraction(),
    ).then((_) => _fetchInfractions()); // Rafraîchir la liste après ajout
  }

  @override
  void dispose() {
    _player?.closePlayer(); // Fermer le lecteur audio
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Menubar(), // Ajout du Menubar
          Expanded(
            child: Column(
              children: [
                Card(
                  margin: const EdgeInsets.all(16.0),
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Infractions Pénales',
                          style: TextStyle(
                            fontSize: 24,
                            color: Colors.blueAccent,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.add),
                          onPressed: _ajouterInfraction,
                          color: Colors.blueAccent,
                          tooltip: 'Ajouter une infraction',
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: infractions.length,
                    itemBuilder: (context, index) {
                      Infraction infraction = infractions[index];
                      return Card(
                        margin: const EdgeInsets.all(10),
                        color: Colors.white,
                        child: ListTile(
                          title: Text(infraction.article),
                          subtitle: Text(infraction.descriptionecrit),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: Icon(
                                  _isPlaying &&
                                          _currentPlayingUrl ==
                                              infraction.descriptionvocal
                                      ? Icons.mic
                                      : Icons.play_arrow,
                                  color: Colors.blue,
                                ),
                                onPressed: () =>
                                    _playAudio(infraction.descriptionvocal),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () =>
                                    _deleteInfraction(infraction.id),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
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
