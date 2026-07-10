
import 'package:flutter/material.dart';
import 'package:note/routes/routes.dart';
import 'package:note/services/database_manager.dart';
import 'package:note/services/gestion_de_session.dart';
import '../Modeles/notes.dart';
import '../style/style.dart';

class PageEditNote  extends StatefulWidget{
  final int? noteId;
  const PageEditNote({super.key, this.noteId});

  @override
  State<PageEditNote> createState() => _PageEditNoteState();
}

class _PageEditNoteState extends State<PageEditNote> {
  final TextEditingController _titreController = TextEditingController();
  final TextEditingController _contenuController = TextEditingController();
  bool _isLoading = true;
  bool _isSaving = false;
  Note? _note;

  @override
  void initState(){
    super.initState();
    _chargerNote();
  }

  Future<void> _chargerNote() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final db = await DatabaseManager.initDb();
      final maps = await db.query('notes', where: 'id = ?',
      whereArgs: [widget.noteId],
      limit: 1,
      );
      if (maps.isEmpty){
        if(mounted) {
          _showSnackBar("Note non trouvee", Colors.red);
          Navigator.pop(context);
        }
        return;
      }
      final note = Note.fromMap(maps.first);
      _note = note;

      _titreController.text = note.titre;
      _contenuController.text = note.contenu ?? '';

      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      if (mounted) {
        _showSnackBar("Erreur: $e", Colors.red);
        Navigator.pop(context);
      }
    }
  }

  Future<void> modifierNote() async {
    final titre = _titreController.text.trim();
    final contenu = _contenuController.text.trim();

    if (titre.isEmpty || contenu.isEmpty){
      if(mounted){
        _showSnackBar("Veuillez remplir tous les champs", Colors.orange);
      }
      return;
    }
    setState(() {
      _isSaving =  true;
    });

    try{
      final userId = await GestionDeSession.getUserId();
      if (userId == null){
        if(mounted){
        _showSnackBar("L'utilisateur n'est pas connecte", Colors.orange);
        Navigator.pushReplacementNamed(context, AppRoutes.pageConnexion);
        }
        return;
      }
      
      final noteModifiee = Note(
        id: widget.noteId,
        titre: titre,
        contenu:contenu,
        utilisateurId: userId,
      );

      final db = await DatabaseManager.initDb();
      final result = await db.update('notes', noteModifiee.toMap(), where: 'id = ?', whereArgs: [widget.noteId]);
      if (result  > 0) {
        if (mounted) {
          _showSnackBar("La note a ete modifiee avec succes", Colors.green);
          Navigator.pop(context, true);
        }
      } else {
        _showSnackBar("Erreur lors de la modification", Colors.red);
      }
    } catch (e){
      _showSnackBar("Erreur: $e", Colors.red);
    } finally{
      setState(() {
        _isSaving = false;
      });
    }
  }
      // Méthode pour afficher un message
  void _showSnackBar(String message, Color color) {
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
        title: Center(
          child: Text(
            "Edition de la Note",
            style: AppStyle.taillText,
            )),
        backgroundColor: Color(0xff1f48ff),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: _isLoading ? const Center(child: CircularProgressIndicator(color: Color(0xff1f48ff),),)
      :
       Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titreController,
              decoration: const InputDecoration(
                hintText: "Titre de la note existante",
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xff1f48ff), width: 2),
                )
              ),
              style: TextStyle(color: Colors.black, fontFamily: 'OpenSans'), // applique ton style texte
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _contenuController,
              minLines: 3,
              maxLines: null, // s’adapte au contenu
              decoration: const InputDecoration(
                hintText: "Contenu de la note",
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xff1f48ff), width: 2),
                )
              ),
              style: TextStyle(color: Colors.black, fontFamily: 'OpenSans'),
            ),
            const SizedBox(height: 20),
            if (_isSaving)
              const CircularProgressIndicator(color: Color(0xff1f48ff),)
            else 
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Color(0xff1f48ff), width: 2),
                  ),
                  onPressed: () {
                    Navigator.pop(context); // bouton Annuler
                  },
                  child: const Text("Annuler"),
                ),
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Color(0xff1f48ff), width: 2),
                  ),
                  onPressed: modifierNote,
                  child: const Text("Enregistrer"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
  @override
  void dispose(){
    _titreController.dispose();
    _contenuController.dispose();
    super.dispose();
  }
}