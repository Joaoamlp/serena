import 'package:flutter/material.dart';
import 'package:serenafrontend/screens/StartScreen.dart';
import 'package:serenafrontend/widgets/CustomBottomNav.dart';

class PerfilScreen extends StatefulWidget {
  const PerfilScreen({super.key});

  @override
  State<PerfilScreen> createState() => _PerfilScreenState();
}

class _PerfilScreenState extends State<PerfilScreen> {
  bool editar = false;

  // Valores iniciais para não sumir ao editar
  final TextEditingController nomeController = TextEditingController(
    text: "Nome do Usuário",
  );
  final TextEditingController emailController = TextEditingController(
    text: "email@exemplo.com",
  );
  final TextEditingController cpfController = TextEditingController(
    text: "12345678901",
  );
  final TextEditingController telefoneController = TextEditingController(
    text: "11999999999",
  );

  String? nomeErro;
  String? emailErro;
  String? cpfErro;
  String? telefoneErro;

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
          : !RegExp(
              r"^[0-9]+$",
            ).hasMatch(cpfController.text.replaceAll(RegExp(r'[^0-9]'), ''))
          ? "Digite apenas números"
          : cpfController.text.replaceAll(RegExp(r'[^0-9]'), '').length != 11
          ? "CPF deve ter exatamente 11 números"
          : null;

      telefoneErro = telefoneController.text.isEmpty
          ? "Campo obrigatório"
          : !RegExp(r"^[0-9]+$").hasMatch(
              telefoneController.text.replaceAll(RegExp(r'[^0-9]'), ''),
            )
          ? "Digite apenas números"
          : telefoneController.text.replaceAll(RegExp(r'[^0-9]'), '').length !=
                11
          ? "Telefone deve ter exatamente 11 números"
          : null;
    });

    return nomeErro == null &&
        emailErro == null &&
        cpfErro == null &&
        telefoneErro == null;
  }

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
              const Text(
                "Perfil do Usuário",
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF7C4DFF),
                ),
              ),
              const SizedBox(height: 10),

              // ---------- BOTÃO EDITAR / CONCLUIR ----------
              OutlinedButton.icon(
                onPressed: () {
                  if (editar) {
                    // Validar ao clicar em CONCLUIR
                    if (!validarCampos()) return;

                    // Mostrar confirmação antes de aplicar mudanças
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text("Aplicar mudanças"),
                        content: const Text(
                          "Deseja realmente salvar as alterações?",
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop(); // Fecha o diálogo
                            },
                            child: const Text("Cancelar"),
                          ),
                          TextButton(
                            onPressed: () {
                              // ---------- FORMATAÇÃO CPF ----------
                              String cpf = cpfController.text.replaceAll(
                                RegExp(r'[^0-9]'),
                                '',
                              );
                              if (cpf.length == 11) {
                                cpfController.text =
                                    "${cpf.substring(0, 3)}.${cpf.substring(3, 6)}.${cpf.substring(6, 9)}-${cpf.substring(9, 11)}";
                              }

                              // ---------- FORMATAÇÃO TELEFONE ----------
                              String tel = telefoneController.text.replaceAll(
                                RegExp(r'[^0-9]'),
                                '',
                              );
                              if (tel.length == 11) {
                                telefoneController.text =
                                    "(${tel.substring(0, 2)}) ${tel.substring(2, 7)}-${tel.substring(7, 11)}";
                              }

                              setState(() {
                                editar = false; // Sai do modo edição
                              });

                              Navigator.of(context).pop(); // Fecha o diálogo
                            },
                            child: const Text(
                              "Confirmar",
                              style: TextStyle(color: Colors.green),
                            ),
                          ),
                        ],
                      ),
                    );
                  } else {
                    // Entra no modo editar
                    setState(() {
                      editar = true;
                    });
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
                placeholder: "12345678901",
                erro: cpfErro,
                tecladoNumerico: true,
              ),
              const SizedBox(height: 12),
              _campoFantasma(
                label: "Telefone",
                controller: telefoneController,
                placeholder: "11999999999",
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

  // --------------------- CAMPO FANTASMA ---------------------
  Widget _campoFantasma({
    required String label,
    required TextEditingController controller,
    required String placeholder,
    String? erro,
    bool tecladoNumerico = false,
  }) {
    return TextField(
      controller: controller,
      readOnly: !editar,
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
      onTap: () {
        if (!editar) {
          FocusScope.of(context).unfocus();
          return;
        }

        // Remove máscara ao editar
        if (controller == cpfController || controller == telefoneController) {
          controller.text = controller.text.replaceAll(RegExp(r'[^0-9]'), '');
          controller.selection = TextSelection.fromPosition(
            TextPosition(offset: controller.text.length),
          );
        }
      },
      onChanged: (value) {
        if (!editar) return;

        String newText = value.replaceAll(RegExp(r'[^0-9]'), '');

        if (controller == cpfController) {
          if (newText.length > 11) newText = newText.substring(0, 11);
          String formatted = '';
          for (int i = 0; i < newText.length; i++) {
            formatted += newText[i];
            if (i == 2 || i == 5) formatted += '.';
            if (i == 8) formatted += '-';
          }
          controller.value = TextEditingValue(
            text: formatted,
            selection: TextSelection.collapsed(offset: formatted.length),
          );
        } else if (controller == telefoneController) {
          if (newText.length > 11) newText = newText.substring(0, 11);
          String formatted = '';
          for (int i = 0; i < newText.length; i++) {
            if (i == 0) formatted += '(';
            if (i == 2) formatted += ') ';
            if (i == 7) formatted += '-';
            formatted += newText[i];
          }
          controller.value = TextEditingValue(
            text: formatted,
            selection: TextSelection.collapsed(offset: formatted.length),
          );
        }
      },
    );
  }

  // ----------- AÇÕES -----------
  Widget _acao(
    IconData icon,
    String text, {
    Color color = const Color(0xFF7C4DFF),
  }) {
    return GestureDetector(
      onTap: () {
        // ---------- EXCLUIR CONTA ----------
        if (text == "Excluir conta") {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text("Excluir conta"),
              content: const Text("Tem certeza que deseja excluir sua conta?"),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text("Cancelar"),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => StartScreen()),
                    );
                  },
                  child: const Text(
                    "Confirmar",
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              ],
            ),
          );
          return;
        }

        // ---------- SAIR ----------
        if (text == "Sair") {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text("Sair"),
              content: const Text("Tem certeza que deseja sair?"),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text("Cancelar"),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => StartScreen()),
                    );
                  },
                  child: const Text(
                    "Confirmar",
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
              ],
            ),
          );
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
