class Note {
  final int? id;
  final String titre;
  final String contenu;
  final int utilisateurId;

  Note({
    this.id,
    required this.titre,
    required this.contenu,
    required this.utilisateurId,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'titre': titre,
      'contenu': contenu,
      'utilisateurId': utilisateurId,
    };
  }

  factory Note.fromMap(Map<String, dynamic> map) {
    return Note(
      id: map['id'],
      titre: map['titre'],
      contenu: map['contenu'],
      utilisateurId: map['utilisateurId'],
    );
  }
}