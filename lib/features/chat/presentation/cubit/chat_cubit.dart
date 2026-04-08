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
        // GEÇMİŞ SOHBETİ YÜKLE
        _hiveSession = existingSession;

        // Veritabanındaki mesajları ekranda göstermek için ChatMessage'a çeviriyoruz
        for (var m in existingSession.messages) {
          _messages.add(
            ChatMessage(text: m.text, isUser: m.isUser, timestamp: m.timestamp),
          );
          // AI'ın eski sohbeti hatırlaması için history listesini dolduruyoruz
          aiHistory.add(
            m.isUser ? Content.text(m.text) : Content.model([TextPart(m.text)]),
          );
        }
      } else {
        // YENİ SOHBET OLUŞTUR
        // Benzersiz bir ID için o anki zamanı kullanıyoruz (Kısa ve pratik çözüm)
        final sessionId = DateTime.now().millisecondsSinceEpoch.toString();
        _hiveSession = HiveChatSession(
          id: sessionId,
          coachId: remoteConfigKey,
          coachName: coachName,
          messages: [],
          lastUpdated: DateTime.now(),
        );
      }

      // Modeli history (geçmiş) ile birlikte ayağa kaldırıyoruz
      _chatSession = await repository.startChatSession(
        remoteConfigKey,
        history: aiHistory,
      );

      // Sadece yeni sohbette bot ilk karşılama mesajını atsın
      if (existingSession == null) {
        final welcomeText =
            'Hi! I am your $coachName coach. How can I help you?';
        _messages.add(
          ChatMessage(
            text: welcomeText,
            isUser: false,
            timestamp: DateTime.now(),
          ),
        );

        // Veritabanına da kaydediyoruz
        _hiveSession!.messages.add(
          HiveChatMessage(
            text: welcomeText,
            isUser: false,
            timestamp: DateTime.now(),
          ),
        );
        await historyRepository.saveSession(_hiveSession!);
      }

      emit(ChatActive(messages: List.from(_messages)));
    } catch (e) {
      emit(ChatError('Bağlantı kurulamadı: ${e.toString()}'));
    }
  }

  Future<void> sendMessage(String text) async {
    if (_chatSession == null || text.trim().isEmpty) return;

    // 1. Kullanıcının mesajını ekrana ve veritabanına ekle
    final userMsg = ChatMessage(
      text: text,
      isUser: true,
      timestamp: DateTime.now(),
    );
    _messages.add(userMsg);

    _hiveSession!.messages.add(
      HiveChatMessage(text: text, isUser: true, timestamp: userMsg.timestamp),
    );
    _hiveSession!.lastUpdated =
        DateTime.now(); // Sıralama için son güncellenme tarihini yenile
    await historyRepository.saveSession(_hiveSession!); // Kaydet

    emit(ChatActive(messages: List.from(_messages), isBotTyping: true));

    try {
      // 2. Mesajı AI'a gönder ve cevabı bekle
      final response = await _chatSession!.sendMessage(Content.text(text));
      final botText = response.text ?? 'Üzgünüm, bir hata oluştu.';

      // 3. Botun cevabını ekrana ve veritabanına ekle
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
      await historyRepository.saveSession(_hiveSession!); // Kaydet

      emit(ChatActive(messages: List.from(_messages), isBotTyping: false));
    } catch (e) {
      emit(ChatError('Mesaj gönderilemedi: ${e.toString()}'));
    }
  }
}
