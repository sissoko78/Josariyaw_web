import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';

import '../Composant/FormulaireCasjuridique.dart';
import '../Model/User.dart' as model;
import '../Page en commun/Pagechat.dart';

class Conseillerdetailpage extends StatefulWidget {
  final model.User conseiller;

  const Conseillerdetailpage({super.key, required this.conseiller});

  @override
  _ConseillerdetailpageState createState() => _ConseillerdetailpageState();
}

class _ConseillerdetailpageState extends State<Conseillerdetailpage> {
  FlutterSoundPlayer? _audioPlayer;
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    _audioPlayer = FlutterSoundPlayer();
    _audioPlayer!.openPlayer();
  }

  @override
  void dispose() {
    _audioPlayer!.closePlayer();
    _audioPlayer = null;
    super.dispose();
  }

  // Fonction pour démarrer ou arrêter la lecture de l'audio
  Future<void> _playPauseAudio() async {
    if (_isPlaying) {
      await _audioPlayer!.stopPlayer();
    } else {
      await _audioPlayer!.startPlayer(
        fromURI: widget.conseiller.descriptionAudio, // URL de l'audio
        codec: Codec.mp3, // Assurez-vous que le fichier audio est au format MP3
        whenFinished: () {
          setState(() {
            _isPlaying = false;
          });
        },
      );
    }

    setState(() {
      _isPlaying = !_isPlaying;
    });
  }

  void Soummettreformulaire(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) =>
          Formulairecasjuridique(conseillerId: widget.conseiller.id),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text(
          '${widget.conseiller.nom} ${widget.conseiller.prenom}',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.blueAccent,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image du conseiller
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  width: double.infinity,
                  height: 200,
                  child: Image.network(
                    widget.conseiller.imageUrl ?? 'default_image_url',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Affichage des détails sous forme de carte
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildDetailRow(
                          Icons.person, 'Nom:', widget.conseiller.nom),
                      _buildDetailRow(
                          Icons.badge, 'Prénom:', widget.conseiller.prenom),
                      _buildDetailRow(Icons.work, 'Spécialité:',
                          widget.conseiller.specialite),
                      _buildDetailRow(Icons.phone, 'Numéro de Téléphone:',
                          widget.conseiller.numero_tel),
                      _buildDetailRow(
                          Icons.home, 'Adresse:', widget.conseiller.adresse),
                      _buildDetailRow(Icons.money, 'Honoraire de suivi de cas:',
                          widget.conseiller.honaire_suivi),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 30),

              // Bouton pour lire la description vocale
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                  backgroundColor:
                      _isPlaying ? Colors.blueAccent : Colors.white70,
                ),
                onPressed: _playPauseAudio,
                icon: Icon(_isPlaying ? Icons.pause : Icons.play_arrow),
                label: Text(
                  _isPlaying
                      ? 'Arrêter la description vocale'
                      : 'Écouter la description vocale',
                  style: TextStyle(fontSize: 18),
                ),
              ),

              const SizedBox(height: 30),

              // Les boutons d'action
              _buildButtonRow(context),
            ],
          ),
        ),
      ),
    );
  }

  // Fonction pour construire une ligne de détail avec icône
  Widget _buildDetailRow(IconData icon, String title, String? data) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 26, color: Colors.blueAccent),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueGrey[700],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  data ?? 'Non disponible',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Fonction pour les boutons d'action avec icônes
  Widget _buildButtonRow(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
            backgroundColor: Colors.lightBlue,
          ),
          onPressed: () => Soummettreformulaire(context),
          icon: Icon(
            Icons.assignment,
            color: Colors.white,
          ),
          label: Text('Soumettre cas',
              style: TextStyle(fontSize: 15, color: Colors.white)),
        ),
        ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
            backgroundColor: Colors.white,
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    Pagechat(conseillerId: widget.conseiller.id),
              ),
            );
          },
          icon: Icon(
            Icons.chat,
            color: Colors.lightBlue,
          ),
          label: Text('Discuter',
              style: TextStyle(fontSize: 16, color: Colors.lightBlue)),
        ),
      ],
    );
  }
}
