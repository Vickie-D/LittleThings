import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:little_things_game/components/health_display.dart';
import 'package:little_things_game/components/hotbar.dart';
import 'package:little_things_game/components/textOverlay.dart';
import 'package:little_things_game/littleThings.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Flame.device.fullScreen();
  Flame.device.setLandscape();

  littleThings game = littleThings();
  runApp(
    GameWidget(
      game: kDebugMode ? littleThings() : game,
      overlayBuilderMap: {
        'Hotbar': (context, game) => Hotbar(game: game as littleThings),
        'TextOverlay': (context, game) => TextOverlay(game: game as littleThings),
        'HealthDisplay': (context, game) => HealthDisplay(game: game as littleThings),
      },
      initialActiveOverlays: const ['Hotbar'],
    )
  );
}

