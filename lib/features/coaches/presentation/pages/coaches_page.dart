import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../injection_container.dart';
import '../../../chat/presentation/pages/chat_page.dart';
import '../../../chat_history/presentation/cubit/chat_history_cubit.dart';
import '../../domain/entities/coach.dart';
import '../cubit/coaches_cubit.dart';
import '../cubit/coaches_state.dart';

class CoachesPage extends StatelessWidget {
  const CoachesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Manifest AI ',
          style: TextStyle(
            fontWeight: FontWeight.w800,
            color: Colors.black87,
            letterSpacing: -0.5,
          ),
        ),
      ),
      body: BlocProvider(
        create: (_) => sl<CoachesCubit>()..fetchCoaches(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 24.0,
                vertical: 16.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Hi there, ready to manifest?',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepPurple.shade800,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'How do you feel today? Choose a coach that matches your goal and get started immediately.',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey.shade600,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // kartların Listelendiği Grid Alanı
            Expanded(
              child: BlocBuilder<CoachesCubit, CoachesState>(
                builder: (context, state) {
                  if (state is CoachesLoading || state is CoachesInitial) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is CoachesError) {
                    return Center(child: Text(state.message));
                  } else if (state is CoachesLoaded) {
                    return GridView.builder(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24.0,
                        vertical: 8.0,
                      ),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 16,
                            mainAxisSpacing: 16,
                            childAspectRatio: 0.85,
                          ),
                      itemCount: state.coaches.length,
                      itemBuilder: (context, index) {
                        final coach = state.coaches[index];
                        return _buildCoachCard(context, coach);
                      },
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCoachCard(BuildContext context, Coach coach) {
    IconData coachIcon;
    Color iconColor;

    final nameLower = coach.name.toLowerCase();
    if (nameLower.contains('diet')) {
      coachIcon = Icons.apple_rounded;
      iconColor = Colors.green;
    } else if (nameLower.contains('fit')) {
      coachIcon = Icons.fitness_center_rounded;
      iconColor = Colors.orange;
    } else if (nameLower.contains('yoga')) {
      coachIcon = Icons.self_improvement_rounded;
      iconColor = Colors.purple;
    } else {
      coachIcon = Icons.sports_gymnastics_rounded;
      iconColor = Colors.blue;
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(
          28,
        ), // Daha yuvarlak ve modern hatlar
        boxShadow: [
          BoxShadow(
            color: iconColor.withOpacity(0.08),
            blurRadius: 15,
            spreadRadius: 2,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(28),
          splashColor: iconColor.withOpacity(0.1),
          highlightColor: iconColor.withOpacity(0.05),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ChatPage(coach: coach)),
            ).then((_) {
              context.read<ChatHistoryCubit>().loadSessions();
            });
          },
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: iconColor.withOpacity(0.12),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(coachIcon, size: 38, color: iconColor),
                ),
                const Spacer(),
                Text(
                  coach.name,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Colors.black87,
                    letterSpacing: -0.3,
                  ),
                ),
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'Start a session',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
