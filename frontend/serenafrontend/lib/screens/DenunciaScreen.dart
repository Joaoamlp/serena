import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:serenafrontend/widgets/CustomBottomNav.dart';
import 'package:serenafrontend/widgets/SucessoDialog.dart';
import 'package:serenafrontend/widgets/ConfirmarDenuncia.dart';

class DenunciaScreen extends StatefulWidget {
  const DenunciaScreen({super.key});

  @override
  State<DenunciaScreen> createState() => _DenunciaScreenState();
}

class _DenunciaScreenState extends State<DenunciaScreen> {
  bool anonima = false;

  final TextEditingController tipoController = TextEditingController();
  final TextEditingController localController = TextEditingController();
  final TextEditingController dataController = TextEditingController();
  final TextEditingController descricaoController = TextEditingController();

  bool erroTipo = false;
  bool erroLocal = false;
  bool erroData = false;
  bool erroDescricao = false;

  @override
  void dispose() {
    tipoController.dispose();
    localController.dispose();
    dataController.dispose();
    descricaoController.dispose();
    super.dispose();
  }

  // Função para preencher endereço automaticamente com loading
  Future<void> preencherEnderecoAtual(TextEditingController controller) async {
    try {
      // Mostra o loading
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => const Center(
          child: CircularProgressIndicator(color: Color(0xFF7C4DFF)),
        ),
      );

      // Verifica permissões
      LocationPermission perm = await Geolocator.checkPermission();
      if (perm == LocationPermission.denied) {
        perm = await Geolocator.requestPermission();
      }

      if (perm == LocationPermission.deniedForever || perm == LocationPermission.denied) {
        Navigator.of(context).pop(); // fecha o loading
        debugPrint("Permissão de localização negada.");
        return;
      }

      // Pega a localização
      final pos = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      // Converte coordenadas em endereço
      List<Placemark> placemarks = await placemarkFromCoordinates(
        pos.latitude,
        pos.longitude,
      );
      final place = placemarks.first;

      final endereco =
          "${place.street}, ${place.subLocality}, ${place.locality} - ${place.administrativeArea}";

      controller.text = endereco;
      debugPrint("Endereço preenchido: $endereco");

    } catch (e) {
      debugPrint("Erro ao preencher endereço: $e");
    } finally {
      // Fecha o loading independente do resultado
      Navigator.of(context).pop();
    }
  }

  Widget input(
    String label,
    TextEditingController controller, {
    bool isDate = false,
    bool erro = false,
    String? erroMsg,
    bool isEndereco = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          readOnly: isDate,
          onTap: isDate ? () => selecionarData() : null,
          decoration: InputDecoration(
            hintText: isDate ? 'Selecione' : 'Escreva aqui',
            suffixIcon: isDate
                ? const Icon(Icons.calendar_today, color: Color(0xFF7C4DFF))
                : isEndereco
                    ? IconButton(
                        icon: const Icon(Icons.my_location, color: Color(0xFF7C4DFF)),
                        onPressed: () => preencherEnderecoAtual(controller),
                      )
                    : null,
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: erro
                  ? const BorderSide(color: Colors.red, width: 2)
                  : BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: erro
                  ? const BorderSide(color: Colors.red, width: 2)
                  : BorderSide.none,
            ),
          ),
        ),
        if (erro)
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              erroMsg ?? "",
              style: const TextStyle(color: Colors.red, fontSize: 12),
            ),
          ),
        const SizedBox(height: 16),
      ],
    );
  }

  Future<void> selecionarData() async {
    DateTime? data = await showDatePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      initialDate: DateTime.now(),
    );

    if (data == null) return;

    TimeOfDay? hora = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (hora == null) return;

    final dataFormatada =
        '${data.day.toString().padLeft(2, '0')}/${data.month.toString().padLeft(2, '0')}/${data.year}'
        ' - ${hora.hour.toString().padLeft(2, '0')}:${hora.minute.toString().padLeft(2, '0')}';

    setState(() {
      dataController.text = dataFormatada;
      erroData = false;
    });
  }

  bool validarCampos() {
    setState(() {
      erroTipo = tipoController.text.isEmpty;
      erroLocal = localController.text.isEmpty;
      erroData = dataController.text.isEmpty;
      erroDescricao = descricaoController.text.isEmpty;
    });

    return !(erroTipo || erroLocal || erroData || erroDescricao);
  }

  void enviarDenuncia() async {
    if (!validarCampos()) return;

    // Mostra o loading de envio
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(
        child: CircularProgressIndicator(color: Color(0xFF7C4DFF)),
      ),
    );

    // Pequena simulação de delay (ex: envio para servidor)
    await Future.delayed(const Duration(seconds: 2));

    // Fecha o loading
    Navigator.of(context).pop();

    // Confirmação da denúncia
    confirmarDenuncia();
  }

  void confirmarDenuncia() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => ConfirmarDenuncia(onConfirmar: mostrarSucesso),
    );
  }

  void mostrarSucesso() {
    final endereco = localController.text.isEmpty
        ? 'Local não informado'
        : localController.text;

    final dataHora = dataController.text.isEmpty
        ? 'Data não informada'
        : dataController.text;

    showGeneralDialog(
      context: context,
      barrierDismissible: false,
      barrierLabel: '',
      transitionDuration: const Duration(milliseconds: 400),
      pageBuilder: (_, __, ___) {
        return SucessoDialog(dataHora: dataHora, endereco: endereco);
      },
      transitionBuilder: (_, animation, __, child) {
        return ScaleTransition(
          scale: CurvedAnimation(parent: animation, curve: Curves.easeOutBack),
          child: child,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3ECFF),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Você merece ser ouvida.',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurple,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Faça aqui a sua denúncia. Qualquer denúncia preenchida neste formulário será enviada para a Delegacia da Mulher.',
                ),
                const SizedBox(height: 20),
                SwitchListTile(
                  title: const Text('Denúncia anônima'),
                  value: anonima,
                  onChanged: (value) => setState(() => anonima = value),
                ),
                input(
                  'Qual o tipo de violência que você está denunciando?',
                  tipoController,
                  erro: erroTipo,
                  erroMsg: "Informe o tipo de violência.",
                ),
                input(
                  'Qual o local do ocorrido?',
                  localController,
                  erro: erroLocal,
                  erroMsg: "Informe o local.",
                  isEndereco: true,
                ),
                input(
                  'Qual a data e o horário do ocorrido?',
                  dataController,
                  isDate: true,
                  erro: erroData,
                  erroMsg: "Selecione a data e o horário.",
                ),
                input(
                  'Descrição livre',
                  descricaoController,
                  erro: erroDescricao,
                  erroMsg: "Descreva o ocorrido.",
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: enviarDenuncia,
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 50),
                    backgroundColor: Colors.white,
                  ),
                  child: const Text('Enviar'),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomNav(
        currentIndex: 3,
        onTap: (index) {
          if (index == 3) return;
          if (index == 0) {
            Navigator.pushReplacementNamed(context, '/HomeScreen');
          } else if (index == 1) {
            Navigator.pushReplacementNamed(context, '/info');
          } else if (index == 2) {
            Navigator.pushReplacementNamed(context, '/chat');
          } else if (index == 4) {
            Navigator.pushReplacementNamed(context, '/PerfilScreen');
          }
        },
      ),
    );
  }
}
