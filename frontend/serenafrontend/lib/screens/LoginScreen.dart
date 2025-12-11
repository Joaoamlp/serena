import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart'; // ✅ Import do SharedPreferences

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController senhaController = TextEditingController();

  String? emailErro;
  String? senhaErro;
  bool carregando = false;

  bool validarCampos() {
    setState(() {
      if (emailController.text.isEmpty) {
        emailErro = "E-mail obrigatório";
      } else if (!RegExp(r"^[^@]+@[^@]+\.[^@]+").hasMatch(emailController.text)) {
        emailErro = "E-mail inválido";
      } else {
        emailErro = null;
      }

      if (senhaController.text.isEmpty) {
        senhaErro = "Senha obrigatória";
      } else if (senhaController.text.length < 6) {
        senhaErro = "Mínimo 6 caracteres";
      } else {
        senhaErro = null;
      }
    });

    return emailErro == null && senhaErro == null;
  }

  // ✅ LOGIN NA API
  Future<void> loginApi() async {
    print("🔵 Botão de login pressionado");

    if (!validarCampos()) {
      print("🔴 Erro na validação dos campos");
      return;
    }

    print("🟡 Campos válidos, iniciando login...");
    setState(() => carregando = true);

    final url = Uri.parse("http://10.0.2.2:5223/api/User/login");
    print("🌐 URL usada: $url");

    try {
      print("📤 Enviando requisição para API...");
      print("📨 Email: ${emailController.text}");
      print("📨 Senha: ${senhaController.text}");

      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "email": emailController.text,
          "password": senhaController.text,
        }),
      );

      print("✅ Resposta recebida da API!");
      print("📡 Status Code: ${response.statusCode}");
      print("📩 Body: ${response.body}");

      if (response.statusCode == 200) {
        final usuario = jsonDecode(response.body);

        // ⚠️ Tratar campos nulos da API
        final int id = usuario['id'] ?? 0;
        final String nome = (usuario['name'] ?? '').toString();
        final String email = (usuario['email'] ?? '').toString();
        final String cpf = (usuario['cpf'] ?? '').toString();
        final String telefone = (usuario['telefone'] ?? '').toString();

        final prefs = await SharedPreferences.getInstance();
        await prefs.setInt('userId', id);
        await prefs.setString('userName', nome);
        await prefs.setString('userEmail', email);
        await prefs.setString('userCpf', cpf);
        await prefs.setString('userTelefone', telefone);

        print("🟢 Login realizado com sucesso! ID do usuário salvo: $id");
        Navigator.pushReplacementNamed(context, '/HomeScreen');
      } else {
        print("🟠 Erro retornado pela API");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response.body)),
        );
      }
    } catch (e) {
      print("❌ ERRO DE CONEXÃO COM A API: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Erro de conexão com o servidor")),
      );
    } finally {
      print("✅ Finalizando carregamento");
      setState(() => carregando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3ECFF),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back),
              ),
              const SizedBox(height: 30),
              Center(
                child: Image.asset(
                  'lib/assets/icons/Group6.png',
                  width: 140,
                ),
              ),
              const SizedBox(height: 40),
              const Text("Entre na sua conta", style: TextStyle(fontSize: 18)),
              const SizedBox(height: 20),
              const Text("E-mail"),
              const SizedBox(height: 5),
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  errorText: emailErro,
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
              const Text("Senha"),
              const SizedBox(height: 5),
              TextField(
                controller: senhaController,
                obscureText: true,
                decoration: InputDecoration(
                  errorText: senhaErro,
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
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: carregando ? null : loginApi,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.deepPurple,
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: carregando
                      ? const CircularProgressIndicator()
                      : const Text(
                          "Entrar",
                          style: TextStyle(fontSize: 18),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
