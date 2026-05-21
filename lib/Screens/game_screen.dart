import 'dart:math' as math;
import 'dart:ui_web' as ui_web; 
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:web/web.dart' as web;
// IMPORTANTE: Asegúrate de tener inicializado Firebase en tu main.dart antes de usar esto
import 'package:cloud_firestore/cloud_firestore.dart'; 

class JugarScreenMobile extends StatefulWidget {
  const JugarScreenMobile({super.key});

  @override
  State<JugarScreenMobile> createState() => _JugarScreenMobileState();
}

class _JugarScreenMobileState extends State<JugarScreenMobile> {
  
  @override
  void initState() {
    super.initState();
    
    ui_web.platformViewRegistry.registerViewFactory(
      'google-adsense-banner',
      (int viewId) {
        final insElement = web.document.createElement('ins') as web.HTMLModElement;
        insElement.className = 'adsbygoogle';
        insElement.style.display = 'block';
        insElement.setAttribute('data-ad-client', 'ca-pub-5184877107526673'); 
        insElement.setAttribute('data-ad-slot', '5025096547'); 
        insElement.style.width = '320px';
        insElement.style.height = '50px';

        final scriptElement = web.document.createElement('script') as web.HTMLScriptElement;
        scriptElement.text = '(adsbygoogle = window.adsbygoogle || []).push({});';

        final container = web.document.createElement('div') as web.HTMLDivElement;
        container.append(insElement);
        container.append(scriptElement);
        
        return container;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 320,
              height: 50,
              color: Colors.grey[800], 
              child: const HtmlElementView(
                viewType: 'google-adsense-banner',
              ),
            ),
          ),
          // ---------------------------------

          const SizedBox(height: 10),
          const CityBloxxMinigame(), // El juego contiene el trigger de guardado
          
          const SizedBox(height: 5),
          
          // --- NUEVO: SECCIÓN SCOREBOARD SEPARADA ---
          Center(
            child: const Text(
              "Mejores Puntajes",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
            ),
          ),
          const SizedBox(height: 10),
          const RealTimeScoreboard(),
        ],
      ),
    );
  }
}

class CityBloxxMinigame extends StatefulWidget {
  const CityBloxxMinigame({super.key});

  @override
  State<CityBloxxMinigame> createState() => _CityBloxxMinigameState();
}

class _CityBloxxMinigameState extends State<CityBloxxMinigame> with SingleTickerProviderStateMixin {
  late Ticker _ticker;
  final TextEditingController _nameController = TextEditingController();
  
  final double blockWidth = 60.0;
  final double blockHeight = 40.0;
  final double ropeLength = 120.0;
  
  int score = 0;
  bool isGameOver = false;
  bool isSavingScore = false; // Estado de carga al subir a Firebase
  bool scoreSaved = false;    // Evita doble envío
  double time = 0.0; 
  
  double pivotX = 0.0; 
  double currentBlockX = 0.0;
  double currentBlockY = 0.0;
  
  bool isDropping = false;
  double dropSpeed = 12.0;
  List<double> stackedBlocksX = [];
  double floorY = 400.0;

  @override
  void initState() {
    super.initState();
    _ticker = createTicker((elapsed) {
      if (!isGameOver) {
        setState(() {
          _updateGame();
        });
      }
    });
    _ticker.start();
  }

  @override
  void dispose() {
    _ticker.dispose();
    _nameController.dispose();
    super.dispose();
  }

  void _updateGame() {
    if (!isDropping) {
      time += 0.035;
      double angle = 0.6 * math.sin(time * 2.5); 
      currentBlockX = pivotX + ropeLength * math.sin(angle);
      currentBlockY = ropeLength * math.cos(angle);
    } else {
      currentBlockY += dropSpeed;
      double targetY = floorY - (stackedBlocksX.length * blockHeight);
      if (currentBlockY >= targetY - blockHeight) {
        currentBlockY = targetY - blockHeight;
        _checkLanding();
      }
    }
  }

  void _checkLanding() {
    isDropping = false;
    if (stackedBlocksX.isEmpty) {
      if ((currentBlockX - pivotX).abs() < blockWidth * 1) {
        stackedBlocksX.add(currentBlockX);
        score++;
      } else {
        _endGame();
      }
    } else {
      double lastBlockX = stackedBlocksX.last;
      double error = (currentBlockX - lastBlockX).abs();
      if (error < blockWidth * 0.75) { 
        stackedBlocksX.add(currentBlockX);
        score++;
        if (stackedBlocksX.length > 5) {
          floorY += blockHeight;
        }
      } else {
        _endGame();
      }
    }
  }

  void _dropBlock() {
    if (!isDropping && !isGameOver) {
      isDropping = true;
    }
  }

  void _endGame() {
    setState(() {
      isGameOver = true;
      scoreSaved = false;
      _nameController.clear();
    });
  }

  // MÉTODO PARA GUARDAR EN FIREBASE
  Future<void> _saveScoreToFirebase() async {
    final String name = _nameController.text.trim().toUpperCase();
    if (name.length != 4) return;

    setState(() {
      isSavingScore = true;
    });

    try {
      await FirebaseFirestore.instance.collection('scoreboard').add({
        'name': name,
        'score': score,
        'timestamp': FieldValue.serverTimestamp(),
      });
      setState(() {
        scoreSaved = true;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error al guardar: $e")),
      );
    } finally {
      setState(() {
        isSavingScore = false;
      });
    }
  }

  void _resetGame() {
    setState(() {
      score = 0;
      isGameOver = false;
      time = 0.0;
      isDropping = false;
      stackedBlocksX.clear();
      floorY = 400.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        pivotX = constraints.maxWidth / 2;
        
        return Column(
          children: [
            GestureDetector(
              onTap: _dropBlock,
              child: Container(
                width: constraints.maxWidth,
                height: 500,
                decoration: BoxDecoration(
                  color: Colors.grey[900],
                  border: Border.all(color: const Color.fromARGB(255, 255, 255, 255).withOpacity(0.5), width: 3),
                ),
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: ClipRect(
                        child: CustomPaint(
                          painter: GamePainter(
                            pivotX: pivotX,
                            currentBlockX: currentBlockX,
                            currentBlockY: currentBlockY,
                            isDropping: isDropping,
                            ropeLength: ropeLength,
                            blockWidth: blockWidth,
                            blockHeight: blockHeight,
                            floorY: floorY,
                            stackedBlocksX: stackedBlocksX,
                          ),
                        ),
                      ),
                    ),
                    
                    Positioned(
                      top: 20, left: 0, right: 0,
                      child: Text(
                        "$score",
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white, fontSize: 40, fontWeight: FontWeight.bold,
                          shadows: [Shadow(color: Colors.black, blurRadius: 4, offset: Offset(2, 2))],
                        ),
                      ),
                    ),
                    
                    // PANTALLA GAME OVER MODIFICADA CON INPUT DE TEXTO
                    if (isGameOver)
                      Container(
                        color: Colors.black.withOpacity(0.85),
                        padding: const EdgeInsets.all(24),
                        child: Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Text(
                                "¡TORRE CAÍDA!",
                                style: TextStyle(color: Colors.red, fontSize: 30, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 5),
                              Text("Puntaje Final: $score", style: const TextStyle(color: Colors.white, fontSize: 18)),
                              const SizedBox(height: 15),
                              
                              if (!scoreSaved) ...[
                                const Text("Ingresa tus 4 letras iniciales:", style: TextStyle(color: Colors.grey, fontSize: 13)),
                                const SizedBox(height: 8),
                                SizedBox(
                                  width: 140,
                                  child: TextField(
                                    controller: _nameController,
                                    maxLength: 4,
                                    autofocus: true,
                                    textAlign: TextAlign.center,
                                    // Mantén esto por si lo prueban en un celular físico
                                    textCapitalization: TextCapitalization.characters, 
                                    inputFormatters: [
                                      LengthLimitingTextInputFormatter(4),
                                      // 1. Permitimos letras mayúsculas y minúsculas en la entrada básica
                                      FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z]')), 
                                      
                                      // 2. NUEVO: Formateador en tiempo real para transformar minúsculas a MAYÚSCULAS
                                      TextInputFormatter.withFunction((oldValue, newValue) {
                                        return newValue.copyWith(
                                          text: newValue.text.toUpperCase(),
                                        );
                                      }),
                                    ],
                                    style: const TextStyle(color: Colors.amber, fontSize: 22, fontWeight: FontWeight.bold, letterSpacing: 6),
                                    decoration: InputDecoration(
                                      counterText: "", // Oculta el contador visual
                                      focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.amber, width: 2)),
                                      enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white.withOpacity(0.5))),
                                    ),
                                    onChanged: (val) => setState(() {}), // Refresca estado del botón
                                  ),
                                ),
                                const SizedBox(height: 15),
                                ElevatedButton.icon(
                                  onPressed: (_nameController.text.length == 4 && !isSavingScore) ? _saveScoreToFirebase : null,
                                  style: ElevatedButton.styleFrom(backgroundColor: Colors.amber, foregroundColor: Colors.black),
                                  icon: isSavingScore 
                                      ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.black))
                                      : const Icon(Icons.cloud_upload, size: 18),
                                  label: const Text("Guardar Récord", style: TextStyle(fontWeight: FontWeight.bold)),
                                ),
                              ] else ...[
                                const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.check_circle, color: Colors.green),
                                    SizedBox(width: 8),
                                    Text("¡Puntaje subido con éxito!", style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
                                  ],
                                ),
                              ],
                              
                              const SizedBox(height: 15),
                              TextButton(
                                onPressed: _resetGame,
                                child: const Text("Volver a Jugar", style: TextStyle(color: Colors.blueAccent, fontSize: 16, fontWeight: FontWeight.bold)),
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              "Toca la pantalla del juego para soltar el bloque",
              style: TextStyle(color: Colors.grey, fontStyle: FontStyle.italic),
            ),
          ],
        );
      },
    );
  }
}

// --- WIDGET INDEPENDIENTE: TABLA EN TIEMPO REAL CON STREAMBUILDER ---
class RealTimeScoreboard extends StatelessWidget {
  const RealTimeScoreboard({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      // Consulta ordenada por puntaje descendente, limitada al Top 5
      stream: FirebaseFirestore.instance
          .collection('scoreboard')
          .orderBy('score', descending: true)
          .limit(5)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Text("Error al cargar las posiciones", style: TextStyle(color: Colors.red));
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: Padding(padding: EdgeInsets.all(8.0), child: CircularProgressIndicator()));
        }

        final docs = snapshot.data?.docs ?? [];

        if (docs.isEmpty) {
          return Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: Colors.grey[900], borderRadius: BorderRadius.circular(8)),
            child: const Text("Sé el primero en marcar un récord 🚀", textAlign: TextAlign.center, style: TextStyle(color: Colors.grey)),
          );
        }

        return Container(
          decoration: BoxDecoration(
            color: Colors.grey[900],
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.white12),
          ),
          child: ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(), // Evita conflictos con el SingleChildScrollView
            itemCount: docs.length,
            separatorBuilder: (context, index) => const Divider(color: Colors.white10, height: 1),
            itemBuilder: (context, index) {
              final data = docs[index].data() as Map<String, dynamic>;
              final String name = data['name'] ?? '????';
              final int points = data['score'] ?? 0;
              
              // Estilo especial para los primeros lugares
              Color rankColor = Colors.grey;
              if (index == 0) rankColor = Colors.amber;       // Oro
              if (index == 1) rankColor = Colors.blueGrey;    // Plata
              if (index == 2) rankColor = Colors.brown;       // Bronce

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 12,
                      backgroundColor: rankColor,
                      child: Text("${index + 1}", style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                    ),
                    const SizedBox(width: 15),
                    Text(
                      name,
                      style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold, letterSpacing: 2),
                    ),
                    const Spacer(),
                    Text(
                      "$points pts",
                      style: const TextStyle(color: Colors.amber, fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }
}

// Conserva tu GamePainter idéntico al final...
class GamePainter extends CustomPainter {
  final double pivotX;
  final double currentBlockX;
  final double currentBlockY;
  final bool isDropping;
  final double ropeLength;
  final double blockWidth;
  final double blockHeight;
  final double floorY;
  final List<double> stackedBlocksX;

  GamePainter({
    required this.pivotX,
    required this.currentBlockX,
    required this.currentBlockY,
    required this.isDropping,
    required this.ropeLength,
    required this.blockWidth,
    required this.blockHeight,
    required this.floorY,
    required this.stackedBlocksX,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paintLine = Paint()..color = Colors.white70..strokeWidth = 3.0..style = PaintingStyle.stroke;
    final paintCurrentBlock = Paint()..color = Colors.amber..style = PaintingStyle.fill;
    final paintStackedBlock = Paint()..color = Colors.cyan..style = PaintingStyle.fill;
    final paintFloor = Paint()..color = Colors.green[700]!..style = PaintingStyle.fill;

    canvas.drawRect(Rect.fromLTRB(0, floorY, size.width, floorY + 15), paintFloor);

    if (!isDropping) {
      canvas.drawLine(Offset(pivotX, 0), Offset(currentBlockX, currentBlockY), paintLine);
    }

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(currentBlockX - (blockWidth / 2), currentBlockY, blockWidth, blockHeight),
        const Radius.circular(4),
      ),
      paintCurrentBlock,
    );

    for (int i = 0; i < stackedBlocksX.length; i++) {
      double yPos = floorY - ((i + 1) * blockHeight);
      if (yPos > size.height || yPos < -blockHeight) continue;

      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(stackedBlocksX[i] - (blockWidth / 2), yPos, blockWidth, blockHeight),
          const Radius.circular(4),
        ),
        paintStackedBlock,
      );
    }
  }

  @override
  bool shouldRepaint(covariant GamePainter oldDelegate) => true;
}