import 'package:flutter/material.dart';
import 'package:portafolio_webapp_2026/widgets/build_info_tile.dart';

class ProfileScreenMobile extends StatelessWidget {
  const ProfileScreenMobile({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
            const CircleAvatar(
            radius: 60,
            backgroundImage: AssetImage(
              'lib/assets/img/profile_pic_asset.jpg',
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            "Miguel Mogollon",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            "Flutter Developer",
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            "Soy desarrollador enfocado en Flutter y Firebase, creando apps modernas "
            "con buen diseño y rendimiento. Me gusta construir productos reales "
            "y mejorar constantemente mis habilidades.",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              height: 1.5,
              color: Colors.white70,
            ),
          ),
          const SizedBox(height: 30),
          BuildInfoTile(icon: Icons.email, text: "miguel@email.com"),
          BuildInfoTile(icon: Icons.code, text: "Flutter, Firebase, Dart"),
          BuildInfoTile(icon: Icons.link, text: "github.com/Mike19200"),
        ],
      ),
    );
  }
}