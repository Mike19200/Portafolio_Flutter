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
      child: Container(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(widget.icon, color: Colors.grey, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                widget.text,
                style: const TextStyle(color: Colors.white70),
                softWrap: true,
              ),
            ),
          ],
        ),
      ),
    );
  }
}