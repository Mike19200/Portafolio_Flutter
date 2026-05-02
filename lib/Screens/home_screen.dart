import 'package:flutter/material.dart';
import 'package:portafolio_webapp_2026/Screens/profile_screen_mobile.dart';
import 'package:portafolio_webapp_2026/Screens/projects_section.dart';
import 'package:portafolio_webapp_2026/models/video_model.dart';
import 'package:portafolio_webapp_2026/services/video_services.dart';
import 'package:portafolio_webapp_2026/widgets/build_contact_tile.dart';
import 'package:portafolio_webapp_2026/widgets/build_experience_card.dart';
import 'package:portafolio_webapp_2026/widgets/section_title.dart';
import 'package:portafolio_webapp_2026/widgets/video_item.dart';
import 'package:portafolio_webapp_2026/widgets/build_info_tile.dart';

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
              height: 70, // Aquí controlas la altura de la barra
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
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
                        child: _buildVideoPlayerArea(isDesktop: true),
                      ),
                    ),
                  ),
                ),
                Expanded(flex: 2, child: _buildRightProjectsColumn()),
              ],
            );
          } else {
            if (_mobileSelectedIndex == 0) {
              return Stack(
                children: [
                  _buildVideoPlayerArea(isDesktop: false),
                  _buildMobileHeader(),
                ],
              );
            } else if (_mobileSelectedIndex == 1) {
              return ProjectsSection();
            } else if (_mobileSelectedIndex == 2) {
              return ProfileScreenMobile();
            } else {
              return const Center(child: Text("Sección no encontrada"));
            }
          }
        },
      ),
    );
  }

  // --- NUEVA BARRA SUPERIOR PARA MÓVIL ---
  Widget _buildMobileHeader() {
    return Padding(
      padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
      child: Row(
        mainAxisSize: MainAxisSize.min, // Que el Row no ocupe todo el ancho
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.4),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min, // Ajusta el Row al contenido
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const CircleAvatar(
                  radius: 18,
                  backgroundImage: AssetImage('lib/assets/img/profile_pic_asset.jpg'),
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Text(
                      "Miguel Mogollon",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        shadows: [Shadow(blurRadius: 10, color: Colors.black)],
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      "Developer & Creator",
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 15,
                        shadows: [Shadow(blurRadius: 10, color: Colors.black)],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNeonNavItem(IconData icon, String label, int index) {
    final isSelected = _mobileSelectedIndex == index;
    final neonColor = const Color.fromARGB(255, 142, 129, 230);

    return GestureDetector(
      onTap: () => setState(() => _mobileSelectedIndex = index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 5),
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

  final VideoService _videoService = VideoService();

  Widget _buildVideoPlayerArea({required bool isDesktop}) {
    return StreamBuilder<List<VideoModel>>(
      stream: _videoService.getVideos(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(
              child: Text("Error: ${snapshot.error}",
                  style: const TextStyle(color: Colors.white)));
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
          physics: const BouncingScrollPhysics(),
          scrollDirection: Axis.vertical,
          itemCount: videos.length,
          itemBuilder: (context, index) => VideoItem(video: videos[index]),
        );
      },
    );
  }

  Widget _buildLeftInfoColumn() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CircleAvatar(
            radius: 50,
            backgroundImage: NetworkImage('lib/assets/img/profile_pic_asset.jpg'),
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
            "Hola! Me presento. Soy estudiante de Ingeniería en Diseño de Entretenimiento Digital y actualmente estoy en sexto semestre!\n"
            "Tengo 23 años, Soy Bilingue y, durante mis estudios, he adquirido experiencia en el campo del diseño gráfico y el desarrollo de software.\n"
            "He trabajado principalmente con Flutter y Firebase (Auth, Firestore y Hosting), AWS, Postman, Roblox (Lua), entre otros.\n"
            "Me destaco por estar siempre dispuesto a aprender nuevas tecnologias y mejorar mis conocimientos.\n",
            textAlign: TextAlign.start,
            style: TextStyle(
              fontSize: 14,
              height: 1.5,
              color: Colors.white,
            ),
          ),
          const SectionTitle(title: "Habilidades"),
          BuildInfoTile(icon: Icons.language, text: "Inglés B2"),
          BuildInfoTile(icon: Icons.flutter_dash, text: "Flutter (4 años)"),
          BuildInfoTile(icon: Icons.storage, text: "Firebase & SQL"),
          BuildInfoTile(icon: Icons.brush, text: "Diseño UX/UI (4 años)"),
          BuildInfoTile(icon: Icons.videogame_asset, text: "Unity & Roblox (Lua)"),
          BuildInfoTile(icon: Icons.code, text: "C#, C++, JS, Node.js, Swift"),
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
                const SectionTitle(title: "Experiencia"),
                BuildExperienceCard(role: "Software Developer Jr.", company: "Avenfor S.A.S", logoPath: 'lib/assets/img/Avenfor Logo.jpg'),
                BuildExperienceCard(role: "Engineering Intern", company: "Karaokulta An Amber Studios", logoPath: 'lib/assets/img/Karaokulta Logo.jpg'),
                BuildExperienceCard(role: "Roblox Developer", company: "Hitbox Studios", logoPath: 'lib/assets/img/Hitbox logo.jpg'),
                BuildExperienceCard(role: "Payroll Specialist", company: "CCS Construction Staffing", logoPath: 'lib/assets/img/CCS Logo.jpg'),
                const SizedBox(height: 0),
                const SectionTitle(title: "Contacto"),
                BuildContactTile(icon: Icons.email, text: "Miguel.angel.mogollon@hotmail.com"),
                BuildContactTile(icon: Icons.code, text: "Flutter, Dart, Firebase, Javascript, HTML/CSS, Kotlin, Lua Roblox, Verse UEFN"),
                BuildContactTile(icon: Icons.link, text: "github.com/Mike19200"),
              ],
            ),
          ),
        ],
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
        onTap: () {},
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