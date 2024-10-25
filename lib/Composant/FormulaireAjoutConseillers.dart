import 'dart:async';
import 'dart:io' as io; // Import pour Flutter mobile/desktop
import 'dart:html' as html; // Import pour Flutter Web
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:josariyaw/Composant/Formulaire.dart';
import 'package:josariyaw/Service/AuthentificationService.dart';
import 'package:josariyaw/Service/FirestorageService.dart';

class Formulaireajoutconseillers extends StatefulWidget {
  const Formulaireajoutconseillers({super.key});

  @override
  State<Formulaireajoutconseillers> createState() =>
      _FormulaireajoutconseillersState();
}

class _FormulaireajoutconseillersState
    extends State<Formulaireajoutconseillers> {
  final nomcontroller = TextEditingController();
  final prenomcontroller = TextEditingController();
  final adressecontroller = TextEditingController();
  final emailcontroller = TextEditingController();
  final motdepassecontroller = TextEditingController();
  final confirmermotdepassecontroller = TextEditingController();
  final numero_telController = TextEditingController();
  final specialiteController = TextEditingController();
  final honorairesuiviController = TextEditingController();

  io.File? _image; // Pour Flutter mobile/desktop
  html.File? _webImage; // Pour Flutter Web
  Uint8List? _audioBytes; // Pour enregistrer l'audio en Web

  final ImagePicker _picker = ImagePicker();
  FlutterSoundRecorder? _recorder;
  bool _isRecording = false;
  String? audioFilePath;

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

  // Fonction pour démarrer l'enregistrement vocal
  Future<void> _startRecording() async {
    if (kIsWeb) {
      await _startWebRecording();
    } else {
      final dir = await getTemporaryDirectory();
      audioFilePath = '${dir.path}/audio.wav';

      await _recorder!.startRecorder(
        toFile: audioFilePath,
        codec: Codec.pcm16WAV,
      );
      setState(() {
        _isRecording = true;
      });
      print("Enregistrement audio démarré");
    }
  }

  // Web-specific audio recording
  Future<void> _startWebRecording() async {
    final stream =
        await html.window.navigator.mediaDevices?.getUserMedia({'audio': true});

    if (stream != null) {
      _webRecorder = html.MediaRecorder(stream);

      _audioChunks = []; // Reset audio chunks

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
        print("Enregistrement audio web arrêté");
      });

      setState(() {
        _isRecording = true;
      });
    }
  }

  // Fonction pour convertir un Blob en Uint8List
  Future<Uint8List> _convertBlobToUint8List(html.Blob blob) async {
    final reader = html.FileReader();
    final completer = Completer<Uint8List>();

    reader.readAsArrayBuffer(blob);
    reader.onLoadEnd.listen((event) {
      completer.complete(reader.result as Uint8List);
    });

    return completer.future;
  }

  // Fonction pour arrêter l'enregistrement vocal
  Future<void> _stopRecording() async {
    if (kIsWeb) {
      _stopWebRecording();
    } else {
      await _recorder!.stopRecorder();
      setState(() {
        _isRecording = false;
      });
      print("Enregistrement audio arrêté : $audioFilePath");
    }
  }

  Future<void> _stopWebRecording() async {
    _webRecorder?.stop();
    setState(() {
      _isRecording = false;
    });
    print("Enregistrement audio web arrêté");
  }

  // Fonction pour sélectionner une image depuis la galerie
  Future<void> _pickImage() async {
    if (kIsWeb) {
      final html.FileUploadInputElement uploadInput =
          html.FileUploadInputElement();
      uploadInput.accept = 'image/*';
      uploadInput.click();

      uploadInput.onChange.listen((event) {
        final files = uploadInput.files;
        if (files != null && files.isNotEmpty) {
          final file = files.first;
          setState(() {
            _webImage = file;
          });
        } else {
          print("Aucune image sélectionnée.");
        }
      });
    } else {
      final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
      setState(() {
        if (pickedFile != null) {
          _image = io.File(pickedFile.path);
        }
      });
    }
  }

  // Fonction pour uploader l'image dans Firebase Storage
  Future<String?> _uploadImage() async {
    StorageService storageService = StorageService();

    if (kIsWeb && _webImage != null) {
      // Upload de l'image pour le web
      return await storageService.uploadWebImage(
          _webImage!, emailcontroller.text);
    } else if (_image != null) {
      // Upload de l'image pour mobile/desktop
      return await storageService.uploadImage(_image!, emailcontroller.text);
    }
    return null;
  }

  // Fonction pour soumettre le formulaire
  void soumettreFormulaire() async {
    if (motdepassecontroller.text == confirmermotdepassecontroller.text) {
      String? audioUrl;
      String? imageUrl = await _uploadImage();

      // Upload audio si enregistré (mobile/desktop)
      if (!kIsWeb && audioFilePath != null) {
        StorageService storageService = StorageService();
        audioUrl = await storageService.uploadAudioFile(
            io.File(audioFilePath!), emailcontroller.text);
      }

      // Web-specific audio upload
      if (kIsWeb && _audioBytes != null) {
        StorageService storageService = StorageService();
        audioUrl = await storageService.uploadAudioFromBytes(
            _audioBytes!, emailcontroller.text);
      }

      // Appel du service d'authentification
      AuthService authService = AuthService();
      try {
        await authService.Inscription_conseillers(
            nom: nomcontroller.text,
            prenom: prenomcontroller.text,
            adresse: adressecontroller.text,
            email: emailcontroller.text,
            specialite: specialiteController.text,
            password: motdepassecontroller.text,
            imageUrl: imageUrl ?? '', // Ajout de l'URL de l'image
            numero_tel: numero_telController.text,
            descriptionAudio: audioUrl ?? '',
            honaire_suivi: honorairesuiviController.text);
        print('Inscription réussie');
        Navigator.pushReplacementNamed(context, '/Conseillers');
      } catch (e) {
        print('Erreur lors de l\'inscription : $e');
      }
    } else {
      print('Les mots de passe ne correspondent pas');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFE1F3F3), Colors.grey],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 24.0),
            child: Card(
              elevation: 8,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              margin: EdgeInsets.symmetric(vertical: 24, horizontal: 16),
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Column(
                  children: [
                    Text(
                      "Inscription",
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 20),
                    GestureDetector(
                      onTap: _pickImage,
                      child: CircleAvatar(
                        radius: 60,
                        backgroundColor: Colors.grey[200],
                        backgroundImage: kIsWeb
                            ? (_webImage != null
                                ? NetworkImage(_webImage!.name)
                                : null)
                            : (_image != null ? FileImage(_image!) : null),
                        child: (_image == null && _webImage == null)
                            ? Icon(Icons.camera_alt,
                                size: 50, color: Colors.grey)
                            : null,
                      ),
                    ),
                    SizedBox(height: 20),
                    Formulaire(
                        controller: nomcontroller,
                        hintText: 'Nom',
                        icon: Icons.person),
                    SizedBox(height: 20),
                    Formulaire(
                        controller: prenomcontroller,
                        hintText: 'Prénom',
                        icon: Icons.person_outline),
                    SizedBox(height: 20),
                    Formulaire(
                        controller: adressecontroller,
                        hintText: 'Adresse',
                        icon: Icons.home),
                    SizedBox(height: 20),
                    Formulaire(
                        controller: specialiteController,
                        hintText: 'Spécialité',
                        icon: Icons.workspace_premium_outlined),
                    SizedBox(height: 20),
                    Formulaire(
                        controller: honorairesuiviController,
                        hintText: 'Honoraire de suivi de cas'),
                    SizedBox(height: 20),
                    Formulaire(
                        controller: numero_telController,
                        hintText: 'Numéro de téléphone',
                        icon: Icons.phone),
                    SizedBox(height: 20),
                    Formulaire(
                        controller: emailcontroller,
                        hintText: 'Email',
                        icon: Icons.email),
                    SizedBox(height: 20),
                    Formulaire(
                        controller: motdepassecontroller,
                        hintText: 'Mot de passe',
                        obscureText: true,
                        icon: Icons.lock),
                    SizedBox(height: 20),
                    Formulaire(
                        controller: confirmermotdepassecontroller,
                        hintText: 'Confirmer le mot de passe',
                        obscureText: true,
                        icon: Icons.lock_outline),
                    SizedBox(height: 30),
                    ElevatedButton(
                      onPressed: _isRecording ? null : _startRecording,
                      child: Text("Démarrer l'enregistrement"),
                    ),
                    SizedBox(height: 15),
                    ElevatedButton(
                      onPressed: _isRecording ? _stopRecording : null,
                      child: Text("Arrêter l'enregistrement"),
                    ),
                    SizedBox(height: 30),
                    ElevatedButton(
                      onPressed: soumettreFormulaire,
                      style: ElevatedButton.styleFrom(
                        padding:
                            EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30)),
                        textStyle: TextStyle(fontSize: 18),
                      ),
                      child: Text("Valider l'inscription"),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
