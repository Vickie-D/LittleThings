import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/services.dart';
import 'package:little_things_game/littleThings.dart';
import 'package:little_things_game/components/player.dart';


class Npc extends SpriteAnimationComponent with HasGameReference<littleThings>, KeyboardHandler, CollisionCallbacks{
  String name;
  Npc({
    super.position, 
    super.size,
    this.name = '',
  });

  final double walk = 1;
  double moveSpeed = 50;
  bool npcCollision = false;

  
  @override
  FutureOr<void> onLoad() {
    add(RectangleHitbox(
      position: Vector2(0, 0),
      size: Vector2(24, 28),
      collisionType: CollisionType.passive,
    ),);


    animation = SpriteAnimation.fromFrameData(
      game.images.fromCache('character/bunny-idle.png'),
      SpriteAnimationData.sequenced(
        amount: 8,
        stepTime: 0.125,
        textureSize: Vector2(46, 28),
      ));
      
      
    return super.onLoad();
  }



  @override
  void onCollisionStart(Set<Vector2> intersectionPoints, PositionComponent other) {
    if(other is Player) npcCollision = true;

    super.onCollisionStart(intersectionPoints, other);
  }

  @override
  void onCollisionEnd(PositionComponent other) {
    if(other is Player) npcCollision = false;

    super.onCollisionEnd(other);
  }


  @override
  bool onKeyEvent(KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    if(npcCollision && keysPressed.contains(LogicalKeyboardKey.space)) _reachedCheckpoint();
    
    return super.onKeyEvent(event, keysPressed);
  }


  void _reachedCheckpoint() {
    final textAnimation = SpriteAnimation.fromFrameData(
      game.images.fromCache('character/hello-text.png'),
      SpriteAnimationData.sequenced(
        amount: 10,
        stepTime: 0.07,
        textureSize: Vector2(32,14),
        loop:false
      )
    );


    final textComponent = SpriteAnimationComponent(
      animation: textAnimation,
      position: Vector2(20,0),
      size: Vector2(32, 14),
      priority: 1,
    );


    add(textComponent);

    Future.delayed(const Duration(seconds: 2), () {
      if (textComponent.isMounted){
        textComponent.removeFromParent();
      }
    });
  }

  void _automaticWalking() {
    
  }
}