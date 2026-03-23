import 'package:flutter_test/flutter_test.dart';
import 'package:portafolio_webapp_2026/main.dart'; // Asegúrate de que este import coincida con tu proyecto

void main() {
  testWidgets('Carga inicial de la app de portafolio', (WidgetTester tester) async {
    // Construimos la app llamando a nuestra clase real
    await tester.pumpWidget(const PortafolioApp());

    // Solo verificamos que se construya algo (por ejemplo, el HomeScreen)
    expect(find.byType(PortafolioApp), findsOneWidget);
  });
}