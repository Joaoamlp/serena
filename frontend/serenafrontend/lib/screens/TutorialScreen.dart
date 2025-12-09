import 'package:flutter/material.dart';

class TutorialScreen extends StatefulWidget {
  const TutorialScreen({super.key});

  @override
  State<TutorialScreen> createState() => _TutorialScreenState();
}

class _TutorialScreenState extends State<TutorialScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  void goToPage(int index) {
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final pages = [page1(context), page2(context), page3(context)];

    return Scaffold(
      backgroundColor: const Color(0xFFF3ECFF),
      body: SafeArea(
        child: Column(
          children: [
            // VOLTAR
            Align(
              alignment: Alignment.centerLeft,
              child: IconButton(
                icon: const Icon(Icons.arrow_back, size: 32),
                color: Colors.deepPurple,
                onPressed: () => Navigator.pushNamed(context, '/LoginScreen'),
              ),
            ),

            Expanded(
              child: Stack(
                children: [
                  // PAGEVIEW
                  PageView(
                    controller: _pageController,
                    onPageChanged: (index) {
                      setState(() => _currentPage = index);
                    },
                    children: pages,
                  ),

                  // ---- SETA ESQUERDA ----
                  if (_currentPage > 0)
                    Positioned(
                      top: MediaQuery.of(context).size.height * 0.32,
                      left: 10,
                      child: IconButton(
                        icon: const Icon(
                          Icons.arrow_back_ios_new_rounded,
                          size: 30,
                          color: Colors.deepPurple,
                        ),
                        onPressed: () => goToPage(_currentPage - 1),
                      ),
                    ),

                  // ---- SETA DIREITA ----
                  if (_currentPage < pages.length - 1)
                    Positioned(
                      top: MediaQuery.of(context).size.height * 0.32,
                      right: 10,
                      child: IconButton(
                        icon: const Icon(
                          Icons.arrow_forward_ios_rounded,
                          size: 30,
                          color: Colors.deepPurple,
                        ),
                        onPressed: () => goToPage(_currentPage + 1),
                      ),
                    ),
                ],
              ),
            ),

            // ---- INDICADORES ----
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                pages.length,
                (index) => AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  margin: const EdgeInsets.symmetric(horizontal: 5),
                  width: _currentPage == index ? 10 : 8,
                  height: _currentPage == index ? 10 : 8,
                  decoration: BoxDecoration(
                    color: _currentPage == index
                        ? Colors.deepPurple
                        : Colors.deepPurple.withOpacity(0.3),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // ------------------------------
  // --------- PAGE 1 -------------
  // ------------------------------

  Widget page1(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Image.asset(
            'lib/assets/images/womanCellphone.png',
            fit: BoxFit.contain,
          ),
        ),

        RichText(
          textAlign: TextAlign.center,
          text: const TextSpan(
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
            children: [
              TextSpan(text: 'Bem-vinda ao\n'),
              TextSpan(
                text: 'Serena',
                style: TextStyle(color: Colors.deepPurple),
              ),
            ],
          ),
        ),

        const SizedBox(height: 28),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: SizedBox(
            width: double.infinity,
            height: 54,
            child: ElevatedButton(
              style: elevatedStyle(),
              onPressed: () => goToPage(1),
              child: const Text(
                'Começar',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),

        // 🔽🔽🔽 Seta abaixo do botão 🔽🔽🔽
        // 🔽🔽🔽 Seta + texto "Pular tutorial" abaixo do botão 🔽🔽🔽
        const SizedBox(height: 20),

        GestureDetector(
          onTap: () => Navigator.pushNamed(context, '/HomeScreen'),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Pular tutorial",
                style: TextStyle(
                  color: Colors.deepPurple,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(width: 10),

              Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.deepPurple, width: 2),
                ),
                child: const Center(
                  child: Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 18,
                    color: Colors.deepPurple,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  // ------------------------------
  // --------- PAGE 2 -------------
  // ------------------------------

  Widget page2(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 20),
        const Text(
          "Seu botão discreto\nde ajuda",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 40),
          child: Text(
            "Você pode acionar ajuda quando estiver em risco, direto da tela do seu celular, de forma rápida e discreta.",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, color: Colors.black87),
          ),
        ),

        Expanded(
          child: Image.asset(
            'lib/assets/images/Phonescreen.png',
            fit: BoxFit.contain,
          ),
        ),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: SizedBox(
            width: double.infinity,
            height: 54,
            child: ElevatedButton(
              style: elevatedStyle(),
              onPressed: () => goToPage(2),
              child: const Text(
                'Continuar',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),

        // 🔽🔽🔽 Seta + texto "Pular tutorial" abaixo do botão 🔽🔽🔽
        const SizedBox(height: 20),

        GestureDetector(
          onTap: () => Navigator.pushNamed(context, '/HomeScreen'),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Pular tutorial",
                style: TextStyle(
                  color: Colors.deepPurple,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(width: 10),

              Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.deepPurple, width: 2),
                ),
                child: const Center(
                  child: Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 18,
                    color: Colors.deepPurple,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 40),
      ],
    );
  }

  // ------------------------------
  // --------- PAGE 3 -------------
  // ------------------------------

  Widget page3(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 40),
        Image(image:AssetImage('lib/assets/images/Group7.png')),

        const SizedBox(height: 24),
        const Text(
          "Conheça o\nChat de apoio",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
        ),

        const SizedBox(height: 14),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 40),
          child: Text(
            "Converse com nossa assistente para receber orientação, registrar situações e saber o que fazer.",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, color: Colors.black87),
          ),
        ),

        const SizedBox(height: 40),
        const Text(
          "Serena:",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.deepPurple,
          ),
        ),

        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(16),
          margin: const EdgeInsets.symmetric(horizontal: 60),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: Colors.white,
          ),
          child: const Text(
            "Como posso ajudar?",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16),
          ),
        ),

        const SizedBox(height: 40),

        // BOTÃO FINAL
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: SizedBox(
            width: double.infinity,
            height: 54,
            child: ElevatedButton(
              style: elevatedStyle(),
              onPressed: () {
                Navigator.pushNamed(context, '/HomeScreen');
              },
              child: const Text(
                'Concluir',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),

        const SizedBox(height: 40),
      ],
    );
  }

  // estilo padrão dos botões
  ButtonStyle elevatedStyle() {
    return ElevatedButton.styleFrom(
      backgroundColor: Colors.white,
      foregroundColor: Colors.deepPurple,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
    );
  }
}
