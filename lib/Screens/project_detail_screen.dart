import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;
// Usamos esta importación para asegurar compatibilidad con la API de registro web en Flutter moderno
import 'dart:ui_web' as ui_web;

class ProjectDetailScreen extends StatefulWidget {
  final String title;
  final String description;
  final String extraInfo; 
  final String imageUrl;
  final bool showMoreButton;
  final String? projectUrl;  
  final bool hasAdBanner; 

  const ProjectDetailScreen({
    Key? key,
    required this.title,
    required this.description,
    required this.extraInfo,
    required this.imageUrl,
    required this.showMoreButton,
    this.projectUrl,
    this.hasAdBanner = false,
  }) : super(key: key);

  @override
  State<ProjectDetailScreen> createState() => _ProjectDetailScreenState();
}

class _ProjectDetailScreenState extends State<ProjectDetailScreen> {

  @override
  void initState() {
    super.initState();
    
    if (widget.hasAdBanner) {
      // API actualizada para registrar vistas HTML en Flutter Web
      ui_web.platformViewRegistry.registerViewFactory(
        'adsense-banner-view',
        (int viewId) {
          final element = html.DivElement()
            ..style.width = '100%'
            ..style.height = '100%'
            ..style.display = 'flex'
            ..style.justifyContent = 'center'
            ..style.alignItems = 'center';

          // Unificamos dimensiones internas a 320x50 para evitar conflictos con AdSense
          element.innerHtml = '''
            <ins class="adsbygoogle"
                 style="display:inline-block;width:320px;height:50px"
                 data-ad-client="ca-pub-5184877107526673" 
                 data-ad-slot="6779435456"></ins>
            <script>
                 (adsbygoogle = window.adsbygoogle || []).push({});
            </script>
          ''';
          
          return element;
        },
      );
    }
  }

  Future<void> _launchURL() async {
    if (widget.projectUrl == null || widget.projectUrl!.isEmpty) return;
    
    final Uri url = Uri.parse(widget.projectUrl!);
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw Exception('No se pudo abrir la URL: ${widget.projectUrl}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 0, 0, 0),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300.0,
            pinned: true,
            backgroundColor: const Color(0xff545454),
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, size: 35, color: Color.fromARGB(255, 0, 0, 0)), 
              onPressed: () => Navigator.pop(context),
            ),
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: true,
              background: Image.network(
                widget.imageUrl,
                fit: BoxFit.cover,
              ),
            ),
          ),
          
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (widget.hasAdBanner) ...[
                    const SizedBox(height: 0),
                    Center(
                      child: Container(
                        width: 320,  
                        height: 50,  
                        color: const Color(0xff1a1a1a), 
                        child: const HtmlElementView(viewType: 'adsense-banner-view'),
                      ),
                    ),
                    const SizedBox(height: 10),
                  ],
                  Text(
                    widget.title,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 12),
                  
                  Text(
                    "${widget.description}\n\n${widget.extraInfo}",
                    style: const TextStyle(
                      fontSize: 15,
                      height: 1.5,
                      color: Color.fromARGB(221, 224, 224, 224),
                    ),
                  ),
                  const SizedBox(height: 30),
                  
                  if (widget.showMoreButton) ...[
                    Center(
                      child: SizedBox(
                        width: 200,
                        height: 45,
                        child: ElevatedButton(
                          onPressed: _launchURL, 
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xff2e7d32),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            "Ver más",
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                  ],
                    Center(
                    child: SizedBox(
                      width: 150,
                      height: 45,
                      child: ElevatedButton(
                        onPressed: () => Navigator.pop(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xff757575),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          "Regresar",
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 50),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}