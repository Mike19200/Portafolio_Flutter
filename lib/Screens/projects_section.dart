import 'package:flutter/material.dart';
import 'package:portafolio_webapp_2026/Screens/project_detail_screen.dart';

class ProjectsSection extends StatelessWidget {
  const ProjectsSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Center(
          child: const Text(
            "Mis Proyectos",
            style: TextStyle(
              fontSize: 22, 
              fontWeight: FontWeight.bold, 
              color: Colors.white,
            ),
          ),
        ),
        const SizedBox(height: 20),
        
        _buildProjectCard(
          context,
          title: "Townsquare Frontend Demo",
          cardColor: const Color.fromARGB(255, 72, 144, 216), // <-- Color personalizado para esta card
          description: "Este es una demo de flutter que hice, un proyecto en el cual me contrataron para desarrollar solo el front de una app usando el diseño de figma de su homescreen.",
          extraInfo: "Este proyecto fue desarrollado como una demostración de las capacidades de Flutter y Figma.",
          imageUrl: "lib/assets/img/TWNSQR Test.png", 
          showMoreButton: true,
          projectUrl: "https://mikebackup192.github.io/first_task_flutter_host/",
        ),
        
        _buildProjectCard(
          context,
          title: "Manejo de Google AdsSense y Google Mobads en Flutter",
          cardColor: const Color.fromARGB(255, 3, 129, 98), // <-- Otro color personalizado (ej: verde oscuro clínico)
          description: "Integración de Google AdsSense y Google Mobile Ads en aplicaciones Flutter para monetización efectiva.",
          extraInfo: "En varios de mis proyectos (incluyendo este), he integrado Google AdsSense y Google Mobile Ads para monetizar aplicaciones Flutter.\n\nEsto incluye la configuración de unidades de anuncios, manejo de eventos de anuncios y optimización para maximizar los ingresos sin comprometer la experiencia del usuario.",
          imageUrl: "lib/assets/img/googleadsense.png", 
          showMoreButton: false,
          hasAdBanner: true, // <-- Esta card mostrará un banner de AdSense
        ),
        
        _buildProjectCard(
          context,
          title: "Proyecto Medico Fullstack Demo (Flutter + Firebase)",
          cardColor: const Color.fromARGB(255, 3, 47, 129), // <-- Otro color personalizado (ej: verde oscuro clínico)
          description: "Aplicacion de gestion de formularios medicos para pacientes y doctores, con autenticacion y base de datos en Firebase.",
          extraInfo: "Sistema para pacientes y doctores que permite llenar y gestionar formularios médicos. Usa Firebase Authentication para el login y Cloud Firestore para almacenar los datos.\n\nLos pacientes completan sus encuestas y pueden ver a su doctor asignado; los doctores acceden solo a sus pacientes. Todo con control de acceso seguro según el rol del usuario.",
          imageUrl: "lib/assets/img/Proyecto_medico_flutter.png", 
          showMoreButton: true,
          projectUrl: "https://flutter-medical-project.web.app/",
        ),
      ],
    );
  }

  Widget _buildProjectCard(
    BuildContext context, {
    required String title,
    required Color cardColor, // <-- Nuevo parámetro requerido
    required String description,
    required String extraInfo,
    required String imageUrl,
    required bool showMoreButton,
    String? projectUrl,
    bool hasAdBanner = false, // <-- Parámetro opcional para mostrar banner publicitario
  }) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProjectDetailScreen(
              title: title,
              description: description,
              extraInfo: extraInfo,
              imageUrl: imageUrl,
              showMoreButton: showMoreButton,
              hasAdBanner: hasAdBanner,
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          color: cardColor, // <-- Ahora usa la variable dinámica en lugar del color fijo
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Parte superior: Imagen
              Container(
                height: 200,
                width: double.infinity,
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.cover,
                ),
              ),
              // Parte inferior: Info del proyecto
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 16.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            description,
                            maxLines: 4,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.white.withOpacity(0.7),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}