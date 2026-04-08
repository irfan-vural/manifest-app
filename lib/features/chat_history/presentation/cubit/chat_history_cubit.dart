import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/chat_history_repository.dart';
import 'chat_history_state.dart';

class ChatHistoryCubit extends Cubit<ChatHistoryState> {
  final ChatHistoryRepository repository;

  ChatHistoryCubit({required this.repository}) : super(ChatHistoryInitial());

  // Veritabanından tüm geçmiş sohbetleri çeken fonksiyon
  Future<void> loadSessions() async {
    emit(ChatHistoryLoading());
    try {
      final sessions = await repository.getAllSessions();
      emit(ChatHistoryLoaded(sessions));
    } catch (e) {
      emit(ChatHistoryError('Geçmiş yüklenirken hata oluştu: ${e.toString()}'));
    }
  }
}
