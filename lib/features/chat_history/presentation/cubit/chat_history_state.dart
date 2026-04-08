import 'package:equatable/equatable.dart';
import '../../data/models/hive_chat_session.dart';

abstract class ChatHistoryState extends Equatable {
  const ChatHistoryState();

  @override
  List<Object> get props => [];
}

class ChatHistoryInitial extends ChatHistoryState {}

class ChatHistoryLoading extends ChatHistoryState {}

class ChatHistoryLoaded extends ChatHistoryState {
  final List<HiveChatSession> sessions;

  const ChatHistoryLoaded(this.sessions);

  @override
  List<Object> get props => [sessions];
}

class ChatHistoryError extends ChatHistoryState {
  final String message;

  const ChatHistoryError(this.message);

  @override
  List<Object> get props => [message];
}
