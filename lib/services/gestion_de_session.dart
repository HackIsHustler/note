import 'package:shared_preferences/shared_preferences.dart';

class GestionDeSession {
  //cles pour stocker les donnees

  static const String _keyUserid = 'user_id';
  static const String _keyUserEmail = 'user_email';
  static const String _keyIsLoggedIn = 'is_logged_in';
  static const String _keyFirstLaunch = 'first_launch';

  //verifie si c'est la premiere installation
  static Future<bool> isFirstLaunch() async {
    final prefs = await SharedPreferences.getInstance();
    final firstLaunch = prefs.getBool(_keyFirstLaunch) ?? true;
    
    if(firstLaunch){
      await prefs.setBool(_keyFirstLaunch, false);
      return true;
    }
    return false;
  }

  //demarrer une session persistante

  static Future<void> startSession(int userId, String email) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_keyUserid, userId);
    await prefs.setString(_keyUserEmail, email);
    await prefs.setBool(_keyIsLoggedIn, true);

    print("session demarrer: $email (ID: $userId)");
  }

  //verifier si l'utilisateur est connecter
  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyIsLoggedIn) ?? false;
  }

  //recuperer ID de lutilisateur
  static Future<int?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_keyUserid);
  }

  //recuperer lemail de lutilisateur
  static Future<Map<String, dynamic>?> getSession() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt(_keyUserid);
    final email = prefs.getString(_keyUserEmail);
    final isLoggedIn = prefs.getBool(_keyIsLoggedIn) ?? false;

    if (!isLoggedIn || userId == null){
      return null;
    }
    return{
      'userId': userId,
      'email': email,
    };
  }

  //fermer la session ou se deconnecter
  static Future<void> endSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyUserid);
    await prefs.remove(_keyUserEmail);
    await prefs.setBool(_keyIsLoggedIn, false);

    print("session fermee");
  }

  //supprimer toutes les donnees de session
  static Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    print("toutes les donnees de session supprimees");
  }

}