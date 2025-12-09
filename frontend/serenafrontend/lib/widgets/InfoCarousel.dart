import 'package:flutter/material.dart';

class InfoCarousel extends StatefulWidget {
  const InfoCarousel({super.key});

  @override
  State<InfoCarousel> createState() => _InfoCarouselState();
}

class _InfoCarouselState extends State<InfoCarousel> {
  final PageController _controller = PageController();
  int indexAtual = 0;

  final List<Map<String, String>> cards = [
    {
      'imagem': 'lib/assets/images/Rectangle21.png',
      'titulo': 'Como identificar sinais de um relacionamento abusivo',
      'descricao':
          'Entenda comportamentos que podem indicar controle, isolamento ou agressão.',
    },
    {
      'imagem': 'lib/assets/images/Signal_for_Help_gestures.png',
      'titulo': 'Como pedir ajuda com segurança',
      'descricao': 'Veja como buscar apoio sem se colocar em risco.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            // ◀ Seta Esquerda
            IconButton(
              icon: const Icon(Icons.chevron_left),
              onPressed: () {
                if (indexAtual > 0) {
                  _controller.previousPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.ease,
                  );
                }
              },
            ),

            // ▶ CARROSSEL RESPONSIVO (SEM OVERFLOW)
            Expanded(
              child: SizedBox(
                height: 330, // altura fixa para evitar overflow vertical
                child: PageView.builder(
                  controller: _controller,
                  itemCount: cards.length,
                  onPageChanged: (index) {
                    setState(() => indexAtual = index);
                  },
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 6),
                      child: buildCard(cards[index]),
                    );
                  },
                ),
              ),
            ),

            // ▶ Seta Direita
            IconButton(
              icon: const Icon(Icons.chevron_right),
              onPressed: () {
                if (indexAtual < cards.length - 1) {
                  _controller.nextPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.ease,
                  );
                }
              },
            ),
          ],
        ),

        const SizedBox(height: 8),

        // ●● Indicadores
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(cards.length, (index) {
            return AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              margin: const EdgeInsets.symmetric(horizontal: 4),
              width: indexAtual == index ? 10 : 6,
              height: 6,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: indexAtual == index ? Colors.deepPurple : Colors.grey,
              ),
            );
          }),
        ),
      ],
    );
  }

  /// 🟥 CARD COMPLETO E RESPONSIVO (NÃO DÁ OVERFLOW)
  Widget buildCard(Map<String, String> item) {
    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 📌 IMAGEM COM TAMANHO FIXO (16:9)
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            child: AspectRatio(
              aspectRatio: 16 / 9,
              child: Image.asset(item['imagem']!, fit: BoxFit.cover),
            ),
          ),

          // 📌 CONTEÚDO QUE SE AJUSTA AUTOMATICAMENTE (SEM OVERFLOW)
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item['titulo']!,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 6),

                  Text(
                    item['descricao']!,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),

                  const Spacer(),

                  const Text(
                    'Saiba mais →',
                    style: TextStyle(
                      color: Colors.deepPurple,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
