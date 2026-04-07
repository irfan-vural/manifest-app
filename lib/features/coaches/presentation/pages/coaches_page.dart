import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../injection_container.dart';
import '../cubit/coaches_cubit.dart';
import '../cubit/coaches_state.dart';

class CoachesPage extends StatelessWidget {
  const CoachesPage({super.key});

  @override
  Widget build(BuildContext context) {
    // BlocProvider, Cubit'i bu sayfaya ve altındaki tüm widget'lara sağlar
    return BlocProvider(
      // sl() ile GetIt üzerinden Cubit'imizin taze bir kopyasını alıp fetchCoaches() metodunu tetikliyoruz
      create: (_) => sl<CoachesCubit>()..fetchCoaches(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('WellnessAI - Choose Your Expert'),
          centerTitle: true,
        ),
        // BlocBuilder, Cubit'ten gelen state değişikliklerini dinler ve sadece burayı rebuild eder
        body: BlocBuilder<CoachesCubit, CoachesState>(
          builder: (context, state) {
            // Veriler yüklenirken ekranda dönen bir progress indicator gösteriyoruz
            if (state is CoachesLoading || state is CoachesInitial) {
              return const Center(child: CircularProgressIndicator());
            }
            // Hata durumunda hata mesajını ekrana basıyoruz
            else if (state is CoachesError) {
              return Center(child: Text(state.message));
            }
            // Veriler başarıyla geldiğinde GridView'i çiziyoruz
            else if (state is CoachesLoaded) {
              final coaches = state.coaches;

              // Case'de istenen GridView yapısı
              return GridView.builder(
                padding: const EdgeInsets.all(16),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // Yan yana 2 koç kartı
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
                        // Tıklanınca chat sayfasına gidecek (navigate işlemini daha sonra ekleyeceğiz)
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Şimdilik placeholder ikon koyalım, assetleri sonra ayarlarız
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

            return const SizedBox.shrink(); // Beklenmeyen bir durumda boş widget döner
          },
        ),
      ),
    );
  }
}
