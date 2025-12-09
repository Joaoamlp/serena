import 'package:flutter/material.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool termos = false;
  bool notificacoes = false;

  Widget input(String label) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        const SizedBox(height: 8),
        TextField(
          decoration: InputDecoration(
            hintText: 'Escreva aqui',
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3ECFF), // cor de fundo lilás
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.arrow_back),
                ),

                const SizedBox(height: 16),

                Center(
                  child: Image.asset(
                    'lib/assets/icons/Group6.png',
                    width: 140,
                  ),
                ),

                const SizedBox(height: 24),

                const Text(
                  'Crie a sua conta',
                  style: TextStyle(fontSize: 18),
                ),

                const SizedBox(height: 24),

                input('E-mail'),
                input('CPF'),
                input('Telefone'),
                input('Senha'),
                input('Confirmar senha'),

                const SizedBox(height: 16),

                SwitchListTile(
                  title: const Text(
                    'Li e estou de acordo com os Termos de Uso e Políticas de Privacidade',
                  ),
                  value: termos,
                  onChanged: (value) {
                    setState(() {
                      termos = value;
                    });
                  },
                ),

                SwitchListTile(
                  title: const Text('Quero receber notificações'),
                  value: notificacoes,
                  onChanged: (value) {
                    setState(() {
                      notificacoes = value;
                    });
                  },
                ),

                const SizedBox(height: 24),

                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/TutorialScreen');
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 50),
                    backgroundColor: const Color.fromARGB(255, 255, 255, 255),
                  ),
                  child: const Text(
                    'Criar conta',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
