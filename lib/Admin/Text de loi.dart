import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:josariyaw/Composant/FormulaireAjoutetextdeloi.dart';
import 'package:josariyaw/Composant/LoiCard.dart';
import 'package:josariyaw/Service/TextdeloiService.dart';

class Testloi extends StatefulWidget {
  const Testloi({super.key});

  @override
  State<Testloi> createState() => _TestloiState();
}

class _TestloiState extends State<Testloi> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<String> typesDeLoi = [];
  bool isLoading = true;

  final TextdeloiService _textdeloiService = TextdeloiService();
  FlutterSoundPlayer? _player;
  bool _isPlaying = false;
  String? _currentPlayingUrl;

  @override
  void initState() {
    super.initState();
    obtenirTypesDeLoi().then((types) {
      setState(() {
        typesDeLoi = types;
        _tabController = TabController(length: typesDeLoi.length, vsync: this);
        isLoading = false;
      });
    });

    _player = FlutterSoundPlayer();
    _initializePlayer();
  }

  Future<void> _initializePlayer() async {
    try {
      await _player?.openPlayer();
    } catch (e) {
      print("Erreur lors de l'initialisation du lecteur audio : $e");
    }
  }

  Future<void> _playAudio(String audioUrl) async {
    if (_isPlaying && _currentPlayingUrl == audioUrl) {
      await _player?.stopPlayer();
      setState(() {
        _isPlaying = false;
        _currentPlayingUrl = null;
      });
    } else {
      try {
        await _player?.startPlayer(
          fromURI: audioUrl,
          codec: Codec.mp3,
          whenFinished: () {
            setState(() {
              _isPlaying = false;
              _currentPlayingUrl = null;
            });
          },
        );
        setState(() {
          _isPlaying = true;
          _currentPlayingUrl = audioUrl;
        });
      } catch (e) {
        print("Erreur lors de la lecture de l'audio : $e");
      }
    }
  }

  Future<void> _deleteTextLoi(String id) async {
    await _textdeloiService.SupprimerTextdeloi(id);
    setState(() {}); // Rafraîchir la vue
  }

  @override
  void dispose() {
    _tabController.dispose();
    _player?.closePlayer();
    super.dispose();
  }

  void Ajouterloitext() {
    showDialog(
      context: context,
      builder: (context) => FormulaireAjouteTexteDeLoi(),
    );
  }

  Future<List<String>> obtenirTypesDeLoi() async {
    var snapshot =
        await FirebaseFirestore.instance.collection('types_de_loi').get();
    return snapshot.docs.map((doc) => doc['nom'] as String).toList();
  }

  Stream<QuerySnapshot> obtenirTextesParType(String type) {
    return FirebaseFirestore.instance
        .collection('textes_loi')
        .where('typeloi', isEqualTo: type)
        .orderBy('date', descending: false) // Du plus ancien au plus récent
        .snapshots();
  }

  IconData getIcon(String type) {
    switch (type) {
      case 'Droit de l\'homme':
        return Icons.man;
      case 'Droit des femmes':
        return FontAwesomeIcons.personDress;
      case 'Constitution':
        return Icons.account_balance;
      case 'Droit du travail':
        return Icons.work;
      case 'Droit des enfants':
        return Icons.child_care;
      case 'Logement':
        return Icons.home;
      default:
        return Icons.article;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Texte de loi'),
        bottom: isLoading
            ? null
            : TabBar(
                controller: _tabController,
                isScrollable: true,
                tabs: typesDeLoi.map((type) => Tab(text: type)).toList(),
              ),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : TabBarView(
              controller: _tabController,
              children: typesDeLoi.map((type) {
                return StreamBuilder<QuerySnapshot>(
                  stream: obtenirTextesParType(type),
                  builder: (context, snapshot) {
                    print(snapshot.error);
                    print(snapshot.data);
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    }

                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return Center(
                        child: Text(
                          'Aucun texte de loi pour le type $type',
                          style: TextStyle(fontSize: 18, color: Colors.black54),
                        ),
                      );
                    }

                    var textesLoi = snapshot.data!.docs;
                    return ListView.separated(
                      itemCount: textesLoi.length,
                      separatorBuilder: (context, index) => Divider(height: 1),
                      itemBuilder: (context, index) {
                        var texteLoi = textesLoi[index].data() as Map;
                        String audioUrl = texteLoi['descriptionvocal'] ?? '';
                        String id = textesLoi[index].id;
                        return LoiCard(
                          texteLoi: texteLoi,
                          icon: getIcon(texteLoi['typeloi']),
                          onPlayAudio: audioUrl.isNotEmpty
                              ? () => _playAudio(audioUrl)
                              : null,
                          onDelete: () => _deleteTextLoi(id),
                          isPlaying:
                              _isPlaying && _currentPlayingUrl == audioUrl,
                        );
                      },
                    );
                  },
                );
              }).toList(),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: Ajouterloitext,
        child: Icon(Icons.add),
        backgroundColor: Colors.blueAccent,
        tooltip: 'Ajouter un texte',
      ),
      backgroundColor: const Color(0xFFE1F3F3),
    );
  }
}
