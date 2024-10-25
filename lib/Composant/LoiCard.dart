import 'package:flutter/material.dart';

class LoiCard extends StatefulWidget {
  final Map texteLoi;
  final IconData icon;

  const LoiCard({required this.texteLoi, required this.icon, Key? key})
      : super(key: key);

  @override
  _LoiCardState createState() => _LoiCardState();
}

class _LoiCardState extends State<LoiCard> {
  bool _isExpanded = false;
  static const int maxChars =
      100; // Limite de caractères avant d'afficher "Lire plus"

  @override
  Widget build(BuildContext context) {
    final description = widget.texteLoi['description'];

    return Card(
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      color: Colors.lightBlue[50],
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.texteLoi['article'],
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Icon(widget.icon),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    _isExpanded
                        ? description
                        : (description.length > maxChars
                            ? '${description.substring(0, maxChars)}...'
                            : description),
                    style: TextStyle(color: Colors.black54),
                    overflow: _isExpanded
                        ? TextOverflow.visible
                        : TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            if (description.length > maxChars)
              TextButton(
                onPressed: () {
                  setState(() {
                    _isExpanded = !_isExpanded;
                  });
                },
                child: Text(_isExpanded ? 'Lire moins' : 'Lire plus'),
              ),
          ],
        ),
      ),
    );
  }
}
