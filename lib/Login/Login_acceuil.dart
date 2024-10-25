import 'package:flutter/material.dart';
import 'package:josariyaw/Composant/Button.dart';
import 'package:josariyaw/Composant/Formulaire.dart';
import 'package:josariyaw/Service/AuthentificationService.dart';

class LoginAcceuil extends StatefulWidget {
  const LoginAcceuil({super.key});

  @override
  State<LoginAcceuil> createState() => _LoginAcceuilState();
}

class _LoginAcceuilState extends State<LoginAcceuil> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final AuthService authService = AuthService();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> seconnecter() async {
    try {
      await authService.Seconnecter(
          context, emailController.text, passwordController.text);
    } catch (e) {
      print("Erreur de connexion: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          // Conteneur global avec une largeur réduite de 1200 et une hauteur ajustée
          child: Container(
            width: 800,
            height: 800, // Hauteur ajustée pour un rendu plus compact
            child: Row(
              children: [
                // Partie gauche : Conteneur pour l'image avec une taille ajustée de 600x700
                Container(
                  width: 400,
                  height: 400,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    image: DecorationImage(
                      image: AssetImage("assets/photo_login.jpg"),
                      fit: BoxFit
                          .cover, // S'assure que l'image remplit bien l'espace
                    ),
                  ),
                ),

                // Partie droite : Formulaire avec la même taille que l'image (600x700)
                Container(
                  width: 400,
                  height: 400,
                  decoration: BoxDecoration(
                    color: const Color(
                        0xFFE1F3F3), // Couleur de fond du formulaire
                    borderRadius: BorderRadius.circular(
                        20), // Ajout d'une bordure arrondie
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        blurRadius: 6,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ), // Couleur de fond du formulaire
                  padding: EdgeInsets.all(30), // Ajuste les marges intérieures
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Logo
                      Center(
                        child: Image.asset(
                          "assets/logo_de_login.png",
                          height: 100,
                        ),
                      ),
                      SizedBox(height: 10),

                      // Champ email
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.2),
                              blurRadius: 6,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: TextField(
                          controller: emailController,
                          decoration: InputDecoration(
                            prefixIcon:
                                Icon(Icons.email_outlined, color: Colors.blue),
                            hintText: 'Email',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 15),

                      // Champ mot de passe
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.2),
                              blurRadius: 6,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: TextField(
                          controller: passwordController,
                          obscureText: true,
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.lock, color: Colors.blue),
                            hintText: 'Mot de passe',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 15),

                      // Bouton Connexion
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: seconnecter,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF00A8E8),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child:
                              Text('Connexion', style: TextStyle(fontSize: 18)),
                        ),
                      ),
                      SizedBox(height: 15),

                      Divider(height: 1, color: Colors.black26),

                      // Lien Inscription
                      Center(
                        child: TextButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/Inscription');
                          },
                          child: Text(
                            "Pas encore inscrit ? Inscription",
                            style: TextStyle(color: Colors.black54),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
