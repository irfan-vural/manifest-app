import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:manifestapp/features/chat/presentation/pages/chat_page.dart';
import 'package:manifestapp/features/coaches/domain/entities/coach.dart';
import '../cubit/chat_history_cubit.dart';
import '../cubit/chat_history_state.dart';

class ChatHistoryPage extends StatelessWidget {
  const ChatHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Chat History'), centerTitle: true),
      body: BlocBuilder<ChatHistoryCubit, ChatHistoryState>(
        builder: (context, state) {
          if (state is ChatHistoryLoading || state is ChatHistoryInitial) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ChatHistoryError) {
            return Center(child: Text(state.message));
          } else if (state is ChatHistoryLoaded) {
            final sessions = state.sessions;

            if (sessions.isEmpty) {
              return const Center(
                child: Text('Henüz hiçbir koçla sohbet etmedin.'),
              );
            }

            return ListView.builder(
              itemCount: sessions.length,
              itemBuilder: (context, index) {
                final session = sessions[index];
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
                      overflow: TextOverflow.ellipsis,
                    ),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      final coach = Coach(
                        id: session.coachId,
                        name: session.coachName,
                        iconPath: '',
                        remoteConfigKey: session.coachId,
                      );

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              ChatPage(coach: coach, existingSession: session),
                        ),
                      ).then((_) {
                        context.read<ChatHistoryCubit>().loadSessions();
                      });
                    },
                  ),
                );
              },
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
