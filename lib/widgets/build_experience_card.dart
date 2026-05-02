import 'package:flutter/material.dart';

class BuildExperienceCard extends StatelessWidget {
  final String role;
  final String company;
  final String logoPath;

  const BuildExperienceCard({
    super.key,
    required this.role,
    required this.company,
    required this.logoPath,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white.withOpacity(0.05), // Fondo sutil para destacar la tarjeta
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            // Contenedor para el logo de la empresa
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: Colors.white10,
                borderRadius: BorderRadius.circular(8),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.asset(
                  logoPath,
                  fit: BoxFit.contain,
                  // Si la imagen no carga, muestra un icono de maletín por defecto
                  errorBuilder: (context, error, stackTrace) =>
                      const Icon(Icons.business, color: Colors.blue, size: 30),
                ),
              ),
            ),
            const SizedBox(width: 15),
            // Información del puesto y empresa
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    role,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    company,
                    style: const TextStyle(
                      color: Color.fromARGB(255, 122, 130, 143),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}