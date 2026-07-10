import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class GestionDeSession {
  //cles pour stocker les donnees

  static const String _keyUserId = 'user_id';
  static const String _keyUserEmail = 'user_email';
  static const String _keyIsLoggedIn = 'is_logged_in';
  static const String _keyFirstLaunch = 'first_launch';

  static const _storage = FlutterSecureStorage();

  //verifie si c'est la premiere installation
  static Future<bool> isFirstLaunch() async {
    final firstLaunch = await _storage.read(key: _keyFirstLaunch) ?? true;
    
    if(firstLaunch == 'true'){
      await _storage.write(key: _keyFirstLaunch, value: 'false');
      return true;
    }
    return false;
  }

  //demarrer une session persistante

  static Future<void> startSession(int userId, String email) async {
    await _storage.write(key: _keyUserId, value: userId.toString());
    await _storage.write(key: _keyUserEmail, value:  email);
    await _storage.write(key: _keyIsLoggedIn, value: 'true');
  }

  //verifier si l'utilisateur est connecter
  static Future<bool> isLoggedIn() async {
    final value = await _storage.read(key: _keyUserId);
    return value == 'true';
  }

  //recuperer ID de lutilisateur
  static Future<int?> getUserId() async {
    final value = await _storage.read(key: _keyUserId);
    return value != null ? int.tryParse(value) : null;
  }

  //recuperer lemail de lutilisateur
  static Future<String?> getUserEmail() async {
    return await _storage.read(key: _keyUserEmail);
  }

  //fermer la session ou se deconnecter
  static Future<void> endSession() async {
    await _storage.delete(key: _keyUserId);
    await _storage.delete(key: _keyUserEmail);
    await _storage.write(key: _keyIsLoggedIn, value: 'false');

  }

}