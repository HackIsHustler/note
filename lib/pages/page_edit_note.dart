
import 'package:flutter/material.dart';
import '../style/style.dart';

class PageEditNote  extends StatefulWidget{
  final int? noteId;
  const PageEditNote({super.key, this.noteId});

  @override
  State<PageEditNote> createState() => _PageEditNoteState();
}

class _PageEditNoteState extends State<PageEditNote> {
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
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
              minLines: 3,
              maxLines: null, // s’adapte au contenu
              decoration: const InputDecoration(
                hintText: "Contenu de la note",
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xff1f48ff), width: 2),
                )
              ),
              style: AppStyle.textButton,
            ),
            const SizedBox(height: 20),
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
                  onPressed: () {
                    // logique pour enregistrer la note
                  },
                  child: const Text("Enregistrer"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}