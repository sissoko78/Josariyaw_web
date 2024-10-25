import 'dart:io' as io; // Import pour Flutter mobile
import 'dart:html' as html; // Import pour Flutter Web
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:josariyaw/Composant/Formulaire.dart';
import 'package:josariyaw/Service/AuthentificationService.dart';

import '../Service/FirestorageService.dart';

class FormulaireInsccription extends StatefulWidget {
  const FormulaireInsccription({super.key});

  @override
  State<FormulaireInsccription> createState() => _FormulaireInsccriptionState();
}

class _FormulaireInsccriptionState extends State<FormulaireInsccription> {
  final nomcontroller = TextEditingController();
  final prenomcontroller = TextEditingController();
  final adressecontroller = TextEditingController();
  final emailcontroller = TextEditingController();
  final motdepassecontroller = TextEditingController();
  final confirmermotdepassecontroller = TextEditingController();
  final numero_telController = TextEditingController();

  io.File? _image; // Pour Flutter mobile/desktop
  html.File? _webImage; // Pour Flutter Web

  final ImagePicker _picker = ImagePicker();

  // Fonction pour sélectionner une image depuis la galerie (mobile) ou explorateur de fichiers (web)
  Future<void> _pickImage() async {
    if (kIsWeb) {
      // Sélection d'image pour Flutter Web
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
      // Sélection d'image pour Flutter mobile/desktop
      final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
      setState(() {
        if (pickedFile != null) {
          _image = io.File(pickedFile.path);
        }
      });
    }
  }

  // Fonction pour soumettre le formulaire
  void soumettreFormulaire() async {
    await ensureUserAuthenticated(); // Assurer que l'utilisateur est authentifié

    if (motdepassecontroller.text == confirmermotdepassecontroller.text) {
      // Appel du service de stockage pour uploader l'image (ajusté pour Flutter Web)
      String? imageUrl;
      if (_image != null || _webImage != null) {
        StorageService storageService = StorageService();
        if (kIsWeb) {
          imageUrl = await storageService.uploadWebImage(
              _webImage!, emailcontroller.text);
        } else {
          imageUrl =
              await storageService.uploadImage(_image!, emailcontroller.text);
        }
      }

      // Appel du service d'authentification
      AuthService authService = AuthService();
      try {
        await authService.Inscription(
          nom: nomcontroller.text,
          prenom: prenomcontroller.text,
          adresse: adressecontroller.text,
          email: emailcontroller.text,
          password: motdepassecontroller.text,
          imageUrl: imageUrl ?? '',
          numero_tel: numero_telController.text,
        );
        print('Inscription réussie');
        Navigator.pushReplacementNamed(context, '/Acceuil');
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
      // Ajout d'un fond dégradé
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

  ensureUserAuthenticated() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      // Demander à l'utilisateur de se connecter ou s'inscrire
      await FirebaseAuth.instance
          .signInAnonymously(); // Exemple : connexion anonyme
    }
  }
}
