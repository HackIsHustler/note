import 'package:flutter/material.dart';
import 'package:note/services/gestion_de_session.dart';
import './pages/page_de_commencement.dart';
import './routes/routes.dart';
import '../pages/page_connexion.dart';
import '../pages/page_inscription.dart';
import '../pages/page_ajout_note.dart';
import '../pages/page_edit_note.dart';
import '../pages/page_acceuil.dart';
import '../services/database_manager.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();

  await DatabaseManager.initDb(); // Initialiser la base de données avant de lancer l'application

  //verifie si lutilisateur est deja connecter
  final isLoggedIn = await GestionDeSession.isLoggedIn();

  //verifie si c'est la rpremiere installation
  final isFirstLaunch = await GestionDeSession.isFirstLaunch();

    // Vérifier si la base fonctionne
  try {
    final db = await DatabaseManager.initDb();
    final result = await db.rawQuery('SELECT name FROM sqlite_master WHERE type="table"');
    print("✅ Tables dans la base :");
    for (var table in result) {
      print("  - ${table['name']}");
    }
    
    // Vérifier le nombre d'utilisateurs
    final users = await db.rawQuery('SELECT COUNT(*) as count FROM utilisateurs');
    print("👤 Nombre d'utilisateurs : ${users.first['count']}");
    
    // Vérifier le nombre de notes
    final notes = await db.rawQuery('SELECT COUNT(*) as count FROM notes');
    print("📝 Nombre de notes : ${notes.first['count']}");
    
  } catch (e) {
    print("❌ Erreur: $e");
  }
  
  runApp(MonApplication(isLoggedIn:isLoggedIn, isFirstLaunch: isFirstLaunch,));
}

class MonApplication extends StatelessWidget{
  final bool isLoggedIn;
  final bool isFirstLaunch;
  const MonApplication({super.key, required this.isLoggedIn, required this.isFirstLaunch});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "page de connexion",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            side: BorderSide(
              color: Colors.white,
              width: 2,
            )
          )
        )
      ),

      initialRoute: _getInitialRoute(),
      routes: {
        AppRoutes.accueil: (context) => PageDeCommencement(),
        AppRoutes.pageConnexion: (context) => PageConnexion(),
        AppRoutes.pageInscription: (context) => PageInscription(),
        AppRoutes.pageAccueil: (context) => PageAcceuil(),
        AppRoutes.nouvelleNote: (context) => PageAjoutNote(),
        AppRoutes.editNote: (context) => PageEditNote(),
      },
    );
  }

  //Methode pour determiner la route initial

  String _getInitialRoute(){
    //premiere installation
    if (isFirstLaunch){
      return AppRoutes.accueil;
    }

    //deja connecter
    if (isLoggedIn){
      return AppRoutes.pageAccueil;
    }

    //deja installer mais pas connecter
    return AppRoutes.pageConnexion;
  } 
}