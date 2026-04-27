import 'dart:async';
import 'dart:developer';

import 'package:flame/camera.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:little_things_game/components/hotbar.dart';
import 'package:little_things_game/components/level.dart';
import 'package:little_things_game/components/npc.dart';
import 'package:little_things_game/components/player.dart';


class littleThings extends FlameGame with HasKeyboardHandlerComponents, HasCollisionDetection{
  littleThings();

  late Level level;
  late final CameraComponent cam;
  late Player player;
  late Npc npc;
  bool isTransitioning = false;
  int selectedIndex = 0;


  @override
  FutureOr<void> onLoad() async {
    player = Player();
    npc = Npc();
    await images.loadAllImages();

    // SPAWNPOINT
    _loadLevel("town-biome", "forest-biome");

    debugMode = true;
    // return super.onLoad();
  }

  
  void selectSlot(int index) {
    selectedIndex = index;
    overlays.remove('Hotbar');
    overlays.add('Hotbar');
  }

  void loadMap(String nextMap) {
    if (isTransitioning) return;
    isTransitioning = true;

    log("You are going from : " + level.mapName);
    log("You are going to : " + nextMap);
    final nextLevel = Level(previousMap: level.mapName, mapName: nextMap, player: player);
    level.removeFromParent();
    level = nextLevel;
    cam.world = level;
    add(level);

    isTransitioning = false;
  }

  void _loadLevel(String previousMap, String mapName) {
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