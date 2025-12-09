import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'services/FloatingButtonController.dart';
import 'screens/StartScreen.dart';
import 'screens/SplashScreen.dart';
import 'screens/LoginScreen.dart';
import 'screens/RegisterScreen.dart';
import 'screens/HomeScreen.dart';
import 'screens/DenunciaScreen.dart';
import 'screens/TutorialScreen.dart';
import 'widgets/FloatingButton.dart';

// ✅ IMPORT DO NAVIGATION SERVICE
import '../services/navigator.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => FloatingButtonController()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey, // ✅ ESSENCIAL
      debugShowCheckedModeBanner: false,
      title: 'Serena App',
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.purple),

      initialRoute: '/',

      builder: (context, child) {
        return Stack(
          children: [
            child!,

            Consumer<FloatingButtonController>(
              builder: (context, controller, _) {
                if (!controller.isEnabled) return const SizedBox.shrink();

                return FloatingButton(); // ✅ SEM CONTEXT AQUI
              },
            ),
          ],
        );
      },

      routes: {
        '/': (context) => const SplashScreen(),
        '/home': (context) => const StartScreen(),
        '/LoginScreen': (context) => const LoginScreen(),
        '/RegisterScreen': (context) => const RegisterScreen(),
        '/HomeScreen': (context) => const HomeScreen(),
        '/DenunciaScreen': (context) => const DenunciaScreen(),
        '/TutorialScreen': (context) => const TutorialScreen(),
      },
    );
  }
}
