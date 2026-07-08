import 'package:flutter/material.dart';
import '../widgets/zone_de_saisie.dart';
import '../services/database_manager.dart';
import '../Modeles/utilisateur.dart';
import '../routes/routes.dart';
import '../style/style.dart';

class PageInscription extends StatefulWidget {
  const PageInscription({super.key});

  @override
  State<PageInscription> createState() => _PageInscriptionState();
}

class _PageInscriptionState extends State<PageInscription> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool _isLoading = false;
  bool _obscurePassword = true;

  //methode d'inscription
  Future<void> _inscrireUtilisateur() async {
    // verifier si les champs sont vides
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      _showSnackbar("Veuillez remplir tous les champs", Colors.red);
      return;
    }

    //verifier si le mot de passe a moins six caractere
    if (password.length < 6) {
      _showSnackbar("Le mot de passe doit contenir au moins 6 caractères", Colors.red);
      return;
    }

    //verifier que l'email est valide
    if (!email.contains('@') || !email.contains('.')) {
      _showSnackbar("Veuillez entrer une adresse email valide", Colors.red);
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      //verifier si l'utilisateur existe deja
      final existingUser = await DatabaseManager.getUtilisateurByEmail(email);
      if (existingUser != null) {
        _showSnackbar("Cet utilisateur existe déjà", Colors.red);
        setState(() {
          _isLoading = false;
        });
        return;
      }

      //creer un nouvel utilisateur
      final nouvelUtilisateur = Utilisateur(nomUtilisateur: email, motDePasse: password);
      final userId = await DatabaseManager.insertUtilisateur(nouvelUtilisateur);
      if (userId > 0) {
        _showSnackbar("Utilisateur inscrit avec succès", Colors.green);

        //redirection vers la page de connexion apres un delai de 3 secondes
        Future.delayed(Duration(seconds: 3), () {
          if (mounted) {
            Navigator.pushNamed(context, AppRoutes.pageConnexion);
          }
        });
      } else {
        _showSnackbar("Erreur lors de l'inscription", Colors.red);
      }
    } catch (e) {
      _showSnackbar("Erreur lors de l'inscription: $e", Colors.red);
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  //methode pour afficher un message
  void _showSnackbar(String message, Color color) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: AppStyle.textSnackBar),
        backgroundColor: color,
        duration: Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            "Page Inscription",
            style: AppStyle.taillText,
          ),
        ),
        backgroundColor: Color(0xff1f48ff),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      backgroundColor: Color(0xff1f48ff),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: constraints.maxHeight,
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 20.0,
                  horizontal: 15.0,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // Logo
                    Center(
                      child: Image.asset(
                        'assets/images/logo.jpg',
                        width: 200,
                        height: 200,
                      ),
                    ),
                    
                    // Champs de saisie
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 15),
                      child: Column(
                        children: [
                          ZoneDeSaisie(
                            controller: emailController,
                            hintText: "Adresse Email",
                          ),
                          const SizedBox(height: 20),
                          ZoneDeSaisie(
                            controller: passwordController,
                            hintText: "Mot de passe",
                            isPassword: true,
                            obscureText: _obscurePassword,
                            onToggleVisibility: () {
                              setState(() {
                                _obscurePassword = !_obscurePassword;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                    
                    // Bouton et lien
                    Column(
                      children: [
                        if (_isLoading)
                          const CircularProgressIndicator(color: Colors.white)
                        else
                          OutlinedButton(
                            onPressed: _inscrireUtilisateur,
                            child: Text(
                              "S'inscrire",
                              style: AppStyle.textButton,
                            ),
                          ),
                        const SizedBox(height: 20),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, AppRoutes.pageConnexion);
                          },
                          child: Text(
                            "Vous avez déjà un compte ? Connectez-vous",
                            style: AppStyle.textOrdinairelien,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}