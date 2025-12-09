import 'package:flutter/material.dart';

class SucessoDialog extends StatelessWidget {
  final String dataHora;
  final String endereco;

  const SucessoDialog({
    super.key,
    required this.dataHora,
    required this.endereco,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        color: Colors.transparent,
        child: Container(
          width: 300,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.topRight,
                child: GestureDetector(
                  onTap: () {
                    Navigator.pop(context); // ← Fecha apenas o modal
                  },
                  child: const Icon(Icons.close),
                ),
              ),
              
              const SizedBox(height: 10),
              const Text(
                'Denúncia efetuada',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple,
                ),
              ),

              const SizedBox(height: 16),
              const Text(
                'Data e hora',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(dataHora),

              const SizedBox(height: 12),
              const Text(
                'Local',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(endereco),

              const SizedBox(height: 16),
              Divider(color: Colors.deepPurpleAccent.shade100),

              const SizedBox(height: 10),
              const Text(
                'Acompanhe o andamento no seu perfil.\nEntraremos em contato pelo e-mail.',
                style: TextStyle(fontSize: 12),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
