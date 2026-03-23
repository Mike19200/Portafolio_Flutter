import 'package:flutter/material.dart';
import 'package:portafolio_webapp_2026/models/video_model.dart';
import 'package:portafolio_webapp_2026/services/video_services.dart';
import 'package:portafolio_webapp_2026/widgets/video_item.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _mobileSelectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width > 900;

    return Scaffold(
      bottomNavigationBar: !isDesktop
      ? Container(
          height: 90, // Aquí controlas la altura de la barra
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
          decoration: const BoxDecoration(
            color: Colors.black,
            border: Border(
              top: BorderSide(color: Colors.white10, width: 0.5),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNeonNavItem(Icons.home, 'Home', 0),
              _buildNeonNavItem(Icons.folder, 'Proyectos', 1),
              _buildNeonNavItem(Icons.person, 'Perfil', 2),
            ],
          ),
        )
      : null,
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth > 900) {
            // --- DISEÑO DESKTOP ---
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(flex: 2, child: _buildLeftInfoColumn()),
                Expanded(
                  flex: 3,
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20.0),
                      child: Container(
                        constraints: const BoxConstraints(maxWidth: 400),
                        clipBehavior: Clip.antiAlias,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          color: Colors.grey[900],
                        ),
                        child: _buildVideoPlayerArea(isDesktop: true), // Pasamos si es desktop
                      ),
                    ),
                  ),
                ),
                Expanded(flex: 2, child: _buildRightProjectsColumn()),
              ],
            );
          } else {
            // --- DISEÑO MOBILE ---
            return _mobileSelectedIndex == 0 
                ? _buildVideoPlayerArea(isDesktop: false) // Pasamos que es mobile
                : const Center(child: Text("Otras secciones"));
          }
        },
      ),
    );
  }

  // --- NUEVA BARRA SUPERIOR PARA MÓVIL ---
  Widget _buildMobileHeader() {
    return Container(
      padding: const EdgeInsets.only(top: 50, left: 20, right: 20), // Ajuste para el notch
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircleAvatar(
            radius: 18,
            backgroundImage: NetworkImage('https://via.placeholder.com/150'), // Tu logo
          ),
          const SizedBox(width: 10),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Text(
                    "Miguel Mogollon",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      shadows: [Shadow(blurRadius: 10, color: Colors.black)], // Para que se lea sobre el video
                    ),
                  ),
                ],
              ),
              const Text(
                "Developer & Creator",
                style: TextStyle(color: Colors.white70, fontSize: 12, shadows: [Shadow(blurRadius: 10, color: Colors.black)]),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // --- ITEM DE LA BARRA DE NAVEGACIÓN MÓVIL ---
  Widget _buildNeonNavItem(IconData icon, String label, int index) {
  final isSelected = _mobileSelectedIndex == index;
  final neonColor = const Color.fromARGB(255, 142, 129, 230); // Cian / Azul Neón

  return GestureDetector(
    onTap: () => setState(() => _mobileSelectedIndex = index),
    child: AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 5),
      decoration: BoxDecoration(
        // Borde medio rectangular
        borderRadius: BorderRadius.circular(8), 
        border: Border.all(
          color: isSelected ? neonColor : Colors.transparent,
          width: 2,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: isSelected ? neonColor : Colors.grey,
            size: 26,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: isSelected ? neonColor : Colors.grey,
              fontSize: 12,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    ),
  );
}

  // --- MODIFICACIÓN DEL AREA DE VIDEO ---
final VideoService _videoService = VideoService();

Widget _buildVideoPlayerArea({required bool isDesktop}) {
  return StreamBuilder<List<VideoModel>>(
    stream: _videoService.getVideos(),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const Center(child: CircularProgressIndicator());
      }

      if (snapshot.hasError) {
        return Center(child: Text("Error: ${snapshot.error}", style: const TextStyle(color: Colors.white)));
      }

      if (!snapshot.hasData || snapshot.data!.isEmpty) {
        return const Center(
          child: Text(
            "No hay videos disponibles",
            style: TextStyle(color: Colors.white),
          ),
        );
      }

      final videos = snapshot.data!;

      return PageView.builder(
  physics: const BouncingScrollPhysics(), // o AlwaysScrollableScrollPhysics()
  scrollDirection: Axis.vertical, // Fuerza el scroll
  itemCount: videos.length,
  itemBuilder: (context, index) => VideoItem(video: videos[index]),
);
    },
  );
}

  // ==========================================
  // WIDGETS DE LAS SECCIONES
  // ==========================================

  Widget _buildLeftInfoColumn() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CircleAvatar(
            radius: 50,
            backgroundImage: NetworkImage('https://via.placeholder.com/150'), // Tu foto
          ),
          const SizedBox(height: 20),
          const Text(
            "Miguel Angel Mogollon Soto",
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),
          const Text(
            "@Mike19200",
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
          const SizedBox(height: 30),
          const Text(
            "Acerca de mí",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          const Text(
            "Desarrollador Fullstack creando experiencias increíbles en web y móvil. "
            "Apasionado por Flutter, Firebase y el buen diseño UX/UI.",
            style: TextStyle(fontSize: 14, height: 1.5, color: Colors.white70),
          ),
          const SizedBox(height: 30),
          // Links o habilidades
          _buildInfoTile(Icons.email, "Miguel.angel.mogollon@hotmail.com"),
          _buildInfoTile(Icons.code, "Flutter, Dart, Firebase, Javascript, HTML/CSS, Kotlin, Lua Roblox, Verse UEFN"),
          _buildInfoTile(Icons.link, "github.com/Mike19200"),
        ],
      ),
    );
  }

  Widget _buildRightProjectsColumn() {
    return Container(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Mis Proyectos",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: ListView(
              children: [
                _buildProjectCard("App de Delivery", "Flutter & Node.js"),
                _buildProjectCard("Clon de Spotify", "React Native"),
                _buildProjectCard("Dashboard Financiero", "Vue.js & Firebase"),
                _buildProjectCard("Portafolio Interactivo", "Flutter Web"),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoTile(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Container(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: Colors.grey, size: 20),
            const SizedBox(width: 12),
            // Expanded allows the text to wrap to the next line when it's too long
            Expanded(
              child: Text(
                text,
                style: const TextStyle(color: Colors.white70),
                softWrap: true,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProjectCard(String title, String subtitle) {
    return Card(
      color: Colors.grey[900],
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle, style: const TextStyle(color: Colors.grey)),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.white54),
        onTap: () {
          // Lógica para abrir detalles del proyecto
        },
      ),
    );
  }



  Widget _buildInteractionButton(IconData icon, String label) {
    return Column(
      children: [
        Icon(icon, size: 32, color: Colors.white),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}