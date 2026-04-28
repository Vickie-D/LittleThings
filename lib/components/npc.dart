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

  // final double walk = 1;
  // double moveSpeed = 50;

  
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


// @override
// bool onKeyEvent(KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
//   if (event is KeyDownEvent &&
//       npcCollision &&
//       event.logicalKey == LogicalKeyboardKey.space &&
//       name != null) {

//     final text = game.dialogManager.nextDialog(name!);

//     if (text.isEmpty) {
//       game.dialogManager.resetDialog(name!);
//       game.overlays.remove('TextOverlay');
//       name = null; // stop interaction
//     } else {
//       speaker = game!;
//       textOverlayed = text;
//       overlays.add('TextOverlay');
//     }

//     return true; // event handled
//   }

//   return super.onKeyEvent(event, keysPressed);
// }
//   void _reachedCheckpoint() {
//     game.npcGetMessage(name);
//     // game.showTextOverlay(name, "Hello World");

//     // Future.delayed(const Duration(seconds: 2), () {
//     //   game.hideTextOverlay();
//     // });

//     // final textAnimation = SpriteAnimation.fromFrameData(
//     //   game.images.fromCache('dialog/hello-text.png'),
//     //   SpriteAnimationData.sequenced(
//     //     amount: 10,
//     //     stepTime: 0.07,
//     //     textureSize: Vector2(32,14),
//     //     loop:false
//     //   )
//     // );


//     // final textComponent = SpriteAnimationComponent(
//     //   animation: textAnimation,
//     //   position: Vector2(20,0),
//     //   size: Vector2(32, 14),
//     //   priority: 1,
//     // );


//     // add(textComponent);

//     // final textComponent = SpriteAnimationComponent(
//     //   animation: textAnimation,
//     //   // position: Vector2(20,0),
//     //   // position: Vector2(game.size.x /2, game.size.y /2),
//     //   position: position + Vector2(game. /2,0),
//     //   size: Vector2(32, 14),
//     //   priority: 1,
//     // );


//     // game.level.add(textComponent);
//     // print("adding text component!");

//     // Future.delayed(const Duration(seconds: 2), () {
//     //   if (textComponent.isMounted){
//     //     textComponent.removeFromParent();
//     //   }
//     // });
//   }

//   // void _automaticWalking() {
    
//   // }
}