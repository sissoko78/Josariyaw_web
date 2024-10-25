import 'dart:async';
import 'dart:typed_data';
import 'dart:io' as io;
import 'dart:html' as html;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:path_provider/path_provider.dart';

import '../Model/InfractionBambara.dart';
import '../Service/FirestorageService.dart';
import '../Service/InfractionService.dart';

class FormulaireAjoutInfraction extends StatefulWidget {
  const FormulaireAjoutInfraction({Key? key}) : super(key: key);

  @override
  _FormulaireAjoutInfractionState createState() =>
      _FormulaireAjoutInfractionState();
}

class _FormulaireAjoutInfractionState extends State<FormulaireAjoutInfraction> {
  final articleController = TextEditingController();
  final descriptionEcritController = TextEditingController();

  FlutterSoundRecorder? _recorder;
  bool _isRecording = false;
  String? audioFilePath;
  Uint8List? _audioBytes;

  html.MediaRecorder? _webRecorder;
  List<html.Blob> _audioChunks = [];

  @override
  void initState() {
    super.initState();
    if (!kIsWeb) {
      _recorder = FlutterSoundRecorder();
      initializeRecorder();
    }
  }

  Future<void> initializeRecorder() async {
    await _recorder!.openRecorder();
  }

  Future<void> _startRecording() async {
    if (kIsWeb) {
      await _startWebRecording();
    } else {
      final dir = await getTemporaryDirectory();
      audioFilePath = '${dir.path}/audio.wav';
      await _recorder!
          .startRecorder(toFile: audioFilePath, codec: Codec.pcm16WAV);
      setState(() {
        _isRecording = true;
      });
    }
  }

  Future<void> _startWebRecording() async {
    final stream =
        await html.window.navigator.mediaDevices?.getUserMedia({'audio': true});
    if (stream != null) {
      _webRecorder = html.MediaRecorder(stream);
      _audioChunks = [];
      _webRecorder?.start();
      _webRecorder?.addEventListener('dataavailable', (event) {
        final html.Blob blob = (event as html.BlobEvent).data!;
        _audioChunks.add(blob);
      });
      _webRecorder?.addEventListener('stop', (event) async {
        final blob = html.Blob(_audioChunks, 'audio/wav');
        _audioBytes = await _convertBlobToUint8List(blob);
        setState(() {
          _isRecording = false;
        });
      });
      setState(() {
        _isRecording = true;
      });
    }
  }

  Future<Uint8List> _convertBlobToUint8List(html.Blob blob) async {
    final reader = html.FileReader();
    final completer = Completer<Uint8List>();
    reader.readAsArrayBuffer(blob);
    reader.onLoadEnd.listen((event) {
      completer.complete(reader.result as Uint8List);
    });
    return completer.future;
  }

  Future<void> _stopRecording() async {
    if (kIsWeb) {
      _stopWebRecording();
    } else {
      await _recorder!.stopRecorder();
      setState(() {
        _isRecording = false;
      });
    }
  }

  Future<void> _stopWebRecording() async {
    _webRecorder?.stop();
    setState(() {
      _isRecording = false;
    });
  }

  Future<String?> _uploadAudio() async {
    StorageService storageService = StorageService();
    if (kIsWeb && _audioBytes != null) {
      return await storageService.uploadAudioFromBytes(
          _audioBytes!, 'infraction');
    } else if (audioFilePath != null) {
      return await storageService.uploadAudioFile(
          io.File(audioFilePath!), 'infraction');
    }
    return null;
  }

  void soumettreFormulaire() async {
    String? audioUrl = await _uploadAudio();
    Infraction infraction = Infraction(
      id: UniqueKey().toString(), // Ou utilise un ID généré par Firestore
      article: articleController.text,
      descriptionecrit: descriptionEcritController.text,
      descriptionvocal: audioUrl ?? '',
    );
    InfractionService infractionService = InfractionService();
    try {
      await infractionService.addInfraction(infraction);
      print('Infraction ajoutée avec succès');
      // Afficher un message ou naviguer
    } catch (e) {
      print('Erreur lors de l\'ajout de l\'infraction : $e');
    }
    print('Formulaire envoyé avec succès, URL audio : $audioUrl');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Ajouter une Infraction")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: articleController,
                decoration: InputDecoration(labelText: "Article"),
              ),
              TextField(
                controller: descriptionEcritController,
                decoration: InputDecoration(labelText: "Description écrite"),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _isRecording ? null : _startRecording,
                child: Text("Démarrer l'enregistrement"),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _isRecording ? _stopRecording : null,
                child: Text("Arrêter l'enregistrement"),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: soumettreFormulaire,
                child: Text("Valider l'ajout d'infraction"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
