import 'package:flutter/cupertino.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../Modeles/utilisateur.dart';
import '../Modeles/notes.dart';

class DatabaseManager {
  static Database? _database;
  static const int _databaseVersion = 1;

  // Initialisation de la base avec 2 tables
  static Future<Database> initDb() async {
    if (_database != null) return _database!;
    try {
      final databasePath = await getDatabasesPath();
      final path = join(databasePath, 'app_database.db');
      debugPrint("chemin de la base de données: $path");

      _database = await openDatabase(
        path,
        version: _databaseVersion,
        onCreate: (Database db, int version) async {
          // Table utilisateurs
          await db.execute('''
            CREATE TABLE utilisateurs(
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              nomUtilisateur TEXT UNIQUE NOT NULL,
              motDePasse TEXT NOT NULL
            )
          ''');

          // Table notes (avec clé étrangère vers utilisateurs)
          await db.execute('''
            CREATE TABLE notes(
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              titre TEXT NOT NULL,
              contenu TEXT,
              utilisateurId INTEGER NOT NULL,
              FOREIGN KEY (utilisateurId) REFERENCES utilisateurs(id) ON DELETE CASCADE
            )
          ''');
        },
        onUpgrade: (Database db, int oldVersion, int newVersion) async {
          // Logique de migration si nécessaire
        },
      );
      return _database!;
    } catch (e) {
      throw Exception("Erreur init DB: $e");
    }
  }

  // Fermeture de la base
  static Future<void> closeDb() async {
    try {
      if (_database != null) {
        await _database!.close();
        _database = null;
      }
    } catch (e) {
      throw Exception("Erreur fermeture DB: $e");
    }
  }

  // ========== Méthodes pour Utilisateurs ==========

  // Insérer un utilisateur
  static Future<int> insertUtilisateur(Utilisateur utilisateur) async {
    try {
      final db = await initDb();
      return await db.insert('utilisateurs', utilisateur.toMap());
    } catch (e) {
      throw Exception("Erreur insertion utilisateur: $e");
    }
  }

  // Récupérer un utilisateur par email
  static Future<Utilisateur?> getUtilisateurByEmail(String email) async {
    try {
      final db = await initDb();
      final maps = await db.query(
        'utilisateurs',
        where: 'nomUtilisateur = ?',
        whereArgs: [email],
        limit: 1,
      );
      return maps.isNotEmpty ? Utilisateur.fromMap(maps.first) : null;
    } catch (e) {
      throw Exception("Erreur récupération utilisateur: $e");
    }
  }

  // ========== Méthodes pour Notes ==========

  // Insérer une note
  static Future<int> insertNote(Note note) async {
    try {
      final db = await initDb();
      return await db.insert('notes', note.toMap());
    } catch (e) {
      throw Exception("Erreur insertion note: $e");
    }
  }

  // Récupérer toutes les notes d'un utilisateur
  static Future<List<Note>> getNotesByUtilisateurId(int utilisateurId) async {
    try {
      final db = await initDb();
      final maps = await db.query(
        'notes',
        where: 'utilisateurId = ?',
        whereArgs: [utilisateurId],
      );
      return maps.map((map) => Note.fromMap(map)).toList();
    } catch (e) {
      throw Exception("Erreur récupération notes: $e");
    }
  }

  // Supprimer une note
  static Future<int> deleteNote(int id) async {
    try {
      final db = await initDb();
      return await db.delete(
        'notes',
        where: 'id = ?',
        whereArgs: [id],
      );
    } catch (e) {
      throw Exception("Erreur suppression note: $e");
    }
  }
}