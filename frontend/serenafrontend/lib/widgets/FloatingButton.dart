import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

import '../widgets/SucessoDialog.dart';
import '../services/navigator.dart'; // ✅ IMPORTANTE
import 'ConfirmarDenuncia.dart';

class FloatingButton extends StatefulWidget {
  const FloatingButton({super.key});

  @override
  State<FloatingButton> createState() => _FloatingButtonState();
}

class _FloatingButtonState extends State<FloatingButton>
    with SingleTickerProviderStateMixin {
  Offset position = const Offset(50, 300);
  bool isMenuOpen = false;

  late AnimationController anim;
  late Animation<double> curvedAnim;

  @override
  void initState() {
    super.initState();

    anim = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );

    curvedAnim = CurvedAnimation(parent: anim, curve: Curves.easeOut);
  }

  // 🚨 SOS
  Future<void> acionarSOS() async {
    final uri = Uri(scheme: 'tel', path: '190');
    await launchUrl(uri);
  }

  // 📍 Localização apenas debug
  Future<void> pegarLocalizacao() async {
    LocationPermission perm = await Geolocator.checkPermission();
    if (perm == LocationPermission.denied) {
      perm = await Geolocator.requestPermission();
    }

    final pos = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    debugPrint("Localização: ${pos.latitude}, ${pos.longitude}");
  }

  // 🔎 Converte coordenada em endereço
  Future<String> coordenadaParaEndereco(double lat, double lon) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(lat, lon);
      final place = placemarks.first;

      return "${place.street}, ${place.subLocality}, "
          "${place.locality} - ${place.administrativeArea}";
    } catch (e) {
      return "Endereço não encontrado";
    }
  }

  // ✅ DENÚNCIA RÁPIDA CORRIGIDA 100%
  void denunciaRapida() async {
    try {
      showDialog(
        context: navigatorKey.currentContext!,
        barrierDismissible: false,
        builder: (_) => ConfirmarDenuncia(
          onConfirmar: () async {
            // Substitui o diálogo de confirmação por loading
            showDialog(
              context: navigatorKey.currentContext!,
              barrierDismissible: false,
              builder: (_) => const Center(
                child: CircularProgressIndicator(color: Color(0xFF9C4DFF)),
              ),
            );

            debugPrint("Iniciando coleta de localização...");

            // Permissões de localização
            LocationPermission perm = await Geolocator.checkPermission();
            if (perm == LocationPermission.denied) {
              perm = await Geolocator.requestPermission();
            }

            if (perm == LocationPermission.deniedForever ||
                perm == LocationPermission.denied) {
              debugPrint("Permissão de localização negada.");
              return; // Apenas retorna, não fecha tela principal
            }

            debugPrint("Permissão de localização concedida.");

            // Pega a localização
            final pos = await Geolocator.getCurrentPosition(
              desiredAccuracy: LocationAccuracy.high,
            );
            debugPrint("Localização obtida: ${pos.latitude}, ${pos.longitude}");

            // Converte para endereço
            String endereco = await coordenadaParaEndereco(
              pos.latitude,
              pos.longitude,
            );
            debugPrint("Endereço convertido: $endereco");

            String dataHora = DateTime.now().toString();
            debugPrint("Data e hora: $dataHora");

            // Remove o loading
            Navigator.of(navigatorKey.currentContext!).pop();

            // Mostra o modal de sucesso
            showDialog(
              context: navigatorKey.currentContext!,
              barrierDismissible: false,
              builder: (_) =>
                  SucessoDialog(dataHora: dataHora, endereco: endereco),
            );

            debugPrint("Denúncia concluída com sucesso!");
          },
        ),
      );
    } catch (e) {
      debugPrint("Erro na denúncia rápida: $e");
    }
  }

  // 🔘 BOTÃO PRINCIPAL
  Widget buildSerenaButton() {
    return GestureDetector(
      onTap: () {
        setState(() {
          isMenuOpen = !isMenuOpen;
          isMenuOpen ? anim.forward() : anim.reverse();
        });
      },
      onPanUpdate: (d) {
        setState(() => position += d.delta);
      },
      child: SizedBox(
        width: 70,
        height: 70,
        child: Image.asset('lib/assets/icons/botao.png', fit: BoxFit.contain),
      ),
    );
  }

  // MENU LATERAL
  List<Widget> buildVerticalMenu(BuildContext context) {
    if (!isMenuOpen) return [];

    final screenWidth = MediaQuery.of(context).size.width;
    final bool isRightSide = position.dx > screenWidth / 2;

    const double spacing = 65;

    List<_MenuItem> items = [
      _MenuItem(Icons.call, acionarSOS),
      _MenuItem(Icons.warning_amber_rounded, denunciaRapida),
      _MenuItem(Icons.location_on, pegarLocalizacao),
    ];

    return List.generate(items.length, (i) {
      return AnimatedBuilder(
        animation: curvedAnim,
        builder: (_, child) {
          final v = curvedAnim.value;

          return Positioned(
            left: isRightSide ? position.dx - 70 * v : position.dx + 70 * v,
            top: position.dy + (i * spacing * v),
            child: Opacity(
              opacity: v,
              child: Transform.scale(scale: v, child: child),
            ),
          );
        },
        child: _buildMenuItem(items[i]),
      );
    });
  }

  Widget _buildMenuItem(_MenuItem item) {
    return GestureDetector(
      onTap: () {
        item.onTap();
        setState(() {
          isMenuOpen = false;
          anim.reverse();
        });
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(50),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            width: 58,
            height: 58,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.4),
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white70),
              boxShadow: [
                BoxShadow(
                  blurRadius: 12,
                  color: Colors.black.withOpacity(0.25),
                ),
              ],
            ),
            child: Icon(item.icon, size: 28, color: const Color(0xFF7A41FF)),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ...buildVerticalMenu(context),
        Positioned(
          left: position.dx,
          top: position.dy,
          child: buildSerenaButton(),
        ),
      ],
    );
  }
}

class _MenuItem {
  final IconData icon;
  final VoidCallback onTap;

  _MenuItem(this.icon, this.onTap);
}
