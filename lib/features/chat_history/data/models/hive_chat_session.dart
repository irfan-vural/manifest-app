import 'package:hive/hive.dart';
import 'hive_chat_message.dart';

part 'hive_chat_session.g.dart';

@HiveType(typeId: 1)
class HiveChatSession extends HiveObject {
  @HiveField(0)
  final String id; // Sohbetin benzersiz uudi

  @HiveField(1)
  final String coachId;

  @HiveField(2)
  final String coachName;

  @HiveField(3)
  List<HiveChatMessage> messages;

  @HiveField(4)
  DateTime lastUpdated;
  HiveChatSession({
    required this.id,
    required this.coachId,
    required this.coachName,
    required this.messages,
    required this.lastUpdated,
  });
}
