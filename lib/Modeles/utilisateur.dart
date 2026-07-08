class Utilisateur {
  final int? id;
  final String nomUtilisateur; // email
  final String motDePasse;

  Utilisateur({
    this.id,
    required this.nomUtilisateur,
    required this.motDePasse,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nomUtilisateur': nomUtilisateur,
      'motDePasse': motDePasse,
    };
  }

  factory Utilisateur.fromMap(Map<String, dynamic> map) {
    return Utilisateur(
      id: map['id'],
      nomUtilisateur: map['nomUtilisateur'],
      motDePasse: map['motDePasse'],
    );
  }
}