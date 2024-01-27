import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:research/common/loader.dart';
import 'package:research/features/auth/auth_controller.dart';
import 'package:research/firebase_options.dart';
import 'package:research/router.dart';
import 'package:research/theme/pallete.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    const ProviderScope(child: MyApp()),
  );
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ref.watch(authStateChangesProvider).when(
          data: (data) {
            return MaterialApp.router(
              title: 'theResearch',
              theme: ThemeData(
                colorScheme: ColorScheme.fromSeed(
                  seedColor: Pallete.primaryColor,
                ),
                useMaterial3: true,
              ),
              routerConfig: data != null ? loggedInRouter : loggedOutRouter,
            );
          },
          error: (error, st) {
            return MaterialApp(
              title: 'theResearch',
              theme: ThemeData(
                colorScheme: ColorScheme.fromSeed(
                  seedColor: Pallete.primaryColor,
                ),
                useMaterial3: true,
              ),
              home: Text(error.toString()),
            );
          },
          loading: () => MaterialApp(
            title: 'theResearch',
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(
                seedColor: Pallete.primaryColor,
              ),
              useMaterial3: true,
            ),
            home: const Loader(),
          ),
        );
  }
}
