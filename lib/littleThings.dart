import 'dart:async';
import 'dart:developer';

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
  bool isTransitioning = false;
  // List<String> mapNames = ['town-biome','forest-biome'];

  @override
  FutureOr<void> onLoad() async {
    await images.loadAllImages();
    player = Player();

    // SPAWNPOINT
    _loadLevel("town-biome", "forest-biome");

    debugMode = true;
    return super.onLoad();
  }


  void loadMap(String nextMap) {
    if (isTransitioning) return;
    isTransitioning = true;

    final nextLevel = Level(previousMap: level.mapName, mapName: nextMap, player: player);
    level.removeFromParent();
    level = nextLevel;
    cam.world = level;
    add(level);

    isTransitioning = false;
  }

  void _loadLevel(String previousMap, String mapName) {
    log(mapName);
    level = Level(previousMap: previousMap, mapName: mapName, player: player);


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