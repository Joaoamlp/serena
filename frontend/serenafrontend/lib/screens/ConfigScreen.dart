import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/FloatingButtonController.dart';

class ConfigScreen extends StatefulWidget {
  const ConfigScreen({super.key});

  @override
  State<ConfigScreen> createState() => _ConfiguracoesScreenState();
}

class _ConfiguracoesScreenState extends State<ConfigScreen> {
  String notificacoes = "Permitir sempre";
  String modoDiscreto = "Desativado";

  bool compartilharLocalizacao = false;
  bool som = true;

  @override
  Widget build(BuildContext context) {
    final floatingController = context.watch<FloatingButtonController>();

    return Scaffold(
      backgroundColor: const Color(0xFFF3ECFF),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              /// -------- TOPO ----------
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    "Configurações",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepPurple,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 30),

              /// -------- NOTIFICAÇÕES ----------
              const Text("Notificações", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),

              _dropdown(
                value: notificacoes,
                items: ["Permitir sempre", "Somente quando aberto", "Nunca"],
                onChanged: (value) {
                  setState(() => notificacoes = value!);

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Notificações: $value")),
                  );
                },
              ),

              const SizedBox(height: 20),

              /// -------- MODO DISCRETO ----------
              const Text("Modo discreto", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),

              _dropdown(
                value: modoDiscreto,
                items: ["Ativado", "Desativado"],
                onChanged: (value) {
                  setState(() => modoDiscreto = value!);

                  if (value == "Ativado") {
                    floatingController.disable();
                  } else {
                    floatingController.enable();
                  }

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Modo discreto: $value")),
                  );
                },
              ),

              const SizedBox(height: 30),

              /// -------- PERMISSÕES ----------
              const Text("Permissões", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),

              _switchItem(
                text: "Botão aparente em todos os aplicativos",
                value: floatingController.isEnabled,
                onChanged: (value) {
                  value
                      ? floatingController.enable()
                      : floatingController.disable();
                },
              ),

              _switchItem(
                text: "Compartilhar localização",
                value: compartilharLocalizacao,
                onChanged: (value) {
                  setState(() => compartilharLocalizacao = value);

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        value
                            ? "Localização ativada"
                            : "Localização desativada",
                      ),
                    ),
                  );
                },
              ),

              _switchItem(
                text: "Som",
                value: som,
                onChanged: (value) {
                  setState(() => som = value);

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        value ? "Som ativado" : "Som desativado",
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// -------- COMPONENTES ----------
  Widget _dropdown({
    required String value,
    required List<String> items,
    required Function(String?) onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          items: items
              .map((item) =>
                  DropdownMenuItem(value: item, child: Text(item)))
              .toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  Widget _switchItem({
    required String text,
    required bool value,
    required Function(bool) onChanged,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Expanded(child: Text(text)),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: Colors.deepPurple,
          ),
        ],
      ),
    );
  }
}
