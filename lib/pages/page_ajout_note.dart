import 'package:flutter/material.dart';
import 'package:note/Modeles/notes.dart';
import 'package:note/routes/routes.dart';
import 'package:note/services/database_manager.dart';
import 'package:note/services/gestion_de_session.dart';
import '../widgets/message.dart';
import '../style/style.dart';


class PageAjoutNote extends StatefulWidget{
  const PageAjoutNote({super.key});

  @override
  State<PageAjoutNote> createState() => _PageAjoutNoteState();
}

class _PageAjoutNoteState extends State<PageAjoutNote> {
  final TextEditingController _titreController = TextEditingController();
  final TextEditingController _contenuController = TextEditingController();
  bool _isLoading = false;

  Future<void> _enregistrerNote() async {
    final titre = _titreController.text.trim();
    final contenu = _contenuController.text.trim();
    
    if(titre.isEmpty){
      SnackBarHelper.showSnackBar(context,"Veuillez entrer un titre", Colors.orange);
      return;
    }

    if(contenu.isEmpty){
      if(mounted){
        _showSnackBar("Veuillez entrer un contenu!", Colors.orange);
        return;
      }
    }
    
    setState(() {
      _isLoading = true;
    });

    try {
      final userId = await GestionDeSession.getUserId();
      if (userId == null){
        _showSnackBar("utilisateur non connecte", Colors.red);
        if (mounted){
        Navigator.pushReplacementNamed(context, AppRoutes.pageConnexion);
        }
        return;
      }
      final note = Note(titre: titre, contenu: contenu, utilisateurId: userId);

      final id = await DatabaseManager.insertNote(note);
      if (id > 0){
        _showSnackBar("Note enregistree", Colors.green);
        if (mounted){
          Navigator.pop(context, true);
        }
      } else{
        _showSnackBar("Erreur lors de l'enregistrement", Colors.red);
      }
    }catch (e){
      _showSnackBar("erreur: $e", Colors.red);
    } finally{
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _showSnackBar(String message, Color color) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        )
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff1f48ff),
        title: Center(
          child: Text(
            "Nouvelle note",
            style: AppStyle.taillText, 
          ),
        ),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titreController,
              decoration: const InputDecoration(
                hintText: "Titre de la note",
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
              maxLines: null, 
              decoration: const InputDecoration(
                hintText: "Contenu de la note",
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xff1f48ff), width: 2),
                )
              ),
              style: TextStyle(color:Colors.black, fontFamily: 'OpenSans' ),
            ),
            const SizedBox(height: 20),
            if (_isLoading)
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
                  onPressed:_enregistrerNote,
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
