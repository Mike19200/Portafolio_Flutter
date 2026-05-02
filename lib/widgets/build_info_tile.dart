import 'package:flutter/material.dart';

class BuildInfoTile extends StatefulWidget {
  final IconData icon;
  final String text;

  const BuildInfoTile({
    Key? key,
    required this.icon,
    required this.text,
  }) : super(key: key);

  @override
  State<BuildInfoTile> createState() => _BuildInfoTileState();
}

class _BuildInfoTileState extends State<BuildInfoTile> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      // Usamos una tarjeta para dar profundidad y separación
      child: Card(
        color: Colors.white.withOpacity(0.05),
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center, // Centrado verticalmente
            children: [
              // Icono más grande y con color para que resalte
              Icon(
                widget.icon, 
                color: Colors.blueAccent, 
                size: 26, // Tamaño aumentado
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  widget.text,
                  style: const TextStyle(
                    color: Colors.white, 
                    fontSize: 16, // Texto más grande
                    letterSpacing: 0.5,
                  ),
                  softWrap: true,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}