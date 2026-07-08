

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ZoneAffichageNoteItem  extends StatelessWidget{
  final String titre;
  final String contenu;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const ZoneAffichageNoteItem({
    super.key,
    required this.titre,
    required this.contenu,
    required this.onEdit,
    required this.onDelete,
    });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(titre),
      subtitle: Text(contenu),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: onEdit,
          ),
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: onDelete,
          ),
        ],
      ),
    );
  }
}