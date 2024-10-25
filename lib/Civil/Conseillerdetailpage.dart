import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:josariyaw/Composant/FormulaireCasjuridique.dart';
import 'package:josariyaw/Model/User.dart' as model;
import 'package:josariyaw/Page%20en%20commun/Pagechat.dart';

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
      appBar: AppBar(
        title: Text('${widget.conseiller.nom} ${widget.conseiller.prenom}'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
              _buildDetailRow('Nom:', widget.conseiller.nom),
              _buildDetailRow('Prénom:', widget.conseiller.prenom),
              _buildDetailRow('Spécialité:', widget.conseiller.specialite),
              _buildDetailRow(
                  'Numéro de Téléphone:', widget.conseiller.numero_tel),
              _buildDetailRow('Adresse:', widget.conseiller.adresse),
              _buildDetailRow('Honoraire de suivi de cas:',
                  widget.conseiller.honaire_suivi),
              const SizedBox(height: 30),

              // Bouton pour lire la description vocale
              ElevatedButton.icon(
                onPressed: _playPauseAudio,
                icon: Icon(_isPlaying ? Icons.pause : Icons.play_arrow),
                label: Text(_isPlaying
                    ? 'Arrêter la description vocale'
                    : 'Écouter la description vocale'),
              ),

              const SizedBox(height: 30),
              _buildButtonRow(context), // Passer le context ici
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String title, String? data) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              data ?? 'Non disponible',
              style: TextStyle(
                fontSize: 22,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildButtonRow(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        ElevatedButton(
          onPressed: () => Soummettreformulaire(context), // Passer le context
          child: Text('Soumettre cas', style: TextStyle(fontSize: 15)),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    Pagechat(conseillerId: widget.conseiller.id),
              ),
            );
          },
          child: Text(
            'Discuter',
            style: TextStyle(fontSize: 15),
          ),
        ),
      ],
    );
  }
}
