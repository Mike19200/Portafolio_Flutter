import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:portafolio_webapp_2026/models/video_model.dart';
import 'package:portafolio_webapp_2026/services/video_services.dart';

class VideoItem extends StatefulWidget {
  final VideoModel video;
  const VideoItem({super.key, required this.video});

  @override
  State<VideoItem> createState() => _VideoItemState();
}

class _VideoItemState extends State<VideoItem> {
  late VideoPlayerController _controller;
  final VideoService _videoService = VideoService();
  late int _currentLikes;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _currentLikes = widget.video.likes;
    _initializePlayer();
  }

  void _initializePlayer() {
    // Construimos la URL de Mux usando el Playback ID almacenado en videoUrl
    final String muxUrl = 'https://stream.mux.com/${widget.video.videoUrl}.m3u8';

    _controller = VideoPlayerController.networkUrl(Uri.parse(muxUrl))
      ..initialize().then((_) {
        if (!mounted) return;

        // CONFIGURACIÓN CRUCIAL PARA WEB:
        // El volumen debe ser 0 para que el navegador permita el .play() automático
        _controller.setVolume(0);
        _controller.setLooping(true);
        
        setState(() {
          _isInitialized = true;
        });

        _controller.play().catchError((error) {
          debugPrint("Error al intentar reproducir (Autoplay): $error");
        });
      }).catchError((error) {
        debugPrint("Error inicializando VideoPlayer: $error");
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: Stack(
        children: [
          // 1. EL VIDEO (Capa de fondo)
          Positioned.fill(
            child: _isInitialized
                ? FittedBox(
                    fit: BoxFit.cover,
                    child: SizedBox(
                      width: _controller.value.size.width,
                      height: _controller.value.size.height,
                      child: VideoPlayer(_controller),
                    ),
                  )
                : const Center(
                    child: CircularProgressIndicator(color: Colors.white24),
                  ),
          ),

          // 2. CAPA DE INTERACCIÓN (Play/Pause)
          Positioned.fill(
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                if (_isInitialized) {
                  setState(() {
                    _controller.value.isPlaying
                        ? _controller.pause()
                        : _controller.play();
                  });
                }
              },
              child: Container(color: Colors.transparent),
            ),
          ),

          // 3. INFORMACIÓN DEL VIDEO (Título y Descripción)
          Positioned(
            left: 20,
            bottom: 25,
            right: 80,
            child: Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.4),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    widget.video.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    widget.video.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // 4. BOTONES DE ACCIÓN (Lateral derecho)
          Align(
            alignment: Alignment.centerRight,
            child: Container(
              margin: const EdgeInsets.only(right: 15, bottom: 55),
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 8),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.4),
                borderRadius: BorderRadius.circular(30),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildActionButton(
                    icon: Icons.favorite,
                    label: _currentLikes.toString(),
                    color: Colors.redAccent,
                    onTap: () async {
                      setState(() {
                        _currentLikes++;
                      });
                      await _videoService.likeVideo(widget.video.id);
                    },
                  ),
                  const SizedBox(height: 25),
                  _buildActionButton(
                    icon: Icons.info_outline,
                    label: "Info",
                    color: Colors.white,
                    onTap: () => _showDescriptionSheet(context),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: const BoxDecoration(
                color: Colors.black54,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 30),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showDescriptionSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.grey[900],
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.video.title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Divider(color: Colors.white24),
            Text(
              widget.video.description,
              style: const TextStyle(color: Colors.white70, fontSize: 16),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}