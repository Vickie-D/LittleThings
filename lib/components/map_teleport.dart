import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:little_things_game/littleThings.dart';
import 'package:little_things_game/components/player.dart';


class mapTeleport extends SpriteAnimationComponent with HasGameReference<littleThings>, CollisionCallbacks{
  String name;
  mapTeleport({
    super.position, 
    super.size,
    this.name = '',
  });

  bool reachedCheckpoint = false;

  
  @override
  FutureOr<void> onLoad() {

    add(RectangleHitbox(
      position: Vector2(0, 0),
      size: Vector2(36, 48),
      collisionType: CollisionType.passive,
    ),);

      
    return super.onLoad();
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    if(other is Player && !reachedCheckpoint) reachedCheckpoint = true;
    super.onCollision(intersectionPoints, other);
  }
}