import '../../domain/entities/coach.dart';
import '../../domain/repositories/coach_repository.dart';

class CoachRepositoryImpl implements CoachRepository {
  @override
  Future<List<Coach>> getCoaches() async {
    // ağa bağlanıyormuşuz gibi ufak bir gecikme ekliyoruz
    await Future.delayed(const Duration(milliseconds: 500));

    // hardcoded olarak bazı koç verileri döndürüyoruz, gerçek uygulamada bu veriler bir API'dençekilebilir
    return const [
      Coach(
        id: '1',
        name: 'Dietitian',
        iconPath: 'assets/icons/dietitian.png',
        remoteConfigKey: 'prompt_dietitian',
      ),
      Coach(
        id: '2',
        name: 'Fitness Coach',
        iconPath: 'assets/icons/fitness.png',
        remoteConfigKey: 'prompt_fitness',
      ),
      Coach(
        id: '3',
        name: 'Yoga Instructor',
        iconPath: 'assets/icons/yoga.png',
        remoteConfigKey: 'prompt_yoga',
      ),
      Coach(
        id: '4',
        name: 'Pilates Coach',
        iconPath: 'assets/icons/pilates.png',
        remoteConfigKey: 'prompt_pilates',
      ),
    ];
  }
}
