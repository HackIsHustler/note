
import 'package:flutter/material.dart';

class ZoneAffichageNoteItem  extends StatelessWidget{
  final String titre;
  final String contenu;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onTap;

  const ZoneAffichageNoteItem({
    super.key,
    required this.titre,
    required this.contenu,
    required this.onEdit,
    required this.onDelete,
    required this.onTap,
    });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: ListTile(
        title: Text(
          titre,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(fontWeight: FontWeight.bold),
          ),
        subtitle: Text(
          contenu,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          ),
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
      ),
    );
  }
}