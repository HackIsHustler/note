import 'package:flutter/material.dart';
import 'package:note/services/gestion_de_session.dart';
import '../widgets/zone_de_saisie.dart';
import '../routes/routes.dart';
import '../pages/page_acceuil.dart';
import '../services/database_manager.dart';
import '../Modeles/utilisateur.dart';
import '../style/style.dart';


class PageConnexion extends StatefulWidget {
  const PageConnexion({super.key});

  @override
  State<PageConnexion> createState() => _PageConnexionState();
}

class _PageConnexionState extends State<PageConnexion> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool _isLoading = false;
  bool _obscurePassword = true;

  //methode de connexion
  Future<void> _connecterUtilisateur() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      _showSnackBar("Veuillez remplir tous les champs", Colors.red);
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      //recupere lutilisateur par mail
      final utilisateur = await DatabaseManager.getUtilisateurByEmail(email);
      if (utilisateur == null) {
        _showSnackBar("Utilisateur non trouvé", Colors.red);
        setState(() {
          _isLoading = false;
        });
        return;
      }

      //verifier le mot de passe
      if (utilisateur.motDePasse != password) {
        _showSnackBar("Mot de passe incorrect", Colors.red);
        setState(() {
          _isLoading = false;
        });
        return;
      }
      
      _showSnackBar("Connexion réussie", Colors.green);
      // Connexion réussie, naviguer vers la page d'accueil
      Future.delayed(Duration(seconds: 1), () {
        if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => PageAcceuil()),
        );
          }
      });
    } catch (e) {
      _showSnackBar("Erreur lors de la connexion: $e", Colors.red);
    } finally {
      if (mounted){
      setState(() {
        _isLoading = false;
      });
      }
    }
  }

  //methode pour afficher le message
  void _showSnackBar(String message, color){
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: AppStyle.textSnackBar,),
        backgroundColor: color,
        duration: const Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            "Page Connexion",
            style: AppStyle.taillText,
            )),
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
                minHeight: constraints.maxHeight
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 20.0,
                  horizontal: 15.0
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Center(
                      child: Image.asset(
                        'assets/images/logo.jpg',
                        width: 200,
                        height: 200,
                        ),
                    ),
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
                    Column(
                      children: [
                        if (_isLoading)
                        const CircularProgressIndicator(color: Colors.white,)
                        else 
                        OutlinedButton(
                          onPressed: _connecterUtilisateur,
                          child: Text(
                            "Connexion", 
                            style: AppStyle.textButton,
                            )
                          ),
                           SizedBox(height: 20,),
                      GestureDetector(
                        onTap: (){
                          Navigator.pushNamed(context, AppRoutes.pageInscription);
                        },
                        child: Text(
                          "Vous n'avez pas encore de compte ? Inscrivez-vous",
                          style: AppStyle.textOrdinairelien,
                          ),
                      )
                      ],
                    ),

                  ],
                ),
              ),
            ),
          );
        }
      )

    );
  }

  @override
  void dispose(){
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

}