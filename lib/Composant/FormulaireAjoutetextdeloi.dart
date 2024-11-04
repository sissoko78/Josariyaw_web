import 'dart:async';
import 'dart:typed_data';
import 'dart:io' as io;
import 'dart:html' as html;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:path_provider/path_provider.dart';
import '../Model/TextLoi.dart';
import '../Model/type_de_loi.dart';
import '../Service/TextdeloiService.dart';
import '../Service/Type_de_loiService.dart';
import '../Service/FirestorageService.dart';

class FormulaireAjouteTexteDeLoi extends StatefulWidget {
  const FormulaireAjouteTexteDeLoi({super.key});

  @override
  State<FormulaireAjouteTexteDeLoi> createState() =>
      _FormulaireAjouteTexteDeLoiState();
}

class _FormulaireAjouteTexteDeLoiState
    extends State<FormulaireAjouteTexteDeLoi> {
  final articleController = TextEditingController();
  final descriptionController = TextEditingController();
  String? _typeLoi;
  final TextdeloiService textdeloiService = TextdeloiService();
  final TypeDeLoiService typeDeLoiService = TypeDeLoiService();
  List<TypeDeLoi> typesDeLoi = [];

  FlutterSoundRecorder? _recorder;
  bool _isRecording = false;
  String? audioFilePath;
  Uint8List? _audioBytes;
  html.MediaRecorder? _webRecorder;
  List<html.Blob> _audioChunks = [];

  @override
  void initState() {
    super.initState();
    typeDeLoiService.recupererTypesDeLoi().listen((data) {
      setState(() {
        typesDeLoi = data;
        _typeLoi = typesDeLoi.isNotEmpty ? typesDeLoi[0].nom : null;
      });
    });

    if (!kIsWeb) {
      _recorder = FlutterSoundRecorder();
      initializeRecorder();
    }
  }

  Future<void> initializeRecorder() async {
    await _recorder?.openRecorder();
  }

  Future<void> _startRecording() async {
    if (kIsWeb) {
      await _startWebRecording();
    } else {
      final dir = await getTemporaryDirectory();
      audioFilePath = '${dir.path}/audio.wav';
      await _recorder?.startRecorder(
          toFile: audioFilePath, codec: Codec.pcm16WAV);
      setState(() => _isRecording = true);
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
        setState(() => _isRecording = false);
      });
      setState(() => _isRecording = true);
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
      await _recorder?.stopRecorder();
      setState(() => _isRecording = false);
    }
  }

  Future<void> _stopWebRecording() async {
    _webRecorder?.stop();
    setState(() => _isRecording = false);
  }

  Future<String?> _uploadAudio() async {
    final storageService = StorageService();
    if (kIsWeb && _audioBytes != null) {
      return await storageService.uploadAudioFromBytes(
          _audioBytes!, 'texte_de_loi');
    } else if (audioFilePath != null) {
      return await storageService.uploadAudioFile(
          io.File(audioFilePath!), 'texte_de_loi');
    }
    return null;
  }

  void AjouterTextloi() async {
    String? audioUrl = await _uploadAudio();
    final newtextloi = TextLoi(
      id: '',
      article: articleController.text,
      description: descriptionController.text,
      descriptionvocal: audioUrl ?? '',
      typeloi: _typeLoi ?? 'Droit de l\'homme',
      date: Timestamp.now(), // Ajout de la date ici
    );

    textdeloiService.AjouterLoi(newtextloi).then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Texte de loi ajouté avec succès')),
      );
    }).catchError((e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur : $e')),
      );
    });
  }

  @override
  void dispose() {
    articleController.dispose();
    descriptionController.dispose();
    _recorder?.closeRecorder();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ajouter un nouveau texte de loi'),
        backgroundColor: const Color(0xFFE1F3F3),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: articleController,
                decoration: InputDecoration(hintText: 'Article'),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: descriptionController,
                decoration: InputDecoration(hintText: 'Description de la loi'),
              ),
              const SizedBox(height: 20),
              DropdownButton<String>(
                value: _typeLoi,
                items: typesDeLoi.map((TypeDeLoi type) {
                  return DropdownMenuItem<String>(
                    value: type.nom,
                    child: Text(type.nom),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _typeLoi = newValue;
                  });
                },
                hint: const Text('Sélectionner le type de loi'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _isRecording ? null : _startRecording,
                child: Text("Démarrer l'enregistrement"),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: _isRecording ? _stopRecording : null,
                child: Text("Arrêter l'enregistrement"),
              ),
              const SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: AjouterTextloi,
                  child: const Text('Ajouter un nouveau texte de loi'),
                ),
              ),
            ],
          ),
        ),
      ),
      backgroundColor: const Color(0xFFE1F3F3),
    );
  }
}
