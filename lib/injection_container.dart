import 'package:get_it/get_it.dart';
import 'features/coaches/data/repositories/coach_repository_impl.dart';
import 'features/coaches/domain/repositories/coach_repository.dart';
import 'features/coaches/presentation/cubit/coaches_cubit.dart';

// service Locator'ın kısaltması. Tüm bağımlılıklarımızı bu obje üzerinden yöneteceğiz.
final sl = GetIt.instance;

Future<void> init() async {
  // cubitleri her zaman factory olarak register ederiz.
  sl.registerFactory(() => CoachesCubit(repository: sl()));
  // tek bir repo lazy olarak register edilir, yani ihtiyaç duyulana kadar oluşturulmaz.
  sl.registerLazySingleton<CoachRepository>(() => CoachRepositoryImpl());
}
