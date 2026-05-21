import 'dart:js_interop';

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
// Importación moderna oficial compatible con WebAssembly (reemplaza dart:html)
import 'package:web/web.dart' as web;
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
  final Color cardColor; 

  const ProjectDetailScreen({
    Key? key,
    required this.title,
    required this.description,
    required this.extraInfo,
    required this.imageUrl,
    required this.showMoreButton,
    required this.cardColor,
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
      // API de registro de vistas HTML adaptada para Wasm
      ui_web.platformViewRegistry.registerViewFactory(
        'adsense-banner-view',
        (int viewId) {
          // Creación de elemento usando package:web
          final element = web.HTMLDivElement()
            ..style.width = '100%'
            ..style.height = '100%'
            ..style.display = 'flex'
            ..style.justifyContent = 'center'
            ..style.alignItems = 'center';

          // SOLUCIÓN: Quitamos 'as JSAny' y usamos '.toJS' para convertir el String de Dart a JS de forma segura.
          element.innerHTML = '''
            <ins class="adsbygoogle"
                 style="display:inline-block;width:320px;height:50px"
                 data-ad-client="ca-pub-5184877107526673" 
                 data-ad-slot="6779435456"></ins>
            <script>
                 (adsbygoogle = window.adsbygoogle || []).push({});
            </script>
          '''.toJS;
          
          return element;
        },
      );
    }
  }

  Future<void> _launchURL() async {
    if (widget.projectUrl == null || widget.projectUrl!.trim().isEmpty) {
      debugPrint("ALERTA: No se puede abrir la URL porque está vacía en los datos del proyecto.");
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Este proyecto no tiene un enlace configurado.')),
      );
      return;
    }
    
    final Uri url = Uri.parse(widget.projectUrl!.trim());
    
    if (!await launchUrl(url)) {
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
            backgroundColor: widget.cardColor,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, size: 35, color: Color.fromARGB(255, 0, 0, 0)), 
              onPressed: () => Navigator.pop(context),
            ),
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: true,
              background: Image.asset(
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
                  const SizedBox(height: 25),
                  
                  if (widget.showMoreButton) ...[
                    Center(
                      child: SizedBox(
                        width: 180,
                        height: 40,
                        child: ElevatedButton(
                          onPressed: _launchURL, 
                          style: ElevatedButton.styleFrom(
                            backgroundColor: widget.cardColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            "Mira el Proyecto",
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                  ],
                  //Center(
                  //  child: SizedBox(
                  //    width: 130,
                  //    height: 35,
                  //    child: ElevatedButton(
                  //      onPressed: () => Navigator.pop(context),
                  //      style: ElevatedButton.styleFrom(
                  //        backgroundColor: const Color(0xff757575),
                  //        shape: RoundedRectangleBorder(
                  //          borderRadius: BorderRadius.circular(12),
                  //        ),
                  //      ),
                  //      child: const Text(
                  //        "Regresar",
                  //        style: TextStyle(color: Colors.white, fontSize: 16),
                  //      ),
                  //    ),
                  //  ),
                  //),
                  const SizedBox(height: 15),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}