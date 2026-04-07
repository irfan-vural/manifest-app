import 'package:firebase_ai/firebase_ai.dart';

abstract class ChatRepository {
  // bir sohbet oturumu dönecek
  Future<ChatSession> startChatSession(
    String remoteConfigKey, {
    List<Content>? history,
  });
}
