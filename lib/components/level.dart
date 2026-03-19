import 'dart:async';

import 'package:flame/components.dart';
import 'package:little_things_game/littleThings.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:little_things_game/components/player.dart';
import 'package:little_things_game/components/collision_block.dart';


class Level extends World with HasGameReference<littleThings> {
  final String levelName;
  final Player player;

  Level({
    required this.levelName,
    required this.player,
  });

  late TiledComponent map;
  List<CollisionBlock> collisionBlocks = [];


  @override
  FutureOr<void> onMount() async {
    map = await TiledComponent.load("$levelName.tmx", Vector2.all(16));

    add(map);

    _spawnObjects();
    _addCollisions();

    return super.onMount();
  }


  void _spawnObjects() {
    final spawnPointsLayer = map.tileMap.getLayer<ObjectGroup>('Spawnpoints');

    if(spawnPointsLayer != null) {
      for (final spawnPoint in spawnPointsLayer.objects) {
        switch (spawnPoint.class_) {
          case "Player":
            player.position = Vector2(spawnPoint.x, spawnPoint.y);
            add(player);
            player.scale = Vector2(1.0, 1.0);
            break;
        }
      }
    }
  }

  void _addCollisions() {
    final collisionsLayer = map.tileMap.getLayer<ObjectGroup>('Collisions');

    if(collisionsLayer != null) {
      for(final collision in collisionsLayer.objects) {
        final block = CollisionBlock(
          position: Vector2(collision.x, collision.y),
          size: Vector2(collision.width, collision.height),
        );
        collisionBlocks.add(block);
        add(block);
      }
    }

    player.collisionBlocks = collisionBlocks;
    
  }
}