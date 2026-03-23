import 'dart:ui';
import 'package:flutter/material.dart';

class MyCustomScrollBehavior extends MaterialScrollBehavior {
  // Overridemos los dispositivos que pueden hacer "drag"
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse, // <--- ESTO habilita el scroll con el mouse
        PointerDeviceKind.trackpad,
      };
}