import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:html' as html;
import 'package:image_picker/image_picker.dart';
import 'package:josariyaw/Model/Actualite.dart';
import 'package:josariyaw/Service/ActualiteService.dart';
import 'package:josariyaw/Service/FirestorageService.dart';

class Formulaireajoutactualite extends StatefulWidget {
  const Formulaireajoutactualite({super.key});

  @override
  State<Formulaireajoutactualite> createState() =>
      _FormulaireajoutactualiteState();
}

class _FormulaireajoutactualiteState extends State<Formulaireajoutactualite> {
  final descriptionController = TextEditingController();
  File? _image;
  html.File? _webimage;
  final ImagePicker _picker = ImagePicker();

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
            _webimage = file;
          });
        } else {
          print("Aucune image sélectionnée");
        }
      });
    } else {
      final pickFile = await _picker.pickImage(source: ImageSource.gallery);
      setState(() {
        if (pickFile != null) {
          _image = File(pickFile.path);
        }
      });
    }
  }

  void soumettreformulaire() async {
    String description = descriptionController.text.trim();
    String? imageUrl;

    if (_image != null || _webimage != null) {
      StorageService storageService = StorageService();
      if (kIsWeb) {
        imageUrl = await storageService.uploadWebImage(
            _webimage!, descriptionController.text);
      } else {
        imageUrl = await storageService.uploadImage(_image!, description);
      }
    }

    ActualiteService actualiteService = ActualiteService();
    try {
      await actualiteService.AjouterActu(Actualite(
        id: DateTime.now().toString(), // Générer un ID unique
        description: description,
        image: imageUrl ?? '',
      ));
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Actualité ajoutée avec succès!')),
      );
      descriptionController.clear();
      setState(() {
        _image = null;
        _webimage = null;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur lors de l\'ajout: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Formulaire d'ajout d'une actualité"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: descriptionController,
              decoration: InputDecoration(
                labelText: "Description",
                border: OutlineInputBorder(),
                hintText: "Entrez la description de l'actualité",
              ),
              maxLines: 5,
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Image: ${_image != null ? _image!.path.split('/').last : _webimage != null ? _webimage!.name : 'Aucune image sélectionnée'}',
                  style: TextStyle(fontSize: 16),
                ),
                ElevatedButton(
                  onPressed: _pickImage,
                  child: const Text('Choisir une image'),
                ),
              ],
            ),
            SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: soumettreformulaire,
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  textStyle: TextStyle(fontSize: 18),
                ),
                child: const Text('Soumettre'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
