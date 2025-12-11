import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:serenafrontend/screens/PerfilScreen.dart';

import 'services/FloatingButtonController.dart';
import 'screens/StartScreen.dart';
import 'screens/SplashScreen.dart';
import 'screens/LoginScreen.dart';
import 'screens/RegisterScreen.dart';
import 'screens/HomeScreen.dart';
import 'screens/DenunciaScreen.dart';
import 'screens/TutorialScreen.dart';
import 'widgets/FloatingButton.dart';
import 'screens/ConfigScreen.dart';

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
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.light,
          primary: Colors.deepPurple,
          onPrimary: Colors.white,
          secondary: Colors.purpleAccent,
          onSecondary: Colors.white,
          background: Colors.white,
          onBackground: Colors.black87,
          surface: Colors.white,
          onSurface: Colors.black87,
          error: Colors.redAccent,
          onError: Colors.white,
        ),
        fontFamily: 'Manrope',

        // 🔹 TextTheme simplificado para evitar conflitos e manter nitidez
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Colors.black87),
          bodyMedium: TextStyle(color: Colors.black87),
          bodySmall: TextStyle(color: Colors.black87),
          titleLarge: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.w700,
          ),
          titleMedium: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.w700,
          ),
          titleSmall: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.w700,
          ),
          labelLarge: TextStyle(color: Colors.black87),
          labelMedium: TextStyle(color: Colors.black87),
          labelSmall: TextStyle(color: Colors.black87),
        ),
      ),

      initialRoute: '/',

      builder: (context, child) {
        return Stack(
          children: [
            child!,

            Consumer<FloatingButtonController>(
              builder: (context, controller, _) {
                if (!controller.isEnabled) return const SizedBox.shrink();
                return FloatingButton();
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
        '/PerfilScreen': (context) => const PerfilScreen(),
        '/ConfigScreen': (context) => const ConfigScreen(),
      },
    );
  }
}
