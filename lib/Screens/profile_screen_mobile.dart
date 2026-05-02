import 'package:flutter/material.dart';
import 'package:portafolio_webapp_2026/widgets/build_experience_card.dart';
import 'package:portafolio_webapp_2026/widgets/build_info_tile.dart';
import 'package:portafolio_webapp_2026/widgets/section_title.dart';

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
            "Jr. Software Developer",
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 20),
          const SectionTitle(title: "Acerca de mí"),
          const Text(
            "Hola, Soy Mike! Estudiante de Ingeniería en Diseño de Entretenimiento Digital y actualmente estoy en sexto semestre!\n"
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

          // Sección Experiencia (Nueva)
          const SectionTitle(title: "Experiencia"),
          BuildExperienceCard(role:"Software Developer Jr.", company: "Avenfor S.A.S", logoPath: 'lib/assets/img/Avenfor Logo.jpg'),
          BuildExperienceCard(role: "Engineering Intern", company: "Karaokulta An Amber Studios", logoPath: 'lib/assets/img/Karaokulta Logo.jpg'),
          BuildExperienceCard(role: "Roblox Developer", company: "Hitbox Studios", logoPath: 'lib/assets/img/Hitbox logo.jpg'),
          BuildExperienceCard(role: "Payroll Specialist", company: "CCS Construction Staffing", logoPath: 'lib/assets/img/CCS Logo.jpg'),

          const SizedBox(height: 30),

          // Sección Habilidades (Expandida)
          const SectionTitle(title: "Habilidades"),
          BuildInfoTile(icon: Icons.language, text: "Inglés C1"),
          BuildInfoTile(icon: Icons.flutter_dash, text: "Flutter/Dart"),
          BuildInfoTile(icon: Icons.storage, text: "Firebase & SQL"),
          BuildInfoTile(icon: Icons.brush, text: "Diseño UX/UI"),
          BuildInfoTile(icon: Icons.videogame_asset, text: "Unity / Roblox (Lua) / Verse UEFN"),
          BuildInfoTile(icon: Icons.code, text: "C# / HTML / CSS / JavaScript / Node.js / Swift / Kotlin"),

          const SizedBox(height: 30),

          // Sección Contacto
          const SectionTitle(title:"Contacto"),
          BuildInfoTile(icon: Icons.location_on, text: "Medellín, Antioquia"),
          BuildInfoTile(icon: Icons.email, text: "miguel.angel.mogollon@hotmail.com"),
          BuildInfoTile(icon: Icons.link, text: "github.com/Mike19200"),
        ],
      ),
    );
  }

  // Widget auxiliar para títulos de sección

}