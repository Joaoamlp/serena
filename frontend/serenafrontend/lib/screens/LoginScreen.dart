import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3ECFF), // cor de fundo lilás
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // BOTÃO DE VOLTAR
              IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.arrow_back),
              ),

              const SizedBox(height: 30),

              // LOGO COM IMAGEM
              Center(
                child: Image.asset(
                  'lib/assets/icons/Group6.png',
                  width: 140, // tamanho da logo
                ),
              ),

              const SizedBox(height: 40),

              // TEXTO "Entre na sua conta"
              const Text("Entre na sua conta", style: TextStyle(fontSize: 18)),

              const SizedBox(height: 20),

              // CAMPO EMAIL
              const Text("E-mail"),
              const SizedBox(height: 5),

              TextField(
                decoration: InputDecoration(
                  hintText: "Escreva aqui",
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // CAMPO SENHA
              const Text("Senha"),
              const SizedBox(height: 5),

              TextField(
                obscureText: true, // ESCONDE A SENHA
                decoration: InputDecoration(
                  hintText: "Escreva aqui",
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // TEXTO CADASTRO
              Center(
                child: GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, '/RegisterScreen');
                  },
                  child: const Text(
                    "Não possui uma conta? Faça o cadastro.",
                    style: TextStyle(color: Colors.deepPurple),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // BOTÃO ENTRAR
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, '/HomeScreen');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.deepPurple,
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text("Entrar", style: TextStyle(fontSize: 18)),
                  
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
