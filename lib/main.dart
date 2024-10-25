import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:josariyaw/Admin/AdminPage.dart';
import 'package:josariyaw/Admin/ConseillersPage.dart';
import 'package:josariyaw/Admin/Text%20de%20loi.dart';
import 'package:josariyaw/Composant/FormulaireAjoutetextdeloi.dart';
import 'package:josariyaw/Login/Formulaire_insccription.dart';
import 'package:josariyaw/Login/Login_acceuil.dart';
import 'package:josariyaw/firebase_options.dart';

import 'Civil/CivilHome.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: {
        "/": (context) => LoginAcceuil(),
        "/Inscription": (context) => FormulaireInsccription(),
        "/admin": (context) => Adminpage(),
        "/Testloi": (context) => Testloi(),
        "/Conseillers": (context) => Conseillerspage(),
        "/Acceuil": (context) => Civilhome()
      },
    );
  }
}
