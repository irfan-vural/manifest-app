import 'package:hive/hive.dart';
import 'package:manifestapp/features/chat_history/data/models/hive_chat_session.dart'
    show HiveChatSession;
import '../../domain/repositories/chat_history_repository.dart';

class ChatHistoryRepositoryImpl implements ChatHistoryRepository {
  final Box<HiveChatSession> sessionBox;

  ChatHistoryRepositoryImpl({required this.sessionBox});

  @override
  Future<void> saveSession(HiveChatSession session) async {
    await sessionBox.put(session.id, session);
  }

  @override
  Future<List<HiveChatSession>> getAllSessions() async {
    final sessions = sessionBox.values.toList();

    sessions.sort((a, b) => b.lastUpdated.compareTo(a.lastUpdated));

    return sessions;
  }
}
