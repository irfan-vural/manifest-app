import '../../data/models/hive_chat_session.dart';

abstract class ChatHistoryRepository {
  // yeni bir sohbeti kaydetmek veya var olanı güncellemek için
  Future<void> saveSession(HiveChatSession session);

  // geçmiş listesinde göstermek üzere tüm sohbetleri çekmek için
  Future<List<HiveChatSession>> getAllSessions();
}
