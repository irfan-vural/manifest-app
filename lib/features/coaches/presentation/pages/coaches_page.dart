import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:manifestapp/features/chat/presentation/pages/chat_page.dart';
import '../../../../injection_container.dart';
import '../cubit/coaches_cubit.dart';
import '../cubit/coaches_state.dart';

class CoachesPage extends StatelessWidget {
  const CoachesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<CoachesCubit>()..fetchCoaches(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('WellnessAI - Choose Your Expert'),
          centerTitle: true,
        ),
        body: BlocBuilder<CoachesCubit, CoachesState>(
          builder: (context, state) {
            // loading durumu
            if (state is CoachesLoading || state is CoachesInitial) {
              return const Center(child: CircularProgressIndicator());
            }
            // hatalı durum
            else if (state is CoachesError) {
              return Center(child: Text(state.message));
            }
            // başarılı yüklenme durumunda koçların listesini alıp GridView ile gösteriyoruz
            else if (state is CoachesLoaded) {
              final coaches = state.coaches;

              // griidview yapısı
              return GridView.builder(
                padding: const EdgeInsets.all(16),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                itemCount: coaches.length,
                itemBuilder: (context, index) {
                  final coach = coaches[index];
                  return Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ChatPage(coach: coach),
                          ),
                        );
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.person,
                            size: 64,
                            color: Colors.deepPurple,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            coach.name,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }

            return const SizedBox.shrink(); // bklenmeyen bir durumda boş widget döner
          },
        ),
      ),
    );
  }
}
