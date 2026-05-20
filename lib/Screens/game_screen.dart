import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class JugarScreenMobile extends StatelessWidget {
  const JugarScreenMobile({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Jugar",
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          // Encapsulamos el juego para que no interfiera negativamente con el scroll
          const CityBloxxMinigame(),
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
  
  // Configuración del juego
  final double blockWidth = 60.0;
  final double blockHeight = 40.0;
  final double ropeLength = 120.0;
  
  // Estado del juego
  int score = 0;
  bool isGameOver = false;
  double time = 0.0; // Tiempo para la oscilación del péndulo
  
  // Posición del bloque oscilando (anclado arriba en el centro X)
  double pivotX = 0.0; 
  double currentBlockX = 0.0;
  double currentBlockY = 0.0;
  
  // Estado del bloque actual
  bool isDropping = false;
  double dropSpeed = 12.0;

  // Lista de posiciones X de los bloques ya apilados
  List<double> stackedBlocksX = [];
  
  // Altura de la base (piso)
  double floorY = 400.0;

  @override
  void initState() {
    super.initState();
    
    // Ticker para actualizar el frame rate del juego continuamente
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
    super.dispose();
  }

  void _updateGame() {
    if (!isDropping) {
      // Movimiento de balanceo usando seno
      time += 0.02;
      // Ángulo de oscilación máximo (~35 grados)
      double angle = 0.6 * math.sin(time * 2.5); 
      
      // Calcular la posición del extremo de la soga
      currentBlockX = pivotX + ropeLength * math.sin(angle);
      currentBlockY = ropeLength * math.cos(angle);
    } else {
      // El bloque está cayendo directo hacia abajo
      currentBlockY += dropSpeed;
      
      // Calcular la altura del objetivo (el suelo o el último bloque apilado)
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
      // Primer bloque: debe caer dentro del rango del centro
      if ((currentBlockX - pivotX).abs() < blockWidth * 1) {
        stackedBlocksX.add(currentBlockX);
        score++;
      } else {
        _endGame();
      }
    } else {
      // Siguientes bloques: comparan su centro con el bloque anterior
      double lastBlockX = stackedBlocksX.last;
      double error = (currentBlockX - lastBlockX).abs();
      
      if (error < blockWidth * 0.75) { // Margen de tolerancia física de colisión
        stackedBlocksX.add(currentBlockX);
        score++;
        
        // Si la torre crece mucho, bajamos el suelo visualmente para que no se salga del contenedor
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
    isGameOver = true;
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
    // Definimos el ancho del canvas basándonos en el espacio disponible
    return LayoutBuilder(
      builder: (context, constraints) {
        pivotX = constraints.maxWidth / 2;
        
        return Column(
          children: [
            // Contenedor del Juego
            GestureDetector(
              onTap: _dropBlock,
              child: Container(
                width: constraints.maxWidth,
                height: 500,
                decoration: BoxDecoration(
                  color: Colors.grey[900],
                  //borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: const Color.fromARGB(255, 255, 255, 255).withOpacity(0.5), width: 3),
                ),
                child: Stack(
                  children: [
                    // Render de los gráficos mediante CustomPaint
                    Positioned.fill(
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
                    
                    // Puntaje arriba y centrado
                    Positioned(
                      top: 20,
                      left: 0,
                      right: 0,
                      child: Text(
                        "$score",
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2,
                          shadows: [
                            Shadow(color: Colors.black, blurRadius: 4, offset: Offset(2, 2)),
                          ],
                        ),
                      ),
                    ),
                    
                    // Pantalla de Game Over
                    if (isGameOver)
                      Container(
                        color: Colors.black.withOpacity(0.75),
                        child: Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Text(
                                "¡TORRE CAÍDA!",
                                style: TextStyle(color: Colors.red, fontSize: 32, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                "Puntaje Final: $score",
                                style: const TextStyle(color: Colors.white, fontSize: 20),
                              ),
                              const SizedBox(height: 20),
                              ElevatedButton(
                                onPressed: _resetGame,
                                style: ElevatedButton.styleFrom(backgroundColor: Colors.blueAccent),
                                child: const Text("Intentar de nuevo", style: TextStyle(color: Colors.white)),
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
    final paintLine = Paint()
      ..color = Colors.white70
      ..strokeWidth = 3.0
      ..style = PaintingStyle.stroke;

    final paintCurrentBlock = Paint()
      ..color = Colors.amber
      ..style = PaintingStyle.fill;

    final paintStackedBlock = Paint()
      ..color = Colors.cyan
      ..style = PaintingStyle.fill;
      
    final paintFloor = Paint()
      ..color = Colors.green[700]!
      ..style = PaintingStyle.fill;

    // 1. Dibujar el Suelo (Base)
    canvas.drawRect(Rect.fromLTRB(0, floorY, size.width, floorY + 15), paintFloor);

    // 2. Dibujar la soga (Solo si el bloque no está en caída libre)
    if (!isDropping) {
      canvas.drawLine(Offset(pivotX, 0), Offset(currentBlockX, currentBlockY), paintLine);
    }

    // 3. Dibujar el bloque actual (en movimiento o cayendo)
    // Centramos el dibujo del cuadrado usando su ancho y alto
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(
          currentBlockX - (blockWidth / 2),
          currentBlockY,
          blockWidth,
          blockHeight,
        ),
        const Radius.circular(4),
      ),
      paintCurrentBlock,
    );

    // 4. Dibujar los bloques apilados de la torre
    for (int i = 0; i < stackedBlocksX.length; i++) {
      double yPos = floorY - ((i + 1) * blockHeight);
      
      // Evitamos dibujar bloques que ya se salieron de la parte superior del contenedor
      if (yPos < -blockHeight) continue;

      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(
            stackedBlocksX[i] - (blockWidth / 2),
            yPos,
            blockWidth,
            blockHeight,
          ),
          const Radius.circular(4),
        ),
        paintStackedBlock,
      );
    }
  }

  @override
  // Forzamos el redibujado continuo en cada ciclo del Ticker
  bool shouldRepaint(covariant GamePainter oldDelegate) => true;
}