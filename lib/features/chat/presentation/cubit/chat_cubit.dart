import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_ai/firebase_ai.dart';
import 'package:manifestapp/features/chat_history/data/models/hive_chat_message.dart'
    show HiveChatMessage;
import 'package:manifestapp/features/chat_history/data/models/hive_chat_session.dart'
    show HiveChatSession;
import 'package:manifestapp/features/chat_history/domain/repositories/chat_history_repository.dart';
import '../../domain/repositories/chat_repository.dart';
import 'chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  final ChatRepository repository;
  final ChatHistoryRepository historyRepository;
  ChatSession? _chatSession;
  final List<ChatMessage> _messages = [];
  HiveChatSession? _hiveSession;
  ChatCubit({required this.repository, required this.historyRepository})
    : super(ChatInitial());
  Future<void> startConversation(
    String remoteConfigKey,
    String coachName, {
    HiveChatSession? existingSession,
  }) async {
    emit(ChatConnecting());
    try {
      List<Content> aiHistory = [];

      if (existingSession != null) {
        _hiveSession = existingSession;
        for (var m in existingSession.messages) {
          _messages.add(
            ChatMessage(text: m.text, isUser: m.isUser, timestamp: m.timestamp),
          );
          aiHistory.add(
            m.isUser ? Content.text(m.text) : Content.model([TextPart(m.text)]),
          );
        }
      } else {
        final sessionId = DateTime.now().millisecondsSinceEpoch.toString();
        _hiveSession = HiveChatSession(
          id: sessionId,
          coachId: remoteConfigKey,
          coachName: coachName,
          messages: [],
          lastUpdated: DateTime.now(),
        );
      }

      _chatSession = await repository.startChatSession(
        remoteConfigKey,
        history: aiHistory,
      );

      if (existingSession == null) {
        final welcomeText =
            'Hello! I am your $coachName coach. How can I help you?';

        _messages.add(
          ChatMessage(
            text: welcomeText,
            isUser: false,
            timestamp: DateTime.now(),
          ),
        );

        _hiveSession!.messages.add(
          HiveChatMessage(
            text: welcomeText,
            isUser: false,
            timestamp: DateTime.now(),
          ),
        );
      }

      emit(ChatActive(messages: List.from(_messages)));
    } catch (e) {
      emit(ChatError('Connection failed: ${e.toString()}'));
    }
  }

  Future<void> sendMessage(String text) async {
    if (_chatSession == null || text.trim().isEmpty) return;

    final userMsg = ChatMessage(
      text: text,
      isUser: true,
      timestamp: DateTime.now(),
    );
    _messages.add(userMsg);

    _hiveSession!.messages.add(
      HiveChatMessage(text: text, isUser: true, timestamp: userMsg.timestamp),
    );
    _hiveSession!.lastUpdated = DateTime.now();

    await historyRepository.saveSession(_hiveSession!);

    emit(ChatActive(messages: List.from(_messages), isBotTyping: true));

    try {
      final response = await _chatSession!.sendMessage(Content.text(text));
      final botText = response.text ?? 'something went wrong...';

      final botMsg = ChatMessage(
        text: botText,
        isUser: false,
        timestamp: DateTime.now(),
      );
      _messages.add(botMsg);

      _hiveSession!.messages.add(
        HiveChatMessage(
          text: botText,
          isUser: false,
          timestamp: botMsg.timestamp,
        ),
      );
      _hiveSession!.lastUpdated = DateTime.now();

      await historyRepository.saveSession(_hiveSession!);

      emit(ChatActive(messages: List.from(_messages), isBotTyping: false));
    } catch (e) {
      emit(ChatError('Message failed to send: ${e.toString()}'));
    }
  }
}
