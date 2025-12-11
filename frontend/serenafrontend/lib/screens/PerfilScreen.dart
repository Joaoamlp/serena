import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:serenafrontend/screens/StartScreen.dart';
import 'package:serenafrontend/widgets/CustomBottomNav.dart';
import '../services/API_User.dart'; // Sua API

class PerfilScreen extends StatefulWidget {
  const PerfilScreen({super.key});

  @override
  State<PerfilScreen> createState() => _PerfilScreenState();
}

class _PerfilScreenState extends State<PerfilScreen> {
  bool editar = false;
  bool carregando = false;

  final TextEditingController nomeController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController cpfController = TextEditingController();
  final TextEditingController telefoneController = TextEditingController();

  String? nomeErro;
  String? emailErro;
  String? telefoneErro;

  int? userId;

  @override
  void initState() {
    super.initState();
    carregarUsuario();
  }

  @override
  void dispose() {
    nomeController.dispose();
    emailController.dispose();
    cpfController.dispose();
    telefoneController.dispose();
    super.dispose();
  }

  // ------------------- MÁSCARAS -------------------
  String formatarTelefone(String tel) {
    tel = tel.replaceAll(RegExp(r'[^0-9]'), '');
    if (tel.length != 11) return tel;
    return "(${tel.substring(0, 2)}) ${tel.substring(2, 7)}-${tel.substring(7, 11)}";
  }

  // ------------------- CARREGAR USUÁRIO -------------------
  Future<void> carregarUsuario() async {
    final prefs = await SharedPreferences.getInstance();
    final savedId = prefs.getInt('userId');

    if (savedId == null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const StartScreen()),
      );
      return;
    }

    userId = savedId;

    String? nome = prefs.getString('userName');
    String? email = prefs.getString('userEmail');
    String? telefone = prefs.getString('userTelefone');
    String? cpf = prefs.getString('userCpf');

    // Busca da API se algum campo estiver vazio
    if (nome == null || email == null || telefone == null || cpf == null) {
      final usuarioApi = await UserService.getUserById(userId!);
      if (usuarioApi != null) {
        nome = usuarioApi['name']?.toString() ?? '';
        email = usuarioApi['email']?.toString() ?? '';
        telefone = usuarioApi['telefone']?.toString() ?? '';
        cpf = usuarioApi['cpf']?.toString() ?? '';

        // Salva no SharedPreferences
        await prefs.setString('userName', nome);
        await prefs.setString('userEmail', email);
        await prefs.setString('userTelefone', telefone);
        await prefs.setString('userCpf', cpf);
      }
    }

    setState(() {
      nomeController.text = nome ?? '';
      emailController.text = email ?? '';
      cpfController.text = cpf ?? ''; // sem máscara
      telefoneController.text = formatarTelefone(telefone ?? '');
    });
  }

  // ------------------- VALIDAÇÃO DE CAMPOS -------------------
  bool validarCampos() {
    setState(() {
      nomeErro = nomeController.text.isEmpty ? "Campo obrigatório" : null;
      emailErro = emailController.text.isEmpty
          ? "Campo obrigatório"
          : !RegExp(r"^[^@]+@[^@]+\.[^@]+").hasMatch(emailController.text)
          ? "E-mail inválido"
          : null;
      String telLimpo = telefoneController.text.replaceAll(
        RegExp(r'[^0-9]'),
        '',
      );
      telefoneErro = telLimpo.isEmpty
          ? "Campo obrigatório"
          : telLimpo.length != 11
          ? "Telefone deve ter 11 números"
          : null;
    });

    return nomeErro == null && emailErro == null && telefoneErro == null;
  }

  // ------------------- ATUALIZAR USUÁRIO -------------------
  Future<void> atualizarUsuario() async {
    if (!validarCampos() || userId == null) return;

    setState(() => carregando = true);

    String telefone = telefoneController.text.replaceAll(RegExp(r'[^0-9]'), '');

    bool sucesso = await UserService.updateUser(
      id: userId!,
      nome: nomeController.text,
      email: emailController.text,
      telefone: telefone,
    );

    setState(() => carregando = false);

    if (sucesso) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('userName', nomeController.text);
      await prefs.setString('userEmail', emailController.text);
      await prefs.setString('userTelefone', telefone);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Dados atualizados com sucesso!")),
      );
      setState(() => editar = false);

      telefoneController.text = formatarTelefone(telefone);
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Erro ao atualizar dados.")));
    }
  }

  // ------------------- SAIR -------------------
  Future<void> sairConta() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const StartScreen()),
    );
  }

  // ------------------- EXCLUIR CONTA -------------------
  Future<void> excluirConta() async {
    if (userId == null) return;

    bool sucesso = await UserService.deleteUser(userId!);
    if (sucesso) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const StartScreen()),
      );
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Erro ao excluir a conta.")));
    }
  }

  // ------------------- BUILD -------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3ECFF),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 10),
              Text(
                nomeController.text.isNotEmpty
                    ? nomeController.text
                    : "Perfil do Usuário",
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF7C4DFF),
                ),
              ),
              const SizedBox(height: 10),
              const SizedBox(height: 10),
              OutlinedButton.icon(
                onPressed: () async {
                  if (editar) {
                    if (!validarCampos()) return;
                    await atualizarUsuario();
                  } else {
                    setState(() => editar = true);
                  }
                },
                icon: const Icon(Icons.edit, color: Color(0xFF7C4DFF)),
                label: Text(
                  editar ? "Concluir" : "Editar",
                  style: const TextStyle(color: Color(0xFF7C4DFF)),
                ),
              ),
              const SizedBox(height: 25),
              _campoFantasma(
                label: "Nome Completo",
                controller: nomeController,
                placeholder: "Digite seu nome...",
                erro: nomeErro,
              ),
              const SizedBox(height: 12),
              _campoFantasma(
                label: "E-mail",
                controller: emailController,
                placeholder: "email@exemplo.com",
                erro: emailErro,
              ),
              const SizedBox(height: 12),
              _campoFantasma(
                label: "CPF",
                controller: cpfController,
                placeholder: "Digite seu CPF...",
                readOnly: true,
              ),
              const SizedBox(height: 12),
              _campoFantasma(
                label: "Telefone",
                controller: telefoneController,
                placeholder: "(11) 91234-5678",
                erro: telefoneErro,
                tecladoNumerico: true,
              ),
              const SizedBox(height: 30),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Ações",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black.withOpacity(0.8),
                  ),
                ),
              ),
              const SizedBox(height: 15),
              _acao(Icons.settings, "Configurações"),
              _acao(Icons.history, "Histórico"),
              _acao(Icons.logout, "Sair"),
              _acao(Icons.delete, "Excluir conta"),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomNav(
        currentIndex: 4,
        onTap: (index) {
          if (index == 0) {
            Navigator.pushReplacementNamed(context, '/HomeScreen');
          } else if (index == 1) {
            Navigator.pushReplacementNamed(context, '/info');
          } else if (index == 2) {
            Navigator.pushReplacementNamed(context, '/chat');
          } else if (index == 3) {
            Navigator.pushReplacementNamed(context, '/DenunciaScreen');
          }
        },
      ),
    );
  }

  Widget _campoFantasma({
    required String label,
    required TextEditingController controller,
    String? placeholder,
    String? erro,
    bool tecladoNumerico = false,
    bool readOnly = false,
  }) {
    return TextField(
      controller: controller,
      readOnly: readOnly || !editar,
      keyboardType: tecladoNumerico ? TextInputType.number : TextInputType.text,
      decoration: InputDecoration(
        labelText: label,
        hintText: placeholder,
        errorText: erro,
        hintStyle: TextStyle(color: Colors.grey.shade400),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 12,
        ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  Widget _acao(
    IconData icon,
    String text, {
    Color color = const Color(0xFF7C4DFF),
  }) {
    return GestureDetector(
      onTap: () {
        if (text == "Excluir conta") {
          excluirConta();
          return;
        }
        if (text == "Sair") {
          sairConta();
          return;
        }
        if (text == "Configurações") {
          Navigator.pushNamed(context, '/ConfigScreen');
          return;
        }
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Ação '$text' pressionada")));
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(icon, color: color, size: 26),
            const SizedBox(width: 15),
            Text(
              text,
              style: TextStyle(
                fontSize: 18,
                color: color,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
