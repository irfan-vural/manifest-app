import 'package:hive/hive.dart';

part 'hive_chat_message.g.dart';

@HiveType(typeId: 0)
class HiveChatMessage extends HiveObject {
  @HiveField(0)
  final String text;

  @HiveField(1)
  final bool isUser;

  @HiveField(2)
  final DateTime timestamp;

  HiveChatMessage({
    required this.text,
    required this.isUser,
    required this.timestamp,
  });
}
