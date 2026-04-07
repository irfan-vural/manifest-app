import 'package:equatable/equatable.dart';

class ChatMessage extends Equatable {
  final String text;
  final bool isUser;
  final DateTime timestamp;

  const ChatMessage({
    required this.text,
    required this.isUser,
    required this.timestamp,
  });

  @override
  List<Object> get props => [text, isUser, timestamp];
}

// Cubit State'lerimiz
abstract class ChatState extends Equatable {
  const ChatState();

  @override
  List<Object> get props => [];
}

class ChatInitial extends ChatState {}

class ChatConnecting extends ChatState {}

class ChatActive extends ChatState {
  final List<ChatMessage> messages;
  final bool isBotTyping;

  const ChatActive({required this.messages, this.isBotTyping = false});

  @override
  List<Object> get props => [messages, isBotTyping];
}

class ChatError extends ChatState {
  final String errorMessage;

  const ChatError(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];
}
