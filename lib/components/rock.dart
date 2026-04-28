import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:little_things_game/littleThings.dart';
import 'package:little_things_game/components/player.dart';


class Rock extends SpriteAnimationComponent with HasGameReference<littleThings>, CollisionCallbacks{
  Rock({
    super.position, 
    super.size,
  });

  bool reachedCheckpoint = false;

  
  @override
  FutureOr<void> onLoad() {

    add(RectangleHitbox(
      position: Vector2(0, 0),
      size: Vector2(size.x, size.y),
      collisionType: CollisionType.passive,
    ),);

    animation = SpriteAnimation.fromFrameData(
      game.images.fromCache('items/Rock.png'),
      SpriteAnimationData.sequenced(
        amount: 1,
        stepTime: 0.05,
        textureSize: Vector2(50, 150),
      )
    );

    return super.onLoad();
  }

  // @override
  // void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
  //   if(other is Player && !reachedCheckpoint) reachedCheckpoint = true;
  //   super.onCollision(intersectionPoints, other);
  // }
}