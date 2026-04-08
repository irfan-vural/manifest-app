import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart' show BlocProvider;
import 'package:manifestapp/features/chat_history/presentation/cubit/chat_history_cubit.dart'
    show ChatHistoryCubit;
import 'firebase_options.dart';
import 'injection_container.dart' as di;
import 'core/presentation/pages/main_wrapper.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'features/chat_history/data/models/hive_chat_message.dart';
import 'features/chat_history/data/models/hive_chat_session.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  // Uygulama ayağa kalkmadan önce tüm bağımlılıkları başlatıyoruz
  await Hive.initFlutter();

  Hive.registerAdapter(HiveChatMessageAdapter());
  Hive.registerAdapter(HiveChatSessionAdapter());

  // chat oturumlarını box
  await Hive.openBox<HiveChatSession>('chat_sessions');
  await di.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => di.sl<ChatHistoryCubit>()..loadSessions(),
      child: MaterialApp(
        title: 'Wellness AI',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const MainWrapper(),
      ),
    );
  }
}
