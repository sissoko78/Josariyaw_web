import 'package:flutter/material.dart';

class LoiCard extends StatelessWidget {
  final Map texteLoi;
  final IconData icon;
  final VoidCallback? onPlayAudio;
  final VoidCallback? onDelete;
  final bool isPlaying;

  const LoiCard({
    required this.texteLoi,
    required this.icon,
    this.onPlayAudio,
    this.onDelete,
    this.isPlaying = false,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(10),
      child: ListTile(
        leading: Icon(icon, color: Colors.blueAccent),
        title: Text(texteLoi['article'] ?? 'Article inconnu'),
        subtitle: Text(texteLoi['description'] ?? 'Description indisponible'),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (onPlayAudio != null)
              IconButton(
                icon: Icon(
                  isPlaying ? Icons.mic : Icons.play_arrow,
                  color: Colors.blueAccent,
                ),
                onPressed: onPlayAudio,
              ),
            if (onDelete != null)
              IconButton(
                icon: Icon(Icons.delete, color: Colors.red),
                onPressed: onDelete,
              ),
          ],
        ),
      ),
    );
  }
}
