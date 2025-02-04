import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:musync/core/providers/current_user_notifier.dart';
import 'package:musync/core/theme/theme.dart';
import 'package:musync/features/auth/view/pages/login_page.dart';
import 'package:musync/features/auth/viewmodel/auth_viewmodel.dart';
import 'package:musync/features/home/view/pages/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await JustAudioBackground.init(
    androidNotificationChannelId: 'com.ryanheise.bg_demo.channel.audio',
    androidNotificationChannelName: 'Audio playback',
    androidNotificationOngoing: true,
  );
  await Hive.initFlutter();
  await Hive.openBox('musync');
  final container = ProviderContainer();
  try {
    await container
        .read(authViewModelProvider.notifier)
        .initSharedPreferences();
    await container.read(authViewModelProvider.notifier).getData();
  } catch (e) {
    debugPrint('Error during initialization $e');
  }
  runApp(UncontrolledProviderScope(container: container, child: const MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(currentUserNotifierProvider);

    return MaterialApp(
      title: 'Musync',
      theme: AppTheme.darkThemeMode,
      home: currentUser == null ? const LoginPage() : const HomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
