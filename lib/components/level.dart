import 'dart:async';

import 'package:flame/components.dart';
import 'package:little_things_game/components/map_teleport.dart';
import 'package:little_things_game/littleThings.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:little_things_game/components/player.dart';
import 'package:little_things_game/components/npc.dart';
import 'package:little_things_game/components/collision_block.dart';


class Level extends World with HasGameReference<littleThings> {
  final String previousMap;
  final String mapName;
  final Player player;

  Level({
    required this.previousMap,
    required this.mapName,
    required this.player,
  });

  late TiledComponent map;
  List<CollisionBlock> collisionBlocks = [];


  @override
  FutureOr<void> onMount() async {
    map = await TiledComponent.load("$mapName.tmx", Vector2.all(16));
    add(map);
    _spawnObjects();
    _addCollisions();

    return super.onMount();
  }


  void _spawnObjects() {
    final spawnPointsLayer = map.tileMap.getLayer<ObjectGroup>('Spawnpoints');

    if(spawnPointsLayer != null) {
      final spawnPoint = spawnPointsLayer.objects.firstWhere((obj) => obj.name == previousMap);

      player.position = Vector2(spawnPoint.x, spawnPoint.y);
      add(player);


      for (final spawnPoint in spawnPointsLayer.objects) {
        switch (spawnPoint.class_) {
          case "NPC":
            final npc = Npc(
              position: Vector2(spawnPoint.x, spawnPoint.y),
              size: Vector2(spawnPoint.width, spawnPoint.height),            
            );
            add(npc);
            break;
          default:
        }
      }
    }
  }                      

  void _addCollisions() {
    final collisionsLayer = map.tileMap.getLayer<ObjectGroup>('Collisions');

    if(collisionsLayer != null) {
      for(final collision in collisionsLayer.objects) {
        switch (collision.class_) {
          case 'MapCollision':
            final playerTeleport = mapTeleport(
              position: Vector2(collision.x, collision.y),
              size: Vector2(collision.width, collision.height),
              name: collision.name,
            );
            add(playerTeleport);
            break;
          default:
            final block = CollisionBlock(
              position: Vector2(collision.x, collision.y),
              size: Vector2(collision.width, collision.height),
            );
            collisionBlocks.add(block);
            add(block);
        }
      }
    }

    player.collisionBlocks = collisionBlocks;
    
  }
}