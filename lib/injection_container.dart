import 'package:get_it/get_it.dart';
import 'features/coaches/data/repositories/coach_repository_impl.dart';
import 'features/coaches/domain/repositories/coach_repository.dart';
import 'features/coaches/presentation/cubit/coaches_cubit.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:firebase_ai/firebase_ai.dart';
import 'features/chat/data/repositories/chat_repository_impl.dart';
import 'features/chat/domain/repositories/chat_repository.dart';
import 'features/chat/presentation/cubit/chat_cubit.dart';
import 'package:firebase_auth/firebase_auth.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // cubitleri her zaman factory olarak register ederiz.
  sl.registerFactory(() => CoachesCubit(repository: sl()));
  // tek bir repo lazy olarak register edilir, yani ihtiyaç duyulana kadar oluşturulmaz.
  sl.registerLazySingleton<CoachRepository>(() => CoachRepositoryImpl());
  sl.registerLazySingleton(() => FirebaseRemoteConfig.instance);
  sl.registerLazySingleton(
    () => FirebaseAI.googleAI(auth: FirebaseAuth.instance),
  );

  // --- CHAT REPOSITORY ---
  sl.registerLazySingleton<ChatRepository>(
    () => ChatRepositoryImpl(remoteConfig: sl(), firebaseAI: sl()),
  );

  // --- CHAT CUBIT ---
  sl.registerFactory(() => ChatCubit(repository: sl()));
}
