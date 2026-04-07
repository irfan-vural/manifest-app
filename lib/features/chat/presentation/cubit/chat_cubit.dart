import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_ai/firebase_ai.dart';
import '../../domain/repositories/chat_repository.dart';
import 'chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  final ChatRepository repository;

  ChatSession? _chatSession;
  final List<ChatMessage> _messages = [];

  ChatCubit({required this.repository}) : super(ChatInitial());

  Future<void> startConversation(
    String remoteConfigKey,
    String coachName,
  ) async {
    emit(ChatConnecting());
    try {
      _chatSession = await repository.startChatSession(remoteConfigKey);

      _messages.add(
        ChatMessage(
          text:
              'Merhaba! Ben senin $coachName koçunum. Sana nasıl yardımcı olabilirim?',
          isUser: false,
          timestamp: DateTime.now(),
        ),
      );

      emit(ChatActive(messages: List.from(_messages)));
    } catch (e) {
      emit(ChatError('Bağlantı kurulamadı: ${e.toString()}'));
    }
  }

  Future<void> sendMessage(String text) async {
    if (_chatSession == null || text.trim().isEmpty) return;

    _messages.add(
      ChatMessage(text: text, isUser: true, timestamp: DateTime.now()),
    );
    emit(ChatActive(messages: List.from(_messages), isBotTyping: true));

    try {
      final response = await _chatSession!.sendMessage(Content.text(text));
      final botText = response.text ?? 'Üzgünüm, bir hata oluştu.';

      _messages.add(
        ChatMessage(text: botText, isUser: false, timestamp: DateTime.now()),
      );
      emit(ChatActive(messages: List.from(_messages), isBotTyping: false));
    } catch (e) {
      emit(ChatError('Mesaj gönderilemedi: ${e.toString()}'));
    }
  }
}
