// pages/page_voir_note.dart
import 'package:flutter/material.dart';
import 'package:note/Modeles/notes.dart';
import 'package:note/services/database_manager.dart';
import 'package:note/pages/page_edit_note.dart';
import '../style/style.dart';

class PageVoirNote extends StatefulWidget {
  final int? noteId;

  const PageVoirNote({
    super.key,
    this.noteId,
  });

  @override
  State<PageVoirNote> createState() => _PageVoirNoteState();
}

class _PageVoirNoteState extends State<PageVoirNote> {
  Note? _note;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _chargerNote();
  }

  Future<void> _chargerNote() async {
    try {
      final db = await DatabaseManager.initDb();
      final maps = await db.query(
        'notes',
        where: 'id = ?',
        whereArgs: [widget.noteId],
        limit: 1,
      );

      if (maps.isNotEmpty) {
        setState(() {
          _note = Note.fromMap(maps.first);
          _isLoading = false;
        });
      } else {
        if (mounted) {
         showSnackBar(
            "Note non trouvée",
            Colors.red,
          );
          Navigator.pop(context);
        }
      }
    } catch (e) {
      if (mounted) {
       showSnackBar(
          "Erreur: $e",
          Colors.red,
        );
        Navigator.pop(context);
      }
    }
  }

    // Méthode pour afficher un message
  void showSnackBar(String message, Color color) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff1f48ff),
        title: Center(
          child: Text(
            "Détail de la note",
            style: AppStyle.taillText,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit, color: Colors.white),
            onPressed: () {
              // Aller à la page d'édition
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PageEditNote(
                    noteId: widget.noteId,
                  ),
                ),
              ).then((_) => _chargerNote()); // Recharger après modification
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(
                color: Color(0xff1f48ff),
              ),
            )
          : _note == null
              ? const Center(
                  child: Text("Note non trouvée"),
                )
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _note!.titre,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const Divider(height: 32),
                      Expanded(
                        child: Text(
                          _note!.contenu ?? '',
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
    );
  }
}