import 'dart:async';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    // ✅ Controla o tempo da animação
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    );

    // ✅ Animação de fade (aparecer)
    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(_controller);

    // ✅ Animação de zoom (crescer)
    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(_controller);

    // ✅ Inicia a animação
    _controller.forward();

    // ✅ Após 3 segundos, vai para a Home
    Timer(const Duration(seconds: 4), () {
      Navigator.pushReplacementNamed(context, '/home');
    });
  }

  @override
  void dispose() {
    _controller.dispose(); // evita vazamento de memória
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A0033),
      body: Center(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: ScaleTransition(
            scale: _scaleAnimation,
            child: Image.asset('lib/assets/icons/Group6.png', width: 180),
          ),
        ),
      ),
    );
  }
}
