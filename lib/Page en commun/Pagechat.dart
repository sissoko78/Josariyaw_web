import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:josariyaw/Model/Message.dart';
import 'package:josariyaw/Service/AuthentificationService.dart';
import 'package:josariyaw/Service/MessageService.dart';
import '../Model/User.dart';

class Pagechat extends StatefulWidget {
  final String conseillerId;

  const Pagechat({super.key, required this.conseillerId});

  @override
  State<Pagechat> createState() => _PagechatState();
}

class _PagechatState extends State<Pagechat> {
  final MessageService messageService = MessageService();
  final TextEditingController _messageController = TextEditingController();
  String? expediteurId;

  @override
  void initState() {
    super.initState();
    expediteurId = AuthService().getCurrentUserId();
  }

  void Envoimessage() {
    if (_messageController.text.isNotEmpty && expediteurId != null) {
      final message = Message(
        id: '',
        message: _messageController.text,
        dateenvoi: Timestamp.now(),
        expediteurId: expediteurId!,
        recepteurId: widget.conseillerId,
        estPartage: false,
        estVu: false,
      );
      messageService.Envoyermessage(message);
      _messageController.clear();
    }
  }

  String _formatDate(Timestamp timestamp) {
    final date = timestamp.toDate();
    return "${date.hour}:${date.minute} ${date.day}/${date.month}/${date.year}";
  }

  Widget _buildMessage(Message message, bool isMe) {
    return Container(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      child: ConstrainedBox(
        constraints:
            BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.7),
        child: Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          color: isMe ? Colors.blue[100] : Colors.grey[300],
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment:
                  isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                Text(
                  message.message,
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 4),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (message.estPartage)
                      Icon(Icons.share, color: Colors.blue, size: 16),
                    if (message.estVu)
                      Icon(Icons.check_circle, color: Colors.green, size: 16),
                    SizedBox(width: 4),
                    Text(
                      _formatDate(message.dateenvoi),
                      style: TextStyle(fontSize: 12, color: Colors.black54),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE1F3F3),
      appBar: AppBar(
        backgroundColor: const Color(0xFFE1F3F3),
        title: StreamBuilder<User>(
          stream: messageService.getDestinataireInfo(widget.conseillerId),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Row(
                children: [
                  CircleAvatar(
                    backgroundImage: NetworkImage(snapshot.data!.imageUrl),
                  ),
                  SizedBox(width: 8),
                  Text('${snapshot.data!.prenom} ${snapshot.data!.nom}'),
                ],
              );
            }
            return Text('Conseiller');
          },
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<List<Message>>(
              stream: messageService.RecupererMessages2User(
                  expediteurId!, widget.conseillerId),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(
                      child: Text('Erreur de chargement des messages'));
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                  List<Message> messages = snapshot.data!;
                  // Tri des messages par date d'envoi
                  messages.sort((a, b) => a.dateenvoi.compareTo(b.dateenvoi));

                  return ListView.builder(
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      Message message = messages[index];
                      bool isMe = message.expediteurId == expediteurId;
                      return _buildMessage(message, isMe);
                    },
                  );
                } else {
                  return Center(child: Text("Aucun message."));
                }
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: "Entrez votre message....",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                IconButton(
                  onPressed: Envoimessage,
                  icon: Icon(Icons.send, color: Colors.blueAccent),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
