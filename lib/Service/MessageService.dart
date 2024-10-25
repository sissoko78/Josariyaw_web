import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:josariyaw/Model/Message.dart';
import 'package:rxdart/rxdart.dart';

import '../Model/User.dart';

class MessageService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> Envoyermessage(Message message) async {
    try {
      await _firestore.collection('messages').add(message.toMap());
    } catch (e) {
      throw Exception("Erreur lors de l'envoi: $e");
    }
  }

  // Ajoutez cette méthode pour récupérer les informations du destinataire
  Stream<User> getDestinataireInfo(String conseillerId) {
    return _firestore
        .collection('users')
        .doc(conseillerId)
        .snapshots()
        .map((snapshot) {
      if (snapshot.exists) {
        final data = snapshot.data() as Map<String, dynamic>;
        return User.fromMap(
            data); // Assurez-vous que votre modèle User a une méthode fromMap
      } else {
        throw Exception('Utilisateur non trouvé');
      }
    });
  }

  Stream<List<Message>> RecupererMessages2User(
      String userId, String recepteurId) {
    final userMessagesStream = _firestore
        .collection('messages')
        .where('expediteurId', isEqualTo: userId)
        .where('recepteurId', isEqualTo: recepteurId)
        .orderBy('dateenvoi')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return Message.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
    });

    final receiverMessagesStream = _firestore
        .collection('messages')
        .where('expediteurId', isEqualTo: recepteurId)
        .where('recepteurId', isEqualTo: userId)
        .orderBy('dateenvoi')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return Message.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
    });

    return Rx.combineLatest2(userMessagesStream, receiverMessagesStream,
        (List<Message> userMessages, List<Message> receiverMessages) {
      return userMessages + receiverMessages; // Combine the two lists
    });
  }

  // Récupérer la liste des utilisateurs avec lesquels l'utilisateur a discuté
  Future<List<User>> recupererListeUtilisateurs(String userId) async {
    final Set<String> userIds = {};

    // Récupérer les IDs des utilisateurs dans les messages envoyés
    final senderMessages = await _firestore
        .collection('messages')
        .where('expediteurId', isEqualTo: userId)
        .get();

    for (var doc in senderMessages.docs) {
      userIds.add(doc['recepteurId']);
    }

    // Récupérer les IDs des utilisateurs dans les messages reçus
    final receiverMessages = await _firestore
        .collection('messages')
        .where('recepteurId', isEqualTo: userId)
        .get();

    for (var doc in receiverMessages.docs) {
      userIds.add(doc['expediteurId']);
    }

    // Récupérer les informations des utilisateurs à partir de leurs IDs
    final List<User> utilisateurs = [];
    for (var id in userIds) {
      final userDoc = await _firestore.collection('users').doc(id).get();
      if (userDoc.exists) {
        utilisateurs.add(User.fromFirestore(userDoc.data()!, userDoc.id));
      }
    }

    return utilisateurs.toList();
  }

  Future<Message?> getDernierMessage(
      String utilisateurId, String expediteurId) async {
    final snapshot = await _firestore
        .collection('messages')
        .where('expediteurId', isEqualTo: utilisateurId)
        .where('recepteurId', isEqualTo: expediteurId)
        .orderBy('dateenvoi', descending: true)
        .limit(1)
        .get();

    if (snapshot.docs.isNotEmpty) {
      return Message.fromMap(snapshot.docs.first.data() as Map<String, dynamic>,
          snapshot.docs.first.id);
    }
    return null; // Aucun message trouvé
  }

  Future<int> getNombreMessagesNonVus(
      String destinataireId, String expediteurId) async {
    final snapshot = await _firestore
        .collection('messages')
        .where('recepteurId', isEqualTo: expediteurId)
        .where('expediteurId', isEqualTo: destinataireId)
        .where('estVu', isEqualTo: false)
        .get();

    return snapshot.docs.length; // Retourne le nombre de messages non vus
  }
}
