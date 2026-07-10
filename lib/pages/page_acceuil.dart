import 'package:flutter/material.dart';
import 'package:note/pages/page_edit_note.dart';
import 'package:note/pages/page_ajout_note.dart';
import 'package:note/services/gestion_de_session.dart';
import 'package:note/style/style.dart';
import 'package:note/widgets/zone_affichage_note.dart';
import 'package:note/services/database_manager.dart';
import 'package:note/Modeles/notes.dart';
import 'package:note/pages/page_voir_note.dart';
import '../routes/routes.dart';

class PageAcceuil extends StatefulWidget {
  const PageAcceuil({super.key});

  @override
  State<PageAcceuil> createState() => _PageAcceuilState();
}

class _PageAcceuilState extends State<PageAcceuil> {
  List<Note> _notes = [];
  bool _isLoading = true;
  String _searchQuery = '';
  int? _userId; 

  @override
  void initState() {
    super.initState();
    _chargerNotes();
  }

  // Charger les notes depuis la base de données
  Future<void> _chargerNotes() async {
    setState(() {
      _isLoading = true;
    });

    try {
      //recuperer lide de lutilisateur depuis la session
      _userId = await GestionDeSession.getUserId();
      
      if (_userId == null) {
        _redirectToLogin();
        return;
      }

      final notes = await DatabaseManager.getNotesByUtilisateurId(_userId!);
      setState(() {
        _notes = notes;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _redirectToLogin(){
    if (mounted) {
      Navigator.pushReplacementNamed(context, AppRoutes.pageConnexion);
    }
  }

  // Supprimer une note
  Future<void> _supprimerNote(int id) async {
    // Afficher une confirmation
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Supprimer la note"),
        content: Text("Voulez-vous vraiment supprimer cette note ?"),
        backgroundColor: Colors.white,
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Annuler"),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context); // Fermer le dialogue
              setState(() {
                _isLoading = true;
              });
              
              try {
                final result = await DatabaseManager.deleteNote(id);
                if (result > 0) {
                  _showSnackBar(" Note supprimée", Colors.green);
                  await _chargerNotes(); // Recharger la liste
                } else {
                  _showSnackBar(" Erreur lors de la suppression", Colors.red);
                }
              } catch (e) {
                _showSnackBar("Erreur: $e", Colors.red);
              } finally {
                setState(() {
                  _isLoading = false;
                });
              }
            },
            child: Text(
              "Supprimer",
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  // Filtrer les notes selon la recherche
  List<Note> _getFilteredNotes() {
    if (_searchQuery.isEmpty) {
      return _notes;
    }
    return _notes.where((note) {
      return note.titre.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          (note.contenu?.toLowerCase().contains(_searchQuery.toLowerCase()) ?? false);
    }).toList();
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

  // Déconnexion
  void _deconnecter(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Déconnexion"),
        content: Text("Voulez-vous vraiment vous déconnecter ?"),
        backgroundColor: Colors.white,
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Annuler"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushReplacementNamed(context, AppRoutes.pageConnexion);
            },
            child: Text(
              "Déconnecter",
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filteredNotes = _getFilteredNotes();

    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            "Mes Notes",
            style: AppStyle.taillText,
          ),
        ),
        backgroundColor: const Color(0xff1f48ff),
        iconTheme: const IconThemeData(color: Colors.white),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: () => _deconnecter(context),
            tooltip: "Se déconnecter",
          ),
        ],
      ),
      body: Column(
        children: [
          // Barre de recherche
          Container(
            margin: const EdgeInsets.all(15),
            child: TextField(
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
              decoration: InputDecoration(
                hintText: "Rechercher une note",
                hintStyle: const TextStyle(color: Colors.black54),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Color(0xff1f48ff), width: 2),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Color(0xff1f48ff), width: 2),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                suffixIcon: IconButton(
                  onPressed: () {
                    // Effacer la recherche
                    setState(() {
                      _searchQuery = '';
                    });
                  },
                  icon: Icon(
                    _searchQuery.isEmpty ? Icons.search : Icons.clear,
                    color: Colors.black,
                  ),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 12.0,
                  horizontal: 8.0,
                ),
              ),
              style: const TextStyle(
                color: Colors.black,
                fontSize: 16.0,
              ),
            ),
          ),
          // Liste des notes
          Expanded(
            child: _isLoading
                ? const Center(
                    child: CircularProgressIndicator(
                      color: Color(0xff1f48ff),
                    ),
                  )
                : filteredNotes.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              _searchQuery.isEmpty
                                  ? Icons.note_add
                                  : Icons.search_off,
                              size: 80,
                              color: Colors.grey,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              _searchQuery.isEmpty
                                  ? "Aucune note pour le moment"
                                  : "Aucun résultat pour '$_searchQuery'",
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 18,
                              ),
                            ),
                            if (_searchQuery.isEmpty)
                              const Text(
                                "Appuyez sur le bouton + pour ajouter une note",
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 14,
                                ),
                              ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        itemCount: filteredNotes.length,
                        itemBuilder: (context, index) {
                          final note = filteredNotes[index];
                          return Container(
                            margin: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.grey,
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: ZoneAffichageNoteItem(
                              titre: note.titre,
                              contenu: note.contenu ?? '',
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => PageVoirNote(
                                      noteId: note.id!,
                                      )
                                    )
                                  );
                              },
                              onEdit: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => PageEditNote(
                                      noteId: note.id!,
                                    ),
                                  ),
                                ).then((_) => _chargerNotes()); // Recharger après modification
                              },
                              onDelete: () => _supprimerNote(note.id!),
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xff1f48ff),
        child: const Icon(
          Icons.add,
          color: Colors.white,
          size: 30.0,
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const PageAjoutNote(),
            ),
          ).then((_) => _chargerNotes()); // Recharger après ajout
        },
      ),
    );
  }
}