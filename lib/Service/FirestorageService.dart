import 'dart:html' as html; // Pour Flutter Web
import 'dart:io' as io; // Pour Flutter Mobile
import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart'; // Pour vérifier si on est sur le Web
import 'package:uuid/uuid.dart'; // Pour générer des UUID

class StorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // Méthode pour uploader une image (Mobile)
  Future<String?> uploadImage(io.File imageFile, String userId) async {
    try {
      final Reference storageRef =
          _storage.ref().child('user_images/$userId.png');
      final UploadTask uploadTask = storageRef.putFile(imageFile);
      final TaskSnapshot snapshot = await uploadTask;
      final String imageUrl = await snapshot.ref.getDownloadURL();
      return imageUrl;
    } catch (e) {
      print("Erreur lors de l'upload de l'image mobile : $e");
      return null;
    }
  }

  // Méthode pour uploader une image (Web)
  Future<String?> uploadWebImage(html.File imageFile, String userId) async {
    try {
      final Reference storageRef =
          _storage.ref().child('user_images/$userId.png');
      final UploadTask uploadTask = storageRef.putBlob(imageFile);
      final TaskSnapshot snapshot = await uploadTask;
      final String imageUrl = await snapshot.ref.getDownloadURL();
      return imageUrl;
    } catch (e) {
      print("Erreur lors de l'upload de l'image web : $e");
      return null;
    }
  }

  // Méthode pour uploader un fichier audio (avec nom unique)
  Future<String?> uploadAudioFile(dynamic audioFile, String userId) async {
    try {
      var uuid = Uuid();
      String uniqueFileName = 'description_vocal_${uuid.v4()}.mp3';

      final Reference storageRef =
          _storage.ref().child('audios/$userId/$uniqueFileName');

      UploadTask uploadTask;

      if (kIsWeb) {
        uploadTask = storageRef.putBlob(audioFile);
      } else {
        uploadTask = storageRef.putFile(audioFile);
      }

      final TaskSnapshot snapshot = await uploadTask;
      final String audioUrl = await snapshot.ref.getDownloadURL();
      return audioUrl;
    } catch (e) {
      print('Erreur lors de l\'upload du fichier audio : $e');
      throw e;
    }
  }

  // Méthode pour uploader un fichier audio depuis des bytes (Web)
  Future<String?> uploadAudioFromBytes(
      Uint8List audioBytes, String userId) async {
    try {
      var uuid = Uuid();
      String uniqueFileName = 'description_vocal_${uuid.v4()}.mp3';

      final Reference storageRef =
          _storage.ref().child('audios/$userId/$uniqueFileName');
      final UploadTask uploadTask = storageRef.putData(audioBytes);
      final TaskSnapshot snapshot = await uploadTask;
      final String audioUrl = await snapshot.ref.getDownloadURL();
      return audioUrl;
    } catch (e) {
      print('Erreur lors de l\'upload du fichier audio depuis bytes : $e');
      return null;
    }
  }
}
