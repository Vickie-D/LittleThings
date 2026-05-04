import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:little_things_game/littleThings.dart';


class Npc extends SpriteAnimationComponent with HasGameReference<littleThings>, KeyboardHandler, CollisionCallbacks{
  final String name;

  Npc({
    required this.name,
    required Vector2 position,
    required Vector2 size,
  }) : super(
      position: position,
    );

  
  @override
  FutureOr<void> onLoad() {
    add(RectangleHitbox(
      position: Vector2(0, 0),
      size: Vector2(16, 16),
      collisionType: CollisionType.passive,
    ),);


    animation = SpriteAnimation.fromFrameData(
      game.images.fromCache('character/$name/Idle.png'),
      SpriteAnimationData.sequenced(
        amount: 1,
        stepTime: 0.125,
        textureSize: Vector2(16, 16),
      ));
      
      
    return super.onLoad();
  }
}