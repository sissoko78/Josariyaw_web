import 'User.dart';

class Discussion {
  final User utilisateur;
  final String? dernierMessage;
  final int nombreMessagesNonVus;

  Discussion({
    required this.utilisateur,
    this.dernierMessage,
    this.nombreMessagesNonVus = 0,
  });
}
