import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:firebase_ai/firebase_ai.dart';
import '../../domain/repositories/chat_repository.dart';

class ChatRepositoryImpl implements ChatRepository {
  final FirebaseRemoteConfig remoteConfig;
  final FirebaseAI firebaseAI;

  ChatRepositoryImpl({required this.remoteConfig, required this.firebaseAI});

  @override
  Future<ChatSession> startChatSession(
    String remoteConfigKey, {
    List<Content>? history,
  }) async {
    // rc güncel verileri çek ve aktif et
    await remoteConfig.fetchAndActivate();

    // coach system instruction'ını al
    final prompt = remoteConfig.getString(remoteConfigKey);

    final model = firebaseAI.generativeModel(
      model: 'gemini-2.5-flash-lite',
      systemInstruction: Content.system(prompt),
    );
    // modeli sohbet oturumuna dönüştür ve döndür
    return model.startChat(history: history ?? []);
  }
}
