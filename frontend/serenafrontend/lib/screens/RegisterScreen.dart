import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:serenafrontend/services/API_User.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool termos = false;
  bool notificacoes = false;
  bool carregando = false;

  final nomeController = TextEditingController();
  final emailController = TextEditingController();
  final cpfController = TextEditingController();
  final telefoneController = TextEditingController();
  final senhaController = TextEditingController();
  final confirmarSenhaController = TextEditingController();

  String? nomeErro;
  String? emailErro;
  String? cpfErro;
  String? telefoneErro;
  String? senhaErro;
  String? confirmarSenhaErro;

  // ===== Máscaras =====
  final cpfMask = MaskTextInputFormatter(
    mask: '###.###.###-##',
    filter: {"#": RegExp(r'[0-9]')},
  );
  final telefoneMask = MaskTextInputFormatter(
    mask: '(##) #####-####',
    filter: {"#": RegExp(r'[0-9]')},
  );

  // ----------- VALIDAÇÕES -----------
  bool validarCampos() {
    setState(() {
      nomeErro = nomeController.text.isEmpty ? "Campo obrigatório" : null;

      emailErro = emailController.text.isEmpty
          ? "Campo obrigatório"
          : !RegExp(r"^[^@]+@[^@]+\.[^@]+").hasMatch(emailController.text)
              ? "E-mail inválido"
              : null;

      cpfErro = cpfController.text.isEmpty
          ? "Campo obrigatório"
          : cpfMask.getUnmaskedText().length != 11
              ? "CPF deve ter 11 números"
              : null;

      telefoneErro = telefoneController.text.isEmpty
          ? "Campo obrigatório"
          : telefoneMask.getUnmaskedText().length != 11
              ? "Telefone deve ter 11 números"
              : null;

      senhaErro = senhaController.text.isEmpty ? "Campo obrigatório" : null;

      confirmarSenhaErro = confirmarSenhaController.text.isEmpty
          ? "Campo obrigatório"
          : senhaController.text != confirmarSenhaController.text
              ? "As senhas não coincidem"
              : null;
    });

    return nomeErro == null &&
        emailErro == null &&
        cpfErro == null &&
        telefoneErro == null &&
        senhaErro == null &&
        confirmarSenhaErro == null;
  }

  // ----------- CRIAR CONTA -----------
 Future<void> criarConta() async {
  if (!validarCampos()) return;

  if (!termos) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Você precisa aceitar os termos')),
    );
    return;
  }

  setState(() => carregando = true);

  bool sucesso = await UserService.createUser(
    nome: nomeController.text,
    email: emailController.text,
    password: senhaController.text,
    cpf: cpfMask.getUnmaskedText(),
    telefone: telefoneMask.getUnmaskedText(),
  );

  setState(() => carregando = false);

  if (sucesso) {
    // ✅ Obter o ID do usuário recém-criado da API
    final usuarioCriado = await UserService.loginUser(
      emailController.text,
      senhaController.text,
    );

    if (usuarioCriado != null) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('userId', usuarioCriado['id']); // só salva o ID

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Conta criada com sucesso!')),
      );

      // Redirecionar para a tela de perfil ou tutorial
      Navigator.pushReplacementNamed(context, '/TutorialScreen');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erro ao obter dados do usuário')),
      );
    }
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Erro ao criar conta')),
    );
  }
}


  Widget input(
    String label,
    TextEditingController controller, {
    bool senha = false,
    String? erro,
    List<TextInputFormatter>? inputFormatters,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          obscureText: senha,
          inputFormatters: inputFormatters,
          decoration: InputDecoration(
            hintText: 'Escreva aqui',
            errorText: erro,
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3ECFF),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.arrow_back),
                ),
                const SizedBox(height: 16),
                Center(
                  child: Image.asset('lib/assets/icons/Group6.png', width: 140),
                ),
                const SizedBox(height: 24),
                const Text('Crie a sua conta', style: TextStyle(fontSize: 18)),
                const SizedBox(height: 24),
                input('Nome', nomeController, erro: nomeErro),
                input('E-mail', emailController, erro: emailErro),
                input(
                  'CPF',
                  cpfController,
                  erro: cpfErro,
                  inputFormatters: [cpfMask],
                ),
                input(
                  'Telefone',
                  telefoneController,
                  erro: telefoneErro,
                  inputFormatters: [telefoneMask],
                ),
                input('Senha', senhaController, senha: true, erro: senhaErro),
                input(
                  'Confirmar senha',
                  confirmarSenhaController,
                  senha: true,
                  erro: confirmarSenhaErro,
                ),
                const SizedBox(height: 16),
                SwitchListTile(
                  title: const Text(
                      'Li e estou de acordo com os Termos de Uso e Políticas de Privacidade'),
                  value: termos,
                  onChanged: (value) => setState(() => termos = value),
                ),
                SwitchListTile(
                  title: const Text('Quero receber notificações'),
                  value: notificacoes,
                  onChanged: (value) => setState(() => notificacoes = value),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: carregando ? null : criarConta,
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 50),
                    backgroundColor: Colors.white,
                  ),
                  child: carregando
                      ? const CircularProgressIndicator()
                      : const Text(
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
