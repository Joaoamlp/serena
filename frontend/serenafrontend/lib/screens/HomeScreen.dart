import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:serenafrontend/widgets/CustomBottomNav.dart';
import 'package:serenafrontend/widgets/infoCarousel.dart';
import 'package:serenafrontend/services/FloatingButtonController.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  Widget cardHome(IconData icon, String text) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 10)],
        ),
        child: Column(
          children: [
            Icon(icon, color: Colors.deepPurple, size: 30),
            const SizedBox(height: 10),
            Text(text, textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      backgroundColor: const Color(0xFFF3ECFF),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Bem-vinda ao Serena',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurple,
                  ),
                ),
                const Text(
                  'Seu acesso é discreto e seguro',
                  style: TextStyle(color: Colors.grey),
                ),

                const SizedBox(height: 24),

                Row(
                  children: [
                    cardHome(Icons.security, 'Dicas de\nSegurança'),
                    const SizedBox(width: 16),
                    cardHome(Icons.report, 'Realize uma\nDenúncia'),
                  ],
                ),

                const SizedBox(height: 20),

                // -------------------------------------------------------------
                //  BOTÃO QUE ATIVA O BOTÃO FLUTUANTE GLOBAL
                // -------------------------------------------------------------
                ElevatedButton(
                  onPressed: () {
                    context.read<FloatingButtonController>().toggle();

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          context.read<FloatingButtonController>().isEnabled
                              ? "Botão Serena ativado"
                              : "Botão Serena desativado",
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 50),
                    backgroundColor: Colors.deepPurple,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 5,
                  ),

                  // 🔥 TEXTO MUDA AUTOMATICAMENTE
                  child: Text(
                    context.watch<FloatingButtonController>().isEnabled
                        ? 'Desativar botão'
                        : 'Ativar botão',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 10),

                ElevatedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    backgroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 5,
                  ),
                  child: const Text(
                    'Fale com a Serena',
                    style: TextStyle(color: Colors.deepPurple),
                  ),
                ),

                const SizedBox(height: 24),

                const Text(
                  'Informações',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 12),

                const InfoCarousel(),
              ],
            ),
          ),
        ),
      ),

      bottomNavigationBar: CustomBottomNav(
        currentIndex: 0,
        onTap: (index) {
          if (index == 0) return;

          if (index == 1) {
            Navigator.pushNamed(context, '/info');
          } else if (index == 2) {
            Navigator.pushNamed(context, '/chat');
          } else if (index == 3) {
            Navigator.pushNamed(context, '/DenunciaScreen');
          } else if (index == 4) {
            Navigator.pushNamed(context, '/perfil');
          }
        },
      ),
    );
  }
}
