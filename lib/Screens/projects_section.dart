import 'package:flutter/material.dart';

class ProjectsSection extends StatelessWidget {
  const ProjectsSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        const Text(
          "Mis Proyectos",
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 20),
        //_buildProjectCard("App de Delivery", "Flutter & Node.js"),
        //_buildProjectCard("Clon de Spotify", "React Native"),
        //_buildProjectCard("Dashboard", "Vue & Firebase"),
      ],
    );
  }
}