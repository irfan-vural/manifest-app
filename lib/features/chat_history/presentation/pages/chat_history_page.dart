import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../injection_container.dart';
import '../cubit/chat_history_cubit.dart';
import '../cubit/chat_history_state.dart';

class ChatHistoryPage extends StatelessWidget {
  const ChatHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      // Sayfa açılır açılmaz geçmiş sohbetleri veritabanından çekiyoruz
      create: (_) => sl<ChatHistoryCubit>()..loadSessions(),
      child: Scaffold(
        appBar: AppBar(title: const Text('Chat History'), centerTitle: true),
        body: BlocBuilder<ChatHistoryCubit, ChatHistoryState>(
          builder: (context, state) {
            if (state is ChatHistoryLoading || state is ChatHistoryInitial) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is ChatHistoryError) {
              return Center(child: Text(state.message));
            } else if (state is ChatHistoryLoaded) {
              final sessions = state.sessions;

              // Eğer hiç geçmiş sohbet yoksa kullanıcıya boş state gösteriyoruz
              if (sessions.isEmpty) {
                return const Center(
                  child: Text('Henüz hiçbir koçla sohbet etmedin.'),
                );
              }

              // Geçmiş sohbetleri listeleyen yapı
              return ListView.builder(
                itemCount: sessions.length,
                itemBuilder: (context, index) {
                  final session = sessions[index];
                  // Son mesajı almak için
                  final lastMessage = session.messages.isNotEmpty
                      ? session.messages.last.text
                      : 'Mesaj yok';

                  return Card(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    child: ListTile(
                      leading: const CircleAvatar(
                        backgroundColor: Colors.deepPurple,
                        child: Icon(Icons.history, color: Colors.white),
                      ),
                      title: Text(
                        session.coachName,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        lastMessage,
                        maxLines: 1,
                        overflow: TextOverflow
                            .ellipsis, // Uzun mesajların sonuna ... koyar
                      ),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () {
                        // Tıklanınca o sohbetin içine (kaldığı yerden) girme işlemini birazdan ekleyeceğiz
                      },
                    ),
                  );
                },
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
