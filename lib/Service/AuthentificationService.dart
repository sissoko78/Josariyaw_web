import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:josariyaw/Admin/AdminPage.dart';
import 'package:josariyaw/Civil/CivilHome.dart';
import 'package:josariyaw/Conseiller/AcceuillMenu.dart';
import 'package:josariyaw/Login/Login_acceuil.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Obtenir l'utilisateur actuel
  User? get currentUser => _auth.currentUser;

  // Obtenir l'ID de l'utilisateur connecté
  String? getCurrentUserId() {
    return currentUser
        ?.uid; // Renvoie l'UID de l'utilisateur actuel, ou null si non connecté
  }

  // Methode pout l'inscription avec un role admin par defaut

  Future<void> Inscription(
      {required String nom,
      required String prenom,
      required String adresse,
      required String email,
      required String password,
      required String imageUrl,
      required String numero_tel}) async {
    try {
      //Création d'un compte avec email et mot de passe
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = userCredential.user;
      if (user != null) {
        //Ajouter le nouvelle utilisateur dans Firestore avec le role admin
        await _firestore.collection('users').doc(user.uid).set({
          'nom': nom,
          'prenom': prenom,
          'email': email,
          'adresse': adresse,
          'role': 'civil', //, 'admin',//'civil',
          'numero_tel': numero_tel,
          'imageUrl': imageUrl ?? '',
        });
      }
    } catch (e) {
      print(e);
      throw e;
    }
  }

  Future<void> Inscription_conseillers({
    required String nom,
    required String prenom,
    required String adresse,
    required String email,
    required String password,
    required String specialite,
    required String imageUrl,
    required String numero_tel,
    required String descriptionAudio,
    required String honaire_suivi,
  }) async {
    try {
      //Création d'un compte avec email et mot de passe
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = userCredential.user;
      if (user != null) {
        //Ajouter le nouvelle utilisateur dans Firestore avec le role admin
        await _firestore.collection('users').doc(user.uid).set({
          'nom': nom,
          'prenom': prenom,
          'email': email,
          'adresse': adresse,
          'specialite': specialite,
          'role': 'conseillers',
          'numero_tel': numero_tel,
          'imageUrl': imageUrl ?? '',
          'descriptionAudio': descriptionAudio,
          'honaire_suivi': honaire_suivi,
        });
      }
    } catch (e) {
      print(e);
      throw e;
    }
  }

//Methode de connexion
  Future<void> Seconnecter(
      BuildContext context, String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);

      // Récupérer l'utilisateur connecté
      User? user = userCredential.user;

      if (user != null) {
        // Récupérer les données de l'utilisateur depuis Firestore
        DocumentSnapshot userDoc =
            await _firestore.collection('users').doc(user.uid).get();

        if (userDoc.exists) {
          String role = userDoc['role'];

          // Redirection en fonction du rôle
          if (role == 'admin') {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      Adminpage()), // Remplace par la bonne page
            );
          } else if (role == 'civil') {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      Civilhome()), // Remplace par la bonne page
            );
          } else if (role == 'conseillers') {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      Acceuillmenu()), // Remplace par la bonne page
            );
          }
        }
      }
    } catch (e) {
      print(e);
      throw e;
    }
  }

  //Ma methode de deconnection

  Future<void> Deconnexion(BuildContext context) async {
    try {
      await _auth.signOut();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginAcceuil()),
      );
    } catch (e) {
      print(e);
      throw e;
    }
  }
}
