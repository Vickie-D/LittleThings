import 'dart:async';

import 'package:flame/camera.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:little_things_game/components/level.dart';
import 'package:little_things_game/components/player.dart';


class littleThings extends FlameGame with HasKeyboardHandlerComponents, HasCollisionDetection{
  littleThings();

  late Level level;
  late final CameraComponent cam;
  late Player player;

  @override
  FutureOr<void> onLoad() async {
    await images.loadAllImages();
    player = Player();

    _loadLevel("forest-biome");
    debugMode = true;
    return super.onLoad();
  }


  void _loadLevel(String levelName) {
    level = Level(levelName: levelName, player: player);

    final windowWidth = size.x;
    final windowHeight = size.y;


    cam = CameraComponent(
      world: level,
      viewport: FixedSizeViewport(
        windowWidth,
        windowHeight
      ),
    );


    cam.viewfinder.anchor = Anchor.center;
    cam.viewfinder.zoom = 3;

    final x = (size.x - windowWidth) / 2;
    final y = (size.y - windowHeight) / 2;
    cam.viewport.position = Vector2(x, y);

    cam.follow(player);

    addAll([cam, level]);
  }
}